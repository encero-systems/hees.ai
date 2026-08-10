# Hees RFCs

Hees uses RFCs for new runtime capabilities, material public-contract changes, and decisions that affect ownership or compatibility across implementations.

## Lifecycle

1. Open an **RFC proposal** issue that states the desired outcome, public boundary, non-goals, acceptance evidence, and unresolved risks.
2. Discuss whether the capability belongs in Hees and whether its scope is coherent enough for an RFC.
3. If accepted for design, submit a focused RFC document by pull request. The RFC should define behavior and compatibility without committing unrelated implementation work.
4. Merge implementation separately, with executable positive and fail-closed evidence. An accepted RFC does not by itself make a capability implemented.

Proposal issues and RFCs describe public outcomes. They must not contain private package contents, client material, raw corpora, credentials, local paths, model artifacts, or unpublished research results.

Until an RFC and its implementation are both merged, the repository's README and checked public API remain the source of truth for what Hees implements.

## Numbering and headers

RFC documents use three-digit numbers and the filename form `NNN-short-title.md`. RFC 000 is reserved for the stable foundational authority model; early RFC numbers establish core contracts that later RFCs refine. Each RFC must have its own dedicated proposal issue. An umbrella may relate several proposal issues but cannot replace an RFC's dedicated issue. New documents start at `Draft` and record their creation date, authors, related RFCs, proposal issue, and the Hees and Incan versions they were written against. `RFC PR` means the pull request that implements the accepted RFC, so it remains `—` until implementation exists. `Shipped in` likewise remains `—` until the implementation is released. Draft RFCs describe proposed behavior and do not imply that the checked public API implements it.

## Document statuses

- **Draft:** Design or review is in progress and unresolved questions are allowed. An implementation plan or progress checklist must not be present.
- **Planned:** The design is accepted with no unresolved questions, but implementation has not started. An implementation plan or progress checklist must still not be present.
- **In Progress:** Implementation is actually underway. An implementation plan and progress checklist may be added and must reflect active work rather than intent.
- **Implemented:** The implementation is merged and released, the progress checklist is complete, and `Shipped in` records the actual release.
- **Rejected:** The proposal was considered and intentionally declined; it does not describe supported behavior.
- **Superseded:** Another named RFC owns the active design; the superseded document must point to it and does not describe supported behavior.

## Current documents

- [RFC 000: Foundational Governance Authority](000-foundational-governance-authority.md) — Draft
- [RFC 001: Spectrum Terminal Adjudication](001-spectrum-terminal-adjudication.md) — Draft
- [RFC 002: Content DNA Answer-Time Provenance](002-content-dna-answer-time-provenance.md) — Draft
- [RFC 003: Governed Memory and Retrieval Results](003-governed-memory-and-retrieval-results.md) — Draft
- [RFC 004: Composable Governance Constraints](004-composable-governance-constraints.md) — Draft
- [RFC 005: Canonical Package Artifact Admission](005-canonical-package-artifact-admission.md) — Draft
- [RFC 006: Export-Safe Governance Receipts](006-export-safe-governance-receipts.md) — Draft
- [RFC 007: Evidence-Grounded Claim Verification Findings](007-evidence-grounded-claim-verification-findings.md) — Draft
- [RFC 008: Governed Behavior Envelopes](008-governed-behavior-envelopes.md) — Draft
- [RFC 009: Governed Visible Response Lifecycle](009-governed-visible-response-lifecycle.md) — Draft
- [RFC 010: hees.ai console](010-hees-console.md) — Draft
- [RFC 011: Canonical Structural Identity for Incan Models](011-canonical-structural-identity.md) — Draft
- [RFC 012: Governed Effect Capabilities and Execution Receipts](012-governed-effect-capabilities-and-execution-receipts.md) — Draft
