#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
REPOSITORY_ROOT=$(CDPATH='' cd -- "$SCRIPT_DIR/../../.." && pwd)
RELEASE_TOOL="$SCRIPT_DIR/release_candidate.sh"
TEST_ROOT=$(mktemp -d "${TMPDIR:-/tmp}/hees-console-release-test.XXXXXX")
PASS_COUNT=0

cleanup() {
    rm -rf "$TEST_ROOT"
}

trap cleanup EXIT HUP INT TERM

fail() {
    printf 'release contract test failed: %s\n' "$1" >&2
    exit 1
}

pass() {
    PASS_COUNT=$((PASS_COUNT + 1))
    printf 'ok %s - %s\n' "$PASS_COUNT" "$1"
}

sha256_file() {
    if command -v sha256sum >/dev/null 2>&1; then
        digest_line=$(sha256sum "$1")
    elif command -v shasum >/dev/null 2>&1; then
        digest_line=$(shasum -a 256 "$1")
    else
        fail "no SHA-256 tool is available"
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
    if ! grep -F "$expected" "$stderr_file" >/dev/null; then
        cat "$stderr_file" >&2
        fail "$label did not report $expected"
    fi
    pass "$label"
}

make_fake_console() {
    destination=$1
    marker=${2:-}
    mkdir -p "$(dirname -- "$destination")"
    {
        cat <<'EOF'
#!/bin/sh
set -eu
scenario=
while [ "$#" -gt 0 ]; do
    case "$1" in
        --mode) [ "${2:-}" = offline ] || exit 64; shift 2 ;;
        --scenario) scenario=${2:-}; shift 2 ;;
        --headless) shift ;;
        *) exit 64 ;;
    esac
done
case "$scenario" in
    valid) printf '%s\n' 'STATE ADMITTED reason=admitted' ;;
    undeclared-action) printf '%s\n' 'STATE REJECTED reason=unknown_action' ;;
    unknown-memory) printf '%s\n' 'STATE REJECTED reason=unknown_memory' ;;
    non-admitted-memory) printf '%s\n' 'STATE REJECTED reason=memory_not_admitted' ;;
    *) exit 64 ;;
esac
EOF
        if [ -n "$marker" ]; then
            printf '# %s\n' "$marker"
        fi
    } >"$destination"
    chmod 755 "$destination"
}

make_fake_incan() {
    destination=$1
    mkdir -p "$destination/bin"
    {
        printf '%s\n' '#!/bin/sh'
        printf '%s\n' 'printf "%s\\n" "incan 0.4.0"'
    } >"$destination/bin/incan"
    chmod 755 "$destination/bin/incan"
}

platform=$("$RELEASE_TOOL" current-platform)
case "$platform" in
    linux-x86_64 | macos-aarch64 | macos-x86_64) ;;
    *) fail "host platform is outside the supported test lanes: $platform" ;;
esac

expect_failure \
    "unsupported platform fails closed" \
    "unsupported_platform" \
    "$RELEASE_TOOL" validate-platform --platform not-a-platform

"$RELEASE_TOOL" validate-platform --platform "$platform"
pass "current platform is accepted"

fake_console="$TEST_ROOT/hees-console"
fake_incan="$TEST_ROOT/incan-0.4.0"
fake_incan_lock="$TEST_ROOT/incan.lock"
output="$TEST_ROOT/output"
source_commit=$(git -C "$REPOSITORY_ROOT" rev-parse HEAD)
source_date_epoch=$(git -C "$REPOSITORY_ROOT" show -s --format=%ct HEAD)
make_fake_console "$fake_console"
make_fake_incan "$fake_incan"
printf '%s\n' 'lock-version = "1"' >"$fake_incan_lock"
fake_incan_lock_sha256=$(sha256_file "$fake_incan_lock")
repository_notice_sha256=$(sha256_file "$REPOSITORY_ROOT/NOTICE")
third_party_licenses_source="$TEST_ROOT/THIRD_PARTY_LICENSES.md"
cp "$SCRIPT_DIR/THIRD_PARTY_LICENSES.md" "$third_party_licenses_source"
printf '\nrelease-test-platform-report\n' >>"$third_party_licenses_source"
export THIRD_PARTY_LICENSES_SOURCE="$third_party_licenses_source"
third_party_licenses_sha256=$(sha256_file "$third_party_licenses_source")

expect_failure \
    "missing Console dependency lock is rejected" \
    "incan_lock_missing" \
    env ALLOW_DIRTY_SOURCE=1 HEES_RELEASE_ALLOW_TEST_EXECUTABLE=1 \
    "$RELEASE_TOOL" package \
    --binary "$fake_console" \
    --platform "$platform" \
    --output-directory "$TEST_ROOT/missing-lock-output" \
    --source-commit "$source_commit" \
    --source-date-epoch "$source_date_epoch" \
    --incan-root "$fake_incan" \
    --incan-lock "$TEST_ROOT/missing.incan.lock"

expect_failure \
    "missing platform license report is rejected" \
    "third_party_licenses_missing" \
    env ALLOW_DIRTY_SOURCE=1 HEES_RELEASE_ALLOW_TEST_EXECUTABLE=1 THIRD_PARTY_LICENSES_SOURCE= \
    "$RELEASE_TOOL" package \
    --binary "$fake_console" \
    --platform "$platform" \
    --output-directory "$TEST_ROOT/missing-licenses-output" \
    --source-commit "$source_commit" \
    --source-date-epoch "$source_date_epoch" \
    --incan-root "$fake_incan" \
    --incan-lock "$fake_incan_lock"

ALLOW_DIRTY_SOURCE=1 HEES_RELEASE_ALLOW_TEST_EXECUTABLE=1 \
    "$RELEASE_TOOL" package \
    --binary "$fake_console" \
    --platform "$platform" \
    --output-directory "$output" \
    --source-commit "$source_commit" \
    --source-date-epoch "$source_date_epoch" \
    --incan-root "$fake_incan" \
    --incan-lock "$fake_incan_lock" \
    --forbidden "$REPOSITORY_ROOT" \
    --forbidden "$HOME"

archive="$output/hees-console-0.1.0-$platform.tar.gz"
checksum="$archive.sha256"
manifest="$output/hees-console-0.1.0-$platform.manifest.json"
[ -f "$archive" ] || fail "archive was not produced"
[ -f "$checksum" ] || fail "checksum was not produced"
[ -f "$manifest" ] || fail "manifest sidecar was not produced"
grep -F '"language":"Incan"' "$manifest" >/dev/null || fail "manifest does not identify Incan"
grep -F '"compiler_version":"0.4.0"' "$manifest" >/dev/null || fail "manifest does not pin Incan 0.4.0"
grep -F "\"incan_lock_sha256\":\"$fake_incan_lock_sha256\"" "$manifest" >/dev/null || fail "manifest does not bind the Console dependency lock"
grep -F "\"notice_source\":\"repository_root\",\"notice_sha256\":\"$repository_notice_sha256\"" "$manifest" >/dev/null || fail "manifest does not bind repository NOTICE provenance"
grep -F "\"third_party_licenses_sha256\":\"$third_party_licenses_sha256\"" "$manifest" >/dev/null || fail "manifest does not bind third-party license provenance"
pass "native release archive and provenance are assembled"

HEES_RELEASE_ALLOW_TEST_EXECUTABLE=1 \
    "$RELEASE_TOOL" smoke-archive \
    --archive "$archive" \
    --platform "$platform" \
    --forbidden "$REPOSITORY_ROOT" \
    --forbidden "$HOME"
pass "extracted archive passes all four offline replay smokes"

listing="$TEST_ROOT/archive.list"
tar -tzf "$archive" | LC_ALL=C sort >"$listing"
expected_root="hees-console-0.1.0-$platform"
for expected in \
    "$expected_root/" \
    "$expected_root/LICENSE" \
    "$expected_root/NOTICE" \
    "$expected_root/THIRD-PARTY-LICENSES.md" \
    "$expected_root/RELEASE-MANIFEST.json" \
    "$expected_root/hees-console"
do
    grep -Fx "$expected" "$listing" >/dev/null || fail "archive is missing $expected"
done
[ "$(wc -l <"$listing" | tr -d ' ')" = 6 ] || fail "archive contains unexpected entries"
pass "archive layout is exact"

leaking_console="$TEST_ROOT/leaking-console"
leaking_output="$TEST_ROOT/leaking-output"
make_fake_console "$leaking_console" "$REPOSITORY_ROOT/private-source"
expect_failure \
    "source-path leakage is rejected" \
    "forbidden_path_leak" \
    env ALLOW_DIRTY_SOURCE=1 HEES_RELEASE_ALLOW_TEST_EXECUTABLE=1 \
    "$RELEASE_TOOL" package \
    --binary "$leaking_console" \
    --platform "$platform" \
    --output-directory "$leaking_output" \
    --source-commit "$source_commit" \
    --source-date-epoch "$source_date_epoch" \
    --incan-root "$fake_incan" \
    --incan-lock "$fake_incan_lock" \
    --forbidden "$REPOSITORY_ROOT"

credential_console="$TEST_ROOT/credential-console"
credential_output="$TEST_ROOT/credential-output"
credential_value="hees-release-test-secret-7f5aeef8"
make_fake_console "$credential_console" "$credential_value"
expect_failure \
    "credential-value leakage is rejected" \
    "credential_value_leak" \
    env ALLOW_DIRTY_SOURCE=1 HEES_RELEASE_ALLOW_TEST_EXECUTABLE=1 OPENAI_API_KEY="$credential_value" \
    "$RELEASE_TOOL" package \
    --binary "$credential_console" \
    --platform "$platform" \
    --output-directory "$credential_output" \
    --source-commit "$source_commit" \
    --source-date-epoch "$source_date_epoch" \
    --incan-root "$fake_incan" \
    --incan-lock "$fake_incan_lock"

printf 'corruption' >>"$archive"
expect_failure \
    "corrupted archive checksum is rejected" \
    "archive_checksum_mismatch" \
    env HEES_RELEASE_ALLOW_TEST_EXECUTABLE=1 \
    "$RELEASE_TOOL" smoke-archive \
    --archive "$archive" \
    --platform "$platform"

printf '1..%s\n' "$PASS_COUNT"
