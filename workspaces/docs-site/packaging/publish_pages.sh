#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
REPOSITORY_ROOT=$(CDPATH='' cd -- "$SCRIPT_DIR/../../.." && pwd)

fail() {
    printf 'hees-docs-publish: %s\n' "$1" >&2
    exit 1
}

usage() {
    printf '%s\n' 'usage: publish_pages.sh --site DIRECTORY --source-commit COMMIT --remote REMOTE --branch BRANCH --publish' >&2
    exit 64
}

require_value() {
    if [ "$#" -lt 2 ] || [ -z "$2" ]; then
        fail "missing_option_value"
    fi
}

cleanup() {
    if [ -n "${WORKTREE:-}" ] && [ -e "$WORKTREE" ]; then
        git -C "$REPOSITORY_ROOT" worktree remove --force "$WORKTREE" >/dev/null 2>&1 || :
    fi
    if [ -n "${TEMP_ROOT:-}" ] && [ -d "$TEMP_ROOT" ]; then
        rm -rf "$TEMP_ROOT"
    fi
}

canonical_directory() {
    CDPATH='' cd -- "$1" 2>/dev/null && pwd -P
}

assert_clean_exact_source() {
    printf '%s\n' "$source_commit" | grep -Eq '^[0-9a-f]{40}$' || fail "invalid_source_commit"
    [ "$(git -C "$REPOSITORY_ROOT" rev-parse HEAD 2>/dev/null)" = "$source_commit" ] || fail "source_commit_mismatch"
    [ -z "$(git -C "$REPOSITORY_ROOT" status --porcelain=v1 --untracked-files=all 2>/dev/null)" ] || fail "source_tree_dirty"
}

assert_staged_site() {
    [ -d "$site" ] || fail "site_missing"
    [ ! -L "$site" ] || fail "site_symlink"
    site=$(canonical_directory "$site") || fail "site_unavailable"
    [ -s "$site/index.html" ] || fail "site_index_missing"
    [ -f "$site/.nojekyll" ] || fail "site_nojekyll_missing"
    [ -f "$site/SOURCE_COMMIT" ] || fail "site_source_commit_missing"
    [ "$(wc -l <"$site/SOURCE_COMMIT" | tr -d ' ')" = 1 ] || fail "site_source_commit_invalid"
    [ "$(cat "$site/SOURCE_COMMIT")" = "$source_commit" ] || fail "site_source_commit_mismatch"
    if find "$site" -type l -print | grep . >/dev/null 2>&1; then
        fail "site_symlink"
    fi
    if find "$site" ! -type f ! -type d -print | grep . >/dev/null 2>&1; then
        fail "site_special_file"
    fi
    if find "$site" \( -name .git -o -name .gitmodules \) -print | grep . >/dev/null 2>&1; then
        fail "site_vcs_control_entry"
    fi
}

remote_tip() {
    tip=$(git -C "$REPOSITORY_ROOT" ls-remote --refs "$remote_url" "refs/heads/$branch" 2>/dev/null) || fail "remote_query_failed"
    [ -n "$tip" ] || fail "remote_branch_missing"
    [ "$(printf '%s\n' "$tip" | wc -l | tr -d ' ')" = 1 ] || fail "remote_branch_missing"
    remote_commit=${tip%%[[:space:]]*}
    printf '%s\n' "$remote_commit" | grep -Eq '^[0-9a-f]{40}$' || fail "remote_tip_invalid"
    printf '%s\n' "$remote_commit"
}

assert_remote_identity() {
    remote_url=$(git -C "$REPOSITORY_ROOT" remote get-url "$remote" 2>/dev/null) || fail "remote_missing"
    push_url=$(git -C "$REPOSITORY_ROOT" remote get-url --push "$remote" 2>/dev/null) || fail "remote_pushurl_unavailable"
    [ "$remote_url" = "$push_url" ] || fail "remote_pushurl_mismatch"
}

publish_pages() {
    assert_clean_exact_source
    assert_staged_site
    printf '%s\n' "$remote" | grep -Eq '^[A-Za-z0-9._-]+$' || fail "invalid_remote"
    assert_remote_identity
    git check-ref-format --branch "$branch" >/dev/null 2>&1 || fail "invalid_branch"
    git -C "$REPOSITORY_ROOT" config --get user.name >/dev/null 2>&1 || fail "git_author_name_missing"
    git -C "$REPOSITORY_ROOT" config --get user.email >/dev/null 2>&1 || fail "git_author_email_missing"

    TEMP_ROOT=$(mktemp -d "${TMPDIR:-/tmp}/hees-docs-publish.XXXXXX") || fail "temporary_directory_unavailable"
    STAGED_SNAPSHOT="$TEMP_ROOT/staged"
    mkdir "$STAGED_SNAPSHOT" || fail "staged_snapshot_create_failed"
    cp -PR "$site"/. "$STAGED_SNAPSHOT"/ || fail "staged_snapshot_copy_failed"
    site=$STAGED_SNAPSHOT
    assert_staged_site

    initial_remote_tip=$(remote_tip)
    remote_ref="refs/remotes/$remote/$branch"
    git -C "$REPOSITORY_ROOT" fetch --no-tags "$remote_url" "refs/heads/$branch:$remote_ref" >/dev/null 2>&1 || fail "remote_fetch_failed"
    [ "$(git -C "$REPOSITORY_ROOT" rev-parse "$remote_ref" 2>/dev/null)" = "$initial_remote_tip" ] || fail "remote_advanced_before_staging"

    WORKTREE="$TEMP_ROOT/gh-pages"
    git -C "$REPOSITORY_ROOT" worktree add --detach "$WORKTREE" "$remote_ref" >/dev/null 2>&1 || fail "worktree_create_failed"
    git -C "$WORKTREE" rm -r --ignore-unmatch . >/dev/null 2>&1 || fail "pages_tree_clear_failed"
    git -C "$WORKTREE" clean -fdx >/dev/null 2>&1 || fail "pages_tree_clean_failed"
    cp -R "$site"/. "$WORKTREE"/ || fail "site_copy_failed"
    git -C "$WORKTREE" add --all

    if git -C "$WORKTREE" diff --cached --quiet; then
        printf '%s\n' 'hees-docs-publish: already_current'
        return
    fi
    git -C "$WORKTREE" commit -m "docs: publish hees.ai documentation for $source_commit" >/dev/null 2>&1 || fail "pages_commit_failed"
    git -C "$WORKTREE" merge-base --is-ancestor "$initial_remote_tip" HEAD >/dev/null 2>&1 || fail "remote_ancestry_not_preserved"
    [ "$(remote_tip)" = "$initial_remote_tip" ] || fail "remote_advanced_before_push"
    git -C "$WORKTREE" push "$remote_url" "HEAD:refs/heads/$branch" >/dev/null 2>&1 || fail "remote_push_rejected"
    [ "$(remote_tip)" = "$(git -C "$WORKTREE" rev-parse HEAD)" ] || fail "remote_push_unverified"
    published_commit=$(git -C "$WORKTREE" rev-parse HEAD)
    printf '%s\n' "hees-docs-publish: published $branch $published_commit"
}

site=
source_commit=
remote=
branch=
publish=0
while [ "$#" -gt 0 ]; do
    case "$1" in
        --site) require_value "$@"; site=$2; shift 2 ;;
        --source-commit) require_value "$@"; source_commit=$2; shift 2 ;;
        --remote) require_value "$@"; remote=$2; shift 2 ;;
        --branch) require_value "$@"; branch=$2; shift 2 ;;
        --publish) publish=1; shift ;;
        *) usage ;;
    esac
done
[ -n "$site" ] || fail "site_required"
[ -n "$source_commit" ] || fail "source_commit_required"
[ -n "$remote" ] || fail "remote_required"
[ -n "$branch" ] || fail "branch_required"
[ "$publish" = 1 ] || fail "publish_flag_required"

trap cleanup EXIT HUP INT TERM
publish_pages
