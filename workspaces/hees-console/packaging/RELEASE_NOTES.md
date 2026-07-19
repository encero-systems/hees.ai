# Hees Console 0.1.0

Hees Console 0.1.0 is the first bounded implementation profile of the permanent Hees Console developer product. The self-contained application is authored in Incan and defaults to credential-free offline replay through the real compiled Hees admission path.

This release contains the original fictional `console_profile_0_1` package and five scenarios: one admitted declared action plus `unknown_action`, `unknown_evidence`, `unknown_memory`, and `memory_not_admitted` rejections. Replay fixtures contain bound inputs and never a stored Hees decision.

Download the archive matching an explicitly supported platform and verify its adjacent `.sha256` file before extraction. `SHA256SUMS` covers every published archive, sidecar checksum, and provenance manifest. Each archive also contains Apache-2.0 project terms, `NOTICE`, a platform-specific third-party license report, and a byte-identical release manifest.

Optional live mode requires an OpenAI API key with available quota and remains separate from the guaranteed offline path. The July 19 canary reached the Responses API but returned HTTP 429 `insufficient_quota`, so live operation must remain described as unverified unless later public evidence proves the released path.

The macOS candidates produced by the draft workflow are unsigned and not notarized. Do not publish this draft until the signing posture is approved; if the assets remain unsigned, retain that limitation in the public release and testing instructions.

Hees Console proves the bounded profile's structural authority and declared admission conditions. It does not prove semantic truth, factual correctness, source ownership, provider provenance, complete Training by Committee, full Spectrum or Content DNA conformance, or completion of Draft RFC 010's permanent north star.
