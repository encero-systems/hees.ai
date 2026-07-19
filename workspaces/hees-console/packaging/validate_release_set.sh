#!/bin/sh

set -eu

PRODUCT_NAME=hees-console
PRODUCT_VERSION=0.1.0
EXPECTED_TAG=hees-console-v0.1.0

fail() {
    printf 'hees-console-release-set: %s\n' "$1" >&2
    exit 1
}

usage() {
    printf '%s\n' 'usage: validate_release_set.sh --directory DIRECTORY --source-commit COMMIT --tag TAG' >&2
    exit 64
}

require_value() {
    if [ "$#" -lt 2 ] || [ -z "$2" ]; then
        fail "missing_option_value"
    fi
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

assert_native_executable() {
    native_binary=$1
    native_platform=$2
    [ -f "$native_binary" ] && [ -x "$native_binary" ] || fail "binary_not_executable_$native_platform"
    if [ "${HEES_RELEASE_ALLOW_TEST_EXECUTABLE:-0}" = 1 ]; then
        [ -n "${HEES_RELEASE_TEST_ROOT:-}" ] || fail "test_executable_scope_missing"
        case "$native_binary" in
            "$HEES_RELEASE_TEST_ROOT"/*) return ;;
            *) fail "test_executable_scope_invalid" ;;
        esac
    fi
    command -v file >/dev/null 2>&1 || fail "file_utility_unavailable"
    native_description=$(file -b "$native_binary" 2>/dev/null) || fail "binary_format_unavailable_$native_platform"
    case "$native_platform:$native_description" in
        linux-x86_64:*ELF*64-bit*executable*x86-64* | \
        macos-aarch64:*Mach-O*64-bit*executable*arm64* | \
        macos-x86_64:*Mach-O*64-bit*executable*x86_64*) ;;
        *) fail "binary_platform_mismatch_$native_platform" ;;
    esac
}

validate_manifest() {
    manifest=$1
    platform=$2
    source_commit=$3
    jq -s -e \
        --arg product "$PRODUCT_NAME" \
        --arg version "$PRODUCT_VERSION" \
        --arg platform "$platform" \
        --arg commit "$source_commit" \
        '
            length == 1 and
            (.[0] |
                keys == ["artifact", "build", "dependencies", "notices", "platform", "product", "schema_version", "source", "toolchain"] and
                (.product | keys == ["name", "version"]) and
                (.build | keys == ["language", "profile"]) and
                (.source | keys == ["commit", "date_epoch", "tree_state"]) and
                (.toolchain | keys == ["compiler", "compiler_version", "release_archive", "release_sha256"]) and
                (.dependencies | keys == ["incan_lock_file", "incan_lock_sha256"]) and
                (.notices | keys == ["notice_file", "notice_sha256", "notice_source", "third_party_licenses_file", "third_party_licenses_sha256"]) and
                (.artifact | keys == ["name", "sha256", "size_bytes"]) and
                .schema_version == 1 and
                .product.name == $product and
                .product.version == $version and
                .build.language == "Incan" and
                .build.profile == "release" and
                .platform == $platform and
                .source.commit == $commit and
                .source.tree_state == "clean" and
                (.source.date_epoch | type == "number" and . >= 0) and
                .toolchain.compiler == "incan" and
                .toolchain.compiler_version == "0.4.0" and
                (.toolchain.release_archive | type == "string" and length > 0) and
                (.toolchain.release_sha256 | test("^[0-9a-f]{64}$")) and
                .dependencies.incan_lock_file == "workspaces/hees-console/incan.lock" and
                (.dependencies.incan_lock_sha256 | test("^[0-9a-f]{64}$")) and
                .notices.notice_file == "NOTICE" and
                .notices.notice_source == "repository_root" and
                (.notices.notice_sha256 | test("^[0-9a-f]{64}$")) and
                .notices.third_party_licenses_file == "THIRD-PARTY-LICENSES.md" and
                (.notices.third_party_licenses_sha256 | test("^[0-9a-f]{64}$")) and
                .artifact.name == $product and
                (.artifact.sha256 | test("^[0-9a-f]{64}$")) and
                (.artifact.size_bytes | type == "number" and . > 0)
            )
        ' \
        "$manifest" >/dev/null || fail "manifest_contract_invalid_$platform"
}

validate_archive_layout() {
    archive=$1
    platform=$2
    scratch=$3
    bundle="$PRODUCT_NAME-$PRODUCT_VERSION-$platform"
    listing="$scratch/$platform.entries"
    tar -tzf "$archive" | LC_ALL=C sort >"$listing" || fail "archive_listing_failed_$platform"
    for expected in \
        "$bundle/" \
        "$bundle/LICENSE" \
        "$bundle/NOTICE" \
        "$bundle/RELEASE-MANIFEST.json" \
        "$bundle/THIRD-PARTY-LICENSES.md" \
        "$bundle/hees-console"
    do
        grep -Fx "$expected" "$listing" >/dev/null || fail "archive_layout_invalid_$platform"
    done
    [ "$(wc -l <"$listing" | tr -d ' ')" = 6 ] || fail "archive_layout_invalid_$platform"
}

validate_platform_set() {
    directory=$1
    platform=$2
    source_commit=$3
    scratch=$4
    base="$PRODUCT_NAME-$PRODUCT_VERSION-$platform"
    archive="$directory/$base.tar.gz"
    checksum="$archive.sha256"
    manifest="$directory/$base.manifest.json"
    [ -f "$archive" ] || fail "archive_missing_$platform"
    [ -f "$checksum" ] || fail "checksum_missing_$platform"
    [ -f "$manifest" ] || fail "manifest_missing_$platform"
    [ "$(wc -l <"$checksum" | tr -d ' ')" = 1 ] || fail "checksum_contract_invalid_$platform"
    [ "$(awk 'NR == 1 {print NF}' "$checksum")" = 2 ] || fail "checksum_contract_invalid_$platform"
    expected_digest=$(awk 'NR == 1 {print $1}' "$checksum")
    expected_name=$(awk 'NR == 1 {print $2}' "$checksum")
    printf '%s\n' "$expected_digest" | grep -Eq '^[0-9a-f]{64}$' || fail "checksum_contract_invalid_$platform"
    [ "$expected_name" = "$base.tar.gz" ] || fail "checksum_contract_invalid_$platform"
    [ "$(sha256_file "$archive")" = "$expected_digest" ] || fail "archive_checksum_mismatch_$platform"
    validate_manifest "$manifest" "$platform" "$source_commit"
    validate_archive_layout "$archive" "$platform" "$scratch"
    extract_root="$scratch/$platform.bundle"
    mkdir "$extract_root"
    tar -xzf "$archive" -C "$extract_root" || fail "archive_extract_failed_$platform"
    bundle="$extract_root/$base"
    [ -d "$bundle" ] || fail "bundle_missing_$platform"
    [ "$(find "$bundle" -mindepth 1 -maxdepth 1 -type f | wc -l | tr -d ' ')" = 5 ] || fail "bundle_file_set_invalid_$platform"
    [ -s "$bundle/LICENSE" ] || fail "license_missing_$platform"
    [ -s "$bundle/NOTICE" ] || fail "notice_missing_$platform"
    [ -s "$bundle/THIRD-PARTY-LICENSES.md" ] || fail "third_party_licenses_missing_$platform"
    assert_native_executable "$bundle/hees-console" "$platform"
    internal_manifest="$bundle/RELEASE-MANIFEST.json"
    cmp "$manifest" "$internal_manifest" >/dev/null || fail "manifest_sidecar_mismatch_$platform"
    [ "$(sha256_file "$bundle/hees-console")" = "$(jq -r '.artifact.sha256' "$manifest")" ] || fail "manifest_binary_hash_mismatch_$platform"
    [ "$(file_size "$bundle/hees-console")" = "$(jq -r '.artifact.size_bytes' "$manifest")" ] || fail "manifest_binary_size_mismatch_$platform"
    [ "$(sha256_file "$bundle/NOTICE")" = "$(jq -r '.notices.notice_sha256' "$manifest")" ] || fail "manifest_notice_hash_mismatch_$platform"
    [ "$(sha256_file "$bundle/THIRD-PARTY-LICENSES.md")" = "$(jq -r '.notices.third_party_licenses_sha256' "$manifest")" ] || fail "manifest_third_party_hash_mismatch_$platform"
}

validate_release_set() {
    directory=$1
    source_commit=$2
    tag=$3
    [ "$tag" = "$EXPECTED_TAG" ] || fail "release_tag_mismatch"
    printf '%s\n' "$source_commit" | grep -Eq '^[0-9a-f]{40}$' || fail "invalid_source_commit"
    [ -d "$directory" ] || fail "release_directory_missing"
    command -v jq >/dev/null 2>&1 || fail "jq_unavailable"
    entry_count=0
    for entry in "$directory"/*
    do
        [ -f "$entry" ] && [ ! -L "$entry" ] || fail "release_set_non_file"
        name=$(basename -- "$entry")
        case "$name" in
            hees-console-0.1.0-linux-x86_64.tar.gz | \
            hees-console-0.1.0-linux-x86_64.tar.gz.sha256 | \
            hees-console-0.1.0-linux-x86_64.manifest.json | \
            hees-console-0.1.0-macos-aarch64.tar.gz | \
            hees-console-0.1.0-macos-aarch64.tar.gz.sha256 | \
            hees-console-0.1.0-macos-aarch64.manifest.json | \
            hees-console-0.1.0-macos-x86_64.tar.gz | \
            hees-console-0.1.0-macos-x86_64.tar.gz.sha256 | \
            hees-console-0.1.0-macos-x86_64.manifest.json) ;;
            *) fail "release_set_unexpected_entry" ;;
        esac
        entry_count=$((entry_count + 1))
    done
    [ "$entry_count" -eq 9 ] || fail "release_set_incomplete"
    if [ "${HEES_RELEASE_ALLOW_TEST_EXECUTABLE:-0}" = 1 ]; then
        [ -d "${HEES_RELEASE_TEST_ROOT:-}" ] || fail "test_executable_scope_missing"
        scratch=$(mktemp -d "$HEES_RELEASE_TEST_ROOT/validator.XXXXXX")
    else
        scratch=$(mktemp -d "${TMPDIR:-/tmp}/hees-console-release-set.XXXXXX")
    fi
    trap 'rm -rf "$scratch"' EXIT HUP INT TERM
    validate_platform_set "$directory" linux-x86_64 "$source_commit" "$scratch"
    validate_platform_set "$directory" macos-aarch64 "$source_commit" "$scratch"
    validate_platform_set "$directory" macos-x86_64 "$source_commit" "$scratch"
    rm -rf "$scratch"
    trap - EXIT HUP INT TERM
}

directory=
source_commit=
tag=
while [ "$#" -gt 0 ]; do
    case "$1" in
        --directory) require_value "$@"; directory=$2; shift 2 ;;
        --source-commit) require_value "$@"; source_commit=$2; shift 2 ;;
        --tag) require_value "$@"; tag=$2; shift 2 ;;
        *) usage ;;
    esac
done
[ -n "$directory" ] || fail "release_directory_required"
[ -n "$source_commit" ] || fail "source_commit_required"
[ -n "$tag" ] || fail "release_tag_required"
validate_release_set "$directory" "$source_commit" "$tag"
