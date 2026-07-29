# Getting started

## Requirements

The current branch requires Incan `0.5.0-dev.32` from merged source commit [`d7f6d4ab0416715b95cdfc951b19e12ee15daf14`](https://github.com/encero-systems/incan/commit/d7f6d4ab0416715b95cdfc951b19e12ee15daf14). Release tooling records that source identity separately from the canonical root `incan.lock`. The release workflow fails closed unless it obtains a byte-identical lock fixed point, the complete local gate, and a fresh native release matrix from the tagged Hees head.

## Verify the repository

```bash
make ci
```

Pass `INCAN=/path/to/incan` when the compiler is not on `PATH`.

## Consume the library

During pre-release development, another Incan project can use a local path dependency:

```toml
[dependencies]
hees_ai = { path = "../hees.ai" }
```

Import checked symbols through the library namespace:

```incan
from pub::hees_ai import package_loader_descriptor, validate_package_loader_descriptor
```

The test project under `workspaces/external-consumer/` compiles and tests this exact dependency boundary.

## Verify the initial console profile

The Console workspace uses only original fictional acceptance data. Its verification covers session-local candidate-profile state, evidence and memory staging, the Hees-owned acceptance probe, blocked activation, reset, responsive rendering, provider boundaries, and all five governed interactions:

```bash
make console-test console-native-smoke \
  INCAN=/path/to/incan-0.5.0-dev.32/bin/incan
```

This proves the bounded `console_profile_0_1` workflow without downloading or invoking a language model. Provider-facing and rendering modules never receive package-authoring, activation, or terminal authority.

## Run the native Console

Build the executable with the pinned Incan compiler, then start the zero-credential offline experience:

```bash
make console-build INCAN=/path/to/incan-0.5.0-dev.32/bin/incan
workspaces/hees-console/target/incan/hees_console/target/release/hees_console
```

The release-candidate archive renames the installed executable to `hees-console` and needs no compiler, package manager, source checkout, network connection, or API key at runtime. Open Evidence with `2`, unstage a record with `Space`, validate with `v`, and reset with `r` to exercise the Profile Studio before running an interaction. Use `--headless` for privacy-redacted automation output. See [Governance profiles](governance-profiles.md) for the package contract, [hees.ai console](console.md) for every interaction key and live-mode syntax, and [profile bounds and evidence](console-profile-0-1.md) before making platform or resource claims.

## Run the fictional runtime example

```bash
incan build --lib --locked
cd examples/minimal_governed_agent
incan run src/main.incn --locked
```

The example constructs values in memory. It is not a model, RAG, archive, package-file, or semantic-verifier demo.
