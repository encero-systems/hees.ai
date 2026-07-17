# Getting started

## Requirements

Use the released Incan `0.4.0` toolchain. The lockfiles in this repository were generated with that release.

## Verify the repository

```bash
python3 -m pip install -r workspaces/docs-site/requirements.txt
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

## Run the fictional runtime example

```bash
incan build --lib --locked
cd examples/minimal_governed_agent
incan run src/main.incn --locked
```

The example constructs values in memory. It is not a model, RAG, archive, package-file, or semantic-verifier demo.
