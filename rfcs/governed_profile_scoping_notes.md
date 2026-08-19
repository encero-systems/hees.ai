# Scoping notes: `governed_profile*` RFC stabilization

Written 2026-08-19 while triaging what else in the promoted kernel commit (`ba4e24a`) needs RFC-track
stabilization, alongside RFC 013/014.

**Update, same night:** after writing the first version of this note (below, preserved as-is), there was still
plenty of time left before the morning, so instead of leaving this as a permanent punt, RFC 000/001/002/006 were
read in full and the actual `governed_profile*` source was read end to end. That closer look showed the module is
a *narrower, simpler* thing than "generalizes RFC 000/001/002/006" made it sound — it reuses the existing Hees
0.0.1 kernel for structural admission and only implements a small, already-proven five-outcome-kind pattern (no
repair, no constraint composability, no behavior envelopes, one Content DNA state, one receipt kind), not those
RFCs' full elaborate designs. That made it possible to draft an honest RFC after all:
[RFC 015](015-generic-governed-profile-evaluation.md), whose relationship sections are explicit about every real
delta from RFC 001/002/006 rather than claiming conformance. The superseding-vs-generalizing question against RFC
010 raised below is still real and still unresolved — RFC 015 names it explicitly as an open question rather than
answering it — but "draft nothing until that's settled" turned out to be too conservative once the actual scope
was understood. The original reasoning is kept below for the record.

---

## What `governed_profile*` is

Seven Incan modules (`governed_profile.incn`, `_artifacts`, `_committee`, `_evaluation`, `_identity`, `_models`,
`_validation`; ~1,870 lines total) implementing a generic, package-neutral governed-interaction evaluation kernel:
a `GovernedProfilePackage` binds actions, evidence, memory, and guided material; a `GovernedRequest`/
`GovernedProposal` pair is validated and evaluated; `CommitteeObservation`s are assessed into `CommitteeAssessment`
findings; a terminal decision is classified (`GovernedSpectrumResult`, `GovernedTerminalClass`); and admitted
answers produce `GovernedContentDna` and a `GovernedReceipt`. `governed_profile.incn` is an explicit "checked
public facade" over the rest.

## Why this isn't a same-night RFC like 013/014

RFC 013 and RFC 014 were each a single, narrow, self-contained concern (session/time admission; memory-lifecycle
admission) with no material overlap with an existing RFC beyond the one clean relationship each RFC names. This
module family is different in kind: it visibly generalizes pieces that **four existing RFCs already own**:

- RFC 000 (Foundational Governance Authority) — the authority model this whole kernel implements.
- RFC 001 (Spectrum Terminal Adjudication) — `GovernedSpectrumResult`/`GovernedTerminalClass` look like a
  generalization of Spectrum's terminal-adjudication concept.
- RFC 002 (Content DNA Answer-Time Provenance) — `construct_governed_content_dna` / `GovernedContentDna`.
- RFC 006 (Export-Safe Governance Receipts) — `construct_governed_receipt` / `GovernedReceipt`.

And it looks closely related to the **already-implemented and shipped** `console_profile_0_1` system that RFC 010
and the top-level README describe at length (governance profiles, Training by Committee, Spectrum, Content DNA,
receipts — the exact same vocabulary). The open question this module family raises is not "what should this do"
(RFC 013/014's question) but **"what is the correct RFC-track shape for a generalization of already-partially-RFC'd
and already-partially-shipped concepts"** — does it become one new umbrella RFC that several of 000/001/002/006
get marked `Superseded` by or amended to reference, or is it better framed as "the RFC 010 console profile,
generalized beyond one fixed package"? That is a real editorial/architecture decision this repo's RFC process
explicitly reserves for design discussion (a dedicated proposal issue, then discussion, then the RFC) — not
something to settle unilaterally in one overnight pass, and not something I can respond to Danny's specific
technical decisions on and reconcile with a straight face here.

Attempting a full RFC to this repo's demonstrated quality bar (see RFC 003, ~455 lines, exhaustive field/stage/
reason tables) for a ~1,870-line, four-RFC-adjacent module family in one sitting, without first reading RFC 000/
001/002/006/010 in full (only RFC 003 was read tonight) and without the actual maintainer's view on the
superseding-vs-generalizing question, risks producing something confidently wrong rather than usefully Draft.

## Recommendation

Treat `governed_profile*` RFC stabilization as its own dedicated follow-up, ideally starting with:

1. Read RFC 000, 001, 002, 006, and 010 in full (not skimmed) alongside the actual `governed_profile*` source.
2. Resolve the superseding-vs-generalizing question with Danny before drafting anything.
3. Only then draft the RFC(s), likely plural (the module family cleanly separates into at least "generic
   evaluation kernel" and "committee assessment" concerns, mirroring how RFC 013/014 stayed split rather than
   merged).

The module family is already committed (`ba4e24a`) and already passing its own tests, so nothing here blocks using
it — only its formal RFC-track status remains open.
