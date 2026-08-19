# RFC 015: Generic Governed Profile Evaluation

- **Status:** Draft
- **Created:** 2026-08-19
- **Author(s):** Encero Systems
- **Related:**
    - RFC 000 (Foundational Governance Authority) — this RFC is a narrower, simpler realization of RFC 000's authority model, not a claim of full conformance; see [Relationship to RFC 000](#relationship-to-rfc-000)
    - RFC 001 (Spectrum Terminal Adjudication) — same relationship, narrower; no repair, no constraint composability, no behavior envelopes
    - RFC 002 (Content DNA Answer-Time Provenance) — `GovernedContentDna` is inspired by, and structurally close to, RFC 002's entry shape, but is a single simpler state, not RFC 002's `admitted_answer`/`no_answer` pair
    - RFC 006 (Export-Safe Governance Receipts) — `GovernedReceipt` is a single-kind simplification of RFC 006's four-kind receipt system
    - RFC 010 (hees.ai console) — `console_profile_0_1` is the existing bounded, hardcoded instance of exactly this pattern; this RFC is that pattern generalized beyond one fixed package
    - RFC 013 (Governed Continuity), RFC 014 (Governed Memory Lifecycle Operations) — sibling generalizations from the same research spike, independent of this one
- **Issue:** https://github.com/encero-systems/hees.ai/issues/37
- **RFC PR:** —
- **Written against:** Hees.ai 0.0.1 / Incan 0.5.0-rc2
- **Shipped in:** —

## Summary

Hees.ai should offer one generic, package-neutral function that evaluates a proposed governed interaction end to end: validate package/request/proposal identity, delegate structural admission (declared action, reviewed evidence) to the existing Hees.ai 0.0.1 kernel, validate bounded non-authoritative committee observations against package-declared coverage, resolve selected memory and optional guided material, derive one of three terminal decisions (`deliver`/`refuse`/`escalate`) from the package-declared action's outcome kind, and — for a delivered answer — atomically construct a redacted Content DNA and receipt from exactly the resolved selected memory. This is the same proven five-outcome-kind interaction shape already running the sleep-learning demo and `console_profile_0_1`, generalized so any package can use it without bespoke per-package evaluation code.

## Core model

1. **The package declares actions, evidence, memory, guided material, and policy.** A `GovernedProfilePackage` binds a bounded `GovernedAction` list (each with a declared `GovernedOutcomeKind` and whether it requires evidence/committee review), a `GovernedEvidence` list, a `GovernedMemory` list, optional `GuidedMaterial`, and a `GovernedPolicy` (constraint-plan identity plus required committee roles).
2. **The caller proposes; Hees.ai decides.** A caller assembles an untrusted `GovernedRequest`/`GovernedProposal` pair plus a bounded list of `CommitteeObservation`s. `evaluate_governed_profile_with_artifacts` validates them and returns exactly one `CompleteGovernedEvaluation`.
3. **Structural admission reuses the existing kernel, not a reimplementation.** The already-implemented Hees.ai 0.0.1 `admit_model_proposal` boundary (declared-action and reviewed-evidence checking) is called directly as this function's first governed stage — this RFC does not duplicate that logic.
4. **Committee observations remain non-authoritative findings.** Exact role coverage, exact identity binding to the package/request/proposal, and one of three verdict classes (`Pass`/`Fail`/`Uncertain`) are validated, but the committee cannot itself decide the terminal outcome — a `Fail` or `Uncertain` verdict rejects the proposal, but nothing a committee observes can *admit* one.
5. **The terminal decision is package-declared, not model-chosen.** `deliver`/`refuse`/`escalate` is derived entirely from the matched action's declared `GovernedOutcomeKind` — never from proposal content, model confidence, or committee wording.
6. **Content DNA and the receipt are atomic with delivery.** For a `deliver` outcome, Content DNA is constructed first from exactly the resolved selected memory; only on success is a receipt constructed referencing it. Either construction failing means no answer is exposed — `evaluate_governed_profile_with_artifacts` never returns `admitted_visible_output` without both artifacts (or, for `refuse`/`escalate`, without at least a receipt).

## Motivation

Every governed package that wants a Hees.ai-decided outcome — not just the sleep-learning demo, not just `console_profile_0_1`'s one fixed Build Week package — currently needs bespoke evaluation code (as this customer-demo project's own `native_generation.rs`/`governed_admission.rs` write in Rust around the same generic 0.0.1 kernel call). That bespoke code has to independently reinvent committee-observation validation, memory resolution, guided-material projection, terminal-decision derivation, Content DNA construction, and receipt construction — each a place two implementations could quietly disagree, and each already specified in detail (if elaborately) by RFC 001/002/006/007/008/009.

This module was built as part of the same research spike as RFC 013/014 (`GOVERNED_CONTINUITY_HYPERQUANT_SPIKE_DECISION.md`, 2026-07-24) and is the working, tested proof that a *deliberately narrower* generalization — five outcome kinds, one committee pass, one Content DNA state, one receipt kind — is enough to serve the demo's actual five real actions (`answer_from_package`/`present_guided_card`/`navigate_guided_card`/`refuse_unsupported`/`escalate_clinical_request`) without needing RFC 001's full constraint-composability, repair, or behavior-envelope machinery to be built and accepted first. This RFC proposes stabilizing that narrower, already-proven shape as its own contract, explicit that it is not a claim of RFC 001/002/006 conformance.

## Goals

- Define `GovernedProfilePackage`, `GovernedRequest`, `GovernedProposal`, and `CommitteeObservation` as the complete untrusted/trusted input surface for one governed evaluation.
- Define `evaluate_governed_profile_with_artifacts` as a pure, deterministic function: same inputs always produce the same `CompleteGovernedEvaluation`.
- Require every stage (package/request/proposal validation, structural admission, committee assessment, memory resolution, guided-material projection, terminal decision, Content DNA, receipt) to run in a fixed order, each capable of independently rejecting.
- Require committee coverage to be exact: the observed role set must equal the package-declared required role set for that action, no more, no fewer, no duplicates — and every observation must bind to the exact package/request/proposal identity being evaluated.
- Require the terminal decision (`deliver`/`refuse`/`escalate`) to come only from the matched action's declared `GovernedOutcomeKind`.
- Require Content DNA and the receipt to be constructed only from data already resolved and validated by this same evaluation — never accepted pre-built from a caller, model, or package.
- Reuse the existing Hees.ai 0.0.1 `admit_model_proposal` kernel for structural admission rather than reimplementing declared-action/reviewed-evidence checking.

## Non-Goals

- Implementing RFC 001's full Spectrum contract: no constraint-plan composability (RFC 004), no claim-verification findings beyond a bounded committee pass (RFC 007), no behavior-envelope selection (RFC 008), no RFC 009's seven-variant response lifecycle or single-repair branch. This module has exactly three terminal decisions and no repair path at all.
- Implementing RFC 002's full Content DNA contract: no `no_answer` closed state (a rejected/non-deliver outcome simply has no Content DNA, rather than an explicit zero-entry representation), no `source_digests` field, no answer-binding digest scoped to "visible answer units" (this module hashes the proposal's single `visible_output` string directly).
- Implementing RFC 006's full receipt contract: one receipt kind, not four; no `receipt_kind` discriminator; no `memory_state`/`constraint_execution` projections; a different, package-neutral-but-simpler field set (`candidate_digest`, `structural_reason`, `admitted_guided_material` are not RFC 006 fields).
- Implementing RFC 007's evidence-grounded claim verification. Committee assessment here is deliberately simple: exact coverage plus a three-way verdict, not target-premise claim checking.
- Retrieval, memory materialization, or model invocation. The caller resolves `memory_ids`/`evidence_ids` and supplies them on the proposal; this module only validates that they resolve inside the package.
- Persisting anything. Like RFC 013's continuity function, this is a pure evaluation; a caller-owned layer is responsible for whatever happens with the returned `CompleteGovernedEvaluation`.

## Guide-level explanation

A package declares its actions, evidence, and policy:

```incan
action = GovernedAction(
    action_id=action_id("answer_from_package"),
    outcome_kind=GovernedOutcomeKind.Answer,
    evidence_required=true,
    committee_required=false,
)
package = GovernedProfilePackage(
    profile_id=profile_id("governed_profile_0_1"),
    package_id=package_id("sleep_learning_demo"),
    domain_id=domain_id("sleep_learning"),
    package_revision=revision("0.2.0-candidate.2"),
    artifact_digest=digest_id("sha256:..."),
    mission="...",
    actions=[action],
    evidence=[...],
    memory=[...],
    guided_material=[],
    policy=GovernedPolicy(constraint_plan_id=..., constraint_plan_revision=..., required_roles=[]),
)
```

A caller builds a request and proposal, then evaluates:

```incan
request = bind_governed_request(package, "How can morning light affect my sleep?", "en", "general_adult_learner")
proposal = governed_proposal(
    package, request, action_id("answer_from_package"),
    "Morning light helps anchor your body's daily rhythm...",
    evidence_ids=[evidence_id("sleep_evidence_morning_light")],
    memory_ids=[memory_id("sleep_atom_morning_light")],
    guided_material_id=None,
)
result = evaluate_governed_profile_with_artifacts(package, request, proposal, observations=[])
# result.spectrum.decision == "deliver"
# result.content_dna_json and result.receipt_json are both Some(...)
```

An action declared `Refusal` or `Escalation` still produces a receipt (so the outcome is exportable and verifiable) but no Content DNA, since nothing was delivered. A structural-admission failure, a committee `Fail`/ `Uncertain` verdict, an unresolvable memory or guided-material reference, or an identity mismatch anywhere in the chain rejects with a specific reason and, once package/request/proposal identity is safely established, still produces a receipt recording the rejection.

## Reference-level explanation

### Evaluation order

`evaluate_governed_profile_with_artifacts` validates in this fixed order, stopping at the first failure:

1. `validate_governed_profile_package(package)` — structural package validity (unique action/evidence/memory/guided-material identifiers, non-empty required fields; not detailed further here, see source).
2. `validate_governed_request(request)` — structural request validity.
3. `validate_governed_proposal(package, request, proposal)` — proposal/package/request identity binding (`profile_id_mismatch`, `package_id_mismatch`, `domain_id_mismatch`, `package_revision_mismatch`, `artifact_digest_mismatch`, `request_id_mismatch`, `request_digest_mismatch`, `unsupported_proposal_contract`), evidence/memory reference validity (`unknown_evidence`, `unknown_memory`, `duplicate_evidence_reference`, `duplicate_memory_reference`, `memory_evidence_mismatch`), guided-material reference validity (`unknown_guided_material`, `guided_material_required`, `guided_material_not_allowed`, `terminal_boundary_support_not_allowed`), and basic proposal shape (`missing_visible_output`, `invalid_proposal`, `invalid_package`, `invalid_request`).
4. The proposal's `action_id` must resolve in the package (`unknown_action`).
5. Structural admission: delegates to the existing Hees.ai 0.0.1 `admit_model_proposal` kernel via a package/proposal projection (`action_contract`, `approved_evidence_record`, `governed_package`, `model_proposal`). Its rejection reason (e.g. `unsupported_proposal`) surfaces as `structural_admission_rejected`, with the kernel's own reason carried in `structural_reason`.
6. Committee assessment (`assess_committee`, detailed below) — `committee_not_allowed` (observations supplied for an action that doesn't require committee review), `committee_coverage_invalid` (role set mismatch or duplicate observation), `unsupported_committee_contract`, `committee_identity_mismatch`, `committee_rejected` (any `Fail` verdict), `committee_uncertain` (any `Uncertain` verdict, checked only once no `Fail` is present).
7. Every `memory_ids` entry must resolve in the package (`selected_memory_invalid`).
8. If `guided_material_id` is present, it must resolve in the package's declared guided material (`guided_material_projection_failed`).
9. The terminal decision is derived from the matched action's `outcome_kind` (below).
10. For `refuse`/`escalate`, a receipt is constructed (no Content DNA); a construction failure rejects with `receipt_projection_failed`.
11. For `deliver`, Content DNA is constructed first (`content_dna_projection_failed` on failure), then the receipt referencing it (`receipt_projection_failed` on failure); only both succeeding returns `admitted_visible_output`.

Once package/request/proposal identity is safely established (step 3 succeeds), every later rejection still constructs and returns a receipt recording that rejection — mirroring RFC 006's "package object required once identity is safely known" principle, though this module has no `PreNormalizationRejected`-style distinct minimal body; a receipt without identity is simply not attempted (`rejected_without_receipt`).

### Committee assessment

`assess_committee` (in `governed_profile_committee.incn`) is a self-contained, single-pass validation:

- If the action does not require committee review, any supplied observation rejects (`committee_not_allowed`); zero observations is fine.
- If it does require review, the observed role set must exactly equal `package.policy.required_roles` — same length, no duplicates, no unrequired role (`committee_coverage_invalid`).
- Every observation must declare the exact expected observation contract, and its `profile_id`/`package_id`/ `domain_id`/`package_revision`/`artifact_digest`/`request_id`/`request_digest`/`candidate_digest` must exactly match the package/request/proposal being evaluated (`unsupported_committee_contract`, `committee_identity_mismatch`). `candidate_digest` is computed by this module from the proposal (`digest_governed_proposal`), never accepted from the observation.
- Each observation is converted to a `GovernedFinding` (Hees.ai-owned, not the raw observation) carrying the observation's role and verdict, plus the package's constraint-plan identity.
- Any `Fail` finding rejects (`committee_rejected`); otherwise any `Uncertain` finding rejects (`committee_uncertain`); otherwise the assessment is valid and the findings are returned for inclusion in the final `CompleteGovernedEvaluation`.

This realizes RFC 000's "providers nominate; they do not decide" principle for committee input specifically: an observation is converted into a Hees.ai-owned, package-bound finding before it can affect anything, and even then it can only ever *reject* — nothing about a committee observation can make an otherwise-inadmissible proposal deliverable.

### Terminal decision

```text
GovernedOutcomeKind.Refusal    -> decision "refuse",   reason "unsupported_by_package"
GovernedOutcomeKind.Escalation -> decision "escalate",  reason "clinical_authority_not_declared"
everything else (Answer, GuidedMaterial, GuidedNavigation)
                                -> decision "deliver",  reason "supported_by_package"
```

The decision comes only from the package's own declared `outcome_kind` for the matched action — never from proposal text, evidence content, or committee findings (which can only reject, not redirect the decision).

### Content DNA (`GovernedContentDna`)

For each memory atom in the resolved selected-memory list, and for each evidence identifier that atom declares, one `GovernedContentDnaEntry` is projected: `memory_id`, `evidence_id`, `source_ref`, `source_kind`, `source_fingerprint`, `provenance_digest` (from the memory atom itself), `review_state`, `review_revision`, `rights_state`, `authority_class`, `evidence_kind` (the last seven from the resolved `GovernedEvidence` record). If any declared evidence identifier fails to resolve, the whole entry list is empty and `construct_governed_content_dna` returns `None` — deliberately fail-closed rather than a partial projection.

The `GovernedContentDnaBody` binds `contract_version` (`governed_content_dna_0_1`), `state` (`"admitted_delivery"` — the module's one and only state; there is no explicit `no_answer` counterpart, unlike RFC 002), the package identity, request id/digest, proposal id, a `candidate_digest` of the proposal, the Spectrum-like decision id/decision/reason, the constraint-plan identity, the entries, and an `answer_digest` over the proposal's `visible_output` string. `content_dna_id` is `sha256:` over the canonical JSON of that body.

### Receipt (`GovernedReceipt`)

`GovernedReceiptBody` binds `contract_version` (`governed_profile_receipt_0_1`), `profile_id`, the package identity, request id/digest, proposal id, `candidate_digest`, the decision id/decision/`reason_namespace` (`governed_profile_admission_0_1`)/reason/`structural_reason`, `admitted_evidence_ids`, `selected_memory_ids`, optional `admitted_guided_material`, and optional `content_dna_id` (present only for `deliver`). `receipt_id` is `sha256:` over the canonical JSON of that body — no separate envelope object distinct from `{body, receipt_id}`.

## Design details

### Relationship to RFC 000

This module realizes RFC 000's authority separation narrowly but faithfully: the package declares (actions, evidence, memory, guided material, policy), the caller proposes (untrusted request/proposal/observations), and one function decides — nothing else can. Content DNA and the receipt are constructed only inside that same function from already-validated state, matching RFC 000's "Hees.ai constructs the projection" invariant. What's absent from RFC 000's model here is its full generality: this module has no notion of retrieval-provider nomination (memory identifiers arrive pre-resolved on the proposal), no separate verifier-finding contract beyond committee observations, and no repair path.

### Relationship to RFC 001

RFC 001's Spectrum composes package, memory, constraint, behavior, and response state through a twelve-step deterministic order feeding seven possible terminal variants with a single permitted repair branch. This module's evaluation order (above) is a real but much shorter analog — nine-ish stages feeding exactly three terminal decisions, no repair, no constraint-plan composability beyond carrying a constraint-plan *identity* through to the receipt (RFC 004's actual composable-constraint adjudication is not implemented here at all). Calling this module "Spectrum" or claiming RFC 001 conformance would be inaccurate; it is better understood as evidence that a much-simplified Spectrum-shaped function is sufficient for the five-outcome-kind package shape this demo project has used throughout, not as a competing or complete implementation of RFC 001.

### Relationship to RFC 002

`GovernedContentDna` entries map closely to RFC 002's entry table (same ten fields, plus `evidence_id` which RFC 002 does not have — this module ties entries to evidence records 1:many per memory atom, a modeling choice RFC 002 leaves to RFC 003/005). The body is structurally close to RFC 002's `admitted_answer` body but omits `source_digests` and has no `no_answer` counterpart state at all — a non-`deliver` decision simply has no Content DNA object, which is a real difference from RFC 002's explicit closed zero-entry representation. `answer_digest` here hashes one plain `visible_output` string rather than RFC 002's ordered "visible answer units" (this module has no notion of multiple visible units, citations, or RFC 009 support projection).

### Relationship to RFC 006

`GovernedReceipt` is a single-kind simplification of RFC 006's four-kind (`PackageAdmission`/`MemoryAdmission`/`ConstraintAdjudication`/`ProposalAdmission`) system — closest in spirit to `ProposalAdmission`, but with a different, package-neutral-but-simpler field set (no `receipt_kind` discriminator since there is only one; no `terminal.variant` matching RFC 009's seven variants, just the three-way `decision`; `candidate_digest` and `structural_reason` are fields RFC 006 does not define). It does not attempt RFC 006's full reason-namespace/diagnostic-allowlist machinery.

### Relationship to RFC 010 / `console_profile_0_1`

`console_profile_0_1` (shipped, per the top-level README) already implements exactly this pattern — profiles, evidence, memory, Training by Committee, governed interactions, terminal artifacts — for one fixed fictional Build Week package. This module is that same pattern with the package itself as a runtime input instead of a hardcoded constant, so any package can use the same evaluation function. A careful reconciliation between this RFC and RFC 010's eventual stabilization (does RFC 010 come to depend on this module, or do they remain independently-evolving siblings that happen to share a design) is real remaining work — see [Open questions](#open-questions).

### Relationship to RFC 013 and RFC 014

Independent. This module never calls `evaluate_continuity` or `evaluate_memory_operation`, and neither of those calls this module. All three came out of the same research spike and are commonly deployed together (as this demo's Rust caller layer does), but none has a structural dependency on another.

## Alternatives considered

### Wait for RFC 001/004/007/008/009 to reach Planned before building anything

Rejected by the original spike, and still rejected here: those RFCs are appropriately elaborate for the general case, but the sleep-learning demo (and `console_profile_0_1` before it) needed a working governed-interaction path months before that full design could be settled and implemented. This module is the evidence that a narrower subset is enough for real, running, tested product use today, without weakening any of RFC 000's authority invariants in the process.

### Call this module "Spectrum"

Rejected. Reusing RFC 001's name for a materially narrower contract (no repair, no constraint composability, no behavior envelopes) would misrepresent conformance and make future RFC 001 stabilization work confusing. This RFC uses its own vocabulary (`GovernedSpectrumResult` as a type name is an unfortunate pre-existing exception worth revisiting — see Open questions).

### Fold Content DNA and receipt construction into RFC 002/006 directly

Rejected for now. RFC 002/006 are Draft and unimplemented; retrofitting this module's simpler shapes into their schemas would require resolving the same conformance gaps (`no_answer` state, `source_digests`, receipt kinds) this RFC deliberately defers rather than papering over.

## Drawbacks

Three real Draft RFCs (001, 002, 006) already claim ownership of the general shape of what this module does, and this RFC's own relationship sections are, by necessity, "close to, but not," for all three — a reviewer has to hold several nuanced deltas in mind rather than one clean "implements RFC N" statement. The three-outcome-kind terminal decision (no repair, no clarification, no constraint composability) may not be enough for a future package with genuinely more complex response needs, at which point this module and RFC 001's eventual full implementation would need a real reconciliation rather than just living side by side. The single Content DNA state (no `no_answer` representation) means a non-`deliver` decision is silently provenance-free rather than explicitly marked as such.

## Layers affected

- **Public contract:** New `GovernedProfilePackage`, `GovernedRequest`, `GovernedProposal`, `CommitteeObservation`, `GovernedAction`, `GovernedEvidence`, `GovernedMemory`, `GuidedMaterial`, `GovernedPolicy`, `CompleteGovernedEvaluation`, `GovernedContentDna`, `GovernedReceipt` types (and their nested bodies); new `evaluate_governed_profile_with_artifacts`/`evaluate_governed_profile_json` public functions, exported through the `governed_profile.incn` facade.
- **Runtime validation:** Package/request/proposal identity validation, delegation to the existing 0.0.1 structural-admission kernel, committee-coverage validation, memory/guided-material resolution, terminal-decision derivation, atomic Content DNA + receipt construction.
- **Package compatibility:** Purely additive and opt-in, mirroring RFC 013/014.
- **Tests and documentation:** The reference implementation already carries positive and fail-closed tests (implied by the repo's `make test` gate covering this module — not independently re-verified line-by-line for this RFC beyond the 61/61 pass confirmed when `ba4e24a` was committed); formal cross-implementation fixtures matching RFC 001/002/006's acceptance-obligations bar remain open work.

## Design Decisions

- Structural admission is delegated to the existing Hees.ai 0.0.1 kernel rather than reimplemented.
- Committee observations become Hees.ai-owned findings before they can affect anything, and can only ever reject, not redirect, the terminal decision.
- The terminal decision is derived solely from the package-declared action's `outcome_kind`.
- Content DNA is constructed before the receipt for a `deliver` outcome; either failing means nothing is exposed.
- A non-`deliver` outcome still produces a receipt (once identity is safely established) but never Content DNA.
- This module deliberately does not claim RFC 001/002/006 conformance; every relationship section names its real deltas rather than asserting equivalence.

## Open questions

- Should `GovernedSpectrumResult` be renamed to avoid implying RFC 001 conformance, given this module's real relationship to RFC 001 is "narrower analog," not "implementation"?
- Does RFC 010's eventual stabilization come to depend on this module (replacing `console_profile_0_1`'s bespoke evaluation with a call to `evaluate_governed_profile_with_artifacts`), or do they remain independent siblings? This is the central editorial question flagged in `governed_profile_scoping_notes.md` and this RFC does not resolve it — it only makes the technical relationship precise enough for that decision to be made.
- Should the single `"admitted_delivery"` Content DNA state gain an explicit `no_answer`-style counterpart for `refuse`/`escalate` outcomes, matching RFC 002, or is "simply absent" an acceptable permanent simplification?
- Should this RFC define exact byte-size/collection bounds, given the current implementation does not enforce any beyond structural non-emptiness (mirroring RFC 013/014's same open question)?
- Proposal issue [#37](https://github.com/encero-systems/hees.ai/issues/37) is now filed; given the density of relationships to Draft RFCs 001/002/006/010, that discussion is more load-bearing here than it was for RFC 013/014, and this document should stay `Draft` until it resolves.
