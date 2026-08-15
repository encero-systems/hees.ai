# RFC 008: Governed Behavior Envelopes

- **Status:** Planned
- **Created:** 2026-07-17
- **Author(s):** Encero Systems
- **Related:**
    - RFC 000 (Foundational Governance Authority)
    - RFC 001 (Spectrum Terminal Adjudication)
    - RFC 004 (Composable governance constraints)
    - RFC 005 (Canonical package artifact admission)
    - RFC 006 (Export-safe governance receipts)
    - RFC 007 (Evidence-Grounded Claim Verification Findings)
    - RFC 009 (Governed visible response lifecycle)
- **Issue:** https://github.com/encero-systems/hees.ai/issues/9
- **RFC PR:** —
- **Written against:** Hees.ai 0.0.1 / Incan 0.5
- **Shipped in:** —

## Summary

Hees.ai should admit a package-committed behavior envelope, evaluate a bounded set of untrusted behavior candidates against that envelope and a trusted runtime frame, and select one uniquely best eligible candidate through package-declared, iteration-order-independent rules. The selection result carries behavioral authority only: it contains no answer text, support, verifier conclusion, repair decision, clarification, or terminal response action, and only its direct opaque return may enter the governed visible-response lifecycle defined by RFC 009.

## Core model

1. **The admitted package owns the envelope.** A behavior envelope is a canonical member committed by the RFC 005 package artifact identity, not a mutable runtime policy or provider option.
2. **Candidates remain untrusted.** Providers may propose bounded behavior slots, but they cannot declare package authority, selection priority, terminal action, or score.
3. **Eligibility never repairs or truncates.** Hees.ai checks each candidate exactly as supplied and marks an over-bound, unknown, or incompatible value ineligible; it does not cap an action list, reinterpret a slot, or silently ignore excess candidates.
4. **Selection is deterministic.** Hees.ai admits candidates only when they preserve declared goal continuity and a valid state transition, then compares package-declared goal continuity and risk/intervention severity without reading model prose or confidence.
5. **Selection is not response admission.** RFC 008 decides which behavioral frame, if any, may continue. RFC 009 separately decides whether the selected candidate's visible response may be shown, repaired, clarified, or rejected.
6. **Authority is direct and narrow.** A caller may inspect a serializable trace, but only the direct opaque selected-candidate capability returned by Hees.ai may authorize the next governed operation.

## Motivation

Hees.ai 0.0.1 validates a small in-memory package and one proposal, but it does not establish a canonical package artifact identity for behavior rules, model state transitions, multiple-candidate selection, or a reusable selected-candidate capability. A provider can supply package, domain, action, visible-output, and evidence claims, while the runtime performs only structural membership checks. That surface is useful as a minimal boundary proof but is insufficient for portable behavior governance.

Package implementations often need richer behavior structure: declared intent and risk classes, state transitions, response strategies, and action combinations. Those declarations must not become provider-owned prompt conventions or application-specific branching. Conversely, moving answer prose, support claims, verifier scores, or repair policy into behavior selection would make the envelope an alternate response authority and would collapse the separation required by RFC 007 and RFC 009.

Naive multi-candidate selectors introduce additional hazards. Evaluating only the first configured number of candidates makes the result depend on input order. Preserving the first candidate on a score tie does the same. Adding caller-supplied model or rubric scores lets an untrusted provider influence authority. Capping an overlong action list and continuing can admit behavior that was never proposed as a valid whole. This RFC defines a bounded selector that rejects those shortcuts.

## Goals

- Define a closed package-owned behavior-envelope payload committed by RFC 005 artifact identity.
- Define the trusted runtime frame and the bounded untrusted behavior-candidate shape.
- Validate intent classes, risk classes, authority classes, declared goals, states, transitions, strategies, and actions without inspecting response prose.
- Define whole-set bounds and fail-closed behavior without prefix truncation or partial candidate repair.
- Define package-declared comparison criteria whose outcome is independent of candidate iteration order.
- Require one uniquely best eligible candidate and fail closed on a remaining tie.
- Define stable selection states, reasons, candidate-violation codes, and precedence.
- Return an opaque selected-candidate capability for RFC 009 while keeping the public trace non-authoritative.
- Preserve exact admitted package and envelope identity through selection.

## Non-Goals

- Generating, rewriting, ranking, or validating visible answer prose.
- Defining support mappings, verifier findings, synthesis completeness, repair, clarification, refusal wording, or response receipts.
- Executing a model, writing prompts, configuring a provider, or choosing a model-specific grammar.
- Accepting model scores, provider confidence, hidden reasoning, free-form rationale, or caller-authored terminal actions as selection authority.
- Defining package-authoring or operator-review workflow.
- Ranking business preferences inside Hees.ai; packages declare the permitted comparison order and Hees.ai applies it mechanically.
- Selecting external resources, performing retrieval, or interpreting raw evidence.
- Defining signatures, attestations, durable sessions, or external producer authenticity.
- Defining an export receipt for behavior selection. RFC 006 remains the sole receipt contract and does not reserve a behavior-selection receipt kind.

## Guide-level explanation

A package author declares the behavior values that a runtime may admit: the classes used to describe a request, the goals that maintain the learner's declared direction, the states and transitions available to the interaction, the strategies that may operate in those states, and the package actions each strategy may use. The declaration also supplies positive candidate and action limits together with an ordered policy for goal continuity and risk/intervention severity.

RFC 005 admission commits that declaration to the package artifact digest. At runtime, Hees.ai derives a frame from the accepted package and other trusted governed results. A provider may then supply zero or more behavior candidates. Each candidate names only declared behavior slots. It cannot attach a score, terminal action, answer, support record, or verifier result.

Hees.ai first validates the complete candidate set against the closed profile resource envelope. It then evaluates every candidate independently. Ineligible candidates remain visible in the bounded trace with stable violation codes but cannot win. If no candidate is eligible, selection returns no selected capability. If eligible candidates remain, Hees.ai compares their package-derived keys. One unique best candidate yields an opaque selected-candidate capability. An unresolved tie yields no selection rather than using list order, candidate identity, answer bytes, or provider score as an undeclared tiebreaker.

The caller may pass the opaque capability to RFC 009 together with the selected candidate's response values and RFC 007 finding batch. A copied trace or caller-constructed candidate cannot substitute for that direct capability.

## Reference-level explanation

### Contract ownership and package binding

The behavior envelope must be a closed canonical `behavior_envelope` member admitted as part of an RFC 005 package artifact. Its descriptor and bytes must participate in the package artifact digest exactly like every other admitted member. A runtime-supplied envelope, a separately mutable sidecar, a provider configuration, or a value reconstructed from a public trace must not carry package authority.

The member must inherit the complete `AdmittedPackageIdentity` defined by RFC 005 only after atomic package admission. That identity includes package, domain, and revision identifiers, `package_semantic_identity`, `artifact_digest`, and `package_admission_binding`.

The envelope payload must not repeat that containing package identity. Hees.ai must bind the admitted member to the exact containing identity without mutating or re-hashing its bytes.

RFC 005 artifact contract `0.1` incorporates the behavior-envelope member in its closed profile topology. An implementation must not reinterpret an admitted artifact contract or accept an uncommitted behavior declaration; another member or wrapper change requires a new exact artifact-contract version.

### Closed behavior-envelope payload

The `behavior_envelope` member must use member contract `0.1` and the RFC 005 common member fields. Its payload must contain exactly:

- `envelope_id`, one canonical package-scoped identifier;
- `envelope_revision`, one canonical revision;
- `phase_ids`, one bounded non-empty ordered identifier array;
- `intent_class_ids`, one bounded non-empty ordered identifier array;
- `risk_class_ids`, one bounded non-empty ordered identifier array;
- `authority_class_ids`, one bounded non-empty ordered identifier array;
- `goal_ids`, one bounded non-empty ordered identifier array;
- `start_state_id`, one identifier resolving in `states`;
- `states`, one bounded non-empty ordered state array;
- `strategies`, one bounded non-empty ordered strategy array; and
- `selection_policy`, one closed policy object.

Every identifier must use the RFC 005 canonical package-identifier grammar and its final field-specific UTF-8 byte ceiling. Every declaration array must be duplicate-free. Array order is identity-bearing and must not be normalized or inferred from object iteration order.

Each state must contain exactly:

- `id`;
- `phase_id`;
- `terminal`; and
- `allowed_next_state_ids`.

State identifiers must be unique. Every phase must resolve in `phase_ids`, every next-state identifier must resolve in `states`, and the start state must resolve exactly once. A terminal state must have an empty next-state array. A nonterminal state may have an empty next-state array only when the package intentionally permits a dead end; such a state can never produce an eligible transition candidate.

Each strategy must contain exactly:

- `id`;
- `allowed_state_ids`;
- `allowed_action_ids`;
- `allowed_intent_class_ids`;
- `allowed_risk_class_ids`;
- `allowed_authority_class_ids`; and
- `allowed_goal_ids`.

Strategy identifiers must be unique. Every referenced state, class, and goal identifier must resolve inside the same envelope, and every action identifier must resolve in the containing package's RFC 005 `actions` member. Each allowed array must be non-empty and duplicate-free. A strategy must not contain answer text, evidence identifiers, memory identifiers, source references, provider data, scores, fallback wording, or arbitrary metadata.

The selection policy must contain exactly:

- `criteria`, one ordered array containing each required comparison criterion exactly once;
- `goal_priority_ids`, one complete duplicate-free permutation of the declared goal identifiers; and
- `risk_intervention_priority_ids`, one complete duplicate-free permutation of the declared risk-class identifiers.

Contract `0.1` has two ordered comparison criteria: `goal_continuity` and `risk_intervention_severity`. `criteria` must contain each one exactly once and must not contain another value. `goal_continuity` uses the ordinal of the candidate goal in `goal_priority_ids`; `risk_intervention_severity` uses the ordinal of the candidate risk class in `risk_intervention_priority_ids`. Lower numeric components are preferred. State-transition validity is a mandatory eligibility condition, not an after-the-fact tiebreaker. The policy therefore never uses model prose, provider confidence, candidate identifiers, lexical order, or action count as a quality signal.

The behavior-envelope `record_count` must equal the sum of the declared phase identifiers, three class-identifier arrays, goals, states, strategies, and selection criteria. Nested state transitions, strategy allowlists, and priority arrays must have their own final collection ceilings and do not add a second interpretation to `record_count`.

### Trusted runtime frame

Selection must receive a trusted runtime frame created by Hees.ai from the same admitted package identity as the envelope. The frame must contain exactly:

- the complete trusted package identity;
- `current_state_id`; and
- `active_goal_ids`, the ordered duplicate-free subset of admitted envelope goals that remains applicable to this interaction; and
- `effective_action_ids`, the ordered duplicate-free subset of admitted package actions that remains available after any applicable governed constraint results.

The current state must resolve in the admitted envelope. Every active goal must resolve in the envelope and every effective action must resolve in the admitted package action catalog. The operation that creates the trusted frame must derive `active_goal_ids` from package-declared learner/session state; it must not accept a model-selected goal list. A caller-provided package tuple, state declaration, goal list, action definition, or constraint result must not be upgraded into a trusted frame merely because its fields are well formed.

RFC 004 may narrow the effective action set before selection, but RFC 008 must not reinterpret RFC 004 findings or choose a constraint action. The direct trusted result of the governing operation supplies the effective set.

### Untrusted behavior candidate

Each candidate must contain exactly:

- `candidate_id`;
- `intent_class_id`;
- `risk_class_id`;
- `authority_class_id`;
- `goal_id`;
- `from_state_id`;
- `to_state_id`;
- `strategy_id`; and
- `action_ids`.

The candidate must not contain package identity, proposal identity, visible text, support, evidence or memory references, resource requests, answerability, uncertainty, clarification text, repair state, terminal action, provider confidence, model score, rubric score, free-form rationale, hidden reasoning, or arbitrary metadata. Those values are either owned by another contract or forbidden as authority inputs.

Candidate identifiers must be canonical and unique within one complete candidate set. Candidate identifiers identify trace entries only. Hees.ai must not use them as a selection criterion or infer quality from lexical order.

The action array must be non-empty, duplicate-free, and bounded by the closed RFC 005 profile resource envelope. Hees.ai must validate the candidate as one whole value. It must not remove unknown actions, cap the list, retain a prefix, reorder it, or mark a subset accepted.

### Complete-set validation

Hees.ai must validate the complete candidate-set shape before it evaluates eligibility. Invalid encoded input, malformed syntax, a field of the wrong type, a missing or unknown field, non-exact count arithmetic, or a profile-envelope failure must produce selection state `invalid` with reason `invalid_candidate_set`; Hees.ai must not reinterpret a partially parsed value. Zero candidates is a valid bounded input that produces selection state `none` with reason `no_candidates`. A well-formed set exceeding the profile resource envelope must produce selection state `invalid` with reason `candidate_limit_exceeded`; Hees.ai must not inspect a permitted prefix and ignore the remainder.

Duplicate candidate identifiers must invalidate the complete set with reason `duplicate_candidate_id`. This classification occurs before per-candidate eligibility so the public result cannot depend on which duplicate happened to be visited first.

After complete-set validation, Hees.ai must evaluate candidates in ascending Unicode scalar-value order of the exact parsed `candidate_id` string for trace construction only. This order remains defined when a parsed identifier violates the canonical identifier grammar and receives `candidate_identifier_invalid`. The evaluation and selected outcome must remain identical under every permutation of the same candidate values.

### Candidate eligibility

A candidate is eligible only when all of the following hold:

- each intent, risk, and authority identifier resolves in the corresponding envelope catalog;
- `goal_id` resolves in the envelope and appears in the trusted frame's `active_goal_ids`;
- `from_state_id` exactly equals the trusted frame's current state;
- `to_state_id` resolves and appears in the current state's allowed-next-state array;
- `strategy_id` resolves;
- the strategy allows the target state, the candidate intent, risk, authority, and goal identifiers;
- every action identifier resolves in the admitted package action member;
- every action remains present in the trusted frame's effective-action set;
- every action is allowed by the selected strategy; and
- the complete action array remains inside both action ceilings.

Hees.ai must collect all applicable bounded candidate-violation codes in the fixed precedence order below. A candidate with any violation is ineligible and must not receive a comparison key. A violation does not itself choose repair, clarification, rejection, or user-visible wording.

The candidate-violation codes and precedence for contract `0.1` are exactly the following 19 values:

1. `candidate_identifier_invalid`;
2. `candidate_intent_unknown`;
3. `candidate_risk_unknown`;
4. `candidate_authority_unknown`;
5. `candidate_goal_unknown`;
6. `candidate_from_state_mismatch`;
7. `candidate_to_state_unknown`;
8. `candidate_transition_forbidden`;
9. `candidate_strategy_unknown`;
10. `candidate_strategy_state_forbidden`;
11. `candidate_strategy_class_forbidden`;
12. `candidate_goal_not_active`;
13. `candidate_strategy_goal_forbidden`;
14. `candidate_action_missing`;
15. `candidate_action_duplicate`;
16. `candidate_action_unknown`;
17. `candidate_action_not_effective`;
18. `candidate_strategy_action_forbidden`; and
19. `candidate_action_limit_exceeded`.

A code must appear at most once per candidate. Unknown codes, free-form reasons, provider diagnostics, parser text, answer excerpts, and field values must not enter the public decision or trace.

### Deterministic comparison and tie behavior

For each eligible candidate, Hees.ai must compute one integer tuple by visiting `selection_policy.criteria` in its identity-bearing order. `goal_continuity` contributes the declared goal ordinal and `risk_intervention_severity` contributes the declared risk ordinal. Hees.ai must compare tuples lexicographically and prefer the lower tuple. The valid current-to-target state transition is a prerequisite to computing any tuple; it is never inferred from the candidate's prose, confidence, or explanation.

If exactly one eligible candidate has the uniquely lowest tuple, selection state must be `selected`, reason must be `candidate_selected`, and Hees.ai must return an opaque selected-candidate capability bound to the complete package identity, envelope identity, trusted frame, and exact candidate value.

If no candidate is eligible, selection state must be `none` and reason must be `no_eligible_candidate`. If two or more eligible candidates share the uniquely best tuple, selection state must be `ambiguous` and reason must be `selection_ambiguous`. Hees.ai must not break a tie with candidate order, candidate identifier, answer bytes, support, provider identity, random data, wall-clock time, model score, rubric score, or an undeclared fallback.

### Selection result, trace, and authority

The public selection result must contain:

- `selection_state`, exactly `selected`, `none`, `ambiguous`, or `invalid`;
- one stable reason from the closed table below;
- the complete trusted package identity when safely established;
- `envelope_id` and `envelope_revision` when safely established;
- optional `selected_candidate_id`, present only for `selected`; and
- bounded candidate decisions in exact parsed candidate-ID order when complete-set validation permits per-candidate evaluation.

Selection reasons belong to namespace `behavior_selection_0_1`. The selection reasons and their unique selection-state mappings are exactly the following nine values:

| Reason | Selection state |
| --- | --- |
| `candidate_selected` | `selected` |
| `no_candidates` | `none` |
| `no_eligible_candidate` | `none` |
| `selection_ambiguous` | `ambiguous` |
| `invalid_behavior_envelope` | `invalid` |
| `package_identity_mismatch` | `invalid` |
| `invalid_candidate_set` | `invalid` |
| `candidate_limit_exceeded` | `invalid` |
| `duplicate_candidate_id` | `invalid` |

When multiple global conditions apply, Hees.ai must choose one public reason in this exact precedence: `invalid_behavior_envelope`, `package_identity_mismatch`, `invalid_candidate_set`, `candidate_limit_exceeded`, `duplicate_candidate_id`, `no_candidates`, `no_eligible_candidate`, `selection_ambiguous`, then `candidate_selected`. Candidate and collection iteration order must not alter that choice.

The public result and trace are explainable data but do not themselves grant behavioral authority to a later Hees.ai operation. Only the direct opaque selected-candidate capability returned beside a `selected` result may enter RFC 009. Hees.ai must expose no public constructor or deserializer that upgrades a caller-created result, trace, package tuple, or candidate into that capability.

### Bounds and allocation

The RFC 005 profile resource envelope must define exact ceilings for behavior-member bytes, parser nesting and tokens, every identifier and revision, each declaration array, states, transitions per state, strategies, allowlist entries per strategy, selection criteria, candidates per set, actions per candidate, complete candidate-set bytes, public trace entries, and retained opaque-capability state.

Hees.ai must enforce the profile candidate-set byte ceiling before parsing and every profile collection ceiling before proportional allocation. All count arithmetic must use the RFC 005 exact-integer domain and checked arithmetic. A package cannot select lower resource limits because the exact resource envelope belongs to its closed profile contract.

An implementation may register this profile only when its resource envelope declares those exact ceilings together with conformance fixtures, maximum-size evidence, retained-state accounting, and cross-runtime results. Deployment RSS, model coexistence, and device-specific latency remain recorded deployment measurements rather than public selection reasons.

## Design details

### Relationship to RFC 000

RFC 000 reserves terminal authority for Spectrum and one governed visible-response channel. This RFC selects only a package-admitted behavioral frame and cannot carry answer prose, provenance, or a terminal response decision.

### Relationship to RFC 001

Spectrum consumes only the direct opaque selected-candidate capability returned by this RFC. The public selection trace is explanatory and cannot be upgraded into behavioral or terminal authority.

### Relationship to RFC 005

RFC 005 owns the exact binary member wire, descriptor order, member digest and length commitments, package topology, `AdmittedPackageIdentity`, sequential admission, profile resource envelopes, and atomic package completion. RFC 008 owns only the `behavior_envelope` payload schema, its local and package-action references, and behavior selection after package admission.

A package may omit the behavior member only when it does not use RFC 008 selection. RFC 009 response governance requires both an admitted behavior envelope and an admitted response contract. A response contract without a behavior envelope must fail RFC 005 cross-member validation.

### Relationship to RFC 007

RFC 008 does not consume verifier findings. Findings evaluate selected visible response content after behavior selection and remain non-authoritative under RFC 007. A package must not smuggle verifier thresholds, finding status, confidence, or provider identity into a behavior selection criterion.

### Relationship to RFC 009

RFC 009 owns proposal and package claims at the untrusted response boundary, visible answer units, typed support, synthesis requirements, finding composition, repair state, clarification, and terminal response admission. RFC 008 supplies only the direct opaque selected-candidate capability and its bounded trace. RFC 009 must not reconstruct selection authority from the trace or rerank the candidates.

### Relationship to RFC 006

RFC 006 does not define a behavior-selection receipt. A later proposal-admission receipt may project the final RFC 009 outcome, but it must not export the complete behavior trace, rejected candidates, behavior classes, strategies, state graph, or comparison tuple. Selection explainability remains a bounded runtime result or separately governed operator trace.

### Stable evolution

Adding a behavior field, class dimension, comparison criterion, selection state, public reason, candidate-violation code, or alternate tie behavior changes the exact contract and requires a new behavior-envelope contract version. Unknown values must fail closed. Implementations must not ignore extensions, infer aliases, or apply compatibility normalization.

## Alternatives considered

### Let each provider select its preferred candidate

Rejected because provider-specific scores and ordering would become implicit governance authority and identical package inputs could produce incompatible selections.

### Preserve the first candidate on a tie

Rejected because it makes input iteration order authoritative and violates the required permutation stability.

### Evaluate only the configured prefix

Rejected because an attacker or adapter could change the outcome by reordering candidates around the prefix boundary. A complete over-bound set fails before eligibility evaluation.

### Use candidate identifiers as the final tiebreaker

Rejected because identifiers are caller-controlled identity, not package-declared quality. Lexical ordering is permitted for trace stability only.

### Accept model or rubric scores

Rejected because an untrusted candidate could promote itself. Any future evaluator-derived ranking requires its own typed non-authoritative finding and an explicit package policy under a new contract.

### Cap an overlong action list

Rejected because the capped subset is not the candidate that was proposed. The complete candidate is ineligible.

### Include answer text in the behavior candidate

Rejected because it would couple structural behavior selection to visible-response admission and could let text or hidden support influence selection before RFC 007 and RFC 009 checks.

### Generate a fallback candidate when none passes

Rejected because fallback behavior would be newly authored output rather than selection. RFC 009 may return a package-authored clarification or closed rejection, but RFC 008 does not invent a candidate.

## Drawbacks

Packages must declare and validate more structure than the current action-only runtime contract. Strict whole-set validation can reject a batch even when an early candidate would otherwise pass. Requiring a unique comparison key means two behaviorally equivalent candidates cannot be distinguished by prose quality in this contract. The opaque authority boundary requires callers to preserve a direct Hees.ai value rather than reconstructing state from serialized data. The closed profile resource envelope and RFC 005 artifact-version rules make resource and evolution obligations explicit.

## Layers affected

- **Package contract:** A new canonical behavior-envelope member, package-action references, topology dependency, and inherited package identity.
- **Runtime authority:** Trusted frame construction, complete-set validation, candidate eligibility, deterministic comparison, and opaque selected-candidate capability.
- **Compatibility:** Closed contract versions, reasons, candidate violations, order rules, tie behavior, and cross-runtime golden outcomes.
- **Tracing:** Bounded non-authoritative selection results and canonical candidate-decision order.
- **Documentation:** Public explanation of the package/provider/runtime boundary and its relationship to visible-response governance.

## Design Decisions

- Behavior selection and visible-response admission are separate public contracts.
- The behavior envelope is committed by RFC 005 package identity and cannot be supplied as a mutable runtime sidecar.
- Candidate behavior contains no answer, support, finding, score, terminal action, repair state, or clarification text.
- Complete candidate sets are validated before eligibility; over-bound sets are rejected rather than truncated.
- Overlong action lists are ineligible as wholes and are never capped into a different candidate.
- Selection uses only package-declared fixed criteria and requires a unique best tuple.
- Candidate input order and candidate identifiers never decide the winner.
- Candidate eligibility requires a valid declared state transition and an active package-declared goal; selection then compares only declared goal continuity and risk/intervention severity.
- Remaining ties fail closed with `selection_ambiguous`.
- No selected capability exists when the envelope, package binding, or candidate set is invalid or when no unique eligible winner exists.
- Only the direct opaque selected-candidate capability carries authority into RFC 009; the public trace does not.
- RFC 008 defines no receipt kind and does not export behavior selection through RFC 006.
- The behavior and response members are part of RFC 005 artifact contract `0.1`'s closed profile topology.
