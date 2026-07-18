# RFC 000: Foundational Governance Authority

- **Status:** Draft
- **Created:** 2026-07-18
- **Author(s):** Encero Systems
- **Related:**
    - RFC 001 (Spectrum Terminal Adjudication)
    - RFC 002 (Content DNA Answer-Time Provenance)
- **Issue:** https://github.com/encero-systems/hees.ai/issues/1
- **RFC PR:** —
- **Written against:** Hees 0.0.1 / Incan 0.4.0
- **Shipped in:** —

## Summary

Hees should define one stable authority model for governed AI operations. Governed packages own reviewed knowledge and policy declarations; retrieval, model, verifier, and other providers nominate bounded values without acquiring authority; Spectrum composes admitted values and makes the terminal runtime decision; and every admitted visible answer carries Content DNA that resolves exactly to the selected reviewed memories that made the answer admissible. Subsequent RFCs may refine this model but must not create another terminal authority, another user-visible model channel, or another provenance authority.

## Core model

1. **Packages declare governed authority.** An admitted package supplies bounded reviewed memory, policy, behavior, source-safe provenance, rights state, and compatibility identity. Package declarations become usable only after Hees validates them under an accepted package contract.
2. **Providers nominate; they do not decide.** Retrieval engines, language models, verifiers, classifiers, and other providers may return bounded values requested by Hees or its caller. Their scores, text, rankings, findings, and metadata remain untrusted until the relevant Hees boundary validates and classifies them.
3. **Spectrum owns terminal adjudication.** Spectrum is the Hees decision core that composes admitted package facts, selected memory, validated non-authoritative findings, and deterministic policy into one terminal outcome.
4. **The visible answer has one model channel.** Model-generated user-visible prose may enter only through the governed response candidate defined by the response lifecycle. Support records, findings, traces, receipts, and Content DNA cannot contain substitute model prose.
5. **Content DNA owns answer-time provenance.** Every admitted visible answer must carry a deterministic Content DNA value derived by Hees from every and only the reviewed memory atoms selected by Spectrum for that answer.
6. **Direct capabilities carry in-process authority.** A trusted Hees operation may return an opaque capability that authorizes its next governed step. Serializable results, traces, receipts, and caller-reconstructed values cannot substitute for that direct capability.
7. **Exported artifacts explain without deciding.** A receipt or Content DNA projection may provide deterministic identity, integrity, and provenance outside the immediate call, but public verification does not recreate the original in-process authority or prove external producer authenticity unless another accepted contract explicitly provides attestation.
8. **Malformed or incomplete governance fails closed.** A runtime must not infer missing authority, salvage ambiguous inputs, silently normalize incompatible values, or let provider preference resolve a policy gap.

## Motivation

Hees contracts divide package admission, memory, constraints, verification, behavior, responses, and receipts into focused boundaries. Without a shared authority model, those boundaries can still assign overlapping finality: retrieval relevance can be mistaken for support, a verifier can become a hidden policy engine, a response validator can bypass package policy, or an exportable trace can be treated as a live decision capability. Spectrum and Content DNA must therefore precede the specialized contracts as foundational responsibilities rather than appear later as optional extensions.

The foundation also makes model and provider substitution safe. A deployment may change its model size, language support, retrieval implementation, device runtime, or provider topology without changing who owns reviewed knowledge, terminal adjudication, and answer-time provenance.

## Goals

- Define the single Hees authority graph that every later RFC must preserve.
- Establish Spectrum as the sole terminal adjudication boundary.
- Establish Content DNA as mandatory answer-time provenance for every admitted visible answer.
- Separate package declarations, provider nominations, non-authoritative findings, terminal decisions, traces, and receipts.
- Preserve one model-generated visible-answer channel and prevent support or metadata from becoming substitute prose.
- Require deterministic, fail-closed behavior and explicit identity across all governed stages.
- Define the Workbench, implementation-package, provider, and Hees ownership boundaries.
- Keep the foundation stable while dedicated RFCs own detailed schemas and algorithms.

## Non-Goals

- Defining domain policy, educational content, source-rights judgments, or organization-specific review workflow.
- Selecting a language model, retrieval engine, embedding representation, quantization method, storage engine, transport, or device runtime.
- Claiming that deterministic governance establishes unrestricted real-world truth.
- Exposing hidden reasoning, model chain-of-thought, raw provider payloads, private deliberation, or unrestricted source content.
- Defining complete Spectrum and Content DNA schemas; RFC 001 and RFC 002 own those details.
- Defining signatures, remote attestation, federation, consensus, or network membership.

## Guide-level explanation

This RFC is the normative foundation for proposed Hees contracts. It does not claim that Hees 0.0.1 already implements Spectrum, Content DNA, retrieval, model execution, or the later contracts that depend on them. Until an RFC and its implementation are both merged, the checked public API and current Contracts documentation remain authoritative for implemented behavior.

The terms Spectrum and Content DNA name public architectural responsibilities. RFC 001 and RFC 002 define their detailed contracts. In the proposed flow, a package supplies reviewed memory and policy, providers nominate bounded values, a model proposes visible prose, Spectrum determines the terminal outcome, and Hees constructs Content DNA from the exact selected reviewed memory before exposing an admitted answer.

## Reference-level explanation

### Authority model

| Participant or artifact | May provide | Must not determine |
| --- | --- | --- |
| Governed package | Reviewed memory, policy, behavior declarations, source-safe provenance, rights and compatibility identity | The outcome of a request without Hees validation and Spectrum adjudication |
| Workbench or another package authoring system | Candidate package artifacts, review workflow, compiled provenance, acceptance fixtures | Runtime admission, terminal action, or answer-time selected memory |
| Retrieval provider | Ranked nominations and bounded retrieval metadata | Package authority, semantic support, selected-memory finality, or terminal outcome |
| Language model | Bounded response candidates through the declared visible channel | Policy, provenance, support authority, Content DNA, or terminal outcome |
| Verifier or evaluator | Typed observations or findings for exact governed targets | Truth, policy action, selected memory, or terminal outcome |
| Spectrum | Deterministic selected and discarded memory, policy effects, contradictions, response strategy, and terminal action | New domain content, policy, source review, or model prose |
| Content DNA | Deterministic answer-time provenance for a terminal outcome | New evidence, raw source authority, hidden reasoning, or a replacement decision |
| Receipt or trace | Bounded explanation, identity, and integrity data | In-process authority merely because it can be serialized or verified |

### Normative invariants

#### Package authority is explicit and bounded

Hees must derive package authority only from a successfully admitted, exact-version package artifact or from the deliberately small in-memory contract implemented before package artifacts exist. A caller-supplied identifier, plausible digest, model assertion, provider configuration, or trace cannot create package authority.

Package declarations must use closed, bounded, versioned contracts. Unknown fields, incompatible versions, duplicate identities, unresolved references, invalid rights state, and incomplete review state must fail according to the owning RFC rather than being ignored or repaired by provider behavior.

#### Nomination is never admission

A provider result is a nomination to a specific Hees boundary. Relevance is not support; support is not policy; policy is not terminal adjudication; and fluent prose is not evidence. A later RFC may define deterministic conversion from a provider observation to a typed finding, but that conversion must preserve the finding's non-authoritative status until Spectrum applies admitted policy.

Provider substitution must not change the outcome when two providers submit the same normalized governed values. Provider-specific scores, diagnostic wording, hidden state, model identity, or iteration order must not become undeclared tiebreakers.

#### Spectrum is the single terminal decision boundary

Every governed operation that can admit a visible answer, issue a package-authored clarification or refusal, reject a proposal, or authorize escalation must terminate through Spectrum. Specialized contracts may validate memory, constraints, packages, findings, behavior candidates, and response candidates, but they feed Spectrum and cannot establish a competing terminal result.

Spectrum must preserve exact package, request, proposal, policy, memory, finding, behavior, and response identity whenever the corresponding boundary has established that identity. It must produce a deterministic public reason and a terminal variant from the owning response contract. Its direct return may carry an opaque capability; its public trace remains non-authoritative.

#### The user-visible answer is singular

The governed response candidate is the only channel through which model-generated prose may become visible to the user. A model must not place substitute synthesis in support records, uncertainty fields, verifier rationale, Content DNA, receipts, traces, repair instructions, or diagnostics.

Package-authored clarification or refusal text is not model output and must be identifiable as such. A structurally rejected operation must not invent fallback wording inside Hees.

#### Content DNA is mandatory for admitted answers

Every terminal outcome that admits model-generated visible answer content must atomically produce valid Content DNA. The value must cover every and only the Spectrum-selected reviewed memory atoms used to admit that answer. Missing selected memory, additional unselected memory, duplicate entries, mismatched source identity, insufficient review, disallowed rights, or a digest mismatch must prevent answer admission.

Content DNA must be emitted by Hees after Spectrum has established the terminal selected-memory set. It must not be authored by a model, retrieval provider, package authoring tool, caller, or receipt consumer. Workbench may compile the package-owned provenance from which Hees constructs the answer-time value, but it cannot know or predeclare the final answer-specific selection.

A package-authored clarification or refusal may carry the explicit zero-entry no-answer representation defined by RFC 002. A structurally rejected operation for which trusted package or proposal identity was never established must not emit a value that resembles admitted-answer provenance.

#### Explanation and authority remain separate

Hees must distinguish direct in-process authority from serializable explanation. A copied result, trace, Content DNA document, receipt, or collection of otherwise valid fields must not be accepted where an opaque direct capability is required.

Canonical digests establish deterministic content identity and integrity for the bytes they cover. They do not independently establish who produced those bytes, that the source material is objectively true, or that a different Hees process made the same live decision. Signatures, attestations, replay protection, and federation require dedicated contracts.

#### Determinism is part of governance

Given the same exact admitted inputs and contract versions, conforming Hees implementations must produce the same normalized findings, selected-memory order, policy effects, terminal variant, public reason, Content DNA body, and canonical digests. A contract must state every meaningful order, bound, absence rule, tie rule, and failure precedence.

A runtime must not read undeclared wall-clock state, use floating-point tolerance as authority, depend on object iteration order, salvage a valid-looking prefix from malformed input, or silently negotiate a nearby contract version.

#### Failure is explicit

Fail-closed behavior must not be represented as success with missing fields. A contract must distinguish invalid input, valid unavailability, insufficient governed support, package-authored clarification, package-authored refusal, rejection, and authorized escalation wherever those distinctions affect callers or users.

One component's failure must not grant another component more authority. In particular, verifier unavailability cannot make retrieval relevance authoritative, a model repair cannot author new policy, and missing Content DNA cannot be replaced by a generic receipt.

### Governed operation lifecycle

The detailed RFCs may split implementation into opaque intermediate capabilities, but the logical authority flow remains:

1. Hees admits an exact governed package and establishes its identity.
2. A retrieval provider nominates logical memory identifiers under a package-approved binding.
3. Hees validates the complete retrieval result and materializes package-owned governed memory.
4. A model may propose bounded behavior or response candidates through the declared provider boundary.
5. Verifiers and other evaluators may produce bounded typed observations for exact governed targets.
6. Hees validates and normalizes findings, then Spectrum applies package-owned policy in deterministic order.
7. Spectrum chooses the terminal response outcome and exact selected-memory set.
8. An admitted visible answer and its Content DNA are produced atomically; other terminal outcomes use their explicitly defined no-answer semantics.
9. Hees may project export-safe receipts or explanatory traces without turning those artifacts into a second decision authority.

No step may be skipped by presenting data that resembles a later result. An implementation may optimize or fuse steps only when the public observations, authority boundaries, failure behavior, and deterministic outputs remain equivalent.

## Design details

### Contract ownership

RFC 001 owns Spectrum's detailed inputs, adjudication record, selected and discarded memory, contradiction and policy representation, terminal decision, and non-authoritative trace.

RFC 002 owns the Content DNA body, entry projection, exact selected-memory coverage, no-answer representation, canonical identity, validation, and privacy boundary.

Later RFCs own specialized contracts for governed memory, composable constraints, package admission, export-safe receipts, verification findings, behavior selection, and visible response lifecycle. Each later RFC must include a relationship section that states how it supplies Spectrum, contributes to Content DNA, or remains outside those responsibilities.

### Workbench and implementation-package boundary

Hees owns generic runtime contracts and deterministic authority transitions. Workbench may ingest sources, support human review, compile governed memory and policy declarations, create package artifacts, produce acceptance fixtures, and preserve build-time provenance. Implementation packages may provide domain-specific content, rules, provider bindings, and reviewed language resources.

Neither Workbench nor an implementation package may precompute a terminal Spectrum result or answer-specific Content DNA and ask Hees to trust it. Hees must resolve package declarations and construct the final runtime values from exact admitted inputs.

### Compatibility and evolution

An RFC that changes an authority relationship, terminal variant, selected-memory meaning, Content DNA coverage rule, canonical identity, or public reason semantics introduces a public-contract change. Such a change requires an explicit version transition and compatibility evidence; it must not be hidden behind an implementation detail or provider configuration.

New providers, retrieval methods, models, languages, storage engines, quantizers, and deployment targets may be added without changing this RFC when they preserve the normalized contract values and authority boundaries. A capability that needs a provider to decide policy or provenance is incompatible with this model rather than an extension of it.

### Acceptance obligations

- Every subsequent RFC must reference RFC 000 and identify any Spectrum or Content DNA relationship.
- Synthetic end-to-end fixtures must prove that a provider can nominate data but cannot produce a terminal result or authoritative provenance.
- Authority-negative fixtures must reject caller-reconstructed opaque capabilities, forged selected-memory sets, model-authored Content DNA, and verified receipts submitted as live authority.
- Independent implementations must agree on the terminal variant, public reason, selected-memory order, Content DNA coverage, and canonical identity for shared fixtures.
- Documentation must clearly distinguish the architectural target from the checked Hees 0.0.1 implementation.
- Publication review must confirm that generic examples contain no private package contents, client material, raw corpora, credentials, model artifacts, local paths, or unpublished research results.

## Alternatives considered

### Treat the language model as the decision authority

Rejected because prompt compliance and generated confidence do not establish package policy, reviewed provenance, deterministic conflict handling, or portable terminal behavior.

### Treat retrieval or verification success as admission

Rejected because relevance is not support, support is not policy, and one provider observation cannot compose every governed constraint or response requirement.

### Define Spectrum and Content DNA as later optional capabilities

Rejected because subsequent contracts would already have assigned memory, policy, response, and receipt authority before the system established its terminal decision and answer-time provenance invariants.

### Let Workbench or the application compose terminal results

Rejected because deployment-specific orchestration would make authority vary between callers. Workbench owns build-time governance inputs; Hees owns runtime finality.

## Drawbacks

A foundational authority model couples later RFCs to explicit terminology and requires every new capability to state its Spectrum and Content DNA relationship. It prevents permissive integrations that would treat a provider score, reconstructed trace, or incomplete provenance as good enough. Implementations must preserve direct capabilities and exact identity across multiple focused contracts.

Those constraints are deliberate. Without them, model or application behavior could silently become the real governance system even while the public API appeared provider-neutral.

## Layers affected

- **Public architecture:** Stable definitions of package authority, provider nomination, Spectrum finality, Content DNA, and exportable explanation.
- **Runtime contracts:** One direct authority flow across package, memory, findings, behavior, response, provenance, and receipt stages.
- **Package and Workbench boundary:** Build-time declarations and provenance compilation without live terminal authorship.
- **Provider boundary:** Bounded untrusted nominations and observations without policy or provenance authority.
- **Compatibility:** Explicit versioning when a later contract changes an authority relationship or terminal invariant.
- **Testing and documentation:** Cross-contract authority-negative, deterministic, privacy, and current-versus-proposed evidence.

## Design Decisions

- RFC 000 is normative and foundational rather than a late capability proposal.
- Spectrum and Content DNA are named core responsibilities, not optional provider conventions.
- Detailed Spectrum and Content DNA contracts remain in dedicated early RFCs so this document can stay stable.
- Every admitted visible answer requires exact selected-memory Content DNA.
- Providers and evaluators remain non-authoritative even when their normalized output is required for admission.
- Direct opaque values may carry in-process authority; traces and exported artifacts do not recreate it.
- Workbench compiles governed inputs, while Hees constructs terminal decisions and answer-time provenance.

## Unresolved questions

- Which terminal variants require a zero-entry no-answer Content DNA representation, and which must emit no Content DNA at all?
- What minimum cross-RFC conformance suite is required before RFC 000 may advance from Draft?
- Which authority-preserving extension point should later federation and external attestation contracts use without changing the single Spectrum terminal boundary?

<!-- Rename this section to "Design Decisions" once all questions have been resolved.
     An RFC cannot move from Draft to Planned until no unresolved questions remain. -->
