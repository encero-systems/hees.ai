#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$root"

scratch="$(mktemp -d)"
trap 'rm -rf "$scratch"' EXIT

index_source="$(git rev-parse --git-path index)"
index_copy="$scratch/index"
cp "$index_source" "$index_copy"

blob="$(git ls-files -s -- .gitignore | awk 'NR == 1 { print $2 }')"
if [[ -z "$blob" ]]; then
    printf 'boundary self-test error: .gitignore is not present in the index\n' >&2
    exit 1
fi

GIT_INDEX_FILE="$index_copy" git update-index --add --cacheinfo "100644,$blob,workspaces/hees-console/target/forced.txt"
GIT_INDEX_FILE="$index_copy" git update-index --add --cacheinfo "100644,$blob,.agents/state/forced.md"
GIT_INDEX_FILE="$index_copy" git update-index --add --cacheinfo "100644,$blob,outputs/forced.txt"
GIT_INDEX_FILE="$index_copy" git update-index --add --cacheinfo "100644,$blob,fixtures/forced.gguf"
GIT_INDEX_FILE="$index_copy" git update-index --add --cacheinfo "100644,$blob,tools/forced.bin"
GIT_INDEX_FILE="$index_copy" git update-index --add --cacheinfo "100644,$blob,config/.env.production"
GIT_INDEX_FILE="$index_copy" git update-index --add --cacheinfo "100644,$blob,config/.env.example"

set +e
GIT_INDEX_FILE="$index_copy" bash tools/validation/check_framework_boundary.sh >"$scratch/output" 2>&1
status=$?
set -e

if [[ "$status" -eq 0 ]]; then
    printf 'boundary self-test error: tracked prohibited paths were accepted\n' >&2
    exit 1
fi

grep -Fq 'tracked private or generated path is present: workspaces/hees-console/target/forced.txt' "$scratch/output"
grep -Fq 'tracked private or generated path is present: .agents/state/forced.md' "$scratch/output"
grep -Fq 'tracked private or generated path is present: outputs/forced.txt' "$scratch/output"
grep -Fq 'tracked disallowed artifact type is present: fixtures/forced.gguf' "$scratch/output"
grep -Fq 'tracked disallowed artifact type is present: tools/forced.bin' "$scratch/output"
grep -Fq 'tracked credential or environment path is present: config/.env.production' "$scratch/output"

if grep -Fq 'config/.env.example' "$scratch/output"; then
    printf 'boundary self-test error: allowed .env.example sample was rejected\n' >&2
    exit 1
fi

printf 'tracked-file boundary self-test passed\n'

facade="$scratch/lib.incn"
cat >"$facade" <<'FACADE'
"""Boundary self-test facade that mixes allowed entry points with authority-bearing symbols."""

pub from governed_profile import (
    CompleteGovernedEvaluation,
    GovernedContentDna,
    GovernedContentDnaBody,
    GovernedReceipt,
    GovernedSpectrumResult,
    assess_committee,
    construct_governed_receipt,
    digest_governed_memory_provenance,
    digest_governed_profile_package,
    evaluate_governed_profile_json,
)
pub from console_profile import (
    SpectrumResult,
    evaluate_console_profile_json,
)
FACADE

manifest="$scratch/hees_ai.incnlib"
cat >"$manifest" <<'MANIFEST'
{
  "exports": {
    "aliases": [
      {"name": "GovernedSpectrumResult"},
      {"name": "digest_governed_profile_package"},
      {"name": "validate_governed_proposal"},
      {"name": "ContentDnaBody"}
    ]
  },
  "vocab": {
    "names": [{"name": "construct_governed_content_dna"}]
  }
}
MANIFEST

set +e
HEES_BOUNDARY_PUBLIC_FACADE="$facade" HEES_BOUNDARY_ROOT_MANIFEST="$manifest" \
    bash tools/validation/check_framework_boundary.sh >"$scratch/export_output" 2>&1
status=$?
set -e

if [[ "$status" -eq 0 ]]; then
    printf 'boundary self-test error: authority-bearing re-exports were accepted\n' >&2
    exit 1
fi

for symbol in GovernedContentDnaBody assess_committee construct_governed_receipt SpectrumResult; do
    if ! grep -Fxq "boundary error: authority-bearing profile symbol is re-exported by $facade: $symbol" "$scratch/export_output"; then
        printf 'boundary self-test error: facade re-export was not rejected: %s\n' "$symbol" >&2
        exit 1
    fi
done

for symbol in validate_governed_proposal ContentDnaBody; do
    if ! grep -Fxq "boundary error: generated root manifest exports authority-bearing profile symbol: $symbol" "$scratch/export_output"; then
        printf 'boundary self-test error: manifest export was not rejected: %s\n' "$symbol" >&2
        exit 1
    fi
done

for symbol in CompleteGovernedEvaluation GovernedContentDna GovernedReceipt GovernedSpectrumResult digest_governed_memory_provenance digest_governed_profile_package evaluate_governed_profile_json evaluate_console_profile_json construct_governed_content_dna; do
    if grep -Eq "authority-bearing profile symbol.*: ${symbol}\$" "$scratch/export_output"; then
        printf 'boundary self-test error: allowed or out-of-range symbol was rejected: %s\n' "$symbol" >&2
        exit 1
    fi
done

printf 'authority-bearing export boundary self-test passed\n'
