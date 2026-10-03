# Changelog

All notable changes will be recorded here.

## Unreleased

### Added

- A curated Incan-first pre-v0.1 public kernel.
- Bounded nominal identifier contracts over a shared `IdType` base.
- Governed goal, schedule, and session-continuity admission (Draft RFC 013), governed memory-operation admission (Draft RFC 014), and package-neutral governed profile evaluation with committee findings, Content DNA, and receipts (Draft RFC 015), each with the digest helpers callers use to stamp package identity. Session state and memory records are authenticated with an HMAC-SHA256 witness under a host-held key, sessions that overrun a phase maximum can be closed with a governed `expire` operation, and refusal and escalation text is package-declared. The entry also adds their nominal identifiers and the `ArtifactRevisionType` package revision grammar. These kernels are exported while their RFCs remain in review, so their public surface may change.
- Checked external package-descriptor and structural proposal-admission contracts.
- External-consumer, adversarial, boundary, and documentation verification.
- A native Incan full-screen hees.ai console with responsive Profiles, Evidence, Memory, Committee, Interactions, Decisions, and Help workspaces.
- Session-local Profile Studio state for staging evidence and memory, validating candidates through the real Hees.ai acceptance probe, blocking unsupported activation, and restoring the shipped profile.
- An original fictional lesson-support profile with one admitted interaction and four adversarial rejection scenarios.
- Inspectable Hees.ai findings, bounded Spectrum evaluation, selected memory, Content DNA, receipts, and a separately labelled non-authoritative trace.
- Provider-neutral Training by Committee target derivation, bounded observations, coverage validation, and Hees.ai-owned classification.
- Integrity-checked offline replay that stores inputs and metadata but never stores a reusable Hees.ai decision.
- An optional bounded GPT-5.6 strict structured-output adapter with no retries, closed provider failure categories, request and response limits, and deterministic injected-transport tests.
- Sanitized diagnostic evidence for the separately proven native GPT-5.6 proposal and six-call live-committee paths, including the exact remaining combined release-binary limitation.
- Native packaging and release-validation workflows for Linux and macOS candidates, including checksums, provenance, dependency notices, leakage scans, and extracted-archive smoke tests. macOS artifacts are not Developer ID-signed and not notarized; linker ad-hoc signing may exist solely for local execution and conveys no publisher identity. The tagged Release is the sole source of artifact availability and platform claims.
- Governance-profile, architecture, testing, release, video, and Devpost documentation for the bounded Console profile and its permanent product direction.
- Bounded approximate TurboQuant nomination with exact reranking (`turboquant_index`, `turboquant_query`, and `TurboquantIndex.nominate` for an index that is queried repeatedly), and dense transforms up to 1,024 dimensions.
- A stored form of a TurboQuant index, built once when a package is made: codes and identifiers in one part (`TurboquantIndex.codes_to_bytes`) and exact vectors in another (`vectors_to_bytes`), loaded with `turboquant_code_index_from_bytes` into a `TurboquantCodeIndex` that scans codes and reranks from the candidate vectors the caller reads from storage. Loading verifies digests, configuration, identifiers and the index fingerprint and fails closed.

### Changed

- A Hyperquant index, exact or TurboQuant, may hold any number of entries; the 65,536-entry ceiling (`MAX_HYPERQUANT_ENTRIES`) and its `index_too_large` error kind are removed. A query stays bounded by `top_k` and its candidate count.
- The repository builds with commit-pinned Incan `0.6.0-dev.6`. Manifests are named `loaf.toml` and the canonical lock is `oven.lock`. CI builds the pinned compiler from source.
- Identifier and revision types expose their canonical text through one `.text()` method, supplied by the new `SymbolicIdentifier` and `DigestIdentifier` traits for nominal identifiers; the per-type `*_id_text`, `id_type_text`, `symbolic_id_type_text`, `digest_id_type_text`, `revision_text`, and `artifact_revision_text` functions and their root exports are removed.

The `0.1.0` release contract is limited to the tagged source and the explicitly published artifacts, platforms, and checksums attached to that tag.
