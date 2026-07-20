# Contributing

Hees is intentionally small. Changes should preserve an Incan-owned public boundary and avoid adding concrete domains, private corpora, model artifacts, product control surfaces, or research spikes.

Before opening a pull request:

1. Use Incan `0.5.0-dev.21` at the source commit recorded in `workspaces/hees-console/packaging/release-platforms.json`.
2. Add positive and fail-closed negative tests for contract changes.
3. Keep `src/lib.incn` exports deliberate and documented.
4. Run `make ci` from a clean checkout.
5. Explain any public API or compatibility impact.

Do not include confidential information, credentials, personal data, raw source material, or content without documented redistribution rights. Report security problems privately as described in `SECURITY.md`.

New runtime capabilities and material public-contract changes should begin as an [RFC proposal](rfcs/README.md). A proposal describes a desired outcome; it does not make the capability part of the implemented public surface.
