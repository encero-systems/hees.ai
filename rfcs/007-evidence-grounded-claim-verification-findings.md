# RFC 007: Evidence-Grounded Claim Verification Findings

- **Status:** Draft
- **Created:** 2026-07-17
- **Author(s):** Encero Systems
- **Related:**
    - RFC 000 (Foundational Governance Authority)
    - RFC 001 (Spectrum Terminal Adjudication)
    - RFC 002 (Content DNA Answer-Time Provenance)
    - RFC 003 (Governed Memory and Retrieval Results)
    - RFC 004 (Composable Governance Constraints)
    - RFC 005 (Canonical Package Artifact Admission)
    - RFC 006 (Export-Safe Governance Receipts)
    - RFC 009 (Governed Visible Response Lifecycle)
- **Issue:** https://github.com/encero-systems/hees.ai/issues/8
- **RFC PR:** —
- **Written against:** Hees 0.0.1 / Incan 0.4.0
- **Shipped in:** —

## Summary

Hees should admit bounded verifier observations only when they exactly cover a trusted candidate-derived check manifest and use a package-admitted provider binding, classify those observations through package-owned fixed-point policy, and project the result into one non-authoritative RFC 004 constraint finding. A verification provider may score exact candidate targets against exact admitted governed-memory premises, but it cannot create or select memory, alter visible output, supply policy actions, establish truth, emit an authoritative receipt, or determine the terminal proposal outcome.

## Core model

1. **The visible-answer contract owns the candidate.** RFC 009 owns logical proposal identity, original-versus-repair attempt identity, normalized visible units, atomic support claims derived from those visible units, support references, and the candidate's terminal lifecycle.
2. **The package owns verification authority.** One optional package member declares exact provider bindings, classification thresholds, policy action/reason mappings, and the RFC 004 constraint definition through which verification participates in governance.
3. **Hees owns the check manifest.** Hees derives an ordered bounded list of visible-answer-unit and support-claim checks from one normalized candidate and one accepted RFC 003 memory context. The provider cannot add, remove, reorder, or rewrite a check.
4. **The provider supplies observations only.** A complete result returns one score triple for each check identifier. It contains no target text, memory reference, action, decision, rationale, evidence, or replacement citation.
5. **Hees classifies deterministically.** Hees validates the complete result, derives `Supported`, `Contradicted`, `Unsupported`, or `Uncertain` under package thresholds, applies package mappings, and selects one strongest non-authoritative action/reason pair.
6. **RFC 004 remains the finding-composition authority.** The verification projection is one ordinary `ConstraintFinding`. RFC 004 combines it with deterministic and package-defined constraints and alone chooses the authoritative constraint-adjudication action.
7. **Spectrum remains the terminal authority.** RFC 009 owns the response lifecycle and terminal variant schema, but RFC 001 Spectrum composes verification, constraint, memory, behavior, and response state into the final candidate outcome.

## Motivation

Hees 0.0.1 validates that a visible proposal is non-empty and cites package-owned evidence identifiers, but it deliberately does not establish that cited material supports a generated claim or that every visible answer statement is grounded. A structurally valid candidate can therefore attach a plausible support record to the wrong source, place useful synthesis only in support metadata, or introduce an unsupported mechanism while still satisfying the current identifier checks.

A semantic verifier can detect some of those failures, but treating its label or score as a decision would create a second runtime authority. Provider probabilities are model- and configuration-specific, unavailable providers are normal operational states, malformed results are untrusted input, and an apparently strong support score may still be wrong. Independent integrations also need identical rules for candidate identity, complete coverage, provider binding, score normalization, threshold edges, unavailable behavior, malformed behavior, and policy precedence.

This RFC defines that shared boundary. It preserves the useful signal from an external verifier while requiring package authority, Hees-owned validation, RFC 004 finding composition, RFC 009 response governance, and RFC 001 Spectrum finality around it.

## Goals

- Define one typed non-authoritative verification contract for visible answer units and atomic support claims.
- Bind every request and result to exact admitted package, policy, candidate, attempt, provider, and memory-context identity.
- Add one package-owned `claim_verification` declaration with exact provider fingerprints, model fingerprints, configuration fingerprints, thresholds, and action/reason mappings.
- Require one exact check for every normalized visible answer unit and every normalized atomic support claim.
- Check each support claim against exactly its one cited governed-memory atom and each visible answer unit against the complete ordered admitted-memory context union.
- Prevent a provider from changing visible output, adding memory, replacing citations, selecting policy, supplying actions, or authoring receipts.
- Represent verifier output as three fixed-point relation scores without treating them as calibrated truth or authority.
- Define deterministic classification, aggregation, tie-breaking, and RFC 004 finding projection.
- Distinguish valid provider unavailability from malformed or incomplete results and fail closed in both cases through package-owned Hees policy.
- Define closed public reason stages and precedence without exposing provider text or hidden reasoning.
- Bound provider declarations, candidate targets, checks, text, memory references, findings, and scores for constrained runtimes.
- Require cross-runtime, multilingual-shape, authority-negative, coverage, threshold-edge, and failure fixtures before implementation is considered conforming.

## Non-Goals

- Defining a verifier model, natural-language inference architecture, tokenizer, runtime backend, quantization, prompt, batching strategy, or hardware placement.
- Claiming that verifier scores prove factual truth, source quality, legal rights, human approval, calibration, or universal semantic entailment.
- Defining retrieval, selecting memory, accepting provider-returned source text, or changing RFC 003 memory admission.
- Defining logical proposal identity, visible-unit construction, support-claim construction, repair counters, clarification semantics, or terminal response variants. RFC 009 owns those response-lifecycle concepts, while RFC 001 Spectrum owns terminal finality.
- Defining requested-synthesis completeness. RFC 009 owns that separate response-lifecycle check and may require accepted verification findings while retaining ownership of completeness.
- Segmenting an opaque visible-output string inside this RFC. RFC 009 must supply normalized ordered visible units before this contract can advance to Planned.
- Allowing independent provider-supplied support prose. The normalized atomic support claim must be derived from RFC 009's referenced visible unit.
- Exporting target text, score triples, classifications, provider bindings, model fingerprints, or detailed verifier findings in RFC 006 receipts.
- Persisting free-form rationale, chain-of-thought, provider diagnostics, raw model output, source text, or arbitrary metadata.
- Defining provider selection, fallback order, network transport, process lifecycle, operator review, package authoring, or deployment policy.
- Treating a verifier evaluation, its derived constraint finding, or a successful receipt-integrity check as terminal candidate authority.

## Guide-level explanation

This RFC describes a proposed public contract. Hees 0.0.1 does not implement provider-bound claim verification, candidate check manifests, semantic classifications, or verification-derived constraint findings.

An admitted package may declare one claim-verification policy and one or more exact provider bindings. The policy identifies the RFC 004 constraint through which verification participates in governance, sets separate thresholds for visible answer units and support claims, maps each Hees-derived classification to one package-owned constraint action/reason pair, and defines one fail-closed pair for valid provider unavailability.

RFC 009 supplies one normalized candidate. The candidate has a logical `proposal_id`, Hees-owned `attempt_index`, ordered visible answer units, and ordered atomic support claims derived from those visible units. Each support claim cites exactly one governed-memory atom. Hees creates a closed verification subject, canonicalizes it with the RFC 005 JCS profile, and computes a separate `candidate_digest`. The digest binds exact candidate content and order for verification; it is not the logical proposal identifier and must not appear as a substitute for `proposal_id`.

Hees then creates checks in one exact order. Every visible answer unit comes first in visible order, and support claims follow in support order. Each visible-answer-unit check carries the complete ordered memory identifiers materialized by one accepted RFC 003 context. Each support-claim check carries exactly its one cited memory identifier. Target text is copied from the normalized candidate, never supplied independently by the provider.

The external provider receives the bounded request and resolves the admitted package-owned memory identified by each check. A complete provider result echoes the request, candidate, and binding identifiers and returns only one ordered score triple per check. An unavailable provider returns a typed unavailable state and no observations. There is no partial state.

Hees validates the entire envelope before using any score. It classifies each complete observation under the package's target-kind rule, maps each classification to a package-owned action/reason pair, and selects the strongest pair using RFC 004 action order. It then constructs one ordinary non-authoritative `ConstraintFinding`. RFC 004 combines that finding with the other constraints, including deterministic checks that do not depend on the verifier. A provider result that says every visible unit is supported cannot override a stronger deterministic rejection.

A malformed, incomplete, reordered, duplicated, unknown, or mismatched provider result yields no verification-derived constraint finding. The linked RFC 004 definition is therefore missing and receives its package-declared fail-closed substitute. A structurally valid unavailable result instead maps through the policy's fixed unavailable pair. In neither path does the provider select the action.

## Reference-level explanation

### Authority boundary

RFC 009 must be the sole owner of logical proposal identity, attempt identity, normalized visible units, support-claim identity, support references, visible-answer rendering, repair, clarification, and terminal response variants. RFC 001 Spectrum owns final adjudication through that lifecycle. RFC 007 must consume those values without redefining or mutating them.

RFC 003 must be the sole owner of accepted governed-memory context. Verification may use only an accepted `complete` or `partial` context and only the ordered package-owned atoms materialized by that record. An accepted `unavailable` record, a rejected record, raw retrieval nominations, relevance scores, or caller-supplied memory text must not become verifier premises.

The admitted package must be the sole source of provider authorization, classification thresholds, policy mappings, and the linked RFC 004 constraint definition. A caller or provider must not add a binding, choose a different policy, widen a threshold, invent a reason, or weaken unavailable or malformed behavior.

A verification provider and every provider observation must be non-authoritative. A provider may return scores for exact Hees-created check identifiers. It must not return or alter target text, package identity, policy identity, memory identifiers, visible output, support references, candidate state, policy actions, terminal decisions, receipts, free-form rationale, or arbitrary metadata.

Hees must own request construction, complete-result validation, provider-binding resolution, classification, policy mapping, aggregation, and projection into an RFC 004 `ConstraintFinding`. The resulting finding remains non-authoritative under RFC 004. Only RFC 004 may select the authoritative constraint-adjudication action, and only RFC 001 Spectrum may select the final candidate outcome through the RFC 009 response lifecycle.

### RFC dependency and lifecycle boundary

This RFC depends normatively on RFC 003 accepted memory contexts, RFC 004 finding and adjudication semantics, RFC 005 package admission and JCS, and the RFC 009 normalized candidate contract. RFC 006 remains the exclusive owner of receipt encoding and exports no detailed verifier data under receipt contract `0.1`.

RFC 005 artifact contract `0.1` incorporates `claim_verification` while the coupled RFCs remain Draft. It owns the member kind, order, record count, bounds, cross-member classification, retained indexes, and atomic package identity; this RFC owns the exact payload and verifier-finding semantics. Adding the member after artifact contract `0.1` were accepted would instead require a new artifact contract and is not an implementation-local extension.

RFC 009 must settle visible-unit identity, support-claim identity, the exact derivation of atomic support-claim text from a visible unit, attempt identity, and candidate normalization before this RFC advances to Planned. RFC 007 must not infer sentence boundaries from an opaque string or accept provider-authored support prose as a substitute.

### Serialized `claim_verification` package member

RFC 005 artifact contract `0.1` must add `claim_verification` as an optional singleton member kind. Coordinated with RFC 008 and RFC 009, the complete topology must become:

```text
actions evidence+ (governed_memory_registry governed_memory_atoms+)? constraints? claim_verification? behavior_envelope? response_contract?
```

Presence of `claim_verification` must require both the complete governed-memory group and the `constraints` member. The claim-verification member appears after constraints so its constraint-definition reference is backward-resolvable during RFC 005's branch-safe sequential admission, and before any `behavior_envelope` or `response_contract` member. It must appear at most once. Its `member_contract` must be exactly `0.1`. RFC 005 must separately enforce that `response_contract` requires `behavior_envelope`.

After the four RFC 005 common wrapper fields, the member must contain exactly:

| Key | JSON type | Presence and meaning |
| --- | --- | --- |
| `provider_bindings` | array of provider-binding objects | Required, non-empty, ordered, unique by binding identifier and complete binding tuple, and bounded to 16 entries. |
| `policy` | claim-verification policy object | Required, exactly one closed object. |

The descriptor `record_count` must equal `len(provider_bindings) + 1`. The one policy counts as one semantic record. Its two named target rules and their fixed named mappings do not add records.

The payload must not contain a nested generic payload, package identity, artifact digest, candidate fields, memory atoms, source text, provider executable bytes, transport data, paths, arbitrary metadata, or extension maps. Every object is closed. Every listed field is required, JSON `null` is invalid, and arrays preserve submitted order.

### Provider-binding object

Every provider binding must contain exactly:

| Key | Meaning |
| --- | --- |
| `binding_id` | Canonical package-scoped binding identifier. |
| `provider_id` | Canonical provider identifier. |
| `provider_contract_version` | Exact normalized provider-result contract version. |
| `adapter_version` | Exact adapter version. |
| `provider_fingerprint` | SHA-256 identity of the governed provider execution artifact. |
| `model_fingerprint` | SHA-256 identity of the verifier model artifact. |
| `configuration_fingerprint` | SHA-256 identity of tokenizer, preprocessing, label order, truncation, score normalization, and other governed inference configuration. |

Identifiers must match `[a-z0-9][a-z0-9_-]*`. Versions must match `[0-9]+(\.[0-9]+){1,2}`. `provider_contract_version` must be exactly `0.1`; contract `0.1` defines no provider-result version negotiation. Every fingerprint must be exactly 64 lowercase hexadecimal characters without a prefix. Binding identifiers and complete six-field execution tuples excluding `binding_id` must be unique. Binding order is identity-bearing.

The package declaration establishes exact expected identity, not external authenticity or proof of execution. Hees may compare a binding identifier and materialize its admitted fields, but it must not claim that it independently hashed the provider, model, configuration, tokenizer, executable, or runtime environment.

### Claim-verification policy object

The policy must contain exactly:

| Key | JSON type | Meaning |
| --- | --- | --- |
| `policy_id` | string | Canonical package-scoped verification-policy identifier. |
| `policy_revision` | string | Exact policy revision. |
| `constraint_id` | string | Exact RFC 004 definition through which verification participates in adjudication. |
| `allowed_binding_ids` | array of strings | Required non-empty ordered subset of admitted binding identifiers, bounded to 16 unique entries. |
| `visible_answer_unit_rule` | target-rule object | Required classification and mapping rule for visible answer units. |
| `support_claim_rule` | target-rule object | Required classification and mapping rule for atomic support claims. |
| `unavailable_finding` | action/reason object | Required fixed mapping for every valid unavailable provider state. |

The policy identifier, constraint identifier, binding identifiers, and every package reason identifier must match the canonical identifier grammar and byte bound. `policy_revision` must match the version grammar and byte bound. Every allowed binding must resolve exactly once in the preceding binding array.

The referenced constraint identifier must resolve exactly to one definition in the already admitted RFC 004 constraints member. That definition must use evaluator kind `claim_verification` and evaluator version `0.1`. Every policy action/reason pair must occur exactly in the definition's `allowed_findings`, every policy action must be no stronger than the definition's `maximum_action`, and the definition's `failure_action` must be at least as strong as `unavailable_finding.action` under RFC 004 order. The definition's failure action and reason remain the sole mapping for absent or malformed verifier output.

RFC 005 cross-member validation must retain or resolve the referenced definition's `constraint_id`, `evaluator_kind`, `evaluator_version`, ordered `allowed_findings`, `maximum_action`, `failure_action`, and `failure_reason_id`. Definition order and dependencies remain part of the admitted RFC 004 plan and are used when Hees constructs the eventual constraint finding; they do not alter claim-verification member admission.

### Target-rule and action/reason objects

Each target rule must contain exactly:

| Key | JSON type | Meaning |
| --- | --- | --- |
| `support_min_bps` | integer | Inclusive support threshold. |
| `contradiction_min_bps` | integer | Inclusive contradiction threshold. |
| `unresolved_min_bps` | integer | Inclusive unsupported threshold. |
| `supported_finding` | action/reason object | Mapping for `Supported`. |
| `contradicted_finding` | action/reason object | Mapping for `Contradicted`. |
| `unsupported_finding` | action/reason object | Mapping for `Unsupported`. |
| `uncertain_finding` | action/reason object | Mapping for `Uncertain`. |

Every threshold must be an exact JSON integer in inclusive `5001..10000`. Fractions, exponents, negative values, zero, `null`, or values outside that range are invalid. Requiring a strict majority ensures that no two relation scores can meet their threshold when the score triple sums to `10000`.

Every action/reason object must contain exactly `action` and `reason_id`. The action must use one lowercase RFC 004 serialized action, and the reason must be a canonical package-owned identifier. Every complete action/reason pair in the policy must be unique, and every reason identifier must map to exactly one policy condition.

`supported_finding.action` must be `continue`. `contradicted_finding.action` must be `reject` or `escalate`. `unsupported_finding.action` and `uncertain_finding.action` may be `revise`, `clarify`, `reject`, or `escalate`, but must not be `continue`. `unavailable_finding.action` must be `reject` or `escalate` and applies identically to every recognized unavailable reason so provider-selected reason spelling cannot weaken policy.

### Normalized verification subject and candidate identity

RFC 009 must supply one normalized candidate containing a canonical `proposal_id`, exact `attempt_index`, ordered visible units with stable unit identifiers and text, and ordered atomic support claims with stable claim identifiers, exact text derived from a referenced visible unit, and exactly one governed-memory identifier. RFC 007 must not accept independently provider-supplied support-claim text.

`attempt_index` must be `0` for the original candidate or `1` for the sole repair. It must not be negative, fractional, greater than one, or inferred from call order. RFC 009 owns whether an attempt is currently legal.

Hees must construct a closed verification-subject projection containing exactly these fields and closed nested objects:

```json
{
  "attempt_index": 0,
  "candidate_id": "candidate_001",
  "proposal_id": "proposal_001",
  "support_mappings": [
    {
      "evidence_ids": ["evidence_001"],
      "memory_ids": ["memory_001"],
      "support_claim_id": "claim_001",
      "unit_id": "unit_001"
    }
  ],
  "visible_answer_units": [
    {
      "requirement_ids": ["requirement_001"],
      "text": "The complete visible answer unit.",
      "unit_id": "unit_001"
    }
  ]
}
```

The values above are illustrative, but the field names, nesting, and array order are exact. The projection copies the RFC 009 proposal, attempt, selected candidate, visible-unit, requirement, support-mapping, evidence, and memory values without normalization or omission. Derived support-claim text is not duplicated because it is exactly the referenced visible-unit text. Hees must serialize this projection with the RFC 005 JCS profile and compute `candidate_digest` as `sha256:<64 lowercase hexadecimal characters>` over those exact bytes.

`proposal_id` and `candidate_digest` have different meanings. The proposal identifier is the RFC 009 logical identity and must never be derived from visible output. The candidate digest binds exact normalized verification content and order for request/result replay protection. It must not replace proposal identity, become a receipt identifier, or be presented as proof of semantic correctness.

A finding produced for attempt zero or one candidate digest must not be accepted for another attempt or digest, even when all target identifiers remain the same.

### Target and check identity

The only target kinds in contract `0.1` are `visible_answer_unit` and `support_claim`. The normalized RFC 009 candidate must own each target's stable identifier. Target identifiers must be unique within their typed collection and must not be supplied or rewritten by a verification provider.

Hees must create one check for every normalized visible answer unit, followed by one check for every normalized atomic support claim. Visible-answer-unit checks preserve visible-unit order. Support-claim checks preserve support-claim order. The total ordered check manifest is part of request identity.

Each check must contain exactly:

- `check_id`, a Hees-derived canonical identifier;
- `target_kind`;
- `target_id`, copied from the normalized candidate;
- `hypothesis_text`, copied from the normalized candidate target;
- `premise_memory_ids`, one ordered bounded list; and
- the candidate digest inherited from the containing request rather than repeated inside the check.

Hees must derive check identifiers as `visible_answer_unit_check_<zero-based ordinal>` and `support_claim_check_<zero-based ordinal>` using canonical decimal ordinals without leading zeroes except ordinal zero. The identifiers are stable only within one candidate digest and check manifest; they are not global content identities.

A visible-answer-unit check's `hypothesis_text` must exactly equal its normalized visible-unit text. Its `premise_memory_ids` must exactly equal the complete ordered memory identifier list materialized by the accepted RFC 003 context.

A support-claim check's `hypothesis_text` must exactly equal the normalized claim text derived by RFC 009 from its referenced visible unit. Its `premise_memory_ids` must contain exactly the one governed-memory identifier cited by that claim. That identifier must occur in the accepted RFC 003 context.

Hees must not accept an opaque visible string and infer sentence boundaries under this contract. It must not accept a caller-selected subset of visible units, an independently rewritten claim, a claim with zero or multiple memory references, or a premise list supplied by the provider.

### Verification request

A `VerificationRequest` must be one closed object containing exactly:

- `verification_contract`, exactly `0.1`;
- `request_id`, one canonical bounded caller request identifier;
- `package_id`, `domain_id`, `package_revision`, and `package_fingerprint`, copied from the trusted admitted RFC 005 package identity, with the fingerprint unprefixed;
- `policy_id` and `policy_revision`, copied from the admitted claim-verification policy;
- `binding_id`, one admitted binding selected from `allowed_binding_ids`;
- `proposal_id` and `attempt_index`, copied from the RFC 009 lifecycle;
- `candidate_digest`, computed by Hees from the exact projection above;
- `evaluation_time_ms`, the non-negative exact integer admitted by RFC 003;
- `memory_ids`, the complete ordered admitted-memory identifiers from the accepted RFC 003 context; and
- `checks`, the complete ordered list of the exact closed check objects defined above.

The request identifier is not a receipt identifier and is not asserted to be globally unique. Package, policy, candidate, attempt, binding, memory-context, and check-manifest values must be materialized or compared against their separately trusted admitted sources. Canonical caller syntax alone must not promote an untrusted request echo into authority.

After constructing and validating the complete request, Hees must canonicalize that closed request object under RFC 005's RFC 8785 profile and compute `request_digest` as `sha256:` followed by 64 lowercase hexadecimal characters. The digest covers every request field, including the complete package, policy, binding, proposal, attempt, candidate, evaluation-time, admitted-memory context, and check-manifest values. It is result-linkage identity only: it is not a receipt, authenticity proof, globally unique operation identifier, or substitute for any covered typed identity.

Target text may appear in the in-memory provider request because it is the hypothesis being evaluated. It must remain bounded, must not include hidden prompt text or chain-of-thought, and must never be copied into an RFC 006 receipt. Governed-memory content is resolved from the admitted package through the trusted identifiers; a provider request must not add raw source material or caller-authored premise text.

### Provider result

A `VerifierProviderResult` must be one closed object containing exactly:

- `provider_result_contract`, exactly `0.1`;
- `request_id`, exactly the request identifier;
- `request_digest`, exactly the Hees-computed request digest;
- `result_id`, one canonical bounded caller result identifier;
- `candidate_digest`, exactly the request candidate digest;
- `binding_id`, exactly the admitted binding selected by the request;
- `state`, one `VerifierResultState`;
- `reason`, one compatible `VerifierResultReason`; and
- `observations`, one bounded ordered observation list.

The only states and compatible reasons are:

| State | Permitted reasons | Observation shape |
| --- | --- | --- |
| `complete` | `completed` | Exactly one observation for every check, in exact check-manifest order. |
| `unavailable` | `provider_unavailable`, `model_unavailable`, `resource_limited`, `deadline_reached`, `unsupported_input` | No observations. |

Contract `0.1` has no `partial` state. A provider that cannot complete every check must discard partial observations and return `unavailable`. A `complete` result with incomplete, extra, duplicate, unknown, or reordered observations is malformed and must not be salvaged.

Each observation must contain exactly:

- `check_id`;
- `support_bps`;
- `contradiction_bps`; and
- `unresolved_bps`.

Each score must be an exact integer in inclusive `0..10000`, and the three scores must sum exactly to `10000` using checked exact arithmetic. Floats, fractions, exponents, negative zero, values outside the range, overflow, NaN-like values, and non-exact totals are invalid.

Scores are binding-specific normalized relation features. They must not be called calibrated probabilities, compared across bindings, interpreted as source authority, or treated as truth. The exact configuration fingerprint commits to the adapter's score and rounding normalization.

The result and each observation must not contain target text, premise text, memory identifiers, evidence identifiers, support references, package or policy actions, terminal decisions, labels selected by the provider, free-form rationale, arbitrary diagnostic strings, hidden reasoning, provider paths, model names, runtime environment, or extension maps. Hees resolves the admitted binding from `binding_id`; it must not trust provider-returned fingerprint fields. It must compare the result's request digest with its independently computed trusted digest before using any observation.

### Classification

For each observation in a valid complete result, Hees must select the target rule by the request check's target kind and classify the score triple in this exact order:

1. `Contradicted` when `contradiction_bps >= contradiction_min_bps`.
2. `Supported` when the first rule did not match and `support_bps >= support_min_bps`.
3. `Unsupported` when the prior rules did not match and `unresolved_bps >= unresolved_min_bps`.
4. `Uncertain` otherwise.

Thresholds greater than `5000` and the exact score sum make simultaneous threshold satisfaction impossible, but the order remains normative for cross-runtime review and future contract evolution.

Each `VerificationFinding` must contain the check identifier, target kind and identifier, exact premise memory identifiers copied from the trusted request, score triple, Hees-derived classification, mapped package action/reason pair, and admitted provider-binding identity. It must not contain terminal candidate authority or free-form rationale.

A `Supported` classification proves only that the selected exact provider binding produced scores meeting the package threshold for that target and premise. It does not prove truth, completeness, factuality, calibration, source rights, or final admissibility. `Unsupported` means the binding's unresolved relation met the package threshold. `Uncertain` means no relation met its threshold. Neither is a provider failure.

### Policy aggregation and RFC 004 composition

Hees must map every complete classification through the exact package target rule. It must then choose the strongest mapped action using the RFC 004 order `Escalate > Reject > Clarify > Revise > Continue`. When multiple mapped findings share the strongest action, the earliest check in the normative manifest order is primary. Visible answer units therefore precede support claims when equally strong outcomes tie.

For a valid unavailable result, Hees must skip per-check classification and use exactly `unavailable_finding`. The typed provider unavailability reason remains provenance in the detailed evaluation but must not select a different action or package reason.

Hees must construct exactly one RFC 004 `ConstraintFinding` from a classified complete or unavailable evaluation. Its contract, constraint identifier, evaluator kind and version, evaluation time, and dependency identifiers must come from the admitted RFC 004 definition and adjudication context. Its action and reason identifier must be the selected package mapping. Its `support_ids` must be empty because examined premise identifiers are not necessarily semantic support, especially for contradicted, unsupported, uncertain, or unavailable outcomes.

The complete per-check `VerificationFinding` list remains separate from the RFC 004 finding. RFC 004 must treat the projected finding like every other non-authoritative evaluator finding, validate it against the admitted definition, and choose the final adjudication action independently. A provider or caller must not submit a complete verifier evaluation directly as an `AdjudicationResult`.

If the verifier result is malformed or rejected, Hees must produce no verifier-derived RFC 004 finding. The missing definition then receives the exact RFC 004 definition-local substitute using the admitted `failure_action` and `failure_reason_id`. A caller that omits verification entirely reaches the same fail-closed definition-local path rather than bypassing the constraint.

### Unavailable and malformed behavior

Provider unavailability is a valid normalized service state only when the complete result envelope is otherwise valid, the state/reason pair is allowed, and the observation list is empty. It retains the admitted package, policy, candidate, memory-context, and provider-binding identity and maps to the package's fixed unavailable pair.

Malformed input is not unavailability. Invalid bounds, identifiers, versions, fingerprints, state/reason pairs, candidate linkage, provider binding, result linkage, check count, check identity, order, score representation, or score sum must reject the verifier envelope and produce no policy-selected verifier finding.

Hees must validate the complete bounded collection and select one public reason by the fixed stage and within-stage precedence below. It must not accept valid-looking observations from a malformed result, infer a missing observation, reorder entries, clamp a score, renormalize a score triple, or turn malformed input into provider-selected unavailability.

### Evaluation-record variants

Every submission must produce one deterministic in-memory `VerificationEvaluationRecord` variant:

- `PreNormalizationRejected` contains only envelope admission `rejected`, one stable Hees stage/reason pair, and optional request and result identifiers when each individual identifier is independently canonical and bounded. It contains no trusted package, policy, candidate, memory-context, provider-binding, target text, score, or malformed input.
- `NormalizedRejected` contains envelope admission `rejected`, the trusted evaluated package and policy identity, trusted RFC 009 proposal and attempt identity, candidate digest, trusted request digest, trusted accepted RFC 003 context identity, one stable Hees stage/reason pair, and no provider observation, classification, policy mapping, or RFC 004 finding. It may retain the admitted provider binding only when binding validation completed before the selected failure stage.
- `Classified` contains envelope admission `accepted`, all trusted identities including the trusted request digest, one valid provider state/reason pair, the admitted provider binding, ordered checks, ordered per-check findings for `complete` or none for `unavailable`, the selected package action/reason pair, and exactly one derived RFC 004 finding.

The complete normative fields of the selected variant form its in-memory identity. Different unsafe inputs may intentionally map to the same minimal rejection. No variant is an RFC 006 receipt, a terminal proposal result, or evidence that a provider executable actually ran.

Every variant contains an `envelope_admission` field whose serialized values are exactly lowercase `accepted` and `rejected`. These are this contract's envelope values; the variant names remain the in-memory typed discriminators, and the field must not be confused with an RFC 003 or RFC 004 typed admission enum.

### Public stages and reasons

Every evaluation record must contain exactly one stage and reason from this closed table. Rows are strict global precedence, reason order within a row is strict precedence, and every reason is globally unique within namespace `verifier_finding_admission_0_1`.

| Stage | Reasons in precedence order | Record and envelope admission |
| --- | --- | --- |
| `normalization` | `verifier_input_collection_bound_exceeded`, `verifier_input_text_bound_exceeded`, `verifier_contract_value_invalid`, `verifier_request_identifier_invalid`, `verifier_request_digest_invalid`, `verifier_result_identifier_invalid`, `verifier_package_identity_invalid`, `verifier_policy_identity_invalid`, `verifier_candidate_identity_invalid`, `verifier_attempt_value_invalid`, `verifier_evaluation_time_invalid`, `verifier_binding_identifier_invalid`, `verifier_memory_identifier_invalid`, `verifier_target_identifier_invalid`, `verifier_check_identifier_invalid`, `verifier_score_value_invalid`, `verifier_state_unsupported`, `verifier_state_reason_unsupported`, `verifier_state_reason_mismatch` | `PreNormalizationRejected` / `rejected` |
| `package` | `verifier_package_not_admitted`, `verifier_policy_not_admitted` | `PreNormalizationRejected` / `rejected` |
| `subject` | `verifier_candidate_not_admitted`, `verifier_memory_context_not_accepted` | `PreNormalizationRejected` / `rejected` |
| `request` | `verifier_contract_unsupported`, `verifier_package_identity_mismatch`, `verifier_policy_identity_mismatch`, `verifier_candidate_identity_mismatch`, `verifier_attempt_mismatch`, `verifier_memory_context_mismatch`, `verifier_binding_not_admitted`, `verifier_target_manifest_mismatch` | `NormalizedRejected` / `rejected` |
| `result` | `verifier_result_contract_mismatch`, `verifier_result_request_mismatch`, `verifier_result_request_digest_mismatch`, `verifier_result_candidate_mismatch`, `verifier_result_binding_mismatch`, `verifier_finding_count_mismatch`, `verifier_finding_duplicate`, `verifier_finding_unknown`, `verifier_finding_order_mismatch`, `verifier_score_sum_invalid` | `NormalizedRejected` / `rejected` |
| `complete` | `verifier_classified_complete`, `verifier_classified_unavailable` | `Classified` / `accepted` |

The normalization reasons classify malformed values before trusted identity is established. Collection and text bounds take precedence before content is retained. Package and policy identity invalidity covers malformed individual fields in those typed tuples; candidate identity invalidity covers malformed proposal or candidate-digest syntax; attempt and evaluation-time invalidity cover their exact RFC 009 and RFC 003 value domains; memory, target, check, binding, request, result, and request-digest reasons cover malformed values in their named namespaces. Score-value invalidity covers a non-exact integer or a value outside `0..10000`; a bounded exact triple whose checked sum differs from `10000` reaches `verifier_score_sum_invalid` only after the trusted request and result linkage exists.

The package reasons mean no successful RFC 005 package identity exists or no admitted `claim_verification` member and linked policy exists. The subject reasons mean RFC 009 did not admit the normalized candidate state or RFC 003 did not supply an accepted complete/partial context. Canonical-looking caller fields must not supply those trusted identities.

At the request stage, exact contract support is checked before package, policy, candidate, attempt, memory-context, binding, and target-manifest equality. A candidate digest mismatch or a result from another attempt must not be repaired by comparing target text. A well-formed but unapproved binding reaches `verifier_binding_not_admitted`.

At the result stage, the result contract must equal both `0.1` and the selected admitted binding's pinned `provider_contract_version`; contract, request-identifier, request-digest, candidate, and binding echoes are checked in that order before observations. Count mismatch takes precedence over item-level identity defects. For an exact-size bounded list, duplicate check identifiers precede unknown identifiers, and unknown identifiers precede order mismatch. Score sums are evaluated only after every expected check appears exactly once in exact order.

The two complete reasons are structural success reasons, not proposal outcomes. `verifier_classified_complete` means every observation was classified and policy-mapped. `verifier_classified_unavailable` means the valid unavailable state was mapped to the fixed unavailable pair. Neither reason may replace the package-owned reason in the derived RFC 004 finding, the RFC 004 Hees-owned adjudication reason, or the RFC 001 Spectrum terminal reason.

Implementations must determine all applicable reason kinds within the selected bounded stage and choose the first reason in the table. Parser wording, provider text, map iteration, the first malformed observation encountered, package reason wording, and local diagnostics must not influence the public stage/reason pair.

### Bounds and Draft measurement gates

Contract `0.1` must use the following exact logical bounds:

| Value | Maximum or exact rule |
| --- | ---: |
| Canonical identifier | 128 UTF-8 bytes |
| Version or revision | 32 bytes |
| Provider, model, or configuration fingerprint | Exactly 64 lowercase hexadecimal characters |
| Candidate digest | Exactly `sha256:` plus 64 lowercase hexadecimal characters |
| Request digest | Exactly `sha256:` plus 64 lowercase hexadecimal characters |
| Provider bindings | 16 |
| Allowed binding identifiers | 16 |
| Selected governed-memory identifiers | 64, inherited from RFC 003 |
| Visible answer units | 64 |
| Atomic support claims | 64 |
| Total checks | 64 |
| Premise identifiers for one support claim | Exactly 1 |
| Premise identifiers for one visible answer unit | At most 64 |
| One target text | 8,192 UTF-8 bytes |
| Aggregate target text | 32,768 UTF-8 bytes |
| Provider observations | Exactly the complete check count, at most 64 |
| One relation score | Exact integer in `0..10000` |
| One relation-score sum | Exactly `10000` |
| Free-form rationale or provider diagnostics | Forbidden |

The visible-answer-unit and support-claim limits are individual ceilings, while their checked sum must not exceed the total-check ceiling. Hees must enforce collection and text ceilings before proportional allocation or retention. Checked sums must use the RFC 005 exact-integer domain and must not wrap, saturate, clamp, or depend on native integer width.

The aggregate target-text ceiling must be no greater than the accepted RFC 009 candidate aggregate text ceiling. If RFC 009 accepts a lower ceiling, this contract must adopt that lower exact value before Planned rather than silently truncating a candidate.

RFC 005 must add exact `claim_verification` member byte, parser, nested-collection, record-count, retained-binding-index, and retained-policy-index ceilings to its shared resource table. RFC 006 requires no new receipt-size allowance because verifier details are not exported. This RFC cannot advance to Planned until representative constrained-device measurement confirms the package-member and one-request/one-result high-water marks and the exact final byte ceilings are mechanically consistent with RFC 005 and RFC 009. The logical counts above are compatibility bounds, not claims about physical RSS, latency, energy, or model coexistence.

### Determinism and privacy

Given identical RFC 005-admitted package data, identical RFC 009 normalized candidate data, the same accepted RFC 003 context, and an identical typed provider result, conforming implementations must produce the same candidate digest, verification-request digest, check manifest, record variant, public reason, per-check classifications, primary check, selected package mapping, and derived RFC 004 finding.

The runtime must not read a wall clock. It must use the caller-supplied evaluation time already admitted by RFC 003 and required by RFC 004. It must not apply Unicode normalization, case folding, whitespace rewriting, sentence inference, provider-specific score adjustment, or implementation-specific threshold tolerance.

Provider observations, scores, target text, candidate digest, provider/model/configuration fingerprints, and detailed per-check findings must not enter RFC 006 receipt contract `0.1`. They may be retained in a separately governed bounded operator trace, but such a trace must not be presented as an authoritative receipt and must not contain free-form provider rationale or hidden reasoning.

## Design details

### Relationship to RFC 000

RFC 000 requires provider observations to remain non-authoritative. This RFC validates and classifies exact verifier output under package policy but cannot establish truth, selected memory, terminal response, or provenance by itself.

### Relationship to RFC 001

Spectrum consumes the RFC 004 finding derived here only after the owning contracts validate its complete identity and coverage. Provider scores and successful classifications cannot bypass Spectrum or author the final selected-memory set.

### Relationship to RFC 002

Verification may contribute to admission, but Content DNA contains no verifier scores, provider bindings, target text, or detailed findings. RFC 002 records the terminally selected reviewed memory and governing identity rather than a provider's confidence transcript.

### Relationship to Hees 0.0.1

The existing `ModelProposal` and `AdmissionResult` remain the implemented Hees 0.0.1 structural contract until this RFC, its dependencies, and a separate implementation are accepted and merged. Existing structural admission proves only package, action, visible-output, and cited-evidence conditions. It must not be retroactively documented as semantic verification.

The new capability is additive and opt-in at the package level. A package without an admitted `claim_verification` member and linked RFC 004 definition must not become verification-capable merely because a runtime understands this contract. Multiple allowed bindings remain legal for deployment compatibility, but each request must select one binding explicitly before provider invocation; implicit fallback within a submitted result is forbidden.

### Relationship to RFC 003

RFC 003 owns admitted governed-memory atoms, provider-result admission, materialized context order, evaluation time, rights, review status, provenance, and validity. RFC 007 imports only an accepted complete/partial context and never reinterprets retrieval relevance as support.

Visible-answer-unit premises use the complete ordered admitted-memory context union so a visible synthesis may be supported across multiple atoms. Atomic support claims use exactly one cited atom so a claim attached to the wrong source cannot pass merely because another admitted atom would support it. RFC 001 Spectrum later freezes the final selected-memory subset.

RFC 007 does not admit evidence identifiers as semantic premises in contract `0.1`. Existing evidence citations remain structural. A future contract may add a typed evidence namespace only with exact authority, identity, bounds, and receipt coordination.

### Relationship to RFC 004

RFC 004 owns constraint definitions, finding validation, action order, definition-local substitution, conflict representation, and authoritative adjudication. RFC 007 owns the provider-specific observation and classification boundary plus deterministic conversion to one allowed RFC 004 finding.

The package's linked constraint definition is deliberately redundant with the claim-verification policy only where cross-validation is required: the policy chooses exact mappings, while RFC 004 limits which mappings may enter adjudication. A mismatch invalidates package admission rather than being resolved at runtime.

Deterministic constraints remain independent. Semantic support cannot override a structural answer failure, forbidden action, invalid package, missing required synthesis, policy conflict, or another stronger package-authorized finding.

### Relationship to RFC 005

RFC 005 owns the common member wrapper, JCS bytes, member digest and length, final member order, sequential admission, record count, package identity, compact retained indexes, and atomic package completion. This RFC owns only the closed `claim_verification` payload and its cross-reference semantics.

The member appears after constraints so `constraint_id` resolves backward in one pass. It has no package-time atom identifier references: runtime checks derive atom identifiers only from an accepted RFC 003 context. Presence still depends on governed memory because contract `0.1` defines no other verifier premise namespace.

### Relationship to RFC 006

RFC 006 owns canonical receipt bodies, envelopes, identifiers, private emission, and public integrity verification. RFC 007 defines no receipt kind, body, digest, exporter, or authenticity claim.

The RFC 004 constraint receipt may identify the linked constraint as evaluated or substituted under RFC 006's existing structural projection. Complete verifier findings, scores, provider bindings, candidate digests, and premise identifiers remain outside the receipt. Successful verification is not proof that admitted identifiers semantically establish real-world truth.

### Relationship to RFC 009

RFC 009 owns the normalized candidate representation and must make visible prose the sole user-facing answer channel. Support metadata must be identifier-only and must not carry independent hidden synthesis. An atomic support claim consumed here is the exact normalized claim derived from its referenced visible unit, not prose supplied by the model or provider in a separate support channel.

RFC 009 also owns whether a candidate is original or repaired, whether its attempt index is legal, whether its visible units satisfy answer or clarification structure, and whether accepted verification and RFC 004 adjudication permit a terminal proposal outcome. RFC 007 binds those values but never advances the repair counter or chooses the terminal variant.

Requested-synthesis completeness remains RFC 009's responsibility. A completeness evaluator may require accepted RFC 007 findings for every relevant visible unit, but it must not treat a support claim or verification score as a substitute for synthesis in visible prose.

### Provider neutrality and calibration

The public contract describes exact normalized score triples and exact provider bindings, not one model architecture. A rule-based verifier, classifier, or other provider may conform only when its admitted adapter deterministically produces the required triple under the bound configuration.

Thresholds are package-specific policy. They must be calibrated and accepted against representative package acceptance evidence. A threshold that performs well on a small synthetic or single-language suite must not be described as a general semantic-support threshold.

Multiple provider bindings may be admitted for deployment compatibility, but each request selects exactly one admitted binding and records it. Scores from different bindings must not be compared or combined. Provider fallback and binding selection are outside this RFC and must not occur implicitly after a result has been submitted.

### Acceptance obligations

Shared package goldens must include complete formatted values plus exact RFC 8785 JCS bytes, member digest, descriptor record count, final-member topology, and inherited package identity for one provider binding, multiple bindings, both target rules, every classification mapping, the unavailable mapping, and the linked RFC 004 definition. JavaScript, Rust, and Incan consumers must agree on every field, omission, order, digest, cross-reference, action-strength check, and RFC 005 admission result.

Negative package fixtures must independently cover every missing, unknown, null, or aliased field; key and enum case changes; malformed identifiers, versions, and fingerprints; a well-formed but unsupported provider contract version; duplicate binding identifiers and tuples; unknown or duplicate allowed bindings; zero, fractional, exponent, below-majority, or above-range thresholds; duplicate or invalid action/reason mappings; forbidden action mappings; missing governed memory; missing constraints; unknown constraint identifiers; wrong evaluator kind or version; mappings absent from `allowed_findings`; actions above `maximum_action`; failure action weaker than unavailable; wrong record count; wrong member position; repeated package identity; generic metadata; and provider/model paths or executable content.

Candidate and check fixtures must cover original and repaired attempts, exact candidate-digest and verification-request-digest reproducibility, finding replay across attempts, candidate digests, packages, bindings, admitted-memory contexts, and check manifests, stable RFC 009 target identifiers, visible-unit-derived support claims, visible-answer-unit-first check order, exact cited-atom checks, admitted-memory-union checks, empty and duplicate target identifiers, unadmitted claim memory, zero or multiple claim memory identifiers, omitted visible units, target-text mismatch, target-count and aggregate-text boundaries, and candidate content that differs only by Unicode code-point sequence or order.

Provider-result fixtures must cover supported, contradicted, unsupported, and uncertain classifications; every threshold at one below, exactly equal, and one above; exact score boundaries and sums; complete and every unavailable reason; complete with zero or missing observations; unavailable with observations; unknown partial state; duplicate, unknown, extra, missing, and reordered checks; wrong request identifier, request digest, candidate, or binding identity; malformed scores; provider-returned target text, memory identifiers, actions, labels, free-form rationale, or extension fields; and deterministic reason precedence for multi-failure results.

Policy fixtures must prove strongest-action selection, visible-answer-first tie-breaking, fixed unavailable mapping independent of provider reason, empty RFC 004 support identifiers, exact linked definition dependencies, deterministic constraints overriding supported semantic observations, malformed output producing RFC 004 substitution, omitted verification producing the same fail-closed substitute, and a package-authorized escalation remaining distinguishable from a globally malformed result.

Semantic mechanism fixtures must include a direct supported paraphrase, a claim supported by another admitted atom but not its cited atom, a visible unit requiring the admitted-memory union, an invented quantity, an unsupported causal mechanism, a lexically similar contradiction, a high-unresolved observation, and a diffuse-score uncertain observation. At least two synthetic provider adapters must produce identical normalized score triples and therefore identical Hees records for the same admitted inputs.

Multilingual shape fixtures must preserve distinct English, Afrikaans, and isiZulu visible units, identifiers, UTF-8 byte counts, canonical bytes, and target order. These fixtures prove contract and Unicode behavior only. Provider language quality and threshold calibration require separate representative acceptance evidence.

Authority-negative API fixtures must prove that a provider cannot change candidate text or references, add memory, select an action, construct an RFC 004 result, emit an authoritative receipt, or turn successful public receipt verification into in-process Hees authority. Receipt fixtures must reject every attempt to include candidate digest, provider/model/configuration fingerprint, target text, scores, classifications, or detailed verifier findings in contract `0.1` bodies.

Constrained-device evidence must separately report claim-verification member parse high-water mark, retained binding/policy state, request-construction high-water mark, complete-result validation high-water mark, per-check sequential provider coexistence, detailed-record retention, and coexistence with representative model and memory consumers. Host-only or synthetic measurements are directional evidence, not proof of the final device envelope.

## Alternatives considered

### Let the provider return `supported` or `rejected`

Rejected because a provider-selected label or terminal action would make provider configuration an implicit decision authority. The provider returns only bounded relation features; Hees derives classifications and RFC 004 owns the action.

### Reuse retrieval relevance as semantic support

Rejected because RFC 003 relevance is a provider-specific ranking feature. A highly ranked atom may fail to support the candidate claim, and retrieval acceptance proves no entailment.

### Check only support records

Rejected because useful or unsupported synthesis may appear in visible prose without a matching support claim. Every visible answer unit also needs an admitted-memory-union check.

### Check only the complete visible answer

Rejected because one aggregate score can hide which statement failed and may exceed provider input bounds. Stable visible units permit complete bounded coverage and actionable repair without exposing free-form rationale.

### Let support metadata carry independent claim prose

Rejected because hidden support prose can substitute for missing visible synthesis and can diverge from what the user reads. The atomic claim is derived from a referenced visible unit under RFC 009.

### Permit partial verifier results

Rejected because partial salvage makes coverage and failure policy caller-dependent. A provider either completes every check or returns a typed unavailable state with no observations.

### Store a free-form verifier rationale

Rejected because generated rationale may leak provider internals, hidden reasoning, source text, or unsafe content and is not needed for deterministic policy. Check identity, score triple, classification, and stable package reason form the bounded explanation.

### Put thresholds in provider configuration only

Rejected because two runtimes could apply different policy to identical scores while claiming the same package behavior. Thresholds and action mappings are admitted package data; provider configuration controls only normalized score production.

### Give verification its own terminal result or receipt kind

Rejected because RFC 004 already owns finding composition and RFC 006 already owns safe terminal receipts. A second terminal path would blur observation, policy, adjudication, and candidate authority.

### Add provider bindings after RFC 005 contract `0.1` is accepted

Rejected because RFC 005 uses a closed member topology. The contracts must coordinate while Draft, or the later member requires a new artifact contract rather than an ignored extension.

## Drawbacks

The contract requires RFC 009 to expose stable visible units and derived atomic claims rather than only a flat output string. Packages must admit provider, model, configuration, threshold, action, and reason identity, so changing a verifier or calibration becomes an explicit package revision. Adding another RFC 005 member increases package schema, cross-reference, parser, fixture, and retained-state complexity.

The verifier's guaranteed granularity is the RFC 009 visible unit. Until RFC 009 adopts a multilingual-safe acceptance rule for claim-focused units, this RFC must not claim that a check corresponds to exactly one grammatical sentence or atomic proposition. That limitation is an explicit Draft gate rather than an implementation-defined segmentation step.

Exact one-check-per-target coverage can require many sequential verifier invocations on constrained devices. A total-check ceiling bounds the work but does not prove acceptable latency, energy, thermal behavior, or model coexistence. Treating incomplete service as unavailable discards potentially useful observations. Strict score normalization and threshold semantics require deterministic adapters for providers that expose different label spaces.

The result remains fallible. A provider may confidently support an unsupported claim or reject a valid paraphrase, and a package may choose poor thresholds. This RFC makes those dependencies explicit and prevents them from becoming direct authority, but it cannot make semantic verification infallible.

Detailed findings intentionally remain outside governance receipts, limiting remote diagnosis through the receipt alone. Operator tooling that needs scores and provider provenance requires a separately governed trace boundary.

## Layers affected

- **Public contract:** New package-relative provider binding and policy declarations, normalized verification subject, target and check identity, request, provider result, observation, classification, evaluation-record, stage, reason, and RFC 004 projection semantics.
- **Package admission:** RFC 005 topology, member kind and order, record count, closed payload, provider/policy bounds, constraint cross-reference, and retained binding/policy identity.
- **Candidate integration:** Exact RFC 009 proposal, attempt, visible-unit, derived support-claim, and candidate-digest binding without taking ownership of candidate lifecycle.
- **Memory integration:** Exact RFC 003 accepted-context identity and package-owned premise resolution without treating retrieval relevance as semantic support.
- **Constraint adjudication:** Deterministic conversion into one allowed RFC 004 finding, definition-local substitution for malformed or missing verification, preservation of RFC 004 finding-composition authority, and preservation of RFC 001 Spectrum terminal authority.
- **Receipt boundary:** Explicit exclusion of detailed verifier data from RFC 006 receipt contract `0.1`.
- **Compatibility:** Cross-runtime canonical package bytes, score normalization, classification, action precedence, reason precedence, and failure behavior.
- **Tests and documentation:** Package, candidate, provider, policy, multilingual-shape, authority-negative, receipt-negative, and constrained-device evidence.

## Design Decisions

- RFC 009 owns logical proposal identity, attempt identity, visible units, support-claim identity and derivation, repair, clarification, and terminal candidate outcomes.
- RFC 007 never segments an opaque visible string and never accepts provider-authored support prose.
- The candidate digest is JCS identity for the exact normalized verification subject and is never the logical proposal identifier or a receipt identifier.
- The verification-request digest binds the complete trusted request, including memory premises and check manifest, and must be echoed by the provider result before observations can be used.
- Visible answer units are checked before support claims; their order provides the deterministic equal-action tie-break.
- Every visible answer unit is checked against the complete ordered accepted RFC 003 memory union, while every atomic support claim is checked against exactly its one cited admitted atom.
- Contract `0.1` uses governed-memory premise identifiers only and defines no semantic evidence-identifier namespace.
- `claim_verification` is an optional RFC 005 member after constraints and before behavior/response members, legal only when governed memory and constraints are present; its descriptor count is provider bindings plus one policy.
- The member position makes its RFC 004 constraint reference backward-resolvable during sequential package admission.
- RFC 005 artifact contract `0.1` incorporates this member before the coupled Draft contract is frozen; a later member addition requires a new exact artifact contract.
- Provider, model, and configuration fingerprints are admitted package identity claims, not proof of execution or authenticity.
- Provider results contain only check identifiers and fixed-point support, contradiction, and unresolved scores; they contain no text, references, actions, labels, or rationale.
- Contract `0.1` has only complete and unavailable provider states. Incomplete observations are malformed and are never salvaged.
- Thresholds are package-owned exact integers greater than 5000, and scores are exact basis points summing to 10000.
- Hees derives `Contradicted`, `Supported`, `Unsupported`, or `Uncertain` and maps each through package policy.
- Strongest-action selection reuses RFC 004 order, but the result remains one non-authoritative RFC 004 finding and cannot decide the candidate.
- Valid unavailability uses one fixed package mapping independent of provider reason; malformed or missing verification yields no finding and therefore uses the RFC 004 definition's fail-closed substitute.
- The derived RFC 004 finding carries no support identifiers because examined premises are not necessarily semantic support.
- Public verifier-admission reasons are closed, globally unique within `verifier_finding_admission_0_1`, and selected by fixed stage and within-stage precedence.
- Detailed targets, scores, classifications, candidate digests, and provider bindings remain outside RFC 006 receipt contract `0.1`.
- Logical count bounds are cross-runtime compatibility rules; final package-member and request/result byte ceilings remain explicit Draft measurement gates.

## Unresolved questions

- What multilingual-safe RFC 009 acceptance rule or bounded check will establish that each visible unit is a sufficiently claim-focused verification granule before this RFC may claim sentence- or proposition-level coverage?
- What final aggregate candidate-text ceiling will RFC 009 accept, and should RFC 007 retain the proposed 32,768-byte aggregate target ceiling or adopt a lower mechanically derived value?
- What exact `claim_verification` member, parser, retained-state, request, and result byte ceilings do representative constrained-device measurements justify inside RFC 005's shared resource table?
- Do representative multilingual civic fixtures justify one threshold rule per target kind, or must the package schema add an explicit language- or capability-specific policy dimension before Planned?

<!-- Rename this section to "Design Decisions" once all questions have been resolved.
     An RFC cannot move from Draft to Planned until no unresolved questions remain. -->
