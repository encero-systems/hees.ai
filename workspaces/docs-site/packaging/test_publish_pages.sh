#!/bin/sh

set -eu

TEST_ROOT=$(mktemp -d "${TMPDIR:-/tmp}/hees-docs-publish-test.XXXXXX")
PASS_COUNT=0

cleanup() {
    rm -rf "$TEST_ROOT"
}

trap cleanup EXIT HUP INT TERM

fail() {
    printf 'Pages publication test failed: %s\n' "$1" >&2
    exit 1
}

pass() {
    PASS_COUNT=$((PASS_COUNT + 1))
    printf 'ok %s - %s\n' "$PASS_COUNT" "$1"
}

expect_failure() {
    label=$1
    expected=$2
    shift 2
    if "$@" >"$TEST_ROOT/failure.stdout" 2>"$TEST_ROOT/failure.stderr"; then
        fail "$label unexpectedly succeeded"
    fi
    grep -F "$expected" "$TEST_ROOT/failure.stderr" >/dev/null || fail "$label did not report $expected"
    pass "$label"
}

source_root="$TEST_ROOT/source"
remote_root="$TEST_ROOT/remote.git"
push_remote_root="$TEST_ROOT/push-remote.git"
stage="$TEST_ROOT/staged"
mkdir -p "$source_root/workspaces/docs-site/packaging" "$stage"
cp "$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)/publish_pages.sh" "$source_root/workspaces/docs-site/packaging/publish_pages.sh"
chmod 755 "$source_root/workspaces/docs-site/packaging/publish_pages.sh"
git -C "$source_root" init --quiet
git -C "$source_root" config user.name 'Pages test'
git -C "$source_root" config user.email 'pages-test@example.invalid'
printf '%s\n' source >"$source_root/source.txt"
git -C "$source_root" add .
git -C "$source_root" commit --quiet -m 'test source'
source_commit=$(git -C "$source_root" rev-parse HEAD)

git init --bare --quiet "$remote_root"
seed="$TEST_ROOT/seed"
git clone --quiet "$remote_root" "$seed"
git -C "$seed" config user.name 'Pages seed'
git -C "$seed" config user.email 'pages-seed@example.invalid'
printf '%s\n' legacy >"$seed/index.html"
printf '%s\n' legacy >"$seed/SOURCE_COMMIT"
touch "$seed/.nojekyll"
git -C "$seed" add .
git -C "$seed" commit --quiet -m 'legacy pages'
git -C "$seed" branch -M gh-pages
git -C "$seed" push --quiet origin gh-pages
git --git-dir="$remote_root" symbolic-ref HEAD refs/heads/gh-pages
initial_pages_commit=$(git -C "$seed" rev-parse HEAD)
git -C "$source_root" remote add pages "$remote_root"

printf '%s\n' '<!doctype html><title>hees.ai</title>' >"$stage/index.html"
printf '%s\n' "$source_commit" >"$stage/SOURCE_COMMIT"
touch "$stage/.nojekyll"
publisher="$source_root/workspaces/docs-site/packaging/publish_pages.sh"

expect_failure \
    'publication requires an explicit flag' \
    'publish_flag_required' \
    "$publisher" --site "$stage" --source-commit "$source_commit" --remote pages --branch gh-pages

printf '%s\n' aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa >"$stage/SOURCE_COMMIT"
expect_failure \
    'staged provenance must match source' \
    'site_source_commit_mismatch' \
    "$publisher" --site "$stage" --source-commit "$source_commit" --remote pages --branch gh-pages --publish
printf '%s\n' "$source_commit" >"$stage/SOURCE_COMMIT"

mkdir -p "$stage/nested/.git"
expect_failure \
    'staged content cannot carry nested Git metadata' \
    'site_vcs_control_entry' \
    "$publisher" --site "$stage" --source-commit "$source_commit" --remote pages --branch gh-pages --publish
rmdir "$stage/nested/.git" "$stage/nested"

printf '%s\n' submodule >"$stage/.gitmodules"
expect_failure \
    'staged content cannot carry submodule metadata' \
    'site_vcs_control_entry' \
    "$publisher" --site "$stage" --source-commit "$source_commit" --remote pages --branch gh-pages --publish
rm "$stage/.gitmodules"

expect_failure \
    'missing remote branch fails deterministically' \
    'remote_branch_missing' \
    "$publisher" --site "$stage" --source-commit "$source_commit" --remote pages --branch missing-pages --publish

ln -s index.html "$stage/alias.html"
expect_failure \
    'staged symlink is rejected' \
    'site_symlink' \
    "$publisher" --site "$stage" --source-commit "$source_commit" --remote pages --branch gh-pages --publish
rm "$stage/alias.html"

if command -v mkfifo >/dev/null 2>&1; then
    mkfifo "$stage/unexpected.pipe"
    expect_failure \
        'staged special file is rejected' \
        'site_special_file' \
        "$publisher" --site "$stage" --source-commit "$source_commit" --remote pages --branch gh-pages --publish
    rm "$stage/unexpected.pipe"
fi

printf '%s\n' dirty >"$source_root/untracked.txt"
expect_failure \
    'dirty source is rejected' \
    'source_tree_dirty' \
    "$publisher" --site "$stage" --source-commit "$source_commit" --remote pages --branch gh-pages --publish
rm "$source_root/untracked.txt"

git init --bare --quiet "$push_remote_root"
git -C "$source_root" remote set-url --push pages "$push_remote_root"
expect_failure \
    'distinct push URL is rejected' \
    'remote_pushurl_mismatch' \
    "$publisher" --site "$stage" --source-commit "$source_commit" --remote pages --branch gh-pages --publish
git -C "$source_root" remote set-url --push pages "$remote_root"

advance="$TEST_ROOT/advance"
git clone --quiet "$remote_root" "$advance"
git -C "$advance" config user.name 'Pages advance'
git -C "$advance" config user.email 'pages-advance@example.invalid'
git -C "$advance" checkout --quiet gh-pages
printf '%s\n' remote-advanced >"$advance/remote-advanced.txt"
git -C "$advance" add remote-advanced.txt
git -C "$advance" commit --quiet -m 'advance pages remotely'
advance_commit=$(git -C "$advance" rev-parse HEAD)
git -C "$advance" push --quiet origin "HEAD:refs/hees-pages-test/advance"
[ "$(git --git-dir="$remote_root" rev-parse refs/heads/gh-pages)" = "$initial_pages_commit" ] || fail 'race setup advanced gh-pages too early'

wrapper_root="$TEST_ROOT/git-wrapper"
wrapper_state="$TEST_ROOT/git-wrapper-state"
mkdir "$wrapper_root"
printf '%s\n' 0 >"$wrapper_state"
cat >"$wrapper_root/git" <<'EOF'
#!/bin/sh
set -eu

command_name=
for argument in "$@"
do
    if [ "$argument" = ls-remote ]; then
        command_name=ls-remote
        break
    fi
done
if [ "$command_name" = ls-remote ]; then
    count=$(cat "$PAGES_RACE_STATE")
    count=$((count + 1))
    printf '%s\n' "$count" >"$PAGES_RACE_STATE"
    if [ "$count" = 2 ]; then
        "$REAL_GIT" --git-dir="$PAGES_RACE_REMOTE" update-ref refs/heads/gh-pages "$PAGES_RACE_ADVANCE_COMMIT"
    fi
fi
exec "$REAL_GIT" "$@"
EOF
chmod 755 "$wrapper_root/git"
real_git=$(command -v git)
expect_failure \
    'remote movement before push is rejected without rewriting gh-pages' \
    'remote_advanced_before_push' \
    env \
    PATH="$wrapper_root:$PATH" \
    REAL_GIT="$real_git" \
    PAGES_RACE_STATE="$wrapper_state" \
    PAGES_RACE_REMOTE="$remote_root" \
    PAGES_RACE_ADVANCE_COMMIT="$advance_commit" \
    "$publisher" --site "$stage" --source-commit "$source_commit" --remote pages --branch gh-pages --publish
[ "$(cat "$wrapper_state")" = 2 ] || fail 'race wrapper did not run between both remote checks'
[ "$(git --git-dir="$remote_root" rev-parse refs/heads/gh-pages)" = "$advance_commit" ] || fail 'race rejection rewrote gh-pages'
git --git-dir="$remote_root" show "refs/heads/gh-pages:remote-advanced.txt" | grep -Fx remote-advanced >/dev/null || fail 'remote advancement was not retained'
if git --git-dir="$remote_root" show "refs/heads/gh-pages:index.html" | grep -F '<title>hees.ai</title>' >/dev/null; then
    fail 'race rejection published staged content'
fi
pass 'remote movement before push leaves the advanced remote branch intact'

"$publisher" --site "$stage" --source-commit "$source_commit" --remote pages --branch gh-pages --publish
published_pages_commit=$(git --git-dir="$remote_root" rev-parse refs/heads/gh-pages)
[ "$published_pages_commit" != "$initial_pages_commit" ] || fail 'publication did not advance gh-pages'
git --git-dir="$remote_root" merge-base --is-ancestor "$initial_pages_commit" "$published_pages_commit" || fail 'publication rewrote gh-pages ancestry'
git --git-dir="$remote_root" show "refs/heads/gh-pages:SOURCE_COMMIT" | grep -Fx "$source_commit" >/dev/null || fail 'published provenance is missing'
git --git-dir="$remote_root" show "refs/heads/gh-pages:index.html" | grep -F '<title>hees.ai</title>' >/dev/null || fail 'published site is missing'
pass 'explicit publication preserves remote ancestry and source provenance'

"$publisher" --site "$stage" --source-commit "$source_commit" --remote pages --branch gh-pages --publish >"$TEST_ROOT/already-current.stdout"
grep -F 'already_current' "$TEST_ROOT/already-current.stdout" >/dev/null || fail 'unchanged staged site was not recognized'
[ "$(git --git-dir="$remote_root" rev-parse refs/heads/gh-pages)" = "$published_pages_commit" ] || fail 'unchanged publication rewrote gh-pages'
pass 'unchanged staged site does not create another publication commit'

printf '1..%s\n' "$PASS_COUNT"
