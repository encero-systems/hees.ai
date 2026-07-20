#!/bin/sh

set -eu

PRODUCT_NAME=hees-console
PRODUCT_VERSION=0.1.0
INCAN_VERSION=0.5.0-dev.21
INCAN_SOURCE_REPOSITORY=https://github.com/encero-systems/incan.git
INCAN_SOURCE_COMMIT=66c69edae20745598effdecf40778bf53f9ecd67
SCRIPT_DIR=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
REPOSITORY_ROOT=$(CDPATH='' cd -- "$SCRIPT_DIR/../../.." && pwd)
THIRD_PARTY_LICENSES_SOURCE=${THIRD_PARTY_LICENSES_SOURCE:-}

fail() {
    printf 'hees-console-release: %s\n' "$1" >&2
    exit 1
}

usage() {
    cat >&2 <<'EOF'
usage:
  release_candidate.sh current-platform
  release_candidate.sh validate-platform --platform PLATFORM
  release_candidate.sh prepare-incan --platform PLATFORM --destination DIRECTORY
  THIRD_PARTY_LICENSES_SOURCE=FILE release_candidate.sh package --binary FILE --platform PLATFORM --output-directory DIRECTORY --source-commit COMMIT --source-date-epoch EPOCH --incan-root DIRECTORY --incan-lock FILE [--forbidden PATH ...]
  release_candidate.sh smoke-binary --binary FILE
  release_candidate.sh smoke-archive --archive FILE --platform PLATFORM [--forbidden PATH ...]
EOF
    exit 64
}

require_value() {
    if [ "$#" -lt 2 ] || [ -z "$2" ]; then
        fail "missing_option_value"
    fi
}

normalize_machine() {
    case "$1" in
        amd64 | x86_64) printf '%s\n' x86_64 ;;
        arm64 | aarch64) printf '%s\n' aarch64 ;;
        *) printf '%s\n' "$1" ;;
    esac
}

current_platform() {
    system=$(uname -s)
    machine=$(normalize_machine "$(uname -m)")
    case "$system:$machine" in
        Linux:x86_64) printf '%s\n' linux-x86_64 ;;
        Darwin:aarch64) printf '%s\n' macos-aarch64 ;;
        Darwin:x86_64) printf '%s\n' macos-x86_64 ;;
        *) fail "unsupported_host_platform" ;;
    esac
}

load_platform() {
    PLATFORM_ID=$1
    case "$PLATFORM_ID" in
        linux-x86_64)
            PLATFORM_SYSTEM=Linux
            PLATFORM_MACHINE=x86_64
            ;;
        macos-aarch64)
            PLATFORM_SYSTEM=Darwin
            PLATFORM_MACHINE=aarch64
            ;;
        macos-x86_64)
            PLATFORM_SYSTEM=Darwin
            PLATFORM_MACHINE=x86_64
            ;;
        *) fail "unsupported_platform" ;;
    esac
}

validate_platform() {
    load_platform "$1"
    actual_system=$(uname -s)
    actual_machine=$(normalize_machine "$(uname -m)")
    [ "$actual_system" = "$PLATFORM_SYSTEM" ] || fail "platform_system_mismatch"
    [ "$actual_machine" = "$PLATFORM_MACHINE" ] || fail "platform_machine_mismatch"
}

sha256_file() {
    if command -v sha256sum >/dev/null 2>&1; then
        digest_line=$(sha256sum "$1" 2>/dev/null) || fail "file_hash_failed"
    elif command -v shasum >/dev/null 2>&1; then
        digest_line=$(shasum -a 256 "$1" 2>/dev/null) || fail "file_hash_failed"
    else
        fail "sha256_tool_unavailable"
    fi
    printf '%s\n' "${digest_line%% *}"
}

file_size() {
    wc -c <"$1" | tr -d ' '
}

canonical_file_path() {
    canonical_directory=$(CDPATH='' cd -- "$(dirname -- "$1")" 2>/dev/null && pwd -P) || fail "path_unavailable"
    printf '%s/%s\n' "$canonical_directory" "$(basename -- "$1")"
}

assert_test_path_scope() {
    [ ! -L "$1" ] || fail "test_executable_scope_invalid"
    test_path=$(canonical_file_path "$1")
    [ -n "${HEES_RELEASE_TEST_ROOT:-}" ] || fail "test_executable_scope_missing"
    test_root=$(CDPATH='' cd -- "$HEES_RELEASE_TEST_ROOT" 2>/dev/null && pwd -P) || fail "test_executable_scope_invalid"
    case "$test_path" in
        "$test_root"/*) ;;
        *) fail "test_executable_scope_invalid" ;;
    esac
}

make_temp_directory() {
    if [ "${HEES_RELEASE_ALLOW_TEST_EXECUTABLE:-0}" = 1 ]; then
        [ -n "${HEES_RELEASE_TEST_ROOT:-}" ] || fail "test_executable_scope_missing"
        test_root=$(CDPATH='' cd -- "$HEES_RELEASE_TEST_ROOT" 2>/dev/null && pwd -P) || fail "test_executable_scope_invalid"
        mktemp -d "$test_root/release.XXXXXX"
        return
    fi
    mktemp -d "${TMPDIR:-/tmp}/hees-console-release.XXXXXX"
}

create_deterministic_tar() {
    destination=$1
    source_root=$2
    bundle_name=$3
    source_date_epoch=$4
    tar_version=$(tar --version 2>/dev/null) || fail "archive_tool_unavailable"
    case "$tar_version" in
        *"GNU tar"*)
            COPYFILE_DISABLE=1 LC_ALL=C tar \
                --format=ustar \
                --sort=name \
                --owner=0 \
                --group=0 \
                --numeric-owner \
                --mtime="@$source_date_epoch" \
                -cf "$destination" \
                -C "$source_root" \
                "$bundle_name" || fail "archive_create_failed"
            ;;
        *)
            COPYFILE_DISABLE=1 LC_ALL=C tar \
                --format=ustar \
                --uid 0 \
                --gid 0 \
                --uname root \
                --gname root \
                -cf "$destination" \
                -C "$source_root" \
                "$bundle_name" || fail "archive_create_failed"
            ;;
    esac
}

assert_safe_source_commit() {
    printf '%s\n' "$1" | grep -Eq '^[0-9a-f]{40}$' || fail "invalid_source_commit"
    head_commit=$(git -C "$REPOSITORY_ROOT" rev-parse HEAD 2>/dev/null) || fail "source_git_unavailable"
    [ "$head_commit" = "$1" ] || fail "source_commit_mismatch"
}

assert_source_date_epoch() {
    source_commit=$1
    source_date_epoch=$2
    printf '%s\n' "$source_date_epoch" | grep -Eq '^[0-9]{1,12}$' || fail "invalid_source_date_epoch"
    expected_epoch=$(git -C "$REPOSITORY_ROOT" show -s --format=%ct "$source_commit" 2>/dev/null) || fail "source_git_unavailable"
    [ "$source_date_epoch" = "$expected_epoch" ] || fail "source_date_epoch_mismatch"
}

assert_incan_provenance() {
    incan_root=$1
    incan_binary="$incan_root/bin/incan"
    [ -x "$incan_binary" ] || fail "incan_binary_missing"
    [ "$("$incan_binary" --version 2>/dev/null)" = "incan $INCAN_VERSION" ] || fail "incan_version_mismatch"
    if [ "${HEES_RELEASE_ALLOW_TEST_EXECUTABLE:-0}" = 1 ]; then
        assert_test_path_scope "$incan_binary"
        return
    fi
    [ -d "$incan_root/source/.git" ] || fail "incan_source_missing"
    incan_commit=$(git -C "$incan_root/source" rev-parse HEAD 2>/dev/null) || fail "incan_source_unavailable"
    [ "$incan_commit" = "$INCAN_SOURCE_COMMIT" ] || fail "incan_source_commit_mismatch"
    incan_status=$(git -C "$incan_root/source" status --porcelain=v1 --untracked-files=no 2>/dev/null) || fail "incan_source_unavailable"
    [ -z "$incan_status" ] || fail "incan_source_dirty"
    [ -L "$incan_binary" ] || fail "incan_binary_provenance_missing"
    [ "$(readlink "$incan_binary" 2>/dev/null)" = "../source/target/release/incan" ] || fail "incan_binary_provenance_mismatch"
}

assert_incan_lock_provenance() {
    incan_lock=$1
    if [ ! -f "$incan_lock" ] || [ ! -s "$incan_lock" ]; then
        fail "incan_lock_missing"
    fi
    if [ "${HEES_RELEASE_ALLOW_TEST_EXECUTABLE:-0}" = 1 ]; then
        assert_test_path_scope "$incan_lock"
        return
    fi
    [ "$(canonical_file_path "$incan_lock")" = "$REPOSITORY_ROOT/incan.lock" ] || fail "incan_lock_provenance_mismatch"
}

source_tree_state() {
    source_status=$(git -C "$REPOSITORY_ROOT" status --porcelain=v1 --untracked-files=all 2>/dev/null) || fail "source_git_unavailable"
    if [ -z "$source_status" ]; then
        printf '%s\n' clean
        return
    fi
    [ "${ALLOW_DIRTY_SOURCE:-0}" = 1 ] || fail "source_tree_dirty"
    printf '%s\n' dirty
}

set_file_mtime() {
    epoch=$1
    shift
    if touch -d "@$epoch" "$@" 2>/dev/null; then
        return
    fi
    timestamp=$(date -u -r "$epoch" '+%Y%m%d%H%M.%S' 2>/dev/null) || fail "source_date_epoch_unsupported"
    TZ=UTC touch -t "$timestamp" "$@" || fail "source_date_epoch_unsupported"
}

assert_native_executable() {
    binary=$1
    platform=${2:-}
    if [ ! -f "$binary" ] || [ ! -x "$binary" ]; then
        fail "binary_not_executable"
    fi
    if [ "${HEES_RELEASE_ALLOW_TEST_EXECUTABLE:-0}" = 1 ]; then
        assert_test_path_scope "$binary"
        return
    fi
    command -v file >/dev/null 2>&1 || fail "binary_format_unavailable"
    description=$(file -b "$binary" 2>/dev/null) || fail "binary_format_unavailable"
    if [ -z "$platform" ]; then
        case "$description" in
            *ELF*executable* | *Mach-O*executable*) ;;
            *) fail "binary_not_native" ;;
        esac
        return
    fi
    case "$platform:$description" in
        linux-x86_64:*ELF*64-bit*executable*x86-64* | \
        macos-aarch64:*Mach-O*64-bit*executable*arm64* | \
        macos-x86_64:*Mach-O*64-bit*executable*x86_64*) ;;
        *) fail "binary_platform_mismatch" ;;
    esac
}

append_forbidden() {
    path=$1
    [ -n "$path" ] || fail "empty_forbidden_path"
    case "$path" in
        *'
'*) fail "invalid_forbidden_path" ;;
    esac
    if [ -n "$FORBIDDEN_PATHS" ]; then
        FORBIDDEN_PATHS="$FORBIDDEN_PATHS
$path"
    else
        FORBIDDEN_PATHS=$path
    fi
}

scan_forbidden_paths() {
    bundle=$1
    [ -n "$FORBIDDEN_PATHS" ] || return
    paths_file=$2
    binary_strings=$3
    printf '%s\n' "$FORBIDDEN_PATHS" >"$paths_file"
    while IFS= read -r forbidden
    do
        [ -n "$forbidden" ] || continue
        for bundled_file in "$bundle/LICENSE" "$bundle/NOTICE" "$bundle/RUNNING.txt" "$bundle/THIRD-PARTY-LICENSES.md" "$bundle/RELEASE-MANIFEST.json"
        do
            if grep -F -- "$forbidden" "$bundled_file" >/dev/null 2>&1; then
                fail "forbidden_path_leak"
            fi
        done
        if grep -F -- "$forbidden" "$binary_strings" >/dev/null 2>&1; then
            fail "forbidden_path_leak"
        fi
    done <"$paths_file"
}

scan_credential_values() {
    bundle=$1
    binary_strings=$2
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
        for bundled_file in "$bundle/LICENSE" "$bundle/NOTICE" "$bundle/RUNNING.txt" "$bundle/THIRD-PARTY-LICENSES.md" "$bundle/RELEASE-MANIFEST.json"
        do
            if grep -F -- "$credential_value" "$bundled_file" >/dev/null 2>&1; then
                fail "credential_value_leak"
            fi
        done
        if grep -F -- "$credential_value" "$binary_strings" >/dev/null 2>&1; then
            fail "credential_value_leak"
        fi
    done
}

scan_credential_patterns() {
    bundle=$1
    binary_strings=$2
    for bundled_file in \
        "$bundle/LICENSE" \
        "$bundle/NOTICE" \
        "$bundle/RUNNING.txt" \
        "$bundle/THIRD-PARTY-LICENSES.md" \
        "$bundle/RELEASE-MANIFEST.json" \
        "$binary_strings"
    do
        if LC_ALL=C grep -E \
            '(-----BEGIN [A-Z ]*PRIVATE KEY-----|AKIA[0-9A-Z]{16}|gh[pousr]_[A-Za-z0-9_]{20,}|sk-[A-Za-z0-9_-]{20,}|xox[baprs]-[A-Za-z0-9-]{20,})' \
            "$bundled_file" >/dev/null 2>&1; then
            fail "credential_pattern_leak"
        fi
    done
}

scan_private_path_patterns() {
    bundle=$1
    binary_strings=$2
    slash=/
    users_directory=Users
    home_directory=home
    private_path_pattern="(${slash}${users_directory}${slash}|${slash}${home_directory}${slash}[^/[:space:]]+${slash}|[A-Za-z]:[\\\\/]+${users_directory}[\\\\/]|/build-home(/|$))"
    for bundled_file in \
        "$bundle/LICENSE" \
        "$bundle/NOTICE" \
        "$bundle/RUNNING.txt" \
        "$bundle/THIRD-PARTY-LICENSES.md" \
        "$bundle/RELEASE-MANIFEST.json" \
        "$binary_strings"
    do
        if LC_ALL=C grep -E "$private_path_pattern" "$bundled_file" >/dev/null 2>&1; then
            fail "private_path_pattern_leak"
        fi
    done
}

audit_bundle() {
    bundle=$1
    scratch=$2
    platform=${3:-}
    [ -d "$bundle" ] || fail "bundle_missing"
    find "$bundle" ! -path "$bundle" -print >"$scratch/bundle-entries"
    count=0
    while IFS= read -r entry
    do
        [ ! -L "$entry" ] || fail "bundle_symlink"
        [ -f "$entry" ] || fail "bundle_non_file"
        relative=${entry#"$bundle"/}
        case "$relative" in
            LICENSE | NOTICE | RUNNING.txt | THIRD-PARTY-LICENSES.md | RELEASE-MANIFEST.json | hees-console) ;;
            *) fail "bundle_unexpected_entry" ;;
        esac
        count=$((count + 1))
    done <"$scratch/bundle-entries"
    [ "$count" -eq 6 ] || fail "bundle_incomplete"
    [ -s "$bundle/LICENSE" ] || fail "license_missing"
    [ -s "$bundle/NOTICE" ] || fail "notice_missing"
    [ -s "$bundle/RUNNING.txt" ] || fail "running_instructions_missing"
    [ -s "$bundle/THIRD-PARTY-LICENSES.md" ] || fail "third_party_licenses_missing"
    [ -s "$bundle/RELEASE-MANIFEST.json" ] || fail "manifest_missing"
    assert_native_executable "$bundle/hees-console" "$platform"
    bundled_binary_sha256=$(sha256_file "$bundle/hees-console")
    bundled_binary_size=$(file_size "$bundle/hees-console")
    bundled_notice_sha256=$(sha256_file "$bundle/NOTICE")
    bundled_third_party_sha256=$(sha256_file "$bundle/THIRD-PARTY-LICENSES.md")
    grep -F -- "\"sha256\":\"$bundled_binary_sha256\",\"size_bytes\":$bundled_binary_size" "$bundle/RELEASE-MANIFEST.json" >/dev/null || fail "manifest_binary_mismatch"
    grep -F -- "\"notice_sha256\":\"$bundled_notice_sha256\"" "$bundle/RELEASE-MANIFEST.json" >/dev/null || fail "manifest_notice_mismatch"
    grep -F -- "\"third_party_licenses_sha256\":\"$bundled_third_party_sha256\"" "$bundle/RELEASE-MANIFEST.json" >/dev/null || fail "manifest_third_party_licenses_mismatch"
    command -v strings >/dev/null 2>&1 || fail "strings_tool_unavailable"
    binary_strings="$scratch/binary-strings"
    strings "$bundle/hees-console" >"$binary_strings" 2>/dev/null || fail "binary_strings_failed"
    scan_forbidden_paths "$bundle" "$scratch/forbidden-paths" "$binary_strings"
    scan_credential_values "$bundle" "$binary_strings"
    scan_credential_patterns "$bundle" "$binary_strings"
    scan_private_path_patterns "$bundle" "$binary_strings"
}

write_manifest() {
    destination=$1
    platform=$2
    source_commit=$3
    source_date_epoch=$4
    tree_state=$5
    binary_sha256=$6
    binary_size=$7
    incan_lock_sha256=$8
    notice_sha256=$9
    third_party_licenses_sha256=${10}
    running_sha256=${11}
    cat >"$destination" <<EOF
{"schema_version":1,"product":{"name":"$PRODUCT_NAME","version":"$PRODUCT_VERSION"},"build":{"language":"Incan","profile":"release"},"platform":"$platform","source":{"commit":"$source_commit","date_epoch":$source_date_epoch,"tree_state":"$tree_state"},"toolchain":{"compiler":"incan","compiler_version":"$INCAN_VERSION","source_repository":"$INCAN_SOURCE_REPOSITORY","source_commit":"$INCAN_SOURCE_COMMIT"},"dependencies":{"incan_lock_file":"incan.lock","incan_lock_sha256":"$incan_lock_sha256"},"guidance":{"running_file":"RUNNING.txt","running_sha256":"$running_sha256"},"notices":{"notice_file":"NOTICE","notice_source":"repository_root","notice_sha256":"$notice_sha256","third_party_licenses_file":"THIRD-PARTY-LICENSES.md","third_party_licenses_sha256":"$third_party_licenses_sha256"},"artifact":{"name":"hees-console","sha256":"$binary_sha256","size_bytes":$binary_size}}
EOF
}

smoke_binary() {
    binary=$1
    assert_native_executable "$binary"
    scratch=$(make_temp_directory)
    trap 'rm -rf "$scratch"' EXIT HUP INT TERM
    mkdir -p "$scratch/home" "$scratch/work"
    run_smoke_scenario "$binary" valid ADMITTED '' "$scratch"
    run_smoke_scenario "$binary" undeclared-action REJECTED unknown_action "$scratch"
    run_smoke_scenario "$binary" unknown-evidence REJECTED unknown_evidence "$scratch"
    run_smoke_scenario "$binary" unknown-memory REJECTED unknown_memory "$scratch"
    run_smoke_scenario "$binary" non-admitted-memory REJECTED memory_not_admitted "$scratch"
    rm -rf "$scratch"
    trap - EXIT HUP INT TERM
}

run_smoke_scenario() {
    binary=$1
    scenario=$2
    expected_state=$3
    expected_reason=$4
    scratch=$5
    stdout_file="$scratch/$scenario.stdout"
    stderr_file="$scratch/$scenario.stderr"
    if ! (
        cd "$scratch/work"
        env -i HOME="$scratch/home" PATH=/usr/bin:/bin LC_ALL=C LANG=C \
            "$binary" --mode offline --scenario "$scenario" --headless
    ) >"$stdout_file" 2>"$stderr_file"; then
        fail "headless_replay_failed_$scenario"
    fi
    [ ! -s "$stderr_file" ] || fail "headless_replay_stderr_$scenario"
    grep -F "$expected_state" "$stdout_file" >/dev/null || fail "headless_replay_state_$scenario"
    if [ -n "$expected_reason" ]; then
        grep -F "$expected_reason" "$stdout_file" >/dev/null || fail "headless_replay_reason_$scenario"
    fi
}

prepare_incan() {
    platform=$1
    destination=$2
    validate_platform "$platform"
    [ ! -e "$destination" ] || fail "incan_destination_exists"
    command -v cargo >/dev/null 2>&1 || fail "cargo_unavailable"
    command -v git >/dev/null 2>&1 || fail "git_unavailable"
    mkdir -p "$destination/source" "$destination/bin"
    git -C "$destination/source" init --quiet || fail "incan_source_init_failed"
    git -C "$destination/source" remote add origin "$INCAN_SOURCE_REPOSITORY" || fail "incan_source_remote_failed"
    git -C "$destination/source" fetch --quiet --depth 1 origin "$INCAN_SOURCE_COMMIT" || fail "incan_source_fetch_failed"
    git -C "$destination/source" checkout --quiet --detach FETCH_HEAD || fail "incan_source_checkout_failed"
    [ "$(git -C "$destination/source" rev-parse HEAD 2>/dev/null)" = "$INCAN_SOURCE_COMMIT" ] || fail "incan_source_commit_mismatch"
    cargo build \
        --manifest-path "$destination/source/Cargo.toml" \
        --locked \
        --release \
        --bin incan || fail "incan_source_build_failed"
    ln -s ../source/target/release/incan "$destination/bin/incan" || fail "incan_install_failed"
    [ "$("$destination/bin/incan" --version 2>/dev/null)" = "incan $INCAN_VERSION" ] || fail "incan_version_mismatch"
}

package_release() {
    binary=$1
    platform=$2
    output_directory=$3
    source_commit=$4
    source_date_epoch=$5
    incan_root=$6
    incan_lock=$7
    validate_platform "$platform"
    assert_native_executable "$binary" "$platform"
    assert_safe_source_commit "$source_commit"
    assert_source_date_epoch "$source_commit" "$source_date_epoch"
    assert_incan_provenance "$incan_root"
    assert_incan_lock_provenance "$incan_lock"
    if [ -z "$THIRD_PARTY_LICENSES_SOURCE" ] || [ ! -f "$THIRD_PARTY_LICENSES_SOURCE" ] || [ ! -s "$THIRD_PARTY_LICENSES_SOURCE" ]; then
        fail "third_party_licenses_missing"
    fi
    tree_state=$(source_tree_state)
    append_forbidden "$incan_root"

    mkdir -p "$output_directory"
    archive_name="$PRODUCT_NAME-$PRODUCT_VERSION-$platform.tar.gz"
    archive="$output_directory/$archive_name"
    checksum="$archive.sha256"
    sidecar_manifest="$output_directory/$PRODUCT_NAME-$PRODUCT_VERSION-$platform.manifest.json"
    if [ -e "$archive" ] || [ -e "$checksum" ] || [ -e "$sidecar_manifest" ]; then
        fail "release_output_exists"
    fi

    scratch=$(make_temp_directory)
    trap 'rm -rf "$scratch"' EXIT HUP INT TERM
    bundle_name="$PRODUCT_NAME-$PRODUCT_VERSION-$platform"
    bundle="$scratch/$bundle_name"
    mkdir -p "$bundle"
    install -m 755 "$binary" "$bundle/hees-console"
    install -m 644 "$REPOSITORY_ROOT/LICENSE" "$bundle/LICENSE"
    install -m 644 "$REPOSITORY_ROOT/NOTICE" "$bundle/NOTICE"
    install -m 644 "$SCRIPT_DIR/RUNNING.txt" "$bundle/RUNNING.txt"
    install -m 644 "$THIRD_PARTY_LICENSES_SOURCE" "$bundle/THIRD-PARTY-LICENSES.md"
    binary_sha256=$(sha256_file "$bundle/hees-console")
    binary_size=$(file_size "$bundle/hees-console")
    incan_lock_sha256=$(sha256_file "$incan_lock")
    notice_sha256=$(sha256_file "$bundle/NOTICE")
    third_party_licenses_sha256=$(sha256_file "$bundle/THIRD-PARTY-LICENSES.md")
    running_sha256=$(sha256_file "$bundle/RUNNING.txt")
    write_manifest \
        "$bundle/RELEASE-MANIFEST.json" \
        "$platform" \
        "$source_commit" \
        "$source_date_epoch" \
        "$tree_state" \
        "$binary_sha256" \
        "$binary_size" \
        "$incan_lock_sha256" \
        "$notice_sha256" \
        "$third_party_licenses_sha256" \
        "$running_sha256"
    chmod 644 "$bundle/RELEASE-MANIFEST.json"
    audit_bundle "$bundle" "$scratch" "$platform"
    set_file_mtime "$source_date_epoch" \
        "$bundle" \
        "$bundle/hees-console" \
        "$bundle/LICENSE" \
        "$bundle/NOTICE" \
        "$bundle/RUNNING.txt" \
        "$bundle/THIRD-PARTY-LICENSES.md" \
        "$bundle/RELEASE-MANIFEST.json"
    cp "$bundle/RELEASE-MANIFEST.json" "$sidecar_manifest"
    set_file_mtime "$source_date_epoch" "$sidecar_manifest"

    tar_file="$output_directory/$PRODUCT_NAME-$PRODUCT_VERSION-$platform.tar"
    create_deterministic_tar "$tar_file" "$scratch" "$bundle_name" "$source_date_epoch"
    gzip -n -9 "$tar_file" || fail "archive_compress_failed"
    [ "$tar_file.gz" = "$archive" ] || fail "archive_name_mismatch"
    archive_sha256=$(sha256_file "$archive")
    printf '%s  %s\n' "$archive_sha256" "$archive_name" >"$checksum"
    set_file_mtime "$source_date_epoch" "$archive" "$checksum"
    rm -rf "$scratch"
    trap - EXIT HUP INT TERM
}

smoke_archive() {
    archive=$1
    platform=$2
    validate_platform "$platform"
    expected_name="$PRODUCT_NAME-$PRODUCT_VERSION-$platform.tar.gz"
    [ "$(basename -- "$archive")" = "$expected_name" ] || fail "archive_name_mismatch"
    [ -f "$archive" ] || fail "archive_missing"
    checksum="$archive.sha256"
    [ -f "$checksum" ] || fail "archive_checksum_missing"
    expected_checksum=$(awk 'NR == 1 {print $1}' "$checksum")
    printf '%s\n' "$expected_checksum" | grep -Eq '^[0-9a-f]{64}$' || fail "archive_checksum_invalid"
    [ "$(awk 'NR == 1 {print $2}' "$checksum")" = "$expected_name" ] || fail "archive_checksum_filename"
    [ "$(sha256_file "$archive")" = "$expected_checksum" ] || fail "archive_checksum_mismatch"

    scratch=$(make_temp_directory)
    trap 'rm -rf "$scratch"' EXIT HUP INT TERM
    tar -tzf "$archive" >"$scratch/archive-entries" || fail "archive_listing_failed"
    entry_count=0
    bundle_name="$PRODUCT_NAME-$PRODUCT_VERSION-$platform"
    while IFS= read -r entry
    do
        case "$entry" in
            "$bundle_name/" | \
            "$bundle_name/LICENSE" | \
            "$bundle_name/NOTICE" | \
            "$bundle_name/RUNNING.txt" | \
            "$bundle_name/THIRD-PARTY-LICENSES.md" | \
            "$bundle_name/RELEASE-MANIFEST.json" | \
            "$bundle_name/hees-console") ;;
            *) fail "archive_unexpected_entry" ;;
        esac
        entry_count=$((entry_count + 1))
    done <"$scratch/archive-entries"
    [ "$entry_count" -eq 7 ] || fail "archive_incomplete"
    tar -xzf "$archive" -C "$scratch" || fail "archive_extract_failed"
    bundle="$scratch/$bundle_name"
    audit_bundle "$bundle" "$scratch" "$platform"
    "$SCRIPT_DIR/release_candidate.sh" smoke-binary --binary "$bundle/hees-console"
    rm -rf "$scratch"
    trap - EXIT HUP INT TERM
}

command=${1:-}
[ -n "$command" ] || usage
shift
FORBIDDEN_PATHS=

case "$command" in
    current-platform)
        [ "$#" -eq 0 ] || usage
        current_platform
        ;;
    validate-platform)
        platform=
        while [ "$#" -gt 0 ]; do
            case "$1" in
                --platform) require_value "$@"; platform=$2; shift 2 ;;
                *) usage ;;
            esac
        done
        [ -n "$platform" ] || fail "platform_required"
        validate_platform "$platform"
        ;;
    prepare-incan)
        platform=
        destination=
        while [ "$#" -gt 0 ]; do
            case "$1" in
                --platform) require_value "$@"; platform=$2; shift 2 ;;
                --destination) require_value "$@"; destination=$2; shift 2 ;;
                *) usage ;;
            esac
        done
        [ -n "$platform" ] || fail "platform_required"
        [ -n "$destination" ] || fail "destination_required"
        prepare_incan "$platform" "$destination"
        ;;
    package)
        binary=
        platform=
        output_directory=
        source_commit=
        source_date_epoch=
        incan_root=
        incan_lock=
        while [ "$#" -gt 0 ]; do
            case "$1" in
                --binary) require_value "$@"; binary=$2; shift 2 ;;
                --platform) require_value "$@"; platform=$2; shift 2 ;;
                --output-directory) require_value "$@"; output_directory=$2; shift 2 ;;
                --source-commit) require_value "$@"; source_commit=$2; shift 2 ;;
                --source-date-epoch) require_value "$@"; source_date_epoch=$2; shift 2 ;;
                --incan-root) require_value "$@"; incan_root=$2; shift 2 ;;
                --incan-lock) require_value "$@"; incan_lock=$2; shift 2 ;;
                --forbidden) require_value "$@"; append_forbidden "$2"; shift 2 ;;
                *) usage ;;
            esac
        done
        [ -n "$binary" ] || fail "binary_required"
        [ -n "$platform" ] || fail "platform_required"
        [ -n "$output_directory" ] || fail "output_directory_required"
        [ -n "$source_commit" ] || fail "source_commit_required"
        [ -n "$source_date_epoch" ] || fail "source_date_epoch_required"
        [ -n "$incan_root" ] || fail "incan_root_required"
        [ -n "$incan_lock" ] || fail "incan_lock_required"
        package_release "$binary" "$platform" "$output_directory" "$source_commit" "$source_date_epoch" "$incan_root" "$incan_lock"
        ;;
    smoke-binary)
        binary=
        while [ "$#" -gt 0 ]; do
            case "$1" in
                --binary) require_value "$@"; binary=$2; shift 2 ;;
                *) usage ;;
            esac
        done
        [ -n "$binary" ] || fail "binary_required"
        smoke_binary "$binary"
        ;;
    smoke-archive)
        archive=
        platform=
        while [ "$#" -gt 0 ]; do
            case "$1" in
                --archive) require_value "$@"; archive=$2; shift 2 ;;
                --platform) require_value "$@"; platform=$2; shift 2 ;;
                --forbidden) require_value "$@"; append_forbidden "$2"; shift 2 ;;
                *) usage ;;
            esac
        done
        [ -n "$archive" ] || fail "archive_required"
        [ -n "$platform" ] || fail "platform_required"
        smoke_archive "$archive" "$platform"
        ;;
    *) usage ;;
esac
