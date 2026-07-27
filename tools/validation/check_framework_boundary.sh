#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$root"

errors=0

fail() {
    printf 'boundary error: %s\n' "$1" >&2
    errors=$((errors + 1))
}

scan_repository() {
    local pattern="$1"
    local found=1
    local grep_status
    local matches

    while IFS= read -r path; do
        case "$path" in
            ./.git | ./.git/* | ./.agents/* | ./target/* | */target/* | */site/* | ./tools/validation/check_framework_boundary.sh)
                continue
                ;;
        esac

        if matches="$(LC_ALL=C grep -nE "$pattern" "$path")"; then
            while IFS= read -r match; do
                printf '%s:%s\n' "${path#./}" "$match"
            done <<<"$matches"
            found=0
        else
            grep_status=$?
            if [[ "$grep_status" -gt 1 ]]; then
                printf 'boundary error: could not scan %s\n' "${path#./}" >&2
                return 0
            fi
        fi
    done < <(find . -type f -print | sort)

    return "$found"
}

scan_tracked_paths() {
    local path

    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        fail "tracked-file boundary requires a Git worktree"
        return
    fi

    while IFS= read -r -d '' path; do
        case "$path" in
            .agents/skills/create-pr-description/SKILL.md | .agents/skills/write-commit-message/SKILL.md)
                ;;
            .env.example | */.env.example)
                ;;
            .env | */.env | .env.* | */.env.* | *.key | *.pem | *.p12 | *.pfx)
                fail "tracked credential or environment path is present: $path"
                ;;
            target/* | */target/* | site/* | */site/* | node_modules/* | */node_modules/* | .idea/* | */.idea/* | .vscode/* | */.vscode/* | .agents/* | */.agents/* | outputs/* | */outputs/* | reference/* | */reference/* | research/* | */research/* | corpora/* | */corpora/* | models/* | */models/* | .DS_Store | */.DS_Store | *.swp)
                fail "tracked private or generated path is present: $path"
                ;;
            *.mjs | *.js | *.bin | *.pdf | *.pptx | *.docx | *.gguf | *.safetensors | *.onnx | *.zip | *.tar | *.tar.gz)
                fail "tracked disallowed artifact type is present: $path"
                ;;
            *.incn | *.md | *.json | *.toml | *.lock | *.sh | *.hbs | *.yml | *.yaml | *.txt | *.ndjson | *.css | *.png | .editorconfig | .gitattributes | .gitignore | */.gitignore | LICENSE | NOTICE | Makefile)
                ;;
            *)
                fail "tracked file type is outside the public allowlist: $path"
                ;;
        esac
    done < <(git ls-files -z)
}

required_files=(
    .editorconfig
    .gitattributes
    .gitignore
    CHANGELOG.md
    CODE_OF_CONDUCT.md
    CONTRIBUTING.md
    LICENSE
    Makefile
    NOTICE
    README.md
    SECURITY.md
    incan.lock
    incan.toml
    src/lib.incn
    src/console_profile.incn
    src/console_profile_artifacts.incn
    src/console_profile_evaluation.incn
    src/console_profile_identity.incn
    src/console_profile_models.incn
    src/console_profile_observations.incn
    src/console_profile_planning.incn
    src/console_profile_validation.incn
    src/content_dna.incn
    src/identifiers.incn
    src/package_loader.incn
    src/programme/mod.incn
    src/programme/models.incn
    src/programme/context.incn
    src/programme/decision.incn
    src/programme/evaluation.incn
    src/programme/validation.incn
    src/runtime.incn
    tests/test_console_profile_contract.incn
    tests/test_content_dna_contract.incn
    tests/test_identifier_contract.incn
    tests/test_package_loader_contract.incn
    tests/test_programme_eligibility_contract.incn
    tests/test_runtime_contract.incn
    tools/validation/test_framework_boundary.sh
    tools/licenses/about.toml
    tools/licenses/deny.toml
    tools/licenses/third-party-licenses.hbs
    workspaces/hees-console/packaging/THIRD_PARTY_LICENSES.md
    workspaces/hees-console/contracts/transport/console_runner_request_0_1.schema.json
    workspaces/hees-console/contracts/transport/console_runner_response_0_1.schema.json
    workspaces/hees-console/runner/incan.toml
    workspaces/hees-console/runner/src/main.incn
    workspaces/docs-site/book.toml
    workspaces/docs-site/docs/SUMMARY.md
)

for path in "${required_files[@]}"; do
    if [[ ! -f "$path" ]]; then
        fail "required file is missing: $path"
    fi
done

while IFS= read -r path; do
    case "$path" in
        ./incan.lock | ./.git/* | ./target/* | */target/*) continue ;;
        *) fail "member-local or stray Incan lock is present: ${path#./}" ;;
    esac
done < <(find . -type f -name '*incan.lock' -print | sort)

for path in src/*.incn; do
    case "$path" in
        src/console_profile.incn | src/console_profile_artifacts.incn | src/console_profile_evaluation.incn | src/console_profile_identity.incn | src/console_profile_models.incn | src/console_profile_observations.incn | src/console_profile_planning.incn | src/console_profile_validation.incn | src/content_dna.incn | src/identifiers.incn | src/lib.incn | src/package_loader.incn | src/runtime.incn) ;;
        *) fail "source module is outside the public allowlist: $path" ;;
    esac
done

for path in src/programme/*.incn; do
    case "$path" in
        src/programme/context.incn | src/programme/decision.incn | src/programme/evaluation.incn | src/programme/mod.incn | src/programme/models.incn | src/programme/validation.incn) ;;
        *) fail "guided-programme module is outside the public allowlist: $path" ;;
    esac
done

allowed_docs=(
    workspaces/docs-site/docs/SUMMARY.md
    workspaces/docs-site/docs/architecture.md
    workspaces/docs-site/docs/assets/governed-runtime-authority-flow.png
    workspaces/docs-site/docs/contracts.md
    workspaces/docs-site/docs/console-profile-0-1.md
    workspaces/docs-site/docs/console.md
    workspaces/docs-site/docs/development.md
    workspaces/docs-site/docs/getting-started.md
    workspaces/docs-site/docs/governance-profiles.md
    workspaces/docs-site/docs/guided-programmes.md
    workspaces/docs-site/docs/hyperquant.md
    workspaces/docs-site/docs/hyperquant-turboquant-reference.md
    workspaces/docs-site/docs/index.md
    workspaces/docs-site/docs/rfcs.md
    workspaces/docs-site/docs/whitepapers/spectrum-and-content-dna.md
)

while IFS= read -r path; do
    allowed=false
    for expected in "${allowed_docs[@]}"; do
        if [[ "$path" == "$expected" ]]; then
            allowed=true
        fi
    done
    if [[ "$allowed" != true ]]; then
        fail "documentation file is outside the canonical docs allowlist: $path"
    fi
done < <(find workspaces/docs-site/docs -type f -print | sort)

while IFS= read -r path; do
    case "$path" in
        ./.git | ./.git/* | ./.agents/* | ./target/* | */target/* | */site/*) continue ;;
        */.agents/* | */outputs/* | */reference/* | */research/* | */corpora/* | */models/*)
            fail "private or generated path is present: ${path#./}"
            ;;
        *.mjs | *.js | *.bin | *.pdf | *.pptx | *.docx | *.gguf | *.safetensors | *.onnx | *.zip | *.tar | *.tar.gz)
            fail "disallowed artifact type is present: ${path#./}"
            ;;
        *.incn | *.md | *.json | *.toml | *.lock | *.sh | *.hbs | *.yml | *.yaml | *.txt | *.ndjson | *.css | *.png | ./.editorconfig | ./.gitattributes | ./.gitignore | */.gitignore | ./LICENSE | ./NOTICE | ./Makefile)
            ;;
        *)
            fail "file type is outside the public allowlist: ${path#./}"
            ;;
    esac
done < <(find . -type f -print | sort)

while IFS= read -r path; do
    case "$path" in
        ./.git | ./.git/* | ./.agents/* | ./target/* | */target/* | */site/*) continue ;;
        *) fail "symbolic links are not allowed in the publication candidate: ${path#./}" ;;
    esac
done < <(find . -type l -print | sort)

scan_tracked_paths

if scan_repository '(/Users/|/home/[^/[:space:]]+/|[A-Za-z]:[\\/]+Users[\\/])'; then
    fail "absolute personal filesystem path found"
fi

if scan_repository '(-----BEGIN [A-Z ]*PRIVATE KEY-----|AKIA[0-9A-Z]{16}|gh[pousr]_[A-Za-z0-9_]{20,}|sk-[A-Za-z0-9]{20,})'; then
    fail "high-confidence credential pattern found"
fi

if scan_repository '@(gmail|outlook|hotmail)\.'; then
    fail "personal email address found"
fi

if ! grep -Eq '^license = "Apache-2.0"$' incan.toml; then
    fail "incan.toml must use the Apache-2.0 SPDX identifier"
fi

if ! grep -Eq '^name = "hees_ai"$' incan.toml; then
    fail "the public Incan package name must remain hees_ai"
fi

if grep -RInE --include='*.incn' 'pub::hees([^_[:alnum:]]|$)' src examples workspaces; then
    fail "Incan sources must import the public package through pub::hees_ai"
fi

if ! grep -Eq '^incan-version = "0.5.0-dev.23"$' incan.lock; then
    fail "incan.lock must be generated by pinned Incan 0.5.0-dev.23"
fi

if ! grep -Fq '"const": "console_runner_request_0_1"' workspaces/hees-console/contracts/transport/console_runner_request_0_1.schema.json; then
    fail "console request schema must use the frozen console_runner_request_0_1 identifier"
fi

if ! grep -Fq '"const": "console_runner_response_0_1"' workspaces/hees-console/contracts/transport/console_runner_response_0_1.schema.json; then
    fail "console response schema must use the frozen console_runner_response_0_1 identifier"
fi

if grep -RInE --exclude-dir=target '(hees\.runner\.v1|runner-request-v1|runner-response-v1)' workspaces/hees-console; then
    fail "console transport contains a forbidden runner contract alias"
fi

for public_facade in src/lib.incn; do
    if grep -Eq 'ContentDna([,[:space:]]|$)|ProfileReceipt|CompleteProfileEvaluation|DerivedFinding|ManifestTarget|PremiseIdentity|ProfileEvaluation|ProfileValidation|SpectrumResult|construct_(content_dna|admitted_receipt|rejected_receipt)|content_dna_(identity|answer_digest)|profile_receipt_identity|build_verifier_manifest|classify_(relation|synthesis)|derive_findings|finding_policy_reason|evaluate_console_profile_with_artifacts' "$public_facade"; then
        fail "authority-bearing profile types or intermediate operations are re-exported by $public_facade"
    fi
done

if [[ -f target/lib/hees_ai.incnlib ]] && sed -n '/^  "exports": {/,/^  "vocab":/p' target/lib/hees_ai.incnlib | grep -Eq '"name"[[:space:]]*:[[:space:]]*"(AdmittedReceiptBody|CompleteProfileEvaluation|ContentDna|ContentDnaBody|DerivedFinding|ManifestTarget|ManifestTargetBody|PremiseIdentity|ProfileEvaluation|ProfileReceipt|ProfileValidation|RejectedReceiptBody|SpectrumResult|admitted_atoms|atom_is_admitted|build_verifier_manifest|classify_relation|classify_synthesis|construct_admitted_receipt|construct_content_dna|construct_rejected_receipt|content_dna_answer_digest|content_dna_identity|derive_findings|digest_atom_provenance|digest_package_artifact|digest_proposal|digest_request_binding|evaluate_console_profile|evaluate_console_profile_with_artifacts|finding_policy_reason|profile_receipt_identity|validate_console_package|validate_console_proposal|validate_observation_coverage|validate_request_binding)"'; then
    fail "generated root manifest exports authority-bearing profile symbols or intermediate operations"
fi

if [[ "$errors" -ne 0 ]]; then
    printf 'framework boundary failed with %d error(s)\n' "$errors" >&2
    exit 1
fi

printf 'framework boundary passed\n'
