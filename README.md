# Hees

Hees is a small Incan-first kernel for structurally admitting governed AI proposals. Its boundary is deliberately
narrow: an external implementation owns its package and untrusted model output; Hees decides whether the proposal's
declared action, visible output, and evidence references fit that package.

## Status

This is a `0.0.1` pre-v0.1 preview. The checked public API is small enough to change before `0.1.0`.

Implemented now:

- a descriptor-shape contract for external source-controlled packages;
- a small in-memory governed-package contract;
- fail-closed structural package validation;
- fail-closed proposal admission against package-owned actions and reviewed, rights-allowed evidence records;
- a checked `src/lib.incn` public surface; and
- an external-consumer fixture and fictional external example.

Not implemented here:

- model inference or provider adapters;
- retrieval, vector search, RAG, or semantic claim verification;
- JSON package parsing, filesystem loading, archive handling, or cryptographic digest verification;
- proof that cited evidence semantically supports the visible output;
- proof of source ownership, licensing, or content rights outside the explicit package status value;
- package authoring, review queues, client configuration, dashboards, or other Workbench behavior; and
- a stable CLI or production runtime.

`PackageLoaderValidation` validates descriptor metadata only. It never opens `package_path` and must not be presented as
package admission.

## Toolchain

The candidate is locked and verified with the released Incan `0.4.0` toolchain. Install that release and make `incan`
available on `PATH`, or pass an explicit binary to Make:

```bash
make ci INCAN=/path/to/incan
```

Use `INCAN_FLAGS="--locked --offline"` only after the Cargo dependencies have been cached locally. The default clean
build is locked but network-capable.

## Build and test

```bash
make ci
```

The gate formats and builds the public library, runs the package/runtime tests, compiles an actual external dependency,
runs the fictional example, applies the repository boundary audit, and builds the documentation strictly.

## External package descriptor

An implementation package can depend on a local checkout during pre-release development:

```toml
[dependencies]
hees = { path = "../hees.ai" }
```

```incan
from pub::hees import package_loader_descriptor, validate_package_loader_descriptor

descriptor = package_loader_descriptor(
    "lesson_support",
    "lesson_support",
    "packages/lesson_support/package/domain.json",
    "0.1",
    "source_controlled_domain_package",
)
validation = validate_package_loader_descriptor(descriptor)
```

The canonical descriptor path is repository-relative and ends in `package/domain.json`. The validator rejects absolute,
traversal, dot-segment, Windows-drive, backslash, and embedded newline, carriage-return, or tab path forms. No descriptor
value is passed to a filesystem API by this library.

## Runtime admission

The fictional [minimal governed agent](examples/minimal_governed_agent/README.md) demonstrates the separate runtime
contract. A caller constructs a `GovernedPackage` and an untrusted `ModelProposal`; `admit_model_proposal` checks only
the structural authority it can prove. The caller remains responsible for retrieval, model execution, semantic
verification, digest integrity, and source-rights due diligence.

## Repository boundary

This repository contains only the reusable kernel, public documentation, fictional examples, tests, and repository
guardrails. Research, corpora, model files, generated artifacts, concrete implementation packages, and product control
surfaces do not belong here.

See [the documentation](workspaces/docs-site/docs/index.md), [contribution guidance](CONTRIBUTING.md), and
[RFC process](rfcs/README.md), and [security policy](SECURITY.md).
