#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
REPOSITORY_ROOT=$(CDPATH='' cd -- "$SCRIPT_DIR/../../.." && pwd)
VALIDATOR="$SCRIPT_DIR/validate_release_set.sh"
TEST_ROOT=$(mktemp -d "${TMPDIR:-/tmp}/hees-console-release-set-test.XXXXXX")
SOURCE_COMMIT=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
RELEASE_TAG=hees-console-v0.1.0
PASS_COUNT=0
export HEES_RELEASE_ALLOW_TEST_EXECUTABLE=1
export HEES_RELEASE_TEST_ROOT="$TEST_ROOT"

cleanup() {
    rm -rf "$TEST_ROOT"
}

trap cleanup EXIT HUP INT TERM

fail() {
    printf 'release set test failed: %s\n' "$1" >&2
    exit 1
}

pass() {
    PASS_COUNT=$((PASS_COUNT + 1))
    printf 'ok %s - %s\n' "$PASS_COUNT" "$1"
}

sha256_file() {
    if command -v sha256sum >/dev/null 2>&1; then
        digest_line=$(sha256sum "$1")
    else
        digest_line=$(shasum -a 256 "$1")
    fi
    printf '%s\n' "${digest_line%% *}"
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

assert_pinned_incan_roots() {
    workflow_file=$1
    expected_count=$2
    workflow_name=$(basename -- "$workflow_file")
    [ "$(grep -Fc "install_root=\"\$RUNNER_TEMP/incan-0.5.0-dev.21\"" "$workflow_file")" -eq "$expected_count" ] ||
        fail "$workflow_name does not bind every Incan build to the pinned install root"
    [ "$(grep -Fc "echo \"INCAN_HOME=\$RUNNER_TEMP/incan-home\"" "$workflow_file")" -eq "$expected_count" ] ||
        fail "$workflow_name does not isolate every pinned Incan provider home"
    [ "$(grep -Fc "echo \"INCAN_STDLIB=\$install_root/source/crates/incan_stdlib/stdlib\"" "$workflow_file")" -eq "$expected_count" ] ||
        fail "$workflow_name does not export every pinned Incan stdlib root"
    [ "$(grep -Fc "echo \"INCAN_TOOLCHAIN_CRATES_DIR=\$install_root/source/crates\"" "$workflow_file")" -eq "$expected_count" ] ||
        fail "$workflow_name does not export every pinned Incan support-crate root"
}

write_manifest() {
    wm_destination=$1
    wm_platform=$2
    wm_source_commit=$3
    wm_binary_sha256=$4
    wm_binary_size=$5
    wm_notice_sha256=$6
    wm_third_party_sha256=$7
    wm_running_sha256=$8
    wm_date_epoch=$9
    cat >"$wm_destination" <<EOF
{"schema_version":1,"product":{"name":"hees-console","version":"0.1.0"},"build":{"language":"Incan","profile":"release"},"platform":"$wm_platform","source":{"commit":"$wm_source_commit","date_epoch":$wm_date_epoch,"tree_state":"clean"},"toolchain":{"compiler":"incan","compiler_version":"0.5.0-dev.21","source_repository":"https://github.com/encero-systems/incan.git","source_commit":"66c69edae20745598effdecf40778bf53f9ecd67"},"dependencies":{"incan_lock_file":"incan.lock","incan_lock_sha256":"cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc"},"guidance":{"running_file":"RUNNING.txt","running_sha256":"$wm_running_sha256"},"notices":{"notice_file":"NOTICE","notice_source":"repository_root","notice_sha256":"$wm_notice_sha256","third_party_licenses_file":"THIRD-PARTY-LICENSES.md","third_party_licenses_sha256":"$wm_third_party_sha256"},"artifact":{"name":"hees-console","sha256":"$wm_binary_sha256","size_bytes":$wm_binary_size}}
EOF
}

make_platform_set() {
    destination=$1
    platform=$2
    source_commit=$3
    date_epoch=${4:-1}
    base="hees-console-0.1.0-$platform"
    scratch=$(mktemp -d "$TEST_ROOT/build-$platform.XXXXXX")
    bundle="$scratch/$base"
    mkdir -p "$bundle" "$destination"
    printf '%s\n' license >"$bundle/LICENSE"
    printf '%s\n' notice >"$bundle/NOTICE"
    printf '%s\n' running >"$bundle/RUNNING.txt"
    printf '%s\n' third-party >"$bundle/THIRD-PARTY-LICENSES.md"
    printf '%s\n' executable >"$bundle/hees-console"
    chmod 755 "$bundle/hees-console"
    write_manifest \
        "$bundle/RELEASE-MANIFEST.json" \
        "$platform" \
        "$source_commit" \
        "$(sha256_file "$bundle/hees-console")" \
        "$(wc -c <"$bundle/hees-console" | tr -d ' ')" \
        "$(sha256_file "$bundle/NOTICE")" \
        "$(sha256_file "$bundle/THIRD-PARTY-LICENSES.md")" \
        "$(sha256_file "$bundle/RUNNING.txt")" \
        "$date_epoch"
    cp "$bundle/RELEASE-MANIFEST.json" "$destination/$base.manifest.json"
    tar -czf "$destination/$base.tar.gz" -C "$scratch" "$base"
    printf '%s  %s\n' "$(sha256_file "$destination/$base.tar.gz")" "$base.tar.gz" >"$destination/$base.tar.gz.sha256"
}

make_release_set() {
    destination=$1
    source_commit=${2:-$SOURCE_COMMIT}
    mkdir -p "$destination"
    make_platform_set "$destination" linux-x86_64 "$source_commit"
    make_platform_set "$destination" macos-aarch64 "$source_commit"
    make_platform_set "$destination" macos-x86_64 "$source_commit"
}

valid="$TEST_ROOT/valid"
make_release_set "$valid"
"$VALIDATOR" --directory "$valid" --source-commit "$SOURCE_COMMIT" --tag "$RELEASE_TAG"
pass "complete release set is accepted"

expect_failure \
    "unexpected release tag is rejected" \
    "release_tag_mismatch" \
    "$VALIDATOR" --directory "$valid" --source-commit "$SOURCE_COMMIT" --tag hees-console-v0.1.1

missing="$TEST_ROOT/missing"
cp -R "$valid" "$missing"
rm "$missing/hees-console-0.1.0-linux-x86_64.manifest.json"
expect_failure \
    "incomplete platform set is rejected" \
    "release_set_incomplete" \
    "$VALIDATOR" --directory "$missing" --source-commit "$SOURCE_COMMIT" --tag "$RELEASE_TAG"

mismatch="$TEST_ROOT/source-mismatch"
make_release_set "$mismatch" bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
expect_failure \
    "source identity mismatch is rejected" \
    "manifest_contract_invalid_linux-x86_64" \
    "$VALIDATOR" --directory "$mismatch" --source-commit "$SOURCE_COMMIT" --tag "$RELEASE_TAG"

date_mismatch="$TEST_ROOT/date-mismatch"
mkdir -p "$date_mismatch"
make_platform_set "$date_mismatch" linux-x86_64 "$SOURCE_COMMIT" 1
make_platform_set "$date_mismatch" macos-aarch64 "$SOURCE_COMMIT" 2
make_platform_set "$date_mismatch" macos-x86_64 "$SOURCE_COMMIT" 1
expect_failure \
    "cross-platform source date mismatch is rejected" \
    "release_set_source_date_mismatch" \
    "$VALIDATOR" --directory "$date_mismatch" --source-commit "$SOURCE_COMMIT" --tag "$RELEASE_TAG"

corrupt="$TEST_ROOT/corrupt"
cp -R "$valid" "$corrupt"
printf '%s\n' corruption >>"$corrupt/hees-console-0.1.0-macos-aarch64.tar.gz"
expect_failure \
    "archive checksum mismatch is rejected" \
    "archive_checksum_mismatch_macos-aarch64" \
    "$VALIDATOR" --directory "$corrupt" --source-commit "$SOURCE_COMMIT" --tag "$RELEASE_TAG"

content_mismatch="$TEST_ROOT/content-mismatch"
cp -R "$valid" "$content_mismatch"
content_scratch=$(mktemp -d "$TEST_ROOT/content-mismatch-build.XXXXXX")
tar -xzf "$content_mismatch/hees-console-0.1.0-linux-x86_64.tar.gz" -C "$content_scratch"
printf '%s\n' tampered >>"$content_scratch/hees-console-0.1.0-linux-x86_64/hees-console"
tar -czf "$content_mismatch/hees-console-0.1.0-linux-x86_64.tar.gz" \
    -C "$content_scratch" \
    hees-console-0.1.0-linux-x86_64
printf '%s  %s\n' \
    "$(sha256_file "$content_mismatch/hees-console-0.1.0-linux-x86_64.tar.gz")" \
    hees-console-0.1.0-linux-x86_64.tar.gz \
    >"$content_mismatch/hees-console-0.1.0-linux-x86_64.tar.gz.sha256"
expect_failure \
    "manifest-bound executable mismatch is rejected" \
    "manifest_binary_hash_mismatch_linux-x86_64" \
    "$VALIDATOR" --directory "$content_mismatch" --source-commit "$SOURCE_COMMIT" --tag "$RELEASE_TAG"

guidance_mismatch="$TEST_ROOT/guidance-mismatch"
cp -R "$valid" "$guidance_mismatch"
guidance_scratch=$(mktemp -d "$TEST_ROOT/guidance-mismatch-build.XXXXXX")
tar -xzf "$guidance_mismatch/hees-console-0.1.0-macos-aarch64.tar.gz" -C "$guidance_scratch"
printf '%s\n' tampered >>"$guidance_scratch/hees-console-0.1.0-macos-aarch64/RUNNING.txt"
tar -czf "$guidance_mismatch/hees-console-0.1.0-macos-aarch64.tar.gz" \
    -C "$guidance_scratch" \
    hees-console-0.1.0-macos-aarch64
printf '%s  %s\n' \
    "$(sha256_file "$guidance_mismatch/hees-console-0.1.0-macos-aarch64.tar.gz")" \
    hees-console-0.1.0-macos-aarch64.tar.gz \
    >"$guidance_mismatch/hees-console-0.1.0-macos-aarch64.tar.gz.sha256"
expect_failure \
    "manifest-bound run guidance mismatch is rejected" \
    "manifest_running_hash_mismatch_macos-aarch64" \
    "$VALIDATOR" --directory "$guidance_mismatch" --source-commit "$SOURCE_COMMIT" --tag "$RELEASE_TAG"

sidecar="$TEST_ROOT/sidecar-mismatch"
cp -R "$valid" "$sidecar"
sed 's/"size_bytes":1/"size_bytes":2/' \
    "$sidecar/hees-console-0.1.0-macos-x86_64.manifest.json" \
    >"$sidecar/changed.manifest"
mv "$sidecar/changed.manifest" "$sidecar/hees-console-0.1.0-macos-x86_64.manifest.json"
expect_failure \
    "internal and sidecar manifest mismatch is rejected" \
    "manifest_sidecar_mismatch_macos-x86_64" \
    "$VALIDATOR" --directory "$sidecar" --source-commit "$SOURCE_COMMIT" --tag "$RELEASE_TAG"

open_manifest="$TEST_ROOT/open-manifest"
cp -R "$valid" "$open_manifest"
jq '. + {unexpected_field: "must fail closed"}' \
    "$open_manifest/hees-console-0.1.0-linux-x86_64.manifest.json" \
    >"$open_manifest/changed.manifest"
mv "$open_manifest/changed.manifest" "$open_manifest/hees-console-0.1.0-linux-x86_64.manifest.json"
expect_failure \
    "open release manifest is rejected" \
    "manifest_contract_invalid_linux-x86_64" \
    "$VALIDATOR" --directory "$open_manifest" --source-commit "$SOURCE_COMMIT" --tag "$RELEASE_TAG"

unexpected="$TEST_ROOT/unexpected"
cp -R "$valid" "$unexpected"
printf '%s\n' unexpected >"$unexpected/unexpected.txt"
expect_failure \
    "unexpected release entry is rejected" \
    "release_set_unexpected_entry" \
    "$VALIDATOR" --directory "$unexpected" --source-commit "$SOURCE_COMMIT" --tag "$RELEASE_TAG"

expect_failure \
    "non-native executable is rejected outside test mode" \
    "binary_platform_mismatch_linux-x86_64" \
    env HEES_RELEASE_ALLOW_TEST_EXECUTABLE=0 \
    "$VALIDATOR" --directory "$valid" --source-commit "$SOURCE_COMMIT" --tag "$RELEASE_TAG"

workflow="$REPOSITORY_ROOT/.github/workflows/console-draft-release.yml"
[ -f "$workflow" ] || fail "draft release workflow is missing"
grep -Fx '      - hees-console-v0.1.0' "$workflow" >/dev/null || fail "draft release workflow does not bind the exact tag"
grep -F -- 'git merge-base --is-ancestor HEAD origin/main' "$workflow" >/dev/null || fail "draft release workflow does not require merged source"
grep -F -- '--draft' "$workflow" >/dev/null || fail "draft release workflow can publish without approval"
grep -F -- '--verify-tag' "$workflow" >/dev/null || fail "draft release workflow does not verify the tag"
[ "$(grep -Fc 'contents: write' "$workflow")" = 1 ] || fail "draft release workflow write authority is not isolated"
if grep -Eq '^[[:space:]]+(pull_request|workflow_dispatch):' "$workflow"; then
    fail "draft release workflow has an unintended trigger"
fi
if grep -Fq 'HEES_RELEASE_ALLOW_TEST_EXECUTABLE' "$workflow"; then
    fail "draft release workflow bypasses native executable validation"
fi
assert_pinned_incan_roots "$workflow" 2
pass "draft release workflow preserves publication authority"

grep -Fq 'sha256sum --check --strict SHA256SUMS' "$workflow" || fail "draft release workflow does not verify aggregate checksums"
grep -Fq "test \"\$(wc -l < SHA256SUMS | tr -d ' ')\" = 9" "$workflow" || fail "draft release workflow does not bind aggregate checksum count"
pass "draft release workflow verifies the complete aggregate checksum set"

platform_contract="$SCRIPT_DIR/release-platforms.json"
jq -e '
    .schema_version == 1 and
    .incan_toolchain.version == "0.5.0-dev.21" and
    .incan_toolchain.source_repository == "https://github.com/encero-systems/incan" and
    .incan_toolchain.source_commit == "66c69edae20745598effdecf40778bf53f9ecd67" and
    (.platforms | keys == ["linux-x86_64", "macos-aarch64", "macos-x86_64"]) and
    .platforms["linux-x86_64"] == {"runner":"ubuntu-24.04","system":"Linux","machine":"x86_64"} and
    .platforms["macos-aarch64"] == {"runner":"macos-15","system":"Darwin","machine":"aarch64"} and
    .platforms["macos-x86_64"] == {"runner":"macos-15-intel","system":"Darwin","machine":"x86_64"}
' "$platform_contract" >/dev/null || fail "release platform contract is inconsistent"
candidate_workflow="$REPOSITORY_ROOT/.github/workflows/console-release-candidate.yml"
if grep -Eq 'HEES_RELEASE_ALLOW_TEST_EXECUTABLE|ALLOW_DIRTY_SOURCE' "$candidate_workflow"; then
    fail "candidate workflow bypasses native or clean-source validation"
fi
for platform in linux-x86_64 macos-aarch64 macos-x86_64
do
    grep -Fq -- "- platform: $platform" "$candidate_workflow" || fail "candidate workflow omits $platform"
done
assert_pinned_incan_roots "$candidate_workflow" 2
assert_pinned_incan_roots "$REPOSITORY_ROOT/.github/workflows/ci.yml" 1
pass "release platform contract matches the candidate matrix"

printf '1..%s\n' "$PASS_COUNT"
