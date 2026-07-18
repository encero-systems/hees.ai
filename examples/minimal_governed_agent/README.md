# Minimal governed agent

This fictional Incan project consumes Hees as an external path dependency. It constructs one runtime package and asks Hees to admit a visible proposal whose action and cited evidence are package-owned.

It does not run a language model, perform retrieval, parse an archive, or claim semantic verification.

After building the Hees library from the repository root:

```bash
incan build --lib --locked
cd examples/minimal_governed_agent
incan lock src/main.incn
incan run src/main.incn --locked
```
