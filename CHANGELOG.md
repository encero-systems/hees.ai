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
- Retrieval-result admission into governed memory context (the runtime part of RFC 003): `admit_memory_result` with its eight stages and 39 reasons, and in-memory declaration admission standing in for RFC 005 package admission. A declaration may hold any number of atoms; the interim resource envelope bounds each request (nominations, materialized context, text fields), not the package.
- `evaluate_governed_profile_in_memory_context`: a profile proposal may nominate only memory that an accepted retrieval context materialized.
- `admit_governed_profile_package` and `AdmittedGovernedProfile`: a profile package is validated and its digest recomputed once; `evaluate`, `evaluate_in_memory_context`, `propose` and `observe` on the admitted profile then cost the same per proposal whatever the size of the package, and return what the package-taking functions return. `digest_governed_memory_provenance_for` stamps a memory atom from the package identity alone.

### Changed

- A governed profile package (Draft RFC 015) may declare any number of evidence records and memory atoms; the ceilings of 64 each are removed. A proposal may still nominate at most 64 of each, now named `MAX_PROPOSAL_EVIDENCE` and `MAX_PROPOSAL_MEMORY` (previously `MAX_GOVERNED_EVIDENCE` and `MAX_GOVERNED_MEMORY`). Package validation is linear in the number of records.
- What a package declares is no longer bounded by a number. Removed: the ceilings on guided material per profile package (16); on goals and schedules per continuity package (16 each), phases per schedule and the lists that refer to phases (32), clock sources per schedule (8) and allowed actions per goal or phase (16); on memory classes (32) and allowed keys per class (32) in a memory policy; and on cards per guided programme (128) and history entries per session (256). The constants `MAX_CONTINUITY_GOALS`, `MAX_CONTINUITY_SCHEDULES`, `MAX_SCHEDULE_PHASES`, `MAX_SCHEDULE_CLOCK_SOURCES`, `MAX_DECLARED_ACTIONS`, `MAX_GUIDED_PROGRAMME_CARDS` and `MAX_GUIDED_PROGRAMME_HISTORY` are no longer exported, and the reasons `invalid_guided_material_count`, `history_limit_exceeded` and `progress_history_limit_exceeded` no longer occur. Bounds on a single request, on text and identifier lengths, and on numeric values are unchanged. Duplicate checks are linear.
- The repository builds with commit-pinned Incan `0.6.0-dev.6`. Manifests are named `loaf.toml` and the canonical lock is `oven.lock`. CI builds the pinned compiler from source.
- Identifier and revision types expose their canonical text through one `.text()` method, supplied by the new `SymbolicIdentifier` and `DigestIdentifier` traits for nominal identifiers; the per-type `*_id_text`, `id_type_text`, `symbolic_id_type_text`, `digest_id_type_text`, `revision_text`, and `artifact_revision_text` functions and their root exports are removed.

The `0.1.0` release contract is limited to the tagged source and the explicitly published artifacts, platforms, and checksums attached to that tag.
