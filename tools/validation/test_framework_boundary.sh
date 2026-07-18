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
grep -Fq 'tracked private or generated path is present: outputs/forced.txt' "$scratch/output"
grep -Fq 'tracked disallowed artifact type is present: fixtures/forced.gguf' "$scratch/output"
grep -Fq 'tracked disallowed artifact type is present: tools/forced.bin' "$scratch/output"
grep -Fq 'tracked credential or environment path is present: config/.env.production' "$scratch/output"

if grep -Fq 'config/.env.example' "$scratch/output"; then
    printf 'boundary self-test error: allowed .env.example sample was rejected\n' >&2
    exit 1
fi

printf 'tracked-file boundary self-test passed\n'
