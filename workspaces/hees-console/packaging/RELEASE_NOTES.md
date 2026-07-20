# hees.ai console 0.1.0

hees.ai console 0.1.0 is the first bounded implementation profile of the permanent hees.ai console developer product. The self-contained application is authored in Incan and defaults to credential-free offline replay through the real compiled Hees admission path.

This release contains the original fictional `console_profile_0_1` package and five scenarios: one admitted declared action plus `unknown_action`, `unknown_evidence`, `unknown_memory`, and `memory_not_admitted` rejections. Replay fixtures contain bound inputs and never a stored Hees decision.

Download the archive matching an explicitly supported platform and verify its adjacent `.sha256` file before extraction. `SHA256SUMS` covers every published archive, sidecar checksum, and provenance manifest. Each archive also contains Apache-2.0 project terms, `NOTICE`, a platform-specific third-party license report, and a byte-identical release manifest.

Optional live mode requires an OpenAI API key and remains separate from the guaranteed offline path. The single funded and approved no-retry canary failed closed at its first proposal call with `provider_unavailable`: it returned no structured proposal, made no committee calls, and did not reach a live Hees decision. No retry was attempted. Live mode is implemented and provider-boundary tested, but it is not demonstrated end to end in this release; offline replay is the judge and video path.

The macOS candidates are intentionally unsigned and not notarized for this release. Verify the adjacent checksum before extraction and follow the narrowly scoped Gatekeeper guidance bundled in `RUNNING.txt`; do not describe these assets as signed or notarized.

This release proves the bounded profile's structural authority, declared admission conditions, deterministic Hees decision, selected-memory attribution, and inspectable artifacts. The permanent hees.ai console product is intended to extend that governed development workflow into deeper semantic, factual, provenance, rights, Training by Committee, Spectrum, and Content DNA assurance; those broader layers are not presented as complete in version 0.1.0.
