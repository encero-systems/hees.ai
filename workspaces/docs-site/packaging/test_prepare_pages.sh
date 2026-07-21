#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
REPOSITORY_ROOT=$(CDPATH='' cd -- "$SCRIPT_DIR/../../.." && pwd)
PREPARE_PAGES="$SCRIPT_DIR/prepare_pages.sh"
TEST_ROOT=$(mktemp -d "${TMPDIR:-/tmp}/hees-docs-pages-test.XXXXXX")
SOURCE_COMMIT=$(git -C "$REPOSITORY_ROOT" rev-parse HEAD)
PASS_COUNT=0

cleanup() {
    rm -rf "$TEST_ROOT"
}

trap cleanup EXIT HUP INT TERM

fail() {
    printf 'Pages contract test failed: %s\n' "$1" >&2
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
    stdout_file="$TEST_ROOT/failure.stdout"
    stderr_file="$TEST_ROOT/failure.stderr"
    if "$@" >"$stdout_file" 2>"$stderr_file"; then
        fail "$label unexpectedly succeeded"
    fi
    grep -F "$expected" "$stderr_file" >/dev/null || fail "$label did not report $expected"
    pass "$label"
}

make_site() {
    site_root=$1
    content=${2:-public documentation}
    mkdir -p "$site_root/assets"
    printf '<!doctype html><title>hees.ai</title><p>%s</p>\n' "$content" >"$site_root/index.html"
    printf '%s\n' 'body { color: #3ecf8e; }' >"$site_root/assets/site.css"
}

site="$TEST_ROOT/site"
destination="$TEST_ROOT/staged"
make_site "$site"
HEES_PAGES_ALLOW_DIRTY_SOURCE=1 "$PREPARE_PAGES" \
    --site "$site" \
    --destination "$destination" \
    --source-commit "$SOURCE_COMMIT"
[ -s "$destination/index.html" ] || fail "index was not staged"
[ -f "$destination/.nojekyll" ] || fail ".nojekyll was not staged"
[ "$(cat "$destination/SOURCE_COMMIT")" = "$SOURCE_COMMIT" ] || fail "source provenance was not staged"
[ -s "$destination/assets/site.css" ] || fail "nested asset was not staged"
pass "clean public site is staged with source provenance"

expect_failure \
    "existing destination is rejected" \
    "destination_exists" \
    env HEES_PAGES_ALLOW_DIRTY_SOURCE=1 "$PREPARE_PAGES" \
    --site "$site" \
    --destination "$destination" \
    --source-commit "$SOURCE_COMMIT"

expect_failure \
    "source identity mismatch is rejected" \
    "source_commit_mismatch" \
    env HEES_PAGES_ALLOW_DIRTY_SOURCE=1 "$PREPARE_PAGES" \
    --site "$site" \
    --destination "$TEST_ROOT/source-mismatch" \
    --source-commit aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa

path_site="$TEST_ROOT/path-site"
make_site "$path_site" "$REPOSITORY_ROOT/private-source"
expect_failure \
    "private source path is rejected" \
    "private_path_pattern_leak" \
    env HEES_PAGES_ALLOW_DIRTY_SOURCE=1 "$PREPARE_PAGES" \
    --site "$path_site" \
    --destination "$TEST_ROOT/path-output" \
    --source-commit "$SOURCE_COMMIT"

credential_site="$TEST_ROOT/credential-site"
credential_value=hees-pages-secret-7f5aeef8
make_site "$credential_site" "$credential_value"
expect_failure \
    "credential value is rejected" \
    "credential_value_leak" \
    env HEES_PAGES_ALLOW_DIRTY_SOURCE=1 OPENAI_API_KEY="$credential_value" "$PREPARE_PAGES" \
    --site "$credential_site" \
    --destination "$TEST_ROOT/credential-output" \
    --source-commit "$SOURCE_COMMIT"

pattern_site="$TEST_ROOT/pattern-site"
make_site "$pattern_site" sk-proj-abcdefghijklmnopqrstuvwxyz123456
expect_failure \
    "credential pattern is rejected" \
    "credential_pattern_leak" \
    env HEES_PAGES_ALLOW_DIRTY_SOURCE=1 "$PREPARE_PAGES" \
    --site "$pattern_site" \
    --destination "$TEST_ROOT/pattern-output" \
    --source-commit "$SOURCE_COMMIT"

remapped_path_site="$TEST_ROOT/remapped-path-site"
make_site "$remapped_path_site" /build-home/Development/private-source
expect_failure \
    "remapped private path is rejected" \
    "private_path_pattern_leak" \
    env HEES_PAGES_ALLOW_DIRTY_SOURCE=1 "$PREPARE_PAGES" \
    --site "$remapped_path_site" \
    --destination "$TEST_ROOT/remapped-path-output" \
    --source-commit "$SOURCE_COMMIT"

symlink_site="$TEST_ROOT/symlink-site"
make_site "$symlink_site"
ln -s index.html "$symlink_site/alias.html"
expect_failure \
    "symbolic link is rejected" \
    "site_symlink" \
    env HEES_PAGES_ALLOW_DIRTY_SOURCE=1 "$PREPARE_PAGES" \
    --site "$symlink_site" \
    --destination "$TEST_ROOT/symlink-output" \
    --source-commit "$SOURCE_COMMIT"

docs_workflow="$REPOSITORY_ROOT/.github/workflows/docs.yml"
if grep -Eq 'HEES_PAGES_ALLOW_DIRTY_SOURCE|ALLOW_DIRTY_SOURCE' "$docs_workflow"; then
    fail "docs workflow bypasses clean-source publication"
fi
pass "docs workflow preserves clean-source publication"

printf '1..%s\n' "$PASS_COUNT"
