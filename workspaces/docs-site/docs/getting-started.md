# Getting started

## Requirements

Use the released Incan `0.4.0` toolchain. The lockfiles in this repository were generated with that release.

## Verify the repository

```bash
make ci
```

Pass `INCAN=/path/to/incan` when the compiler is not on `PATH`.

## Consume the library

During pre-release development, another Incan project can use a local path dependency:

```toml
[dependencies]
hees = { path = "../hees.ai" }
```

Import checked symbols through the library namespace:

```incan
from pub::hees import package_loader_descriptor, validate_package_loader_descriptor
```

The test project under `workspaces/external-consumer/` compiles and tests this exact dependency boundary.

## Verify the initial console profile

The Console workspace uses only original fictional acceptance data. Its current proof runs fourteen native application tests and fourteen provider-boundary tests, builds the native Incan executable, and reruns all five replay inputs through Hees:

```bash
make console-test console-native-smoke \
  INCAN=/path/to/incan-0.4.0/bin/incan
```

This proves the closed `console_profile_0_1` path. It does not download or invoke a language model, perform retrieval, or grant the provider-facing Console module admission authority.

## Run the native Console

Build the executable with released Incan `0.4.0`, then start the zero-credential offline experience:

```bash
make console-build INCAN=/path/to/incan-0.4.0/bin/incan
workspaces/hees-console/target/incan/.cargo-target/release/hees_console
```

The release-candidate archive renames the installed executable to `hees-console` and needs no compiler, package manager, source checkout, network connection, or API key at runtime. Use `--headless` for privacy-redacted automation output. See [Hees Console](console.md) for interaction keys and live-mode syntax, and consult the [profile bounds and evidence](console-profile-0-1.md) before making platform or resource claims.

## Run the fictional runtime example

```bash
incan build --lib --locked
cd examples/minimal_governed_agent
incan run src/main.incn --locked
```

The example constructs values in memory. It is not a model, RAG, archive, package-file, or semantic-verifier demo.
