# RFC 002: Content DNA Answer-Time Provenance

- **Status:** Draft
- **Created:** 2026-07-18
- **Author(s):** Encero Systems
- **Related:**
    - RFC 000 (Foundational Governance Authority)
    - RFC 001 (Spectrum Terminal Adjudication)
    - RFC 003 (Governed Memory and Retrieval Results)
    - RFC 005 (Canonical Package Artifact Admission)
    - RFC 006 (Export-Safe Governance Receipts)
    - RFC 009 (Governed Visible Response Lifecycle)
- **Issue:** https://github.com/encero-systems/hees.ai/issues/3
- **RFC PR:** —
- **Written against:** Hees 0.0.1 / Incan 0.4.0
- **Shipped in:** —

## Summary

Hees should construct deterministic Content DNA at answer time from every and only the reviewed governed-memory atoms selected by Spectrum for one terminal response. An admitted visible answer and its Content DNA must be returned atomically. The Content DNA value binds the answer, request, proposal, package, policy, Spectrum decision, selected memory, source-safe provenance, review state, rights state, and canonical digest without reproducing source text, answer prose, provider scores, hidden reasoning, or build-time review history. Models, providers, callers, packages, and build-time tooling may supply governed inputs, but none may author the terminal Content DNA projection.

## Core model

1. **Content DNA is answer-time provenance.** It records which reviewed memory made one terminal answer admissible; it is not a corpus-ingestion manifest or model citation format.
2. **Spectrum fixes the membership.** Every admitted-answer entry corresponds to one Spectrum-selected memory atom, in the exact terminal order, with no omissions or additions.
3. **The package supplies provenance facts.** Source-safe references, source fingerprints, review and rights state, authority classification, and provenance identity come from the exact RFC 005-admitted package.
4. **Hees constructs the projection.** A model, retrieval provider, verifier, caller, package-authoring process, or package field cannot submit a completed Content DNA value for admission.
5. **The answer and provenance are atomic.** Hees must not expose admitted visible prose if Content DNA construction, validation, canonicalization, or digest computation fails.
6. **No-answer outcomes are explicit.** A package-authored clarification, or a future package-authored refusal, may carry a closed zero-entry no-answer value; rejection does not masquerade as answer provenance.
7. **Canonical identity is not terminal authority.** A Content DNA identifier proves deterministic content identity and integrity for the covered body, but a copied or verified document cannot recreate the original Spectrum capability.
8. **The public projection is source-safe.** Raw memory, source passages, answer text, hidden reasoning, provider payloads, private review notes, and unrestricted locators remain outside the contract.

## Motivation

Conventional retrieval-augmented generation often exposes citations assembled by the model or application. Such citations can be incomplete, can name retrieved passages that did not actually govern the answer, and can survive even when the runtime rejects or replaces the response. Build-time provenance is necessary but also insufficient: it explains where package memory came from, not which reviewed memories made one particular answer admissible.

Hees needs a terminal provenance contract that is tied to the same authority that admits the answer. Spectrum knows the complete admitted context, the final selected-memory subset, the applied package policy, the terminal response, and the exact proposal identity. Content DNA is the deterministic projection of those trusted facts. It lets applications explain and audit an answer without treating model-authored citation prose, retrieval rank, or a generic support record as provenance authority.

Content DNA also closes an important failure mode in which the visible answer is returned successfully but provenance emission fails afterward. By making the answer and Content DNA one atomic result, Hees fails closed before an untraceable answer can become visible.

## Goals

- Define Content DNA as a mandatory terminal artifact for every admitted visible answer.
- Bind exact answer, request, proposal, package, policy, Spectrum decision, selected memory, and source-safe provenance identity.
- Require complete selected-memory-only coverage and deterministic entry order.
- Define an export-safe closed body, canonical bytes, deterministic identifier, and strict validation order.
- Distinguish admitted-answer provenance from the permitted zero-entry no-answer representation.
- Define the relationship between Content DNA and generic RFC 006 receipts without merging their responsibilities.
- Keep raw source text, answer prose, provider observations, verifier scores, hidden reasoning, private review notes, and unrestricted implementation metadata outside the artifact.
- Preserve the package-compilation role without allowing build-time tools to author answer-specific provenance.
- Define cross-implementation, privacy, authority-negative, and constrained-device acceptance evidence.

## Non-Goals

- Proving unrestricted real-world truth or guaranteeing that reviewed sources are objectively correct.
- Reproducing source passages, complete documents, visible answers, model transcripts, prompts, or hidden reasoning.
- Replacing source-rights review, organizational policy, semantic claim verification, or Spectrum adjudication.
- Defining document ingestion, chunking, semantic extraction, embeddings, indexes, retrieval, reranking, or model inference.
- Exposing complete build-time review history, reviewer identity, private notes, client metadata, or raw corpus structure.
- Acting as a general telemetry, observability, analytics, audit-log, or receipt-chain format.
- Establishing producer authenticity, signatures, remote attestation, federation, or replay protection.

## Guide-level explanation

When Spectrum admits an answer, Hees already knows the exact package, proposal, policy, visible answer, and ordered memory selected for that answer. Hees projects each selected atom's source-safe provenance, review state, rights state, and governance identity into one Content DNA entry, binds the visible answer by digest, canonicalizes the closed body, and returns the answer and Content DNA atomically.

Applications may display authorized source references or retain the Content DNA envelope for audit. The artifact contains no source passages or answer prose, and successful public digest verification does not turn it into a live Spectrum capability. A package-authored clarification uses the explicit zero-entry no-answer form so an empty provenance list can never be mistaken for a source-free admitted answer.

## Reference-level explanation

### Authority boundary

Content DNA must be constructed inside the terminal Spectrum operation from direct trusted values. The construction function may accept only the trusted RFC 001 decision state, the exact RFC 009 terminal response state, and the RFC 005-admitted package view needed to project selected RFC 003 memory provenance. It must not accept a caller-authored entry list, caller-authored source reference, caller-authored answer digest, or prebuilt Content DNA body.

The package must not contain an answer-specific Content DNA object. It may contain the reviewed source-safe provenance fields from which Hees later constructs entries. Package-authoring tooling may compile and validate those package fields and may create synthetic expected outputs for acceptance fixtures, but it cannot declare the memory selected for a live answer.

A model may emit visible answer units and identifier-only support through RFC 009. It must not emit Content DNA fields, entry order, provenance digests, review status, rights claims, source references, or the Content DNA identifier. A retrieval provider may nominate memory identifiers but cannot determine terminal membership. A verifier may classify exact target-premise relations but cannot author entries.

### Terminal states

Content DNA contract 0.1 defines two body states:

- **admitted_answer:** The Spectrum result is RFC 009 admitted_original or admitted_repaired, the visible answer is present, selected memory is non-empty, and entries provide exact selected-memory coverage.
- **no_answer:** The trusted terminal result is a package-authored clarification under RFC 009, or a future accepted package-authored refusal variant. The answer digest is absent, selected memory and entries are empty, and the body names the exact no-answer kind.

A repair-requested terminal is not complete and must not emit Content DNA. A rejected terminal must not emit Content DNA. A failure before trusted package, proposal, or terminal identity is established must not produce a Content DNA-shaped artifact from untrusted input.

The no-answer state prevents applications from interpreting an empty entry array as evidence that a visible answer needed no sources. It is a closed terminal provenance statement that no model answer was admitted. Contract 0.1 permits no other zero-entry case.

### Canonical body

A Content DNA body must be a closed JSON object canonicalized with the exact RFC 005 RFC 8785 JCS over I-JSON profile. The body must contain exactly the fields permitted by its state and no generic metadata, extensions, diagnostics, provider fields, arbitrary labels, timestamps, paths, or nested content.

Every body contains:

| Field | Meaning |
| --- | --- |
| contract_version | Exact Content DNA contract version; contract 0.1 accepts only the string 0.1 |
| state | admitted_answer or no_answer |
| package | Exact trusted package, domain, revision, and artifact digest |
| proposal_id | Exact trusted logical proposal identity from RFC 009 |
| spectrum_decision_id | Exact deterministic RFC 001 decision identity |
| terminal | Exact RFC 009 terminal variant and public reason |
| policy | Exact constraint-plan and response-contract identity that governed the terminal decision |
| entries | Ordered Content DNA entries; non-empty for admitted_answer and empty for no_answer |
| source_digests | Ordered duplicate-free first-use projection of entry source fingerprints; empty for no_answer |

An admitted_answer body additionally contains answer_digest. The digest binds the exact ordered visible answer units without embedding their text. A no_answer body instead contains no_answer_kind, whose closed contract 0.1 value is clarification. A future response-contract version may add refusal only together with an exact RFC 009 terminal variant and updated Content DNA contract.

The body must omit evaluation time unless a later privacy-reviewed contract demonstrates that it is required for external verification. Review and validity decisions use the trusted admitted evaluation time internally, but a timestamp is not necessary to prove selected-memory identity and can disclose interaction timing.

### Package and policy identity

The package object must contain exactly package_id, domain_id, package_revision, and artifact_digest copied from the direct RFC 005 accepted package capability. It must never use values repeated by a response candidate, provider result, public trace, or caller.

The policy object must contain the exact constraint plan identifier and revision plus the exact response contract identifier and revision that governed the terminal result. If a future Spectrum contract uses another package-owned policy surface that can change selected memory or answer admission, that policy identity must join a new exact Content DNA contract version rather than being placed in an extension map.

Content DNA does not copy complete policy definitions, findings, thresholds, provider bindings, behavior traces, or private failure data. Exact package and policy identity lets an authorized system resolve those declarations separately without leaking them in every answer artifact.

### Answer binding

For admitted_answer, answer_digest must equal SHA-256 over the RFC 005 JCS canonical bytes of a closed answer-binding object containing the exact ordered RFC 009 visible answer units and no support, findings, provider fields, or presentation metadata. The digest string must use the lowercase sha256 prefix and lowercase hexadecimal form required by RFC 005.

The Content DNA body must not contain the answer-binding object or visible text. An application that is already authorized to display the answer may independently recompute answer_digest from the exact trusted visible units returned atomically by Hees. Whitespace, Unicode code points, unit order, and unit identifiers are identity-bearing exactly as RFC 009 defines them; Content DNA must not normalize or reinterpret them.

For no_answer, answer_digest must be absent. Hashing an empty string would be ambiguous because it could suggest that empty model output was admitted.

### Content DNA entry

Each admitted_answer entry is a closed source-safe projection of one RFC 001 selected RFC 003 governed-memory atom. It must contain exactly:

| Field | Source and requirement |
| --- | --- |
| memory_id | Exact package-owned logical atom identifier |
| source_ref | Exact source-safe reference admitted with the atom |
| source_kind | Exact closed package-owned source classification |
| source_fingerprint | Exact source digest or fingerprint admitted with the atom |
| provenance_digest | SHA-256 identity of the canonical source-safe provenance projection defined below |
| review_state | Exact approved runtime review state |
| review_revision | Exact package-owned review revision or policy identity that established approval |
| rights_state | Exact runtime-allowed rights state |
| authority_class | Exact package-owned authority classification applied to the atom |
| evidence_kind | Exact package-owned evidence or guidance classification used by policy |

Contract 0.1 must not include source title, filesystem path, URI with embedded credentials, unrestricted locator, raw page text, extracted claim or guidance, applicability prose, reviewer identity, review notes, provider binding, retrieval rank, relevance score, verifier score, visible-unit identifier, support-claim identifier, or model field.

If RFC 003 contract 0.1 does not yet provide a closed source_kind, review_revision, or evidence_kind field, RFC 003 and RFC 005 must add those exact package-relative declarations before this RFC advances to Planned. Content DNA must not invent missing values from labels or free-form text.

### Provenance digest

The provenance_digest must equal SHA-256 over the RFC 005 JCS canonical bytes of a closed projection containing memory_id, source_ref, source_kind, source_fingerprint, review_state, review_revision, rights_state, authority_class, evidence_kind, and the exact containing package identity. It binds the answer-time entry to the package-reviewed source-safe facts without reproducing the memory text.

The provenance digest is distinct from source_fingerprint and artifact_digest. The source fingerprint identifies the governed source revision; the provenance digest identifies one package-bound reviewed projection for one memory atom; the artifact digest identifies the complete admitted package. An implementation must not substitute one for another or infer equality from matching prefixes.

### Selected-memory coverage

For admitted_answer, Content DNA validation must establish all of the following:

1. Spectrum selected memory is non-empty and duplicate-free.
2. The entry count equals the selected-memory count.
3. Entry memory identifiers equal selected-memory identifiers position by position.
4. Every entry resolves to the exact selected RFC 003 atom in the direct RFC 005 accepted package.
5. No discarded, merely examined, retrieved-but-unselected, unknown, stale, invalid, rights-blocked, or unreviewed atom appears.
6. Every source-safe field equals the package-owned value without normalization or caller substitution.
7. Every provenance digest recomputes exactly.
8. source_digests equals the ordered duplicate-free first-use projection of entry source_fingerprint values.
9. The package, proposal, policy, Spectrum decision, terminal response, and answer digest all match the direct trusted terminal state.

Set equality without order equality is insufficient because selected-memory order is part of the deterministic Spectrum decision and may be meaningful to explanation. Sorting entries by identifier, source, digest, or caller preference must reject rather than silently normalize.

For no_answer, selected memory, entries, and source_digests must all be empty, answer_digest must be absent, and the exact terminal variant must permit the declared no_answer_kind. A zero-entry admitted_answer is invalid.

### Content DNA identifier and envelope

The Content DNA identifier must be the lowercase string sha256 followed by a colon and the SHA-256 digest of the canonical Content DNA body bytes. The returned exportable value is a closed object containing exactly body and content_dna_id. Verification must canonicalize body under the RFC 005 profile, recompute the identifier, and validate every closed-schema and state rule that does not require private in-process capabilities.

The identifier establishes deterministic content identity and detects body modification. It does not prove that Hees produced the value, that a live Spectrum operation occurred, that the package artifact is available, or that reviewed memory is objectively true. External authenticity requires a later signature or attestation contract.

The direct terminal Hees return remains authoritative inside the running operation. A caller-created body with a valid digest, a copied Content DNA envelope, or a value that passes public verification must not be accepted where a direct RFC 001 capability is required.

### Atomic construction and failure behavior

Spectrum must freeze the terminal response, selected-memory order, package and policy identity, and decision identity before Content DNA construction. Hees must then project entries from the direct accepted package, validate state and exact coverage, compute provenance and answer digests, canonicalize the body, compute content_dna_id, and return the visible answer and Content DNA together.

If any step fails, the admitted answer must not be returned. The failure must map through the exact RFC 009 response policy and public-reason precedence rather than producing an admitted result with absent or partial provenance. Implementations must not retry with fewer entries, remove a failing source, downgrade review or rights requirements, substitute a generic citation, or emit the answer before repair or rejection is selected.

A construction failure caused by an invalid response candidate may be candidate-correctable only where RFC 009 explicitly permits one repair and the repair can change model-controlled values. Package provenance, selected-memory identity, digest calculation, review state, rights state, or internal Hees failure is not model-correctable and must not be sent to the model as a repair request.

### Relationship to export-safe receipts

RFC 002 owns the Content DNA body, entries, state rules, canonical bytes, identifier, construction, and validation. RFC 006 owns general governance receipt bodies, receipt identifiers, terminal projections, and public receipt verification.

For admitted_original and admitted_repaired proposal outcomes, the RFC 006 proposal receipt must include content_dna_id copied unchanged from the atomic terminal result. It may optionally carry the complete already-export-safe Content DNA envelope only in a future exact receipt version; receipt contract 0.1 remains compact and references the identifier. Clarification receipts may include the no-answer content_dna_id when RFC 006 adopts that exact field. Repair-requested and rejected receipts must omit it.

A proposal receipt and Content DNA answer different questions. The receipt records the governed terminal outcome and redacted admitted identifiers; Content DNA records the exact selected reviewed memory and source-safe provenance for the admitted answer. Neither replaces the other, and matching identifiers do not turn an external receipt into in-process authority.

### Package authoring

Package-authoring tooling may transform approved source material into governed-memory atoms, collect source-safe references and fingerprints, record review and rights state, assign package-owned authority and evidence classifications, compute build-time provenance fixtures, and compile those values into an RFC 005 package artifact.

Package-authoring tooling must not place answer-specific Content DNA, a live Spectrum decision identifier, a response answer digest, or a terminal selected-memory list into the package. It may generate synthetic expected Content DNA for acceptance fixtures only when the fixture is clearly non-authoritative and Hees recomputes the runtime value independently.

Package validation must reject provenance fields that contain raw source text, local paths, credentials, unrestricted private locators, unbounded review notes, or unknown extensions. Source-rights review remains a package-authoring responsibility; Hees validates only the admitted state and policy semantics defined by the contract.

### Privacy and redaction

Content DNA is designed for export, but export safety is field-specific rather than implied by a digest. source_ref must be a package-reviewed logical or public reference and must not be an arbitrary URI or filesystem path. source_fingerprint, provenance_digest, artifact_digest, answer_digest, and content_dna_id may still be correlatable identifiers and must be treated according to deployment privacy policy.

Contract 0.1 contains no user query text, visible answer text, source text, extracted memory text, support claim, verifier target, provider identity, timestamps, reviewer identity, or private policy value. An application may display authorized source references beside the answer, but Content DNA does not grant access to restricted source material.

A deployment that cannot export a source-safe reference must use a package-approved opaque public reference whose resolution is separately access-controlled. It must not remove the entry or replace the reference with an empty string after Content DNA construction.

### Bounds and resource behavior

The entry ceiling must equal the RFC 001 selected-memory ceiling and may not exceed the RFC 003 admitted-context ceiling. Each identifier, source reference, classification, revision, and digest has an absolute UTF-8 byte ceiling coordinated with RFC 003 and RFC 005. The aggregate canonical body and envelope must have exact byte ceilings checked before proportional allocation or serialization.

Package-declared lower bounds may narrow the number of selected memories but cannot raise contract ceilings. Digest input sizes must use checked exact arithmetic. An over-bound body, field, or collection must fail before answer admission; truncation is forbidden because it would break exact coverage.

Final numeric ceilings remain Draft gates pending representative consumer-phone measurement. Measurement must cover maximum selected memory, repeated and distinct source fingerprints, canonicalization, digest construction, atomic response retention, and public verification while the target model and runtime remain resident.

### Determinism

Given the same RFC 005 package, RFC 001 terminal decision, RFC 009 visible answer units, and exact contract versions, conforming implementations must produce byte-identical canonical Content DNA bodies, identical answer and provenance digests, identical source_digests order, and the same content_dna_id.

Implementations must not normalize Unicode, case, whitespace, URI spelling, classification spelling, or identifier order outside the owning contract. They must not read a wall clock, insert serialization timestamps, depend on object-property or hash-map order, use platform-native path rules, or choose an available digest implementation dynamically.

### Public validation

Public Content DNA verification may establish only that:

- the body uses the exact supported closed schema and canonical value profile;
- state-specific presence and absence rules hold;
- entries and source_digests are internally ordered and duplicate-free;
- digest fields use the required syntax;
- provenance digests recompute from their included source-safe fields and package identity;
- answer_digest is present only for admitted_answer;
- content_dna_id matches the canonical body bytes; and
- terminal variant and state are a permitted pair under the supported contract.

Public verification without the admitted package and direct Spectrum result cannot prove that the entries equal the live selected-memory set, that source fields match the package, that the review and rights claims are genuine, or that Hees emitted the artifact. Applications must describe that distinction accurately.

## Design details

### Relationship to other RFCs

#### Relationship to RFC 000

RFC 000 makes Content DNA mandatory for admitted visible answers and establishes that only Hees may author answer-time provenance. This RFC defines the detailed value and validation rules that realize that invariant.

#### Relationship to RFC 001

RFC 001 owns terminal selected-memory order, Spectrum decision identity, applied policy, and atomic response finality. This RFC projects those trusted values into source-safe answer-time provenance and cannot change the selection.

#### Relationship to RFC 003

RFC 003 owns admitted governed-memory atoms, source-safe provenance, review and rights state, authority classification, validity, and materialized context. This RFC requires an exact entry projection from selected atoms and may require additional closed source_kind, review_revision, and evidence_kind fields before Planned.

#### Relationship to RFC 005

RFC 005 owns canonical package bytes, package identity, package-relative provenance declarations, and the JCS over I-JSON profile reused here. Content DNA does not create another package identity or accept package fields from a caller.

#### Relationship to RFC 006

RFC 006 owns generic terminal receipt projection and integrity. Proposal receipts reference the Content DNA identifier for admitted answers; Content DNA remains the dedicated selected-memory provenance artifact.

#### Relationship to RFC 009

RFC 009 owns exact visible answer units, proposal identity, attempt state, clarification, support, terminal variants, and public reasons. This RFC hashes the exact admitted visible units, admits no substitute prose, and applies state-specific emission rules to those terminal variants.

### Acceptance obligations

- Golden fixtures must include admitted original and repaired answers, package-authored clarification, multiple memories from one source, multiple sources, repeated source fingerprints, and deterministic first-use source order.
- Fail-closed fixtures must cover missing, extra, duplicate, reordered, unknown, stale, unreviewed, rights-blocked, package-mismatched, proposal-mismatched, decision-mismatched, policy-mismatched, terminal-mismatched, answer-mismatched, and digest-mismatched entries.
- State fixtures must reject zero-entry admitted answers, answer digests on no-answer values, entries on clarification, Content DNA on repair-requested or rejected terminals, and artifacts produced before safe identity exists.
- Cross-implementation fixtures must agree on canonical bytes, answer digest, every provenance digest, source_digests order, content_dna_id, and public verification result.
- Authority-negative fixtures must prove that models, providers, callers, package-authoring tooling, packages, traces, receipts, and publicly verified Content DNA cannot author or recreate the direct terminal value.
- Privacy fixtures must reject source text, answer text, prompts, hidden reasoning, local paths, credentials, arbitrary URIs, provider scores, reviewer identity, private notes, timestamps, and unknown fields.
- Constrained-device measurements must justify final per-field, entry-count, canonical-body, retained-state, and atomic-return ceilings before Planned.

## Alternatives considered

### Reuse model-authored citations

Rejected because model citations can be omitted, fabricated, reordered, or detached from the memory and policy that governed terminal admission.

### Treat the complete retrieved context as Content DNA

Rejected because retrieval nomination and context admission do not prove that every atom contributed to the answer. Content DNA covers only Spectrum-selected memory.

### Put Content DNA in the package

Rejected because a package is built before a live request and cannot know the answer, terminal decision, or selected-memory subset. The package owns provenance facts, not answer-specific projection.

### Let package-authoring tooling emit the final value

Rejected because package-authoring tooling owns build-time review and compilation rather than runtime terminal authority. It may create fixtures but Hees must recompute the live result.

### Use only the generic proposal receipt

Rejected because a compact terminal receipt does not carry exact source-safe provenance, review identity, rights state, or selected-memory-only coverage. The receipt references Content DNA but does not replace it.

### Include raw source passages or visible answer text

Rejected because that would duplicate governed content, increase leakage risk, and turn provenance into another content channel. Exact digests and authorized resolution preserve binding without reproduction.

### Permit partial Content DNA after a projection failure

Rejected because partial provenance would make an admitted answer appear fully governed when selected memory was omitted. The answer and complete Content DNA are atomic.

## Drawbacks

Content DNA adds canonicalization, digest work, source-safe provenance retention, and an atomic failure condition to the answer path. Packages must carry exact review and provenance identity, and implementations must maintain selected-memory order through terminal adjudication. Exported digest values may enable correlation even without raw text. Applications must understand that public integrity verification is not producer authenticity or proof of truth.

Those costs are necessary for a system that claims answer-specific governed provenance. A cheaper citation list would not establish the same authority or coverage guarantees.

## Layers affected

- **Public contract:** Content DNA states, body, entry, canonical identity, validation, and public verification.
- **Spectrum:** Atomic construction from terminal selected memory and response state.
- **Governed memory:** Closed source-safe provenance, review, rights, authority, and evidence classification fields.
- **Package admission:** Exact canonical field schemas and bounds required for entry projection.
- **Visible response:** Exact answer digest binding and terminal-state emission rules.
- **Receipts:** Content DNA identifier projection for admitted answers without schema conflation.
- **Package-authoring tooling:** Build-time provenance compilation and synthetic fixtures, never live answer-specific authorship.
- **Testing:** Golden, fail-closed, authority-negative, privacy, interoperability, and constrained-device evidence.

## Design Decisions

- Content DNA is a core answer-time artifact rather than a late receipt extension.
- Every admitted visible answer requires non-empty exact selected-memory coverage.
- Package-authored clarification uses a closed zero-entry no-answer representation; repair-requested and rejected outcomes emit no Content DNA.
- Entries contain source-safe provenance and governance identity but no source or answer text.
- Hees constructs Content DNA inside Spectrum; no external component may submit a completed value.
- The Content DNA body and identifier are distinct from the generic governance receipt body and identifier.
- Proposal receipts reference content_dna_id for admitted answers.
- Canonical identity establishes content integrity, not producer authenticity or real-world truth.

## Unresolved questions

- What exact closed source_kind, review_revision, and evidence_kind declarations should RFC 003 and RFC 005 add before this RFC advances to Planned?
- Should clarification contract 0.1 emit no-answer Content DNA by default, or only when a package explicitly enables export of the source-safe terminal provenance statement?
- Which answer-binding object fields are required beyond ordered visible-unit identifiers and text to remain stable across presentation-only changes?
- What final per-field, entry, canonical-body, retained-state, and atomic-return ceilings do representative consumer-phone measurements justify?
- Which future attestation mechanism can prove producer authenticity without turning Content DNA into a replayable Spectrum capability?

<!-- Rename this section to "Design Decisions" once all questions have been resolved.
     An RFC cannot move from Draft to Planned until no unresolved questions remain. -->
