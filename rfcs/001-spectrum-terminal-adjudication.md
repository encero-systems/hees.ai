# RFC 001: Spectrum Terminal Adjudication

- **Status:** Draft
- **Created:** 2026-07-18
- **Author(s):** Encero Systems
- **Related:**
    - RFC 000 (Foundational Governance Authority)
    - RFC 002 (Content DNA Answer-Time Provenance)
    - RFC 003 (Governed Memory and Retrieval Results)
    - RFC 004 (Composable Governance Constraints)
    - RFC 005 (Canonical Package Artifact Admission)
    - RFC 006 (Export-Safe Governance Receipts)
    - RFC 007 (Evidence-Grounded Claim Verification Findings)
    - RFC 008 (Governed Behavior Envelopes)
    - RFC 009 (Governed Visible Response Lifecycle)
- **Issue:** https://github.com/encero-systems/hees.ai/issues/2
- **RFC PR:** —
- **Written against:** Hees.ai 0.0.1 / Incan 0.4.0
- **Shipped in:** —

## Summary

Hees.ai should expose Spectrum as its single terminal adjudication boundary. Spectrum consumes only direct trusted capabilities and validated bounded findings produced by the specialized Hees.ai contracts, resolves selected and discarded governed memory, contradictions, package policy, behavior, and response state in one deterministic order, and returns one terminal response outcome plus a bounded non-authoritative trace. Only Spectrum may authorize admission of model-generated visible prose, and an admitted answer must be returned atomically with valid RFC 002 Content DNA.

## Core model

1. **Spectrum receives authority; it does not reconstruct it.** Accepted package, memory, constraint, behavior, and response values enter Spectrum through direct Hees.ai capabilities or trusted values produced inside the same governed operation.
2. **Findings remain observations.** Verifier, coverage, policy, and other evaluator findings are validated and normalized under their owning contracts but cannot select the final action.
3. **Memory selection becomes terminally exact.** Spectrum distinguishes the complete admitted context from the exact ordered subset used as premises for an admitted answer.
4. **Policy application is deterministic.** Package-declared order, dependencies, allowed actions, conflict rules, and failure substitutions determine the effective governance result.
5. **Behavior selection is not answer admission.** A selected behavioral frame may authorize a response candidate to continue, but Spectrum still applies response, support, verification, synthesis, repair, and terminal rules.
6. **The response lifecycle supplies terminal variants.** Spectrum returns exactly one RFC 009 variant and reason for the original or repaired proposal path.
7. **Content DNA closes admitted answers.** Spectrum cannot return an admitted variant unless RFC 002 constructs and validates exact Content DNA from the terminal selected-memory set.
8. **The trace explains but cannot authorize.** Public decision data may be inspected or exported, but only the direct Spectrum result and its opaque capabilities may continue a governed operation.

## Motivation

The specialized RFCs deliberately separate memory admission, package identity, finding classification, behavior eligibility, response structure, repair, and receipt projection. That separation keeps each boundary testable, but it does not by itself identify the single operation that owns finality. Without Spectrum, an implementation could let a constraint result, behavior selector, verifier, response validator, control plane, or provider become the de facto terminal authority.

The absence of an explicit terminal core also leaves selected memory ambiguous. A retrieval result can materialize a valid governed context without proving that every atom supports or contributes to the visible answer. A verifier can examine claims against memory without deciding whether the final answer is admissible. Content DNA requires a terminally exact selected-memory set, so the operation that decides admission must own that set and its relationship to the response.

Spectrum provides that composition point without becoming a domain rules engine. Packages declare domain policy and reviewed content; specialized Hees.ai contracts normalize their inputs; Spectrum applies those admitted declarations mechanically and produces the single terminal result required by RFC 000.

## Goals

- Define Spectrum as the sole terminal authority for governed proposal outcomes.
- Define the exact categories of trusted inputs Spectrum may consume and the authority each input carries.
- Distinguish admitted context, selected memory, discarded memory, examined premises, and cited support.
- Define deterministic policy, contradiction, behavior, response, repair, and terminal ordering.
- Preserve exact package, request, proposal, attempt, policy, memory, behavior, and response identity.
- Define a bounded public decision record and non-authoritative explanatory trace.
- Require atomic Content DNA construction for every admitted visible answer.
- Prevent traces, receipts, provider results, and caller-created values from recreating in-process authority.
- Define cross-contract acceptance evidence for independent implementations.

## Non-Goals

- Authoring domain policy, memory, clarification, refusal wording, or behavior declarations.
- Generating, translating, rewriting, or ranking visible answer prose.
- Performing retrieval, embedding, reranking, model inference, or provider selection.
- Determining unrestricted real-world truth from model or verifier output.
- Exposing hidden reasoning, chain-of-thought, free-form evaluator rationale, or private package deliberation.
- Defining the canonical package format, individual finding schemas, response candidate schema, receipt envelope, or Content DNA entry schema owned by their dedicated RFCs.
- Defining remote federation, quorum, consensus, signatures, attestation, or replay protection across independent Hees.ai processes.

## Guide-level explanation

An application begins with a directly admitted package and governed request. Retrieval may nominate package-owned memory, a model may propose a bounded response, and verifiers may report observations about exact targets. Those values remain specialized inputs. Spectrum receives their direct trusted Hees.ai results, applies the admitted package policy, distinguishes selected from discarded memory, and chooses one response-lifecycle terminal variant.

If Spectrum admits a visible answer, it freezes the exact selected-memory order and asks Hees.ai to construct RFC 002 Content DNA from the corresponding package-owned provenance. The answer and Content DNA are returned together. If the candidate needs its single permitted repair, requires package-authored clarification, or must be rejected, Spectrum returns that exact terminal path without inventing fallback prose.

## Reference-level explanation

### Authority boundary

Spectrum is an in-process Hees.ai operation, not a package evaluator, provider protocol, serialized orchestration format, or package-authoring function. Its caller may coordinate provider execution, but every value entering Spectrum must already be bound to the exact governed operation by the owning Hees.ai contract.

Spectrum must not accept a public trace, receipt, Content DNA document, package tuple, list of memory identifiers, terminal variant, or collection of findings as a substitute for the direct trusted capabilities that establish those values. Public scalar identities may be repeated for mismatch detection, but trusted identity must come from the opaque source value rather than the caller's copy.

An implementation may internally fuse Spectrum with specialized validation stages for efficiency. Fusion is conforming only when the observable validation order, failure precedence, selected-memory semantics, terminal outcome, Content DNA, and authority-negative behavior are identical to the logical contract defined here.

### Trusted inputs

Spectrum operates on one bounded adjudication context with these trusted categories:

| Input category | Owning contract | Authority carried into Spectrum |
| --- | --- | --- |
| Accepted package | RFC 005 | Exact package, domain, revision, artifact, declared memory, policy, behavior, response, and provider-binding identity |
| Accepted governed-memory context | RFC 003 | Ordered package-owned atoms materialized from a complete or permitted partial retrieval result |
| Effective constraint adjudication | RFC 004 | Validated package-plan execution, substitutions, conflicts, primary finding, and effective action |
| Claim-verification record | RFC 007 | Exact normalized observations and classifications projected into one non-authoritative constraint finding |
| Behavior selection | RFC 008 | One direct opaque selected-candidate capability and bounded trace, or a closed no-selection result |
| Response lifecycle state | RFC 009 | Exact proposal, attempt, visible units, identifier-only support, synthesis coverage, repair state, and candidate-correctable failures |
| Caller-supplied evaluation time | RFC 003 and RFC 004 | One admitted deterministic time value; never permission to read a local wall clock |

Future finding kinds may enter Spectrum only through an accepted RFC that defines exact identity, bounds, package policy, normalization, failure behavior, and conversion to the shared constraint authority model. An extension map, untyped diagnostic, provider label, or arbitrary score is not a valid Spectrum input.

### Memory roles

Spectrum must keep the following memory roles distinct:

- **Admitted context:** Every package-owned governed-memory atom materialized by RFC 003 from the accepted retrieval result.
- **Examined premises:** Atoms used as verifier or policy inputs for exact candidate targets, whether or not they support the final answer.
- **Selected memory:** Every and only the admitted, reviewed, rights-allowed atoms that Spectrum treats as premises for the admitted visible answer.
- **Discarded memory:** Admitted context atoms that are not selected for the terminal answer.
- **Cited support:** The ordered identifier projection attached to visible answer units under RFC 009; every cited memory must be selected, but selected memory need not be repeated as a citation on every unit.

Selected and discarded memory must form a duplicate-free partition of the admitted context for a terminal admitted answer. Their combined membership must equal the admitted context membership, and their order must preserve the RFC 003 materialized order. An atom cannot be selected if its review, rights, validity, package identity, source provenance, or governing policy is invalid at the admitted evaluation time.

Retrieval rank and relevance may influence nomination order only as RFC 003 permits. They cannot independently make an atom selected. A verifier observation may establish that a target is supported under admitted policy, but the verifier cannot add an atom, remove another atom, or set the final selected-memory list.

For a terminal non-answer outcome, Spectrum may retain examined and discarded memory in a bounded private trace, but it must not label those atoms as answer-supporting selected memory. RFC 002 owns the exact no-answer Content DNA representation.

### Contradictions and conflicts

Spectrum must represent structural policy conflict separately from semantic contradiction. A structural policy conflict is the typed RFC 004 condition in which effective constraints nominate incompatible actions under the package plan. A semantic contradiction is a package-declared or accepted-finding relationship between governed claims or guidance that cannot be jointly applied to the current request without qualification.

Spectrum must not infer arbitrary semantic contradictions from raw natural language. A contradiction may enter only through package-owned typed declarations or a future accepted finding contract with bounded identity and policy mapping. Free-form provider rationale, model disagreement, score distance, or retrieval rank is not a contradiction record.

Every accepted contradiction record must identify its package-owned type, the ordered participating memory or policy identifiers, the finding or declaration that established it, and the package rule that resolves or escalates it. The public trace may project source-safe identifiers and resolution codes but must not expose restricted content or private evaluator text.

An unresolved contradiction that package policy marks as terminal must prevent answer admission. Spectrum must choose clarification, rejection, or package-authorized escalation according to the admitted response and constraint contracts; it must not ask the model to invent a balancing rule.

### Deterministic adjudication order

Spectrum must apply the following logical order. An implementation may avoid work after a terminal failure, but it must preserve the same first public failure and terminal outcome:

1. Establish the direct accepted package capability and exact package identity.
2. Establish request, proposal, contract, bounds, evaluation time, and repair-capability identity.
3. Establish the accepted governed-memory context and reject incompatible, stale, rights-blocked, or incomplete context where policy requires completeness.
4. Validate normalized finding batches and apply definition-local fail-closed substitutions under RFC 004.
5. Resolve structural policy conflicts, package-authorized escalation, and the effective constraint action.
6. Establish the trusted request mode and any package-declared governed gap.
7. Select one behavior candidate through RFC 008 when the response mode permits model-generated answering.
8. Validate visible answer structure, identifier-only support, claim findings, and synthesis coverage under RFC 007 and RFC 009.
9. Resolve candidate-correctable failure into the single RFC 009 repair branch, or choose the terminal response variant and reason.
10. Freeze the terminal selected and discarded memory sets.
11. Construct and validate RFC 002 Content DNA for an admitted answer or the permitted no-answer representation for another governed terminal outcome.
12. Atomically return the Spectrum decision and, where requested, project RFC 006 receipts and a bounded explanatory trace.

The exact public reason precedence within specialized stages remains owned by the corresponding RFC. Spectrum must not replace those reasons with a generic provider error or whichever failure happened to be encountered first in an implementation loop.

### Decision contract

A completed Spectrum operation must return one trusted decision with the following conceptual fields. RFC 009 and RFC 002 own the exact nested response and Content DNA schemas; this RFC owns their atomic relationship and authority.

| Field | Requirement |
| --- | --- |
| Spectrum contract version | Exact supported version with no implicit negotiation |
| Decision identifier | Deterministic identifier derived from the canonical public decision projection |
| Package identity | Exact trusted package, domain, revision, and artifact identity when safely established |
| Request and proposal identity | Exact trusted identifiers when safely established under the response lifecycle |
| Evaluation time | Exact admitted caller-supplied value when applicable |
| Policy identity | Exact admitted constraint plan and response-policy revisions that governed the decision |
| Memory partition | Ordered selected and discarded memory identifiers for an admitted answer; no false selected-memory claim for a non-answer |
| Contradictions | Bounded typed source-safe contradiction projections in deterministic order |
| Applied policy | Ordered evaluated, substituted, skipped, conflicting, and primary policy identifiers |
| Behavior | Exact selected behavior identity when selection succeeded, without candidate prose or provider scores |
| Terminal response | Exact RFC 009 terminal variant, public reason, and permitted response values |
| Content DNA | Exact RFC 002 admitted-answer or permitted no-answer value when the corresponding identity can safely be established |

The decision identifier must not be used as a capability. It provides deterministic public identity only. The direct return may carry an opaque selected-response, pending-repair, or terminal capability as required by the owning RFC, and no public constructor or deserializer may recreate those capabilities.

### Terminal outcomes

Spectrum contract 0.1 imports the exact seven RFC 009 terminal variants for original, repair-requested, clarification, rejection, repaired admission, post-repair clarification, and post-repair rejection. It must not introduce aliases or collapse original and repaired outcomes merely because they share a higher-level action.

Only the admitted-original and admitted-repaired variants may carry model-generated visible answer units, admitted support, a non-empty selected-memory set, and admitted-answer Content DNA. A repair-requested variant carries only the bounded repair request and direct pending-repair capability. Clarification variants carry only exact package-authored clarification content and the permitted no-answer provenance representation. Rejected variants carry no model answer, support, or selected-memory provenance.

A future response contract may add a package-authored refusal variant. It must define its user-visible source, policy conditions, receipt mapping, and zero-entry Content DNA semantics explicitly; Spectrum must not treat rejection or clarification as an undocumented refusal alias.

### Content DNA integration

Spectrum must construct RFC 002 Content DNA only after terminal response selection and selected-memory freeze. The admitted answer and Content DNA must be one atomic trusted return: an implementation must not expose the answer first and attempt provenance construction afterward.

For an admitted answer, RFC 002 validation must prove exact set equality and order consistency between Spectrum selected memory and the Content DNA entries. A missing entry, additional entry, duplicate, reordered identity where order is meaningful, source-provenance mismatch, review or rights failure, package mismatch, policy mismatch, proposal mismatch, answer-digest mismatch, or decision-digest mismatch changes the outcome from admission to the owning fail-closed terminal result.

Spectrum must never accept Content DNA supplied by the model, provider, caller, package-authoring tooling, or package. The package supplies reviewed provenance facts; Spectrum supplies the final selection; Hees.ai constructs the answer-specific projection.

### Trace contract

Spectrum may return a bounded serializable trace for debugging, explanation, acceptance testing, and operator review. The trace may include source-safe decision identity, trusted package and proposal identity, selected and discarded logical memory identifiers, contradiction codes, evaluated and substituted policy identifiers, behavior identity, terminal variant, public reason, and Content DNA identity.

The trace must not include raw source content, complete memory text, model hidden state, chain-of-thought, free-form verifier rationale, provider payloads, unbounded diagnostics, private deliberation, repair capability bytes, or values that let a caller reconstruct an opaque authority capability.

The trace is non-authoritative even when its schema and digest verify. A caller may compare or retain it but may not submit it to another Hees.ai operation as proof that the original in-process decision occurred. RFC 006 receipts own external integrity projections; a future attestation RFC may add producer authenticity without changing Spectrum's single terminal authority.

### Bounds and resource behavior

Spectrum must impose absolute contract ceilings on admitted memory count, finding count, contradiction count, policy identifiers, trace bytes, and retained intermediate state. Package-declared bounds may narrow but never raise those ceilings. Every collection bound must be checked before proportional allocation, and aggregate byte arithmetic must use checked exact integers.

The final numeric ceilings remain Draft measurement gates. Representative constrained-device measurements must cover a maximum permitted admitted-memory context, complete finding batches, one original response, one repair branch, Content DNA construction, receipt projection, and trace suppression. A conforming low-memory implementation may stream or fuse internal stages only when it preserves the same atomic terminal behavior and never emits a partially authoritative result.

### Determinism and privacy

Given identical admitted package data, governed request values, evaluation time, provider-normalized results, and response candidates, conforming implementations must produce the same validation stage, substitutions, conflict representation, selected and discarded memory order, behavior identity, terminal variant, public reason, Content DNA, and decision identifier.

Spectrum must not read a wall clock, use model identity as a tiebreaker, depend on hash-map or object-property order, normalize Unicode or whitespace outside an owning contract, compare provider floating-point values without a fixed admitted representation, or include local environment state in a decision.

Public decision and trace projections must apply source-safe provenance and package redaction policy. Restricted memory text, internal policy parameters, provider diagnostics, user secrets, and raw request content must remain outside exportable artifacts unless a dedicated accepted contract explicitly governs them.

## Design details

### Relationship to other RFCs

#### Relationship to RFC 000

RFC 000 owns the constitutional authority model. This RFC specifies the Spectrum operation that realizes its single terminal boundary. A change that lets another component decide the terminal response is incompatible with both contracts.

#### Relationship to RFC 002

RFC 002 owns Content DNA schema, canonical identity, exact entry validation, no-answer form, and export-safe projection. Spectrum owns the terminal selected-memory set and the atomic decision point from which Content DNA must be constructed.

#### Relationship to RFC 003

RFC 003 owns retrieval-result validation and materialized package-owned context. Spectrum consumes only its accepted direct result, then establishes the final selected and discarded partition without reinterpreting provider relevance as authority.

#### Relationship to RFC 004

RFC 004 owns plan order, typed findings, substitutions, conflict representation, primary constraint, and effective action. Spectrum imports its direct authoritative adjudication result as policy input and composes it with response state; it does not let an individual finding decide the terminal response.

#### Relationship to RFC 005

RFC 005 owns canonical package bytes, artifact identity, member topology, sequencing, and atomic package admission. Spectrum requires the direct accepted package capability and never reconstructs package authority from identities copied into later values.

#### Relationship to RFC 006

RFC 006 owns canonical export-safe receipt bodies, envelopes, identifiers, and public integrity verification. Spectrum owns the governing terminal operation and private source records from which receipts are projected. A verified receipt cannot be submitted as a Spectrum capability.

#### Relationship to RFC 007

RFC 007 owns verifier requests, observations, classification, and projection into a non-authoritative RFC 004 finding. Spectrum consumes only the validated classification path and cannot treat provider score or verifier success as unrestricted truth.

#### Relationship to RFC 008

RFC 008 owns behavior-envelope admission, candidate eligibility, deterministic selection, and the direct selected-candidate capability. Spectrum uses that capability as one governed stage; behavior selection cannot admit the visible response by itself.

#### Relationship to RFC 009

RFC 009 owns visible answer units, support, synthesis coverage, clarification, repair, exact terminal variants, and public response reasons. Spectrum makes that lifecycle terminal by composing its trusted result with all other admitted governance state and Content DNA.

### Acceptance obligations

- Shared fixtures must cover admitted original and repaired answers, repair request, package-authored clarification, rejection, insufficient governed memory, rights-blocked memory, verifier unavailability, policy substitution, structural conflict, semantic contradiction, behavior tie, and package-authorized escalation.
- Every admitted-answer fixture must prove exact selected/discarded partitioning and exact Content DNA equality with the selected-memory set.
- Cross-implementation fixtures must remain invariant under provider substitution, candidate input permutation where the owning contract declares order irrelevant, map iteration differences, and equivalent internal stage fusion.
- Authority-negative fixtures must reject caller-created accepted-package identities, selected-memory lists, terminal variants, traces, receipts, Content DNA, and copied opaque capability fields.
- Privacy fixtures must prove that raw memory, hidden reasoning, provider payloads, repair capabilities, and private package details do not enter public decision or trace projections.
- Constrained-device measurements must justify final collection and byte ceilings before this RFC advances to Planned.

## Alternatives considered

### Let the constraint adjudicator be terminal

Rejected because constraint actions do not own visible response structure, repair state, behavior selection, exact support, or Content DNA. Treating RFC 004 as terminal would either duplicate those contracts or make the response caller authoritative.

### Let the response lifecycle be terminal without Spectrum

Rejected because response validation alone does not own the final selected-memory set, all package policy, contradiction handling, or the general single-authority invariant. Spectrum composes the specialized response result rather than replacing it.

### Let an orchestrator or package-authoring system compose the final result

Rejected because external composition could vary by deployment and would let a control plane construct authority from serializable parts. Build-time tooling owns package authoring; Hees.ai owns runtime finality.

### Treat the public trace as the decision capability

Rejected because serializable authority can be copied, reconstructed, replayed, or modified outside the direct trusted operation. The trace is explanation only.

### Let the verifier select supported memory

Rejected because a verifier observes exact target-premise relations under package policy. It cannot add or remove memory, resolve all policy, or decide the terminal outcome.

## Drawbacks

Spectrum introduces an explicit composition contract across otherwise focused RFCs. Implementations must preserve opaque capabilities or equivalent unforgeable internal state, maintain exact identity across stages, and test whole-operation failure precedence. Exact selected/discarded partitioning can retain more identifiers than a minimal response validator would need. Atomic Content DNA construction adds work to the terminal path and can convert an otherwise valid candidate into a fail-closed non-admission.

Those costs are deliberate. Without one terminal composition contract, authority would migrate into provider adapters or application orchestration and independent implementations could disagree about what made an answer admissible.

## Layers affected

- **Public contract:** Spectrum adjudication context, terminal decision, selected/discarded memory semantics, contradiction projection, policy projection, and trace boundary.
- **Runtime:** Single terminal composition point and opaque capability flow across package, memory, constraints, behavior, response, and Content DNA.
- **Packages:** Exact policy and contradiction declarations needed by Spectrum, without package-authored terminal results.
- **Receipts:** Private atomic projection from the Spectrum terminal source record through RFC 006.
- **Package-authoring system:** Package compilation and acceptance fixtures only; no precomputed Spectrum result.
- **Testing:** Cross-contract deterministic, authority-negative, privacy, interoperability, and constrained-device evidence.

## Design Decisions

- Spectrum is the sole terminal Hees.ai adjudication boundary.
- Spectrum consumes direct trusted values rather than reconstructing authority from public records.
- Selected memory is an exact ordered terminal subset of admitted context and is distinct from examined or cited memory.
- Selected and discarded memory partition the admitted context for an admitted answer.
- Findings remain non-authoritative until package policy is applied through the RFC 004 model.
- RFC 009 owns exact response variants; Spectrum composes them rather than defining a competing terminal enum.
- Every admitted answer is returned atomically with valid RFC 002 Content DNA.
- Spectrum traces are bounded and non-authoritative.

## Unresolved questions

- Which bounded typed semantic-contradiction declaration belongs in the initial package contract, and should it be a dedicated RFC 005 member or part of an existing governed-memory declaration?
- What exact decision-identifier canonical projection avoids duplicating RFC 006 receipt identity while remaining stable for traces?
- Which private selected/discarded reason codes are needed for acceptance evidence without becoming a public policy-leakage surface?
- What final memory, finding, contradiction, trace, and retained-state ceilings do representative consumer-phone measurements justify?

<!-- Rename this section to "Design Decisions" once all questions have been resolved.
     An RFC cannot move from Draft to Planned until no unresolved questions remain. -->
