# RFC 007: Governed Visible Response Lifecycle

- **Status:** Draft
- **Created:** 2026-07-17
- **Author(s):** Encero Systems
- **Related:**
    - RFC 001 (Governed memory and retrieval results)
    - RFC 002 (Composable governance constraints)
    - RFC 003 (Canonical package artifact admission)
    - RFC 004 (Export-safe governance receipts)
    - RFC 005 (Evidence-Grounded Claim Verification Findings)
    - RFC 006 (Governed behavior envelopes)
- **Issue:** https://github.com/encero-systems/hees.ai/issues/9
- **RFC PR:** —
- **Written against:** Hees 0.0.1 / Incan 0.4.0
- **Shipped in:** —

## Summary

Hees should govern one logical proposal lifecycle in which ordered visible answer units are the sole model-generated user-visible channel, support contains identifiers only, claim-verification and synthesis-coverage findings remain non-authoritative inputs, clarification text comes only from the admitted package, and an original candidate may receive at most one bounded repair before a closed terminal outcome. The trusted result must preserve exact proposal and package identity wherever each has been safely established, carry one of seven terminal variants and one globally unique public reason, and supply the exact admitted support projection required by RFC 004.

## Core model

1. **One visible model channel.** A model may contribute only the ordered text of visible answer units. Support mappings, traces, findings, repair requests, and receipts must not contain substitute answer prose.
2. **Runtime-owned response mode.** A trusted response context determines whether the operation may answer, must clarify, or must reject. A candidate cannot declare itself answerable or turn an evidence gap into advice.
3. **Package-authored clarification.** Clarification selects one reviewed prompt committed by the admitted response contract. A model cannot generate clarification or uncertainty text.
4. **Non-authoritative verification.** RFC 005 findings and RFC 007 synthesis-coverage findings are bound to exact candidate values, but Hees and RFC 002 policy retain all terminal authority.
5. **One repair branch.** The original operation may return one opaque pending-repair capability. A repair operation can terminate but can never issue another repair capability.
6. **Exact terminal projection.** Seven terminal variants, terminal-specific reasons, trusted package identity, logical proposal identity, and typed admitted support give RFC 004 one unambiguous source contract.

## Motivation

A structurally valid response can still fail its user. A nonempty answer may contain only a generic introduction while useful synthesis appears in hidden support records. A free-form uncertainty field can add uncited factual, medical, political, or advisory content even when the nominal answer is empty. A support record that repeats or improves the answer becomes a second response channel that applications may accidentally display or trust.

Hees 0.0.1 does not prevent those failures. Its proposal contract contains one visible string and evidence identifiers, while its result does not carry the visible value, complete package artifact identity, logical proposal identity, repair state, clarification state, verifier binding, or a receipt-ready terminal variant. It checks only that visible output is nonempty and that cited evidence belongs to the package.

Constrained generation and one repair attempt are useful provider techniques, but prompt instructions and grammar alone cannot own governance. The runtime needs a provider-neutral contract that preserves useful synthesis, admits only exact support references, binds findings to the candidate actually evaluated, and closes after one failed repair. That contract must not make a verifier, package authoring tool, provider, application, or receipt consumer a second terminal authority.

## Goals

- Define a canonical package-owned response contract committed by RFC 003 artifact identity.
- Define the logical proposal identity and exact untrusted package-reference check.
- Define ordered visible answer units as the sole model-generated user-visible response content.
- Define identifier-only support mappings whose claim text is derived from visible units rather than supplied separately.
- Define runtime-selected synthesis requirements and deterministic structural completeness checks.
- Compose RFC 005 claim-verification findings without exposing provider scores as authority.
- Define non-authoritative synthesis-coverage findings owned by this response contract.
- Define package-authored clarification that cannot carry model text or support.
- Define an opaque one-repair capability, bounded repair request, and fail-closed second-attempt behavior.
- Define exactly seven terminal variants, terminal-specific reason families, and fixed precedence.
- Define exact package/proposal identity presence and admitted support mapping for RFC 004 proposal receipts.
- Preserve deterministic outcomes across providers that submit the same governed values.

## Non-Goals

- Generating, improving, translating, or summarizing an answer inside Hees.
- Choosing a model, verifier, prompt, grammar, tokenizer, sampling policy, or provider.
- Performing retrieval, selecting memory, segmenting raw documents, or evaluating raw source material.
- Letting support mappings, uncertainty, citations, traces, receipts, or verifier rationale substitute for visible answer text.
- Exposing hidden reasoning, chain-of-thought, model logs, provider payloads, or free-form diagnostics.
- Defining application layout, speech synthesis, text-to-speech markup, or source-panel behavior.
- Authoring clarification prompts or synthesis requirements inside Hees; the admitted package owns those declarations.
- Defining durable repair sessions, global replay prevention, receipt chains, signatures, or external authenticity.
- Exporting visible answers, clarification prompts, verifier data, repair state, or candidate digests in RFC 004 receipts.
- Replacing RFC 006 behavior selection or RFC 005 claim verification.

## Guide-level explanation

An admitted package may contain a response contract beside its behavior envelope. The response contract declares bounded synthesis requirements, reviewed clarification prompts, lower response limits, and a closed failure-policy mapping. RFC 003 commits those declarations to the package artifact digest.

Before visible-answer generation, Hees derives a trusted request frame from the accepted package, governed memory, applicable constraints, and the caller's governed request state. In `answer` mode, RFC 006 first selects among bounded behavior candidates without reading answer text. Hees then binds the selected behavior and its active synthesis requirements into the trusted response context. The provider supplies exactly one bounded response candidate linked to that selected behavior. The response candidate contains ordered visible answer units and identifier-only support mappings. Every unit is displayed in its declared order and no support text exists for an application to substitute.

Hees normalizes each support mapping into a claim whose text is exactly the referenced visible unit text. RFC 005 binds its checks to the exact normalized candidate digest, checks visible units against the complete ordered selected-memory union, and checks each derived support claim against exactly its one cited governed-memory atom. The provider returns scores only for expected check identifiers; Hees classifies them under admitted policy and RFC 002 retains terminal authority.

The response contract also selects the synthesis dimensions required for the chosen behavior. Candidate metadata maps those requirement identifiers to visible units, and a bounded non-authoritative synthesis-coverage finding evaluates whether the mapped visible text actually covers each required dimension. The mapping cannot pass merely because an identifier was asserted.

If the original candidate has a candidate-correctable failure, Hees may return a bounded repair request plus an opaque pending-repair capability. The repair request contains codes and target identifiers only. The provider may submit one replacement attempt. That operation either admits, clarifies, or rejects; it can never request another repair.

In `clarify` mode, Hees does not admit model-generated answer or uncertainty text. It selects an exact package-authored clarification prompt whose declared gap reasons match the trusted context. In `reject` mode, Hees returns no visible answer or clarification prompt. Receipts remain redacted outcome projections rather than response channels.

## Reference-level explanation

### Contract ownership and package binding

The response contract must be a closed canonical `response_contract` member admitted as part of the same RFC 003 package artifact as the RFC 006 behavior envelope it references. A response contract without a behavior envelope must fail cross-member package admission. A runtime-supplied response contract, mutable sidecar, provider template, or caller-created copy must not carry authority.

The response member must inherit the complete trusted package identity after atomic RFC 003 completion:

- `package_id`;
- `domain_id`;
- `package_revision`; and
- `artifact_digest`.

The payload must not repeat that identity. RFC 003 artifact contract `0.1` commits the response member and its order to the artifact digest while the coupled RFCs remain Draft; another member or wrapper change after acceptance requires a new exact artifact-contract version.

### Closed response-contract payload

The `response_contract` member must use member contract `0.1` and the RFC 003 common member fields. Its payload must contain exactly:

- `response_contract_id`, one canonical package-scoped identifier;
- `response_revision`, one canonical revision;
- `max_answer_units`, one positive package limit no greater than the contract ceiling;
- `max_requirement_ids_per_unit`, one positive package limit no greater than the contract ceiling;
- `max_support_ids_per_claim`, one positive package limit no greater than the contract ceiling;
- `synthesis_requirements`, one bounded non-empty ordered array;
- `clarifications`, one bounded ordered array; and
- `failure_policy`, one bounded non-empty ordered array.

Each synthesis requirement must contain exactly:

- `id`;
- `description`;
- `strategy_ids`; and
- `action_ids`.

Requirement identifiers must be unique and canonical. The description must be bounded, nonempty reviewed package text used only to form a synthesis-coverage target; it must never be displayed, copied into an answer, exported in a receipt, or treated as pre-rendered answer wording. Every strategy identifier must resolve in the same package's RFC 006 behavior envelope, and every action identifier must resolve in the RFC 003 actions member. Both applicability arrays must be non-empty and duplicate-free.

A requirement is active for a selected behavior candidate only when its strategy array contains the selected strategy and its action array contains at least one selected action. The active requirement order is declaration order. The direct Hees operation that computes this list must return a trusted response expectation; a candidate-supplied requirement list cannot replace it.

Each clarification must contain exactly:

- `id`;
- `gap_reason_ids`; and
- `visible_prompt`.

Clarification identifiers must be unique and canonical. The gap-reason array must be non-empty, duplicate-free, and contain only stable public memory, constraint, or response-context reasons recognized by this contract. The visible prompt must be bounded, nonempty reviewed package text. It is the only clarification text Hees may return. It may ask for missing context or identify the governed category of a gap, but it must not introduce factual assertions, advice, recommendations, interpolation slots, model text, source excerpts, support mappings, hidden rationale, or arbitrary metadata.

Each failure-policy rule must contain exactly:

- `violation_class`; and
- `original_action`.

The package-configurable violation classes are exactly `visible_structure`, `support`, `findings`, `synthesis`, `context_gap`, and `evidence_gap`. Each class must appear exactly once. The action values are exactly `repair`, `clarify`, and `reject`, subject to these restrictions:

- `visible_structure`, `support`, `findings`, and `synthesis` may map to `repair` or `reject`;
- `context_gap` and `evidence_gap` may map to `clarify` or `reject`;
- a non-selected RFC 006 result, identity failure, contract failure, bounds failure, malformed or unavailable provider result, and invalid repair state are fixed Hees rejections and are not package-configurable; and
- a repair attempt must reinterpret an original `repair` mapping as `reject`, because no second repair is permitted.

The response-contract `record_count` must equal the sum of synthesis requirements, clarification definitions, and failure-policy rules. Requirement applicability arrays and clarification gap-reason arrays must have independent final collection ceilings.

### Trusted response context

The governing operation must receive a direct RFC 006 selection result and a trusted response context bound to the same accepted package identity. In `answer` mode, the selection result must be `selected` and the operation must hold its direct opaque selected-candidate capability. A non-selected result can produce only the fixed original behavior rejection and must not enter response-candidate evaluation. The context must contain:

- response mode, exactly `answer`, `clarify`, or `reject`;
- the ordered active synthesis requirement identifiers;
- the ordered selected RFC 001 governed-memory identifiers;
- the ordered selected evidence identifiers, if any;
- the applicable stable gap-reason identifiers; and
- the direct applicable RFC 002 adjudication result or equivalent trusted action narrowing.

A caller must not construct a trusted response context from strings, package files, traces, parsed receipts, provider output, or verifier findings. Response mode, active requirements, selected support unions, and gap reasons are runtime-owned values. A model-supplied `answerable`, `uncertainty`, refusal, or clarification field must not override them.

In `clarify` mode, Hees must select the first clarification in package declaration order whose gap-reason set contains every applicable trusted gap reason. If no such definition exists, the operation must reject with the corresponding context or evidence reason. In `reject` mode, the operation must not evaluate candidate answer content for admission. In both modes, candidate-supplied visible answer or support is forbidden and must never be returned.

### Logical proposal and package-reference identity

Every original proposal input must contain one logical `proposal_id`, `attempt_index` exactly `0`, and one claimed package reference. `proposal_id` must use the RFC 003 canonical package-identifier grammar and its final response field byte ceiling. It identifies one logical response lifecycle only; it does not prove global uniqueness, external origin, or session authenticity.

The proposal identifier must be supplied independently from candidate output. It must never be computed from visible text, support, findings, hidden reasoning, provider payload, the complete request, or a candidate digest. A valid identifier becomes trusted only after Hees validates its exact syntax and binds it to the current governing operation.

The claimed package reference must contain exactly:

- `package_id`;
- `domain_id`;
- `package_revision`; and
- `artifact_digest`.

Hees must compare the complete tuple with the trusted accepted package identity before behavior or response admission. It must not accept a partial tuple, package identifier alone, unprefixed artifact fingerprint, inferred revision, or caller-supplied fallback. A mismatch must reject while preserving only the trusted evaluated package identity in the terminal result.

The attempt index is a bounded lifecycle discriminator, not proposal identity or a repair counter that callers may advance freely. The original operation accepts only `0`. A pending-repair capability fixes the expected replacement index to `1`, and the repair candidate must carry exactly `1`. Any other original value, repair value, missing value, or mismatch with the opaque capability must fail closed. No operation accepts an index greater than `1`.

### Selected response candidate and visible answer units

After proposal identity and package-reference validation, an original answer-mode proposal with a selected RFC 006 result must carry exactly one bounded response candidate corresponding to that selection. RFC 006 has already evaluated the separate behavior-candidate value and has not inspected this response content. The response candidate must contain exactly:

- `candidate_id`;
- `visible_answer_units`; and
- `support_mappings`.

The candidate identifier must exactly equal the selected candidate identifier bound into the direct RFC 006 capability. It is linkage to the selected behavior value, not an answer score or a tiebreaker. An absent response candidate, an additional response candidate, or a mismatched identifier is a closed-schema or behavior-linkage failure; Hees must not choose response content independently from RFC 006.

The visible-answer-unit array must be non-empty and must not exceed either the final contract ceiling or the package's lower `max_answer_units` limit.

Each visible answer unit must contain exactly:

- `unit_id`;
- `text`; and
- `requirement_ids`.

Unit identifiers must be canonical, unique within the candidate, and stable for the exact candidate value. Text must be bounded and contain at least one non-whitespace Unicode scalar value. Each unit is the provider-declared verification granule. The ordered unit array is the complete model-generated user-visible answer. Applications may render formatting around units, but they must display every admitted unit's exact text in order and must not replace or augment it with support, findings, traces, repair codes, or receipt fields. Contract `0.1` does not infer sentence boundaries; the final multilingual acceptance rule for ensuring that a unit is sufficiently claim-focused remains a Draft gate.

Requirement identifiers must be duplicate-free, resolve in the trusted active requirement set, and remain within the package and global per-unit ceilings. Every active synthesis requirement must appear in at least one visible unit. A requirement identifier that appears only in support, trace, provider rationale, or hidden data does not count.

The candidate must not contain a second answer string, support claim text, uncertainty, answerability, free-form refusal, model-generated clarification, provider rationale, hidden reasoning, terminal action, or arbitrary metadata. Unknown fields must fail closed.

### Identifier-only support and derived claims

Each support mapping must contain exactly:

- `support_claim_id`;
- `unit_id`;
- `evidence_ids`; and
- `memory_ids`.

Support-claim identifiers must be canonical and unique within the candidate. Each `unit_id` must resolve exactly once in the visible answer. Evidence arrays must be ordered, duplicate-free, and contain only identifiers from the trusted selected evidence union. `memory_ids` must contain exactly one identifier from the trusted selected memory union; the typed array shape is retained for receipt-projection consistency, but contract `0.1` does not admit zero or multiple memory identifiers in one support mapping. The combined number of evidence and memory identifiers in one mapping must not exceed either the final contract ceiling or the package's lower `max_support_ids_per_claim` limit. Evidence identifiers may accompany the memory support but cannot replace it.

Support mappings contain no text. For RFC 005 normalization, Hees must derive one atomic support claim whose identifier is `support_claim_id`, whose claim text is exactly the referenced visible unit text, and whose typed references are exactly the mapping's admitted identifiers. The derived text must not be independently editable, summarized, expanded, translated, or supplied by the provider. This preserves RFC 005's atomic support-claim input without creating an alternate answer channel.

Every visible answer unit must have at least one support mapping. Multiple mappings may reference one unit only when their support-claim identifiers and typed reference sets are distinct. The same evidence or memory identifier may support multiple visible units; duplicate prohibition is local to one mapping, not global across the answer.

### Candidate digest and RFC 005 findings

Hees must normalize the selected response candidate under this exact contract, including its RFC 006 candidate linkage, the admitted proposal identifier, and the exact attempt index, and supply that normalized value to RFC 005. RFC 005 owns the canonical candidate digest used to bind verifier checks and provider results. The candidate digest is content identity for verification only; it is not `proposal_id`, package identity, receipt identity, producer authenticity, or terminal authority.

RFC 005 must check visible-answer units first, in visible unit order, against the complete ordered selected RFC 001 memory union. It must then check derived support claims in support-mapping order against exactly their one cited governed-memory atom. Provider output may contain only expected check identifiers and bounded support, contradiction, and unresolved basis-point scores. It must not return text, action, rationale, references, proposal identity, or a receipt.

RFC 007 must consume only the direct RFC 005 normalized finding result and its ordinary non-authoritative RFC 002 constraint finding. It must not consume raw provider scores as terminal authority. Complete expected check coverage is required. A malformed provider result yields no verifier constraint finding and must follow RFC 002 fail-closed substitution. An unavailable provider returns zero findings and must take the fixed rejection path unless an independently established trusted context or evidence gap already requires package-authored clarification; it must never pretend verification succeeded.

Every visible unit and derived support claim must classify as `supported` under the admitted RFC 005 policy before answer admission. `contradicted`, `unsupported`, `uncertain`, missing, duplicated, unexpected, malformed, or unavailable checks are findings violations. The response policy may request one repair for candidate-correctable finding violations on the original attempt; malformed or unavailable provider execution is not candidate-correctable and must reject or use an independently established governed clarification gap.

### Synthesis completeness and coverage findings

Structural presence of requirement identifiers is necessary but not sufficient. For each active synthesis requirement, RFC 007 must construct one coverage target containing the requirement identifier, its admitted package description, and the exact ordered visible-unit identifiers that claim coverage. A coverage provider may evaluate that target, but its result remains non-authoritative.

Each synthesis-coverage result must contain only:

- a check identifier derived from proposal, candidate, requirement, and unit identity under the accepted canonical profile;
- status, exactly `covered`, `not_covered`, `uncertain`, or `unavailable`; and
- bounded provider and configuration fingerprints.

It must not contain answer text, replacement wording, rationale, terminal action, confidence presented as authority, support references, or receipt data. Hees must require exactly one result for every active requirement, reject missing, duplicate, or unexpected targets, and apply the admitted failure policy. Only `covered` satisfies synthesis completeness. The terminal decision remains Hees-owned and must compose this result through the same RFC 002 non-authoritative finding boundary as RFC 005.

Coverage targets and results must bind to the same package identity, proposal identity, candidate identity, candidate digest, and visible unit identities as the RFC 005 batch. A result for another attempt, package, candidate, digest, requirement, or unit set must fail closed.

### One bounded repair capability

The original governing operation may return `repair_requested_original` only when the selected failure-policy action is `repair` and all fixed identity, contract, bounds, provider-integrity, and repair-state checks have passed. It must atomically return:

- the terminal original result;
- one bounded repair request; and
- one opaque `PendingRepair` capability.

The repair request may contain only ordered stable violation codes and their canonical proposal, candidate, unit, support-claim, requirement, or check identifiers. It must not contain answer text, support text, evidence or memory content, clarification text, provider rationale, parser text, hidden reasoning, arbitrary field values, or a rewritten candidate.

The opaque capability must be privately constructed and bound to the trusted package identity, admitted proposal identifier, expected attempt index `1`, original selected-candidate identity, original candidate digest, response-contract identity, and ordered repair-target codes. It must retain no raw model output, source text, evidence text, memory text, provider payload, or hidden reasoning. There must be no public constructor or deserializer that upgrades caller data into this capability.

The repair operation must accept the direct capability, repair input attempt index `1`, exactly one replacement response candidate, and its exact finding inputs. The replacement candidate identifier must equal the RFC 006 candidate identifier bound into the capability. Proposal identity, package identity, and selected behavior come from the capability; a caller must not replace them, and the repair operation must not rerun RFC 006 or select another behavior candidate. The operation may return `admitted_repaired`, `clarification_required_after_repair`, or `rejected_after_repair`. It must never return another pending-repair capability.

If opaque capabilities can be cloned as ordinary process values, each clone is an independent bounded branch from the same trusted original state. Every branch permits one repair transition and no branch can request a further repair. This contract does not claim global one-time consumption, durable replay prevention, or cross-process uniqueness; those properties require a separately designed session, linear-capability, or authenticated-state contract.

### Package-authored clarification

Clarification is a governed terminal response, not model output. A clarification result must contain exactly the selected clarification identifier and the exact admitted package-authored visible prompt. It must contain no visible answer units, support mappings, evidence or memory identifiers, model uncertainty, provider text, verifier rationale, or repair capability.

The prompt may ask for missing user context or explain the bounded category of an evidence gap only as reviewed package text. The package-authoring and review boundary owns its content. Hees owns deterministic selection from the trusted gap reasons and must not append explanatory or advisory prose.

### Terminal variants

Every completed proposal operation must contain exactly one terminal object with member `variant`. The value must be exactly one of:

- `admitted_original`;
- `repair_requested_original`;
- `clarification_required_original`;
- `rejected_original`;
- `admitted_repaired`;
- `clarification_required_after_repair`; or
- `rejected_after_repair`.

An admitted terminal must carry the exact ordered visible answer units and normalized support mappings. A repair-requested terminal must carry only the bounded repair request and direct opaque capability beside the public result. A clarification terminal must carry only the selected package clarification. A rejected terminal must carry none of those response values.

### Public reasons and precedence

Proposal reasons belong to namespace `proposal_admission_0_1`. Every reason identifier must map to exactly one terminal variant and must not be reused across original, repair, clarification, or rejection paths.

The closed reason allowlist contains exactly 31 globally unique values:

| Terminal variant | Permitted reasons |
| --- | --- |
| `admitted_original` | `admitted_original` |
| `repair_requested_original` | `repair_requested_original_visible_structure`, `repair_requested_original_support`, `repair_requested_original_findings`, `repair_requested_original_synthesis` |
| `clarification_required_original` | `clarification_required_original_context`, `clarification_required_original_evidence` |
| `rejected_original` | `rejected_original_package_unavailable`, `rejected_original_identity`, `rejected_original_contract`, `rejected_original_bounds`, `rejected_original_behavior`, `rejected_original_visible_structure`, `rejected_original_support`, `rejected_original_findings`, `rejected_original_synthesis`, `rejected_original_context`, `rejected_original_evidence` |
| `admitted_repaired` | `admitted_repaired` |
| `clarification_required_after_repair` | `clarification_required_after_repair_context`, `clarification_required_after_repair_evidence` |
| `rejected_after_repair` | `rejected_after_repair_state`, `rejected_after_repair_identity`, `rejected_after_repair_contract`, `rejected_after_repair_bounds`, `rejected_after_repair_visible_structure`, `rejected_after_repair_support`, `rejected_after_repair_findings`, `rejected_after_repair_synthesis`, `rejected_after_repair_context`, `rejected_after_repair_evidence` |

Hees must collect applicable internal violation codes under their owning contracts, classify them into the public reason families above, apply the admitted failure policy where permitted, and choose exactly one public reason by this fixed stage precedence:

1. safe package availability;
2. raw proposal byte ceiling and minimal outer framing;
3. proposal and claimed package identity;
4. contract version and closed schema;
5. remaining semantic bounds;
6. repair-capability validity;
7. trusted response mode and governed gap;
8. RFC 006 behavior selection;
9. visible-answer structure;
10. support mapping;
11. RFC 005 finding integrity and coverage;
12. claim support classification;
13. synthesis-target integrity and coverage;
14. admission.

Within a stage, the exact owning-contract order must apply. RFC 006 behavior selection occurs only on the original path; a valid repair capability fixes that selected behavior, so a repair cannot produce a new behavior-selection failure. Candidate iteration, object property order, hash-map order, parser wording, provider order, score magnitude, wall-clock time, and free-form text must not affect the selected public reason.

### Exact RFC 004 proposal-receipt projection

RFC 007 is the governing source contract for RFC 004 `ProposalAdmission`. RFC 004 continues to own canonical receipt bodies, envelopes, identifiers, atomic private emission, verification, integrity semantics, and the distinction between in-process authority and external authenticity.

This 31-reason allowlist and the identity rules below replace the Hees 0.0.1 proposal baseline used during RFC 004's initial drafting. RFC 004 imports this table and retains no aliases for the older action-only result.

The proposal receipt terminal object must contain exactly `variant` with the same seven-value enum. Its reason namespace must be `proposal_admission_0_1`, and its reason identifier must be copied unchanged from the terminal result.

Package and proposal identity presence is exact:

| Source outcome | Trusted package object | `proposal_id` |
| --- | --- | --- |
| `rejected_original_package_unavailable` before safe package identity | Absent | Absent |
| `rejected_original_bounds` at the raw proposal ceiling before safe proposal identity | Required when an accepted package was supplied | Absent |
| `rejected_original_identity` caused by invalid or missing proposal identity | Required when an accepted package was supplied | Absent |
| Valid proposal identity with a mismatched claimed package reference | Required from the trusted evaluated package | Required |
| Every later original outcome after safe proposal identity | Required | Required |
| Every repair outcome from an authentic pending-repair capability | Required | Required |

The complete package object must contain `package_id`, `domain_id`, `package_revision`, and `artifact_digest` from the RFC 003 accepted package. It must never use the candidate's mismatched claim. A failure before safe package identity must use RFC 004's minimal safe form and expose no input-derived identifier or hash.

Only `admitted_original` and `admitted_repaired` may export support identifiers. For those outcomes, RFC 007 must derive two ordered duplicate-free result arrays by traversing visible answer units in display order, then their support mappings in mapping order, then each mapping's identifier arrays in declared order, appending an identifier only on its first occurrence. The resulting typed evidence array becomes RFC 004 `admitted_evidence_ids`; the resulting typed memory array becomes `admitted_memory_ids`.

Repair-requested, clarification, and rejected outcomes must export empty admitted-evidence and admitted-memory arrays even when some identifiers were structurally valid during evaluation. Proposal receipts must not contain attempt indexes, visible answer units, support mappings, support-claim identifiers, candidate identifiers, candidate digests, requirements, clarification identifiers or prompts, repair codes or capability data, verifier checks or scores, coverage findings, traces, provider fields, or hidden reasoning. The terminal variant already distinguishes the original and repaired paths.

Proposal receipts must omit `evaluation_time_ms`, `constraint_plan`, `constraint_execution`, and `memory_state`. `diagnostic_codes` must remain empty under receipt contract `0.1`. Any future export of these values requires an exact revised source and receipt contract.

### Bounds and allocation

Contract `0.1` must define exact global ceilings for response-member bytes, parser nesting and tokens, proposal and response identifiers, clarification text, requirement descriptions, requirement applicability, failure-policy rules, response-candidate bytes per attempt, visible units, bytes per unit, total visible-answer bytes, requirement identifiers per unit, support mappings, evidence identifiers per mapping, the exact one memory identifier per mapping, unique admitted support identifiers, RFC 005 checks, synthesis-coverage targets and results, repair violation codes, opaque retained repair state, terminal result size, and receipt-source projection.

The package's three lower response limits may narrow but must not raise the global ceilings. Hees must enforce raw input ceilings before parsing and collection ceilings before proportional allocation. Count and byte arithmetic must use the RFC 003 exact-integer domain with checked operations.

This Draft does not promote spike limits into normative production ceilings. It cannot advance to Planned until common JavaScript, Rust, and Incan goldens plus representative civic-shaped fixtures establish the final table, prove exact maximum source-result sizes, and let RFC 004 mechanically derive the largest `ProposalAdmission` body and envelope. Physical RSS, model coexistence, latency, thermal behavior, and battery use remain deployment measurements rather than public admission reasons.

## Design details

### Settled contract decisions

- Ordered visible answer units are the only model-generated user-visible response channel.
- Support mappings contain identifiers only; support-claim text is exactly derived from the referenced visible unit.
- Free-form uncertainty, answerability, model clarification, support rationale, and hidden answer fields are forbidden.
- Response mode and active synthesis requirements come from a trusted Hees context.
- Clarification text is package-authored, package-committed, and selected by stable governed gap reasons.
- RFC 005 candidate digests bind findings but never become logical proposal, package, or receipt identity.
- Claim-verification and synthesis-coverage results remain non-authoritative RFC 002 finding inputs.
- An original lifecycle may issue one opaque repair capability; a repair lifecycle can never issue another.
- The contract makes no unsupported claim of global one-time repair consumption across cloned values or process boundaries.
- Branch-local one-repair enforcement is sufficient for contract `0.1`; durable single-use or cross-process replay prevention remains a separate future contract rather than a hidden prerequisite.
- Proposal identity is a separately validated logical identifier and is never derived from response content; attempt index is exactly `0` for the original and `1` for the repair.
- Untrusted proposal package references use the complete package, domain, revision, and artifact-digest tuple and are compared with trusted RFC 003 identity.
- The seven terminal variants are closed and their reason identifiers are unique across paths.
- Only admitted original or repaired outcomes export evidence and memory identifiers, in first-visible-use order.
- Repair, clarification, and rejection receipts always carry empty admitted support arrays.
- Receipts contain no answer, clarification, support mapping, candidate digest, finding, repair, trace, provider, or hidden-reasoning data.
- The response member joins RFC 003 artifact contract `0.1` before the coupled Draft contract is frozen.

### Relationship to RFC 001

RFC 001 owns selected governed-memory identity, provider state, partial or unavailable semantics, and memory admission. RFC 007 receives only the trusted selected-memory union and typed materialized identifiers. It does not perform retrieval or upgrade a provider nomination into admitted support.

### Relationship to RFC 002

RFC 002 owns constraint evaluation, conflict policy, fail-closed substitution, and terminal governance actions. RFC 005 claim classifications and RFC 007 synthesis-coverage classifications enter as ordinary non-authoritative findings. RFC 007 applies only a trusted direct adjudication result and does not let a finding choose the terminal response.

### Relationship to RFC 003

RFC 003 owns canonical response-member bytes, digest commitment, member order, inherited package identity, and cross-member validation. RFC 007 owns the response payload and its references to RFC 006 strategy identifiers and RFC 003 action identifiers. It does not reference constraint, evidence, or memory identifiers from the package member; those are selected dynamically in the trusted runtime context.

### Relationship to RFC 004

RFC 004 owns the redacted receipt representation and private atomic emission. RFC 007 supplies the exact proposal source result, seven terminal variants, terminal-specific reasons, identity-presence rules, and admitted support order. Neither contract may define a competing receipt encoder or public authoritative receipt constructor.

### Relationship to RFC 005

RFC 005 owns candidate canonicalization for verification, candidate digest, visible-unit and support-claim checks, provider result shape, score classification, availability, completeness, and its non-authoritative RFC 002 finding. RFC 007 owns the visible units, stable unit identifiers, identifier-only support mapping, derived support-claim text, proposal/attempt lifecycle, and terminal use of the trusted finding result. The candidate digest must never replace logical proposal identity.

### Relationship to RFC 006

RFC 006 selects behavior without inspecting answer text and returns the opaque selected-candidate capability. RFC 007 must require that direct capability and must not reconstruct selection from a trace, rerank candidates using findings, or let response content alter the behavior winner. RFC 007 alone owns repair and terminal response action.

### Provider neutrality

Two provider adapters that produce the same normalized proposal, selected response candidate, verifier results, and synthesis-coverage results must receive the same Hees terminal variant, public reason, admitted support arrays, and receipt body. Provider name, model identity, sampling configuration, raw JSON formatting, and prompt wording must not affect authority except where a separately admitted provider or verifier fingerprint is required to bind a finding.

### Stable evolution

Adding a visible response field, support field, terminal variant, reason, failure-policy class, clarification path, finding status, repair transition, or receipt projection changes the exact contract and requires a new response-contract version. Unknown fields, enums, reasons, versions, or receipt members must fail closed rather than being ignored.

## Alternatives considered

### Keep free-form support claims

Rejected because support prose can contain the useful synthesis while the visible answer remains empty or generic. Support is identifiers only; claim text is derived exactly from visible text.

### Keep a free-form uncertainty field

Rejected because uncertainty can introduce unsupported facts or advice and become an alternate answer channel. Governed limitations belong in supported visible units, while clarification comes from the admitted package.

### Let the model declare answerability

Rejected because answerability is a runtime governance decision derived from admitted memory, constraints, authority, and context. A provider cannot override it.

### Let a verifier decide admission directly

Rejected because score calibration and provider availability do not confer authority. Findings remain inputs to RFC 002 and the Hees-owned terminal decision.

### Treat requirement identifiers as sufficient synthesis proof

Rejected because a candidate could attach the right identifier to generic visible prose. Structural mapping must compose with a bound non-authoritative coverage result.

### Return model-generated clarification

Rejected because clarification could smuggle factual or advisory content. Only a reviewed package-authored prompt may be displayed on a clarification path.

### Permit unlimited repairs until a candidate passes

Rejected because repeated generation is unbounded, can fail to converge, and complicates receipt identity. One original branch may issue one repair capability and the repair must terminate.

### Encode repair count as a public integer

Rejected because callers could forge or reset the count. The repair transition requires a direct opaque capability. Durable global replay prevention remains a separate contract.

### Hash visible output to create `proposal_id`

Rejected because logical proposal identity must remain independent from answer content, support, hidden data, and malformed input. RFC 005 may derive a separate candidate digest for finding binding only.

### Export answer or clarification text in the receipt

Rejected because receipts are redacted governance outcomes, not response or audit-log payloads. Text remains in the direct terminal result only.

## Drawbacks

The provider schema becomes more structured and may require adapters to produce stable unit and support-claim identifiers. Requiring support for every visible unit discourages conversational filler and may require applications to render presentation separately. Package-authored clarification trades model flexibility for a stronger authority boundary. One repair can reject candidates that a longer loop might eventually fix. Synthesis coverage introduces another bounded non-authoritative provider task. Exact package topology, numeric ceilings, synthesis-coverage construction, and cross-runtime canonicalization remain Draft gates.

## Layers affected

- **Package contract:** A canonical response member, synthesis requirements, clarification definitions, failure policy, behavior/action references, and inherited package identity.
- **Runtime authority:** Trusted response contexts, proposal/package identity, selected-candidate composition, visible and support normalization, finding application, clarification selection, repair transition, and terminal result.
- **Provider boundary:** Bounded candidate, claim-verification, synthesis-coverage, and one-repair input/output shapes without terminal authority.
- **Receipt source contract:** Seven proposal terminal variants, terminal-specific reasons, exact identity presence, admitted support order, and empty non-admitted support projections.
- **Compatibility:** Closed versions, field schemas, reason precedence, bounds, canonical candidate binding, and common cross-runtime goldens.
- **Documentation:** Explicit separation of visible answer, support, findings, clarification, repair, trace, and receipt channels.

## Unresolved questions

- What exact numeric ceiling table is supported by shared cross-runtime goldens and representative civic-shaped fixtures for response members, candidates, findings, repair state, results, and proposal receipts?
- What exact canonical construction and provider contract should synthesis-coverage checks use while preserving RFC 005's distinct ownership of claim verification?
- What exact multilingual-safe acceptance rule or bounded provider check must establish that each visible unit is a sufficiently claim-focused verification granule before this RFC may claim sentence- or proposition-level coverage?
- Which RFC 001, RFC 002, and response-context gap reasons are safe and sufficient for the first closed package-authored clarification allowlist?

<!-- Rename this section to "Design Decisions" once all questions have been resolved.
     An RFC cannot move from Draft to Planned until no unresolved questions remain. -->
