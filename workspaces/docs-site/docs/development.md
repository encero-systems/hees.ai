# Development

Run the complete local gate with released Incan `0.4.0`:

```bash
make ci INCAN=/path/to/incan
```

The default uses locked dependency resolution and permits a clean machine to populate Cargo's cache. Once dependencies are present, `INCAN_FLAGS="--locked --offline"` provides an additional offline replay check.

The gate includes:

- formatting checks;
- a locked public-library build;
- positive and adversarial package/runtime tests;
- an actual external Incan dependency test;
- the fictional external runtime example;
- the fail-closed repository boundary audit; and
- a strict documentation build.

Public symbols must be re-exported deliberately from `src/lib.incn`. A change that claims a new guarantee needs a test that fails when the guarantee is violated and documentation that distinguishes the guarantee from caller-owned work.

Do not add client packages, corpora, private source material, generated model artifacts, research benchmarks, provider spikes, or product control surfaces. Use fictional data in tests and examples.
