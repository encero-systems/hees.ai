#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
REPOSITORY_ROOT=$(CDPATH='' cd -- "$SCRIPT_DIR/../../.." && pwd)

fail() {
    printf 'hees-docs-pages: %s\n' "$1" >&2
    exit 1
}

usage() {
    printf '%s\n' 'usage: prepare_pages.sh --site DIRECTORY --destination DIRECTORY --source-commit COMMIT [--forbidden TEXT ...]' >&2
    exit 64
}

require_value() {
    if [ "$#" -lt 2 ] || [ -z "$2" ]; then
        fail "missing_option_value"
    fi
}

append_forbidden() {
    forbidden=$1
    [ -n "$forbidden" ] || fail "empty_forbidden_text"
    case "$forbidden" in
        *'
'*) fail "invalid_forbidden_text" ;;
    esac
    if [ -n "$FORBIDDEN_TEXT" ]; then
        FORBIDDEN_TEXT="$FORBIDDEN_TEXT
$forbidden"
    else
        FORBIDDEN_TEXT=$forbidden
    fi
}

scan_text_file() {
    scan_file=$1
    if LC_ALL=C grep -I -E \
        '(-----BEGIN [A-Z ]*PRIVATE KEY-----|AKIA[0-9A-Z]{16}|gh[pousr]_[A-Za-z0-9_]{20,}|sk-[A-Za-z0-9_-]{20,}|xox[baprs]-[A-Za-z0-9-]{20,})' \
        "$scan_file" >/dev/null 2>&1; then
        fail "credential_pattern_leak"
    fi
    slash=/
    users_directory=Users
    home_directory=home
    private_path_pattern="(${slash}${users_directory}${slash}|${slash}${home_directory}${slash}[^/[:space:]]+${slash}|[A-Za-z]:[\\\\/]+${users_directory}[\\\\/]|/build-home(/|$))"
    if LC_ALL=C grep -I -E "$private_path_pattern" "$scan_file" >/dev/null 2>&1; then
        fail "private_path_pattern_leak"
    fi
    while IFS= read -r forbidden
    do
        [ -n "$forbidden" ] || continue
        if grep -I -F -- "$forbidden" "$scan_file" >/dev/null 2>&1; then
            fail "forbidden_text_leak"
        fi
    done <"$FORBIDDEN_FILE"
    for credential_name in \
        ANTHROPIC_API_KEY \
        AWS_SECRET_ACCESS_KEY \
        AWS_SESSION_TOKEN \
        GH_TOKEN \
        GITHUB_TOKEN \
        HF_TOKEN \
        HUGGING_FACE_HUB_TOKEN \
        OPENAI_API_KEY
    do
        credential_value=$(printenv "$credential_name" 2>/dev/null || :)
        [ -n "$credential_value" ] || continue
        if grep -I -F -- "$credential_value" "$scan_file" >/dev/null 2>&1; then
            fail "credential_value_leak"
        fi
    done
}

prepare_pages() {
    site=$1
    destination=$2
    source_commit=$3
    printf '%s\n' "$source_commit" | grep -Eq '^[0-9a-f]{40}$' || fail "invalid_source_commit"
    head_commit=$(git -C "$REPOSITORY_ROOT" rev-parse HEAD 2>/dev/null) || fail "source_git_unavailable"
    [ "$source_commit" = "$head_commit" ] || fail "source_commit_mismatch"
    source_status=$(git -C "$REPOSITORY_ROOT" status --porcelain=v1 --untracked-files=all 2>/dev/null) || fail "source_git_unavailable"
    if [ -n "$source_status" ] && [ "${HEES_PAGES_ALLOW_DIRTY_SOURCE:-0}" != 1 ]; then
        fail "source_tree_dirty"
    fi
    [ -d "$site" ] || fail "site_missing"
    site_root=$(CDPATH='' cd -- "$site" 2>/dev/null && pwd -P) || fail "site_unavailable"
    [ -s "$site_root/index.html" ] || fail "site_index_missing"
    [ ! -e "$destination" ] || fail "destination_exists"
    destination_parent=$(CDPATH='' cd -- "$(dirname -- "$destination")" 2>/dev/null && pwd -P) || fail "destination_parent_missing"
    case "$destination_parent/$(basename -- "$destination")" in
        "$REPOSITORY_ROOT" | "$REPOSITORY_ROOT"/*) fail "destination_inside_repository" ;;
    esac
    if find "$site_root" -type l -print | grep . >/dev/null 2>&1; then
        fail "site_symlink"
    fi
    if find "$site_root" ! -type f ! -type d -print | grep . >/dev/null 2>&1; then
        fail "site_special_file"
    fi
    append_forbidden "$REPOSITORY_ROOT"
    append_forbidden "$HOME"
    site_files=$(mktemp "${TMPDIR:-/tmp}/hees-docs-pages-files.XXXXXX") || fail "temporary_file_unavailable"
    FORBIDDEN_FILE=$(mktemp "${TMPDIR:-/tmp}/hees-docs-pages-forbidden.XXXXXX") || fail "temporary_file_unavailable"
    trap 'rm -f "$site_files" "$FORBIDDEN_FILE"' EXIT HUP INT TERM
    printf '%s\n' "$FORBIDDEN_TEXT" >"$FORBIDDEN_FILE"
    find "$site_root" -type f -print | LC_ALL=C sort >"$site_files" || fail "site_listing_failed"
    while IFS= read -r site_file
    do
        scan_text_file "$site_file"
    done <"$site_files"
    mkdir "$destination_parent/$(basename -- "$destination")" || fail "destination_create_failed"
    COPYFILE_DISABLE=1 cp -R "$site_root"/. "$destination_parent/$(basename -- "$destination")"/ || fail "site_copy_failed"
    destination_root="$destination_parent/$(basename -- "$destination")"
    : >"$destination_root/.nojekyll"
    printf '%s\n' "$source_commit" >"$destination_root/SOURCE_COMMIT"
    [ -s "$destination_root/index.html" ] || fail "staged_index_missing"
    if find "$destination_root" -type l -print | grep . >/dev/null 2>&1; then
        fail "staged_symlink"
    fi
    rm -f "$site_files" "$FORBIDDEN_FILE"
    trap - EXIT HUP INT TERM
}

site=
destination=
source_commit=
FORBIDDEN_TEXT=
while [ "$#" -gt 0 ]; do
    case "$1" in
        --site) require_value "$@"; site=$2; shift 2 ;;
        --destination) require_value "$@"; destination=$2; shift 2 ;;
        --source-commit) require_value "$@"; source_commit=$2; shift 2 ;;
        --forbidden) require_value "$@"; append_forbidden "$2"; shift 2 ;;
        *) usage ;;
    esac
done
[ -n "$site" ] || fail "site_required"
[ -n "$destination" ] || fail "destination_required"
[ -n "$source_commit" ] || fail "source_commit_required"
prepare_pages "$site" "$destination" "$source_commit"
