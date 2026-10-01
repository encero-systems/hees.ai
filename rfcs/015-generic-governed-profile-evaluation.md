# RFC 015: Generic Governed Profile Evaluation

- **Status:** Draft
- **Created:** 2026-08-19
- **Author(s):** Encero Systems
- **Related:**
    - RFC 000 (Foundational Governance Authority) — this RFC is a narrower, simpler realization of RFC 000's authority model, not a claim of full conformance; see [Relationship to RFC 000](#relationship-to-rfc-000)
    - RFC 001 (Spectrum Terminal Adjudication) — same relationship, narrower; no repair, no constraint composability, no behavior envelopes
    - RFC 002 (Content DNA Answer-Time Provenance) — `GovernedContentDna` is inspired by, and structurally close to, RFC 002's entry shape, but is a single simpler state, not RFC 002's `admitted_answer`/`no_answer` pair
    - RFC 006 (Export-Safe Governance Receipts) — `GovernedReceipt` is a single-kind simplification of RFC 006's four-kind receipt system
    - RFC 010 (Hees.ai Console) — `console_profile_0_1` is the existing bounded, fixed-package instance of this pattern; this RFC generalizes that pattern beyond one fixed package
    - RFC 013 (Governed Continuity), RFC 014 (Governed Memory Lifecycle Operations) — sibling kernels with no structural dependency on this one
- **Issue:** https://github.com/encero-systems/hees.ai/issues/37
- **RFC PR:** —
- **Written against:** Hees.ai 0.0.1 / Incan 0.6.0-dev.6
- **Shipped in:** —

## Summary

Hees.ai should offer one generic, package-neutral function that evaluates a proposed governed interaction end to end: validate package/request/proposal identity, delegate structural admission (declared action, reviewed evidence) to the existing Hees.ai 0.0.1 kernel, validate bounded non-authoritative committee observations against package-declared coverage, resolve selected memory and optional guided material, derive one admitted decision (`deliver`/`refuse`/`escalate`) from the package-declared action's outcome kind or `reject` with a specific reason, and — for a delivered answer — atomically construct a redacted Content DNA and receipt from exactly the resolved selected memory. This generalizes the five-outcome-kind interaction shape of `console_profile_0_1` so any package can use it without bespoke per-package evaluation code.

## Core model

1. **The package declares actions, evidence, memory, guided material, and policy.** A `GovernedProfilePackage` binds a bounded `GovernedAction` list (each with a declared `GovernedOutcomeKind` and whether it requires evidence/committee review), a `GovernedEvidence` list, a `GovernedMemory` list, optional `GuidedMaterial`, and a `GovernedPolicy` (constraint-plan identity, a non-empty set of package-wide committee roles, and `require_all_passed`, which contract 0.1 requires to be `true`).
2. **The caller proposes; Hees.ai decides.** A caller assembles an untrusted `GovernedRequest`/`GovernedProposal` pair plus a bounded list of `CommitteeObservation`s. `evaluate_governed_profile_with_artifacts` validates them and returns exactly one `CompleteGovernedEvaluation`.
3. **Structural admission reuses the existing kernel, not a reimplementation.** The already-implemented Hees.ai 0.0.1 `admit_model_proposal` boundary (declared-action and reviewed-evidence checking) is called directly as this function's structural-admission stage (step 5 below).
4. **Committee observations remain non-authoritative findings.** Exact role coverage, exact identity binding to the package/request/proposal, and one of three verdict classes (`Pass`/`Fail`/`Uncertain`) are validated, but the committee cannot itself decide the terminal outcome — a `Fail` or `Uncertain` verdict rejects the proposal, but nothing a committee observes can *admit* one.
5. **The terminal decision is package-declared, not model-chosen.** `deliver`/`refuse`/`escalate` is derived entirely from the matched action's declared `GovernedOutcomeKind` — never from proposal content, model confidence, or committee wording. Any failed stage yields `reject`.
6. **Content DNA and the receipt are atomic with delivery.** For a `deliver` outcome, Content DNA is constructed first from exactly the resolved selected memory; only on success is a receipt constructed referencing it. Either construction failing means no answer is exposed — `evaluate_governed_profile_with_artifacts` never returns `admitted_visible_output` without both artifacts (or, for `refuse`/`escalate`, without at least a receipt).
7. **Refusal and escalation text is package-declared.** A `Refusal` or `Escalation` action declares its own reviewed `boundary_text`. A proposal for such an action carries no visible output of its own; an admitted `refuse` or `escalate` delivers the package's `boundary_text`, and its receipt records that the text came from the package. Model prose is never shown on a boundary outcome.

## Motivation

Every governed package that wants a Hees.ai-decided outcome — not just `console_profile_0_1`'s one fixed Build Week package — currently needs bespoke evaluation code around the generic 0.0.1 kernel call. That code has to independently reinvent committee-observation validation, memory resolution, guided-material projection, terminal-decision derivation, Content DNA construction, and receipt construction — each a place two implementations could quietly disagree, and each already specified in detail (if elaborately) by RFC 001/002/006/007/008/009.

A *deliberately narrower* generalization — five outcome kinds, one committee pass, one Content DNA state, one receipt kind — covers answering from reviewed material, presenting and navigating package-owned guided material, refusing, and escalating, without first requiring RFC 001's full constraint-composability, repair, or behavior-envelope machinery to be built and accepted. This RFC proposes stabilizing that narrower shape as its own contract, explicit that it is not a claim of RFC 001/002/006 conformance.

## Goals

- Define `GovernedProfilePackage`, `GovernedRequest`, `GovernedProposal`, and `CommitteeObservation` as the complete untrusted/trusted input surface for one governed evaluation.
- Define `evaluate_governed_profile_with_artifacts` as a pure, deterministic function: same inputs always produce the same `CompleteGovernedEvaluation`.
- Require every stage (package/request/proposal validation, structural admission, committee assessment, memory resolution, guided-material projection, terminal decision, Content DNA, receipt) to run in a fixed order, each capable of independently rejecting.
- Require committee coverage to be exact: for any action that requires committee review, the observed role set must equal the package-wide `policy.required_roles` set, no more, no fewer, no duplicates — and every observation must bind to the exact package/request/proposal identity being evaluated.
- Require the admitted decision (`deliver`/`refuse`/`escalate`) to come only from the matched action's declared `GovernedOutcomeKind`.
- Require Content DNA and the receipt to be constructed only from data already resolved and validated by this same evaluation — never accepted pre-built from a caller, model, or package.
- Reuse the existing Hees.ai 0.0.1 `admit_model_proposal` kernel for structural admission rather than reimplementing declared-action/reviewed-evidence checking.
- Fail closed on every input: oversized collections, non-canonical identifiers, and identifiers of any valid length produce a terminal result, never a panic.

## Non-Goals

- Implementing RFC 001's full Spectrum contract: no constraint-plan composability (RFC 004), no claim-verification findings beyond a bounded committee pass (RFC 007), no behavior-envelope selection (RFC 008), no RFC 009's seven-variant response lifecycle or single-repair branch. This module has three admitted decisions plus `reject`, and no repair path at all.
- Implementing RFC 002's full Content DNA contract: no `no_answer` closed state (a rejected/non-deliver outcome simply has no Content DNA, rather than an explicit zero-entry representation), no `source_digests` field, no answer-binding digest scoped to "visible answer units" (this module hashes a one-field `{visible_output}` projection of the proposal's single visible string).
- Implementing RFC 006's full receipt contract: one receipt kind, not four; no `receipt_kind` discriminator; no `memory_state`/`constraint_execution` projections; a different, package-neutral-but-simpler field set (`candidate_digest`, `structural_reason`, `admitted_guided_material` are not RFC 006 fields).
- Implementing RFC 007's evidence-grounded claim verification. Committee assessment here is deliberately simple: exact coverage plus a three-way verdict, not target-premise claim checking.
- Retrieval, memory materialization, or model invocation. The caller resolves `memory_ids`/`evidence_ids` and supplies them on the proposal; this module only validates that they resolve inside the package.
- Persisting anything. Like RFC 013's continuity function, this is a pure evaluation; a caller-owned layer is responsible for whatever happens with the returned `CompleteGovernedEvaluation`.

## Guide-level explanation

A package declares its actions, evidence, memory, and policy. Its `profile_package_digest` and each memory atom's `provenance_digest` are not caller-chosen labels — `validate_governed_profile_package` recomputes and checks both, so a package is assembled in two phases: build it with a placeholder digest, stamp the real package digest, then stamp each memory atom's provenance digest against the stamped package. The identifiers below are invented for illustration:

```incan
action = GovernedAction(
    action_id=action_id("answer_from_package"),
    outcome_kind=GovernedOutcomeKind.Answer,
    evidence_required=true,
    committee_required=false,
    boundary_text=None,
)
refusal = GovernedAction(
    action_id=action_id("refuse_unsupported"),
    outcome_kind=GovernedOutcomeKind.Refusal,
    evidence_required=false,
    committee_required=false,
    boundary_text=Some("The reviewed Lantern Path package does not cover that request."),
)
unwitnessed = GovernedProfilePackage(
    contract_version=contract_id("governed_profile_package_0_1"),
    profile_id=profile_id("governed_profile_0_1"),
    package_id=package_id("lantern_path_lessons"),
    domain_id=domain_id("fictional_lesson_support"),
    package_revision=artifact_revision("0.1.0-candidate.1"),
    profile_package_digest=digest_id_type("sha256:0000000000000000000000000000000000000000000000000000000000000000"),
    mission="...",
    actions=[action, refusal],
    evidence=[...],
    memory=[...],
    guided_material=[],
    policy=GovernedPolicy(
        constraint_plan_id=constraint_plan_id("lantern_committee_policy"),
        constraint_plan_revision=revision("1.0.0"),
        required_roles=[committee_role_id("evidence_support")],
        require_all_passed=true,
    ),
)
mut package = unwitnessed.clone()
package.profile_package_digest = digest_governed_profile_package(unwitnessed)
# then stamp each memory atom: atom.provenance_digest = digest_governed_memory_provenance(package, atom)
```

A caller builds a request and proposal, then evaluates:

```incan
request = bind_governed_request(request_id("request_lantern"), "Which card should I start with?", "en", audience_id("general_audience"))
proposal = governed_proposal(
    package, request, proposal_id("proposal_lantern_answer"), action_id("answer_from_package"),
    "Start with the first Lantern Path card...",
    evidence_ids=[evidence_id("lantern_evidence_card_order")],
    memory_ids=[memory_id("lantern_atom_card_order")],
    guided_material_id=None,
    current_step_id=None,
    next_step_id=None,
)
result = evaluate_governed_profile_with_artifacts(package, request, proposal, observations=[])
# result.spectrum.decision == "deliver"
# result.content_dna_json and result.receipt_json are both Some(...)
```

The action above sets `committee_required=false`, so no observations are supplied. An action with `committee_required=true` needs exactly one observation per role in `policy.required_roles`, each built with `committee_observation` against the exact package, request, and proposal.

An action declared `Refusal` or `Escalation` still produces a receipt (so the outcome is exportable and verifiable) but no Content DNA, since no package material was delivered. Its proposal carries an empty `visible_output`; the evaluation delivers the action's package-declared `boundary_text` instead, and the receipt records `visible_output_source: "package_boundary_text"` with the digest of that text. A boundary proposal that carries any text of its own is rejected (`boundary_output_not_allowed`). A structural-admission failure, a committee `Fail`/`Uncertain` verdict, an unresolvable memory or guided-material reference, or an identity mismatch anywhere in the chain yields `reject` with a specific reason and, once the proposal's identity has been validated, still produces a receipt recording the rejection.

## Reference-level explanation

### Evaluation order

`evaluate_governed_profile_with_artifacts` validates in this fixed order, stopping at the first failure. Each rejection sets `spectrum.decision` to `reject` and `spectrum.reason` to the reason named below, in the `governed_profile_admission_0_1` reason namespace.

1. `validate_governed_profile_package(package)`. Every failure surfaces as reason `invalid_package`; a caller who wants the specific cause calls `validate_governed_profile_package` directly and reads `errors[0]`. Stages, in order:
    1. Header: `unsupported_package_contract` (contract must be `governed_profile_package_0_1`), `unsupported_profile` (profile must be `governed_profile_0_1`), `invalid_package_id`, `invalid_domain_id`, `invalid_package_revision`, `invalid_profile_package_digest`.
    2. Bounds, checked before any duplicate scan and before the digest is recomputed (see [Bounds](#bounds)): `invalid_mission`, `invalid_action_count`, `invalid_evidence_count`, `invalid_memory_count`, `invalid_guided_material_count`, `invalid_committee_role_count`, `invalid_memory_evidence_count`, `invalid_guided_memory_count`, `invalid_guided_evidence_count`, `invalid_guided_steps`, `invalid_guided_transition_count`.
    3. Digest: `package.profile_package_digest` is recomputed from every other package field, including each action's `boundary_text` and excluding each atom's `provenance_digest` (`digest_governed_profile_package`); a difference is `profile_package_digest_mismatch`.
    4. Uniqueness: `duplicate_action_id`, `duplicate_evidence_id`, `duplicate_memory_id`, `duplicate_guided_material_id`.
    5. Each action: `invalid_action_id`; for a `Refusal` or `Escalation` action, `terminal_boundary_action_requires_support` (it requires evidence or committee review), `boundary_text_missing` (it declares no `boundary_text`), and `boundary_text_invalid` (its `boundary_text` is blank or longer than the visible-output bound); for an `Answer`, `GuidedMaterial`, or `GuidedNavigation` action, `boundary_text_not_allowed` (it declares a `boundary_text`) and `deliverable_action_missing_evidence_requirement` (it does not require evidence).
    6. Each evidence record: `invalid_evidence_id`, `invalid_evidence_claim`, `invalid_evidence_guidance`, `invalid_evidence_source`, `invalid_source_fingerprint`, `invalid_evidence_language`, `evidence_not_admitted` (`review_state` must be `approved` and `rights_state` must be `allowed`), `invalid_evidence_authority`, `invalid_evidence_kind`.
    7. Each memory atom: `invalid_memory_id`, `invalid_memory_concept`, `duplicate_memory_evidence`, `unknown_memory_evidence`, `memory_not_admitted`, `invalid_memory_provenance`, `memory_provenance_mismatch` (the atom's `provenance_digest` must equal `digest_governed_memory_provenance` against the established package identity).
    8. Each guided material: `invalid_guided_material_identity`, `invalid_guided_material_language`, `guided_material_not_admitted`, `duplicate_guided_memory`, `duplicate_guided_evidence`, `unknown_guided_memory`, `unknown_guided_evidence`, `guided_memory_evidence_mismatch` (its evidence set must equal the evidence union of its memory), `unknown_guided_presentation_action`, `invalid_guided_presentation_action`, `unknown_guided_navigation_action`, `invalid_guided_navigation_action`, `duplicate_guided_step`, `unknown_guided_transition_step`, `self_guided_transition`, `duplicate_guided_transition`.
    9. Policy: `duplicate_committee_role`, `invalid_committee_role`, `unsupported_committee_policy` (`require_all_passed` must be `true`).
2. `validate_governed_request(request)`: `invalid_request` (`errors[0]` is `invalid_request_id`, `invalid_question`, `invalid_request_language`, or `invalid_request_audience`), then `request_digest_mismatch` when `request_digest` does not bind the exact request fields.
3. `validate_governed_proposal(package, request, proposal)`, in four parts:
    1. Identity (`validate_governed_proposal_identity`): `unsupported_proposal_contract`, `profile_id_mismatch`, `package_id_mismatch`, `domain_id_mismatch`, `package_revision_mismatch`, `profile_package_digest_mismatch`, `request_id_mismatch`, `request_digest_mismatch`, `invalid_proposal` (non-canonical `proposal_id`), `missing_visible_output` (longer than the bound), `proposal_reference_limit_exceeded` (more evidence or memory references than a package can hold). This `profile_package_digest_mismatch` compares the proposal's claimed digest with the package's `profile_package_digest` field; step 1 has already established that field is internally correct.
    2. Action resolution: `unknown_action`.
    3. Visible output, for the resolved action: a `Refusal` or `Escalation` proposal must carry an empty `visible_output` (`boundary_output_not_allowed` for any text, including whitespace); any other proposal must carry non-blank output (`missing_visible_output`).
    4. Nominations, for the resolved action: a non-guided action rejects any guided material or step nomination (`guided_material_not_allowed`); a guided action requires a declared guided material (`guided_material_required`, `unknown_guided_material`). Then references: `duplicate_evidence_reference`, `duplicate_memory_reference`, `unknown_evidence`, `unknown_memory`, `evidence_required` (an evidence-requiring action nominates no evidence or no memory), `memory_evidence_mismatch` (the evidence set must equal the evidence union of the nominated memory), `terminal_boundary_support_not_allowed` (a refusal or escalation nominates support). Then, for guided actions: `guided_material_language_mismatch`, `guided_material_audience_mismatch`, `guided_material_memory_mismatch`, `guided_material_evidence_mismatch`, `guided_material_action_mismatch`, and `invalid_guided_transition` (`errors[0]` is `unexpected_guided_transition` for a presentation naming steps, or `current_step_required`, `next_step_required`, or `transition_not_declared` for navigation).
4. (Defensive) the matched action is re-resolved; `unknown_action` is normally already returned by step 3.
5. Structural admission: delegates to the existing Hees.ai 0.0.1 `admit_model_proposal` kernel via a package/proposal projection (`action_contract`, `approved_evidence_record`, `governed_package`, `model_proposal`). The projected visible output is the text the result would deliver: the proposal's output, or the package's `boundary_text` for a refusal or escalation. A kernel rejection (for example `invalid_package` or `unknown_evidence`) surfaces as `structural_admission_rejected`, with the kernel's own reason carried in `structural_reason`; on success `structural_reason` is `admitted`. Every package that passes step 1 also passes the kernel's package validation, including its source-reference rule.
6. Committee assessment (`assess_committee`, detailed below): `committee_not_allowed`, `committee_coverage_invalid`, `unsupported_committee_contract`, `invalid_committee_observation`, `committee_identity_mismatch`, `committee_rejected`, `committee_uncertain`.
7. (Defensive) every `memory_ids` entry must resolve in the package (`selected_memory_invalid`).
8. (Defensive) a nominated `guided_material_id` must resolve in the package's declared guided material (`guided_material_projection_failed`).
9. The admitted decision is derived from the matched action's `outcome_kind` (below).
10. For `refuse`/`escalate`, a receipt is constructed (no Content DNA); a construction failure rejects with `receipt_projection_failed`. Only on success is `admitted_visible_output` returned, and it is the action's package-declared `boundary_text`.
11. For `deliver`, Content DNA is constructed first (`content_dna_projection_failed` on failure), then the receipt referencing it (`receipt_projection_failed` on failure); only both succeeding returns `admitted_visible_output`, which is the proposal's `visible_output`.

**Receipt boundary.** Once `validate_governed_proposal_identity` succeeds (step 3.1), every rejection, including the remaining step 3 checks, constructs and returns a receipt recording that rejection, except `receipt_projection_failed`. Before that point no receipt is attempted. This mirrors RFC 006's rule that package identity is exported only once safely known, though this module has no `PreNormalizationRejected`-style minimal body.

**Derived identifiers.** `decision_id` is derived from `proposal_id` by replacing a leading `proposal_` with `decision_` (or prefixing `decision_`). When that text is not a canonical identifier — because the proposal identifier is long or was constructed without validation — the decision identifier is `decision_` followed by the 64 hex characters of the SHA-256 digest of the exact proposal identifier text. Finding identifiers are derived from observation identifiers the same way (`observation_` to `finding_`). Derivation therefore never fails, on any rejection path.

### Bounds

Text lengths are measured with `len`. Blank means empty after trimming.

| Field | Bound |
| --- | --- |
| `actions` | 1 to 16 |
| `evidence` | 1 to 64 |
| `memory` | 1 to 64 |
| `guided_material` | 0 to 16 |
| `policy.required_roles` | 1 to 16 |
| memory atom `evidence_ids` | 1 to 8 |
| guided material `memory_ids` | 1 to 8 |
| guided material `evidence_ids` | 1 to 16 |
| guided material `steps` | 1 to 8 |
| guided material `transitions` | 0 to 56 (every distinct non-self edge between eight steps) |
| proposal `evidence_ids` / `memory_ids` | at most 64 each |
| `mission`, evidence `claim`/`guidance`, memory `concept` | not blank, at most 512 |
| evidence `source_kind`/`authority_class`/`evidence_kind` | not blank, at most 64 |
| evidence `source_ref` | 1 to 256 characters from `a-z 0-9 _ . / : -`; no `..`, `\`, `:/`, or leading `/` |
| `language` (evidence, guided material, request) | 2 to 16 characters from `a-z 0-9 -`, not starting with `-` or `_` |
| request `question` | not blank, at most 1024 |
| proposal `visible_output` | at most 4096; not blank for a deliverable action, empty for a refusal or escalation |
| action `boundary_text` | present, not blank, at most 4096 for a refusal or escalation; absent otherwise |
| symbolic identifiers (package, action, evidence, memory, request, proposal, observation, role, ...) | canonical lowercase identifiers of at most 128 characters |
| `package_revision`, guided `artifact_revision` | 1 to 64 lowercase revision characters starting with a digit |

### Committee assessment

`assess_committee` (in `governed_profile_committee.incn`) is a self-contained, single-pass validation:

- If the action does not require committee review, any supplied observation rejects (`committee_not_allowed`); zero observations is fine.
- If it does require review, the observed role set must exactly equal `package.policy.required_roles` — same length, no duplicates, no unrequired role (`committee_coverage_invalid`).
- Every observation must declare the exact expected observation contract (`unsupported_committee_contract`), carry a canonical `observation_id` and a well-formed `evaluator_fingerprint` digest (`invalid_committee_observation`), and its `profile_id`/`package_id`/`domain_id`/`package_revision`/`profile_package_digest`/`request_id`/`request_digest`/`candidate_digest` must exactly match the package/request/proposal being evaluated (`committee_identity_mismatch`). `candidate_digest` is computed by this module from the proposal (`digest_governed_proposal`), never accepted from the observation. A repeated `observation_id` is `committee_coverage_invalid`.
- Each observation is converted to a `GovernedFinding` (Hees.ai-owned, not the raw observation) carrying the observation's role and verdict as a `CommitteeVerdict`, plus the package's constraint-plan identity.
- Any `Fail` verdict rejects (`committee_rejected`); otherwise any `Uncertain` verdict rejects (`committee_uncertain`); otherwise the assessment is valid and the findings are returned for inclusion in the final `CompleteGovernedEvaluation`.

This realizes RFC 000's "providers nominate; they do not decide" principle for committee input specifically: an observation is converted into a Hees.ai-owned, package-bound finding before it can affect anything, and even then it can only ever *reject* — nothing about a committee observation can make an otherwise-inadmissible proposal deliverable.

### Terminal decision

```text
GovernedOutcomeKind.Refusal    -> decision "refuse",   reason "unsupported_by_package"
GovernedOutcomeKind.Escalation -> decision "escalate", reason "escalation_declared_by_package"
everything else (Answer, GuidedMaterial, GuidedNavigation)
                               -> decision "deliver",  reason "supported_by_package"
any failed stage               -> decision "reject",   reason <that stage's reason>
```

The admitted decision comes only from the package's own declared `outcome_kind` for the matched action — never from proposal text, evidence content, or committee findings (which can only reject, not redirect the decision). The reasons are domain-neutral: a package explains *why* it refuses or escalates through its own actions and copy, not through the reason vocabulary.

### Content DNA (`GovernedContentDna`)

For each memory atom in the resolved selected-memory list, and for each evidence identifier that atom declares, one `GovernedContentDnaEntry` is projected: `memory_id`, `evidence_id`, `source_ref`, `source_kind`, `source_fingerprint`, `provenance_digest`, `review_state`, `review_revision`, `rights_state`, `authority_class`, `evidence_kind`. `memory_id` and `provenance_digest` come from the memory atom; every other field comes from the resolved `GovernedEvidence` record. If any declared evidence identifier fails to resolve, the whole entry list is empty and `construct_governed_content_dna` returns `None` — deliberately fail-closed rather than a partial projection.

The `GovernedContentDnaBody` binds `contract_version` (`governed_content_dna_0_1`), `state` (`"admitted_delivery"` — the module's one and only state; there is no explicit `no_answer` counterpart, unlike RFC 002), the package identity, request id/digest, proposal id, a `candidate_digest` of the proposal, the Spectrum-like decision id/decision/reason, the constraint-plan identity, the entries, an `answer_digest` over a one-field `{visible_output}` projection of the proposal, and the optional admitted guided-material identity. `content_dna_id` is the tagged digest of that body under `hees.ai/profile-content-dna/v0` (see [Identity digests](#identity-digests)).

### Receipt (`GovernedReceipt`)

`GovernedReceiptBody` binds `contract_version` (`governed_profile_receipt_0_1`), `profile_id`, the package identity, request id/digest, proposal id, `candidate_digest`, the decision id/decision/`reason_namespace` (`governed_profile_admission_0_1`)/reason/`structural_reason`, `admitted_evidence_ids`, `selected_memory_ids`, optional `admitted_guided_material`, optional `content_dna_id` (present only for `deliver`), and the provenance of the delivered text: `visible_output_source` (a `GovernedVisibleOutputSource`: `admitted_proposal` for `deliver`, `package_boundary_text` for `refuse` and `escalate`) and `visible_output_digest`, the digest of the exact delivered text over its one-field `{visible_output}` projection. Both are absent for `reject`, which delivers no text. The receipt never carries the text itself. `receipt_id` is the tagged digest of that body under `hees.ai/profile-receipt/v0` — no separate envelope object distinct from `{body, receipt_id}`.

Content DNA and receipts cross the public boundary as JSON strings (`content_dna_json`, `receipt_json`). The `GovernedContentDna` and `GovernedReceipt` types are exported so callers can decode them; Hees.ai never accepts either as input.

### Identity digests

Every identity digest this module computes is SHA-256 over a type tag, a line feed, and the projection's JSON as rendered by the current Incan serializer (`digest_tagged_json`). Each projection type has its own tag, so the digest of one projection can never be presented as the digest of another even when their JSON is identical:

| Digest | Type tag |
| --- | --- |
| `profile_package_digest` (`digest_governed_profile_package`) | `hees.ai/profile-package/v0` |
| memory `provenance_digest` (`digest_governed_memory_provenance`) | `hees.ai/memory-provenance/v0` |
| `request_digest` (`bind_governed_request`) | `hees.ai/profile-request/v0` |
| `candidate_digest` (`digest_governed_proposal`) | `hees.ai/profile-proposal/v0` |
| Content DNA `answer_digest`, receipt `visible_output_digest` | `hees.ai/profile-answer/v0` |
| `content_dna_id` | `hees.ai/profile-content-dna/v0` |
| `receipt_id` | `hees.ai/profile-receipt/v0` |

These encodings are interim. They depend on the current serializer's JSON rendering and do not yet conform to RFC 011 structural identity; a later contract revision that adopts RFC 011 will change every digest above.

## Design details

### Relationship to RFC 000

This module realizes RFC 000's authority separation narrowly but faithfully: the package declares (actions, evidence, memory, guided material, policy), the caller proposes (untrusted request/proposal/observations), and one function decides — nothing else can. Content DNA and the receipt are constructed only inside that same function from already-validated state, matching RFC 000's rule that Hees.ai constructs Content DNA and terminal values from admitted inputs. What's absent from RFC 000's model here is its full generality: this module has no notion of retrieval-provider nomination (memory identifiers arrive pre-resolved on the proposal), no separate verifier-finding contract beyond committee observations, and no repair path.

### Relationship to RFC 001

RFC 001's Spectrum composes package, memory, constraint, behavior, and response state through a twelve-step deterministic order feeding seven possible terminal variants with a single permitted repair branch. This module's evaluation order (above) is a real but much shorter analog — eleven stages feeding three admitted decisions plus rejection, no repair, no constraint-plan composability beyond carrying a constraint-plan *identity* through to the receipt (RFC 004's actual composable-constraint adjudication is not implemented here at all). Calling this module "Spectrum" or claiming RFC 001 conformance would be inaccurate; it is a much-simplified Spectrum-shaped function for the five-outcome-kind package shape, not a competing or complete implementation of RFC 001.

### Relationship to RFC 002

`GovernedContentDna` entries map closely to RFC 002's entry table (same ten fields, plus `evidence_id` which RFC 002 does not have — this module ties entries to evidence records 1:many per memory atom, a modeling choice RFC 002 leaves to RFC 003/005). The body is structurally close to RFC 002's `admitted_answer` body but omits `source_digests` and has no `no_answer` counterpart state at all — a non-`deliver` decision simply has no Content DNA object, which is a real difference from RFC 002's explicit closed zero-entry representation. `answer_digest` here hashes one `visible_output` string rather than RFC 002's ordered "visible answer units" (this module has no notion of multiple visible units, citations, or RFC 009 support projection).

`provenance_digest` shares RFC 002's name but not its formula. RFC 002 digests a source-safe evidence projection (`memory_id`, `source_ref`, `source_kind`, `source_fingerprint`, `review_state`, `review_revision`, `rights_state`, `authority_class`, `evidence_kind`) plus package identity, and deliberately excludes memory text. Here `digest_governed_memory_provenance` binds the memory atom's own fields — `memory_id`, `concept`, `evidence_ids`, `review_state`, `review_revision`, `rights_state` — to the package identity (`package_id`, `domain_id`, `package_revision`, `profile_package_digest`), so it does cover the memory text in `concept`.

### Relationship to RFC 006

`GovernedReceipt` is a single-kind simplification of RFC 006's four-kind (`PackageAdmission`/`MemoryAdmission`/`ConstraintAdjudication`/`ProposalAdmission`) system — closest in spirit to `ProposalAdmission`, but with a different, package-neutral-but-simpler field set (no `receipt_kind` discriminator since there is only one; no `terminal.variant` matching RFC 009's seven variants, just the four-way `decision`; `candidate_digest` and `structural_reason` are fields RFC 006 does not define). It does not attempt RFC 006's full reason-namespace/diagnostic-allowlist machinery.

### Relationship to RFC 010 / `console_profile_0_1`

`console_profile_0_1` (implemented in the checked `0.0.1` library, per the top-level README) implements this pattern — profiles, evidence, memory, Training by Committee, governed interactions, terminal artifacts — for one fixed fictional Build Week package. This module is that pattern with the package itself as a runtime input instead of a hardcoded constant, so any package can use the same evaluation function. Whether RFC 010 comes to depend on this module, or the two remain independently evolving siblings, is an open question (see [Open questions](#open-questions)).

### Relationship to RFC 013 and RFC 014

Independent. This module never calls `evaluate_continuity` or `evaluate_memory_operation`, and neither of those calls this module. A caller may use all three together, but none has a structural dependency on another.

## Alternatives considered

### Wait for RFC 001/004/007/008/009 to reach Planned before building anything

Rejected: those RFCs are appropriately elaborate for the general case, but a package that only needs to answer, guide, refuse, and escalate should not wait for their full design to settle. A narrower subset serves that shape without weakening any of RFC 000's authority invariants.

### Call this module "Spectrum"

Rejected. Reusing RFC 001's name for a materially narrower contract (no repair, no constraint composability, no behavior envelopes) would misrepresent conformance and make future RFC 001 stabilization work confusing. This RFC uses its own vocabulary (`GovernedSpectrumResult` as a type name is an exception worth revisiting — see Open questions).

### Fold Content DNA and receipt construction into RFC 002/006 directly

Rejected for now. RFC 002/006 are Draft and unimplemented; retrofitting this module's simpler shapes into their schemas would require resolving the same conformance gaps (`no_answer` state, `source_digests`, receipt kinds) this RFC deliberately defers rather than papering over.

## Drawbacks

Three Draft RFCs (001, 002, 006) already claim ownership of the general shape of what this module does, and this RFC's relationship sections are, by necessity, "close to, but not," for all three — a reviewer has to hold several nuanced deltas in mind rather than one clean "implements RFC N" statement. Three admitted decisions (no repair, no clarification, no constraint composability) may not be enough for a future package with more complex response needs, at which point this module and RFC 001's eventual full implementation would need a real reconciliation rather than just living side by side. The single Content DNA state (no `no_answer` representation) means a non-`deliver` decision is silently provenance-free rather than explicitly marked as such.

## Layers affected

- **Public contract:** exported from the `governed_profile` facade and the library root:
    - types: `GovernedProfilePackage`, `GovernedAction`, `GovernedOutcomeKind`, `GovernedVisibleOutputSource`, `GovernedEvidence`, `GovernedMemory`, `GuidedMaterial`, `GuidedTransition`, `GovernedPolicy`, `GovernedRequest`, `GovernedProposal`, `CommitteeObservation`, `CommitteeVerdict`, `GovernedFinding`, `GovernedValidation`, `GovernedSpectrumResult`, `AdmittedGuidedMaterial`, `CompleteGovernedEvaluation`, `GovernedContentDna`, `GovernedReceipt`;
    - body types that only Hees.ai constructs, exported from the `governed_profile` facade but not from the library root: `GovernedContentDnaBody`, `GovernedContentDnaEntry`, `GovernedReceiptBody`, `GovernedPackageIdentity`. A caller reads their fields from a returned `GovernedContentDna` or `GovernedReceipt`;
    - functions: `validate_governed_profile_package`, `digest_governed_profile_package`, `digest_governed_memory_provenance`, `bind_governed_request`, `governed_proposal`, `committee_observation`, `digest_governed_proposal`, `evaluate_governed_profile_with_artifacts`, `evaluate_governed_profile_json`;
    - identifier namespaces: `ArtifactRevisionType`, `AudienceId`, `CommitteeRoleId`, `GuidedMaterialId`, `GuidedStepId` with their constructors and text projections.
- **Runtime validation:** Package/request/proposal identity validation, delegation to the existing 0.0.1 structural-admission kernel, committee-coverage validation, memory/guided-material resolution, terminal-decision derivation, atomic Content DNA + receipt construction.
- **Package compatibility:** Purely additive and opt-in, mirroring RFC 013/014.
- **Tests and documentation:** `tests/test_governed_profile_contract.incn` carries positive and fail-closed tests for every package, request, proposal, committee, and guided-material reason above, at-limit and one-over tests for every bound, receipt-boundary tests, and stale-digest mutation tests. Formal cross-implementation fixtures matching RFC 001/002/006's acceptance-obligations bar remain open work.

## Design Decisions

- Structural admission is delegated to the existing Hees.ai 0.0.1 kernel rather than reimplemented, and package validation accepts only source references the kernel also accepts.
- Committee observations become Hees.ai-owned findings before they can affect anything, and can only ever reject, not redirect, the terminal decision.
- The admitted decision is derived solely from the package-declared action's `outcome_kind`, with domain-neutral reasons.
- Content DNA is constructed before the receipt for a `deliver` outcome; either failing means nothing is exposed.
- A non-`deliver` outcome still produces a receipt (once proposal identity is validated) but never Content DNA.
- A `refuse` or `escalate` outcome delivers only the package's reviewed `boundary_text`, never model prose, and its receipt records that source and the delivered text's digest.
- This module deliberately does not claim RFC 001/002/006 conformance; every relationship section names its real deltas rather than asserting equivalence.
- `GovernedProfilePackage.profile_package_digest` and each `GovernedMemory.provenance_digest` are not caller-chosen labels: `validate_governed_profile_package` recomputes and checks both against the rest of the package's own content, so a package mutated after its digest was stamped fails closed instead of being evaluated under a stale identity.
- Every collection bound is checked before duplicate scans and digest recomputation, and derived identifiers never fail, so no input causes unbounded work or a panic.

## Open questions

- Should `GovernedSpectrumResult` be renamed to avoid implying RFC 001 conformance, given this module's real relationship to RFC 001 is "narrower analog," not "implementation"?
- Does RFC 010's eventual stabilization come to depend on this module (replacing `console_profile_0_1`'s bespoke evaluation with a call to `evaluate_governed_profile_with_artifacts`), or do they remain independent siblings?
- Should the single `"admitted_delivery"` Content DNA state gain an explicit `no_answer`-style counterpart for `refuse`/`escalate` outcomes, matching RFC 002, or is "simply absent" an acceptable permanent simplification?
- Should the [bounds](#bounds) above be frozen as part of contract 0.1, or remain implementation limits that a later contract revision may change?
