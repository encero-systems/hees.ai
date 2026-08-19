# RFC 004: Composable Governance Constraints

- **Status:** Planned
- **Created:** 2026-07-17
- **Author(s):** Encero Systems
- **Related:**
    - RFC 000 (Foundational Governance Authority)
    - RFC 001 (Spectrum Terminal Adjudication)
    - RFC 002 (Content DNA Answer-Time Provenance)
    - RFC 003 (Governed Memory and Retrieval Results)
    - RFC 005 (Canonical Package Artifact Admission)
    - RFC 006 (Export-Safe Governance Receipts)
- **Issue:** https://github.com/encero-systems/hees.ai/issues/5
- **RFC PR:** —
- **Written against:** Hees.ai 0.0.1 / Incan 0.5
- **Shipped in:** —

## Summary

Hees.ai should compose package-declared governance constraints by validating normalized typed findings in one explicit total order and producing one deterministic authoritative action. Constraint evaluators remain non-authoritative: they may nominate actions and reasons within package-declared bounds, while Hees.ai alone validates the complete evaluation transcript, resolves action conflicts, applies fail-closed behavior, and chooses the final outcome.

## Core model

1. **The package declares authority.** An admitted package owns a versioned constraint plan with a dense total order, earlier-only dependencies, evaluator identities, allowed action/reason pairs, and fail-closed actions.
2. **Concrete evaluators produce typed findings.** Each evaluator is invoked through a generic constraint protocol and returns one normalized `ConstraintFinding`. Evaluators are not stored in a heterogeneous trait-typed collection.
3. **Hees.ai composes concrete findings.** The runtime validates an ordered `list[ConstraintFinding]` against a concrete `ConstraintAdjudicationContext`, not a list of evaluator trait objects or an arbitrary package context. Known gaps receive definition-local fail-closed substitutes; unknown, duplicate, descending, or post-escalation entries invalidate the transcript globally.
4. **The strongest effective action wins.** For a valid adjudication, `Escalate > Reject > Clarify > Revise > Continue`; ties are broken by package-declared order. Globally malformed package, context, or transcript input instead returns an invalid `Reject` result without pretending that human escalation was authorized.
5. **Only effective escalation short-circuits evaluation.** Every definition through the first effective `Escalate` receives one validated or substituted effective finding. Later definitions are marked skipped and receive no finding.

## Motivation

The current Hees.ai 0.0.1 runtime admits a proposal through one fixed structural function. It does not define a public way to combine independent policy, intent, knowledge, resource, or temporal checks. External callers can therefore disagree about rule order, dependency visibility, evaluator failure, action strength, conflict handling, and when evaluation stops.

Those semantics are part of the governance boundary, not a provider detail. A package should be able to supply its domain rules without gaining authority to choose the final outcome, and independent callers should produce the same decision from the same admitted plan, context, and normalized findings.

## Goals

- Define a small generic protocol through which concrete constraint evaluators return typed non-authoritative findings.
- Freeze the exact package-relative constraint-plan binary member payload imported by RFC 005, including closed nested shapes, action spellings, ordering, and absence rules.
- Define an admitted package-owned constraint plan with exact version, identity, order, dependency, authority, and failure semantics.
- Define one concrete Hees.ai adjudication context that binds contract, package, plan, evaluation time, and ordered available support identity independently from package evaluator context.
- Define deterministic evaluation transcript validation without relying on heterogeneous trait-typed collections.
- Define a total action-strength order, tie-breaking, structural action-conflict reporting, and terminal escalation behavior.
- Require exactly one effective finding per processed definition, record evaluated, substituted, and skipped identifiers, and distinguish definition-local substitution from global structural invalidity.
- Bound plans, dependencies, findings, reason identifiers, support references, and evaluator-invocation count.
- Allow constraints to read only declared earlier findings and one caller-supplied deterministic evaluation time.
- Define synthetic acceptance evidence across independent constraint implementations.

## Non-Goals

- Authoring domain policies, organizational intent, content rules, taxonomies, or package-specific constraint kinds.
- Inferring semantic contradictions between arbitrary policies or deciding whether a package's policy is desirable.
- Defining model inference, retrieval algorithms, storage, transport, operator approval workflows, or package authoring interfaces.
- Re-verifying package artifact bytes or accepting a second independently supplied package identity. RFC 005 establishes the admitted artifact identity; this RFC receives the resulting `AdmittedPackageIdentity`.
- Defining RFC 005 member wrappers, exact binary member bytes, descriptor commitments, sequencing, profile resource envelopes, or package-artifact identity.
- Defining receipt canonicalization, redaction, envelope bytes, identifier construction, verification, or external authenticity. RFC 006 owns that export boundary; this RFC owns the complete in-memory source result from which Hees.ai privately projects a receipt.
- Making evaluator findings authoritative or allowing an evaluator to select the final runtime action.
- Persisting hidden reasoning, chain-of-thought, free-form evaluator diagnostics, or provider-specific extension maps.
- Dynamically loading evaluator code, choosing an evaluator implementation, or standardizing an evaluator registry transport.
- Treating a `list[GovernanceConstraint[Context]]` as the composition mechanism. The runtime composes concrete findings instead.

## Guide-level explanation

This RFC describes a proposed public contract. Hees.ai 0.0.1 does not implement composable constraints or deterministic finding adjudication.

A package declares a `ConstraintPlan`. Each definition has a stable identifier, exact evaluator kind and version, one zero-based order, a required ordered dependency list that may be empty and may name only earlier definitions, a bounded ordered `allowed_findings` list of action/reason pairs, the strongest action that evaluator may nominate, and the action/reason pair Hees.ai must apply if evaluation is absent or invalid. Package admission validates this plan before it can govern a proposal.

Concrete package-owned evaluators may adopt one generic Incan trait. They are invoked one at a time, and their results are collected as ordinary `ConstraintFinding` values. The following illustrative shape uses compiler-supported generic dispatch without constructing a heterogeneous trait-typed list:

```incan
# Proposed API shape; not implemented in Hees.ai 0.0.1.
pub model PolicyContext:
    pub visible_output: str
    pub governed_memory_count: int
    pub evaluation_time_ms: int


pub trait GovernanceConstraint[Context]:
    def evaluate(self, context: Context, dependency_findings: list[ConstraintFinding]) -> ConstraintFinding


pub model RequiresVisibleOutput with GovernanceConstraint[PolicyContext]:
    pub constraint_id: str

    def evaluate(self, context: PolicyContext, dependency_findings: list[ConstraintFinding]) -> ConstraintFinding:
        if context.visible_output.strip() == "":
            return constraint_finding(
                contract_version="0.1",
                constraint_id=self.constraint_id,
                evaluator_kind="visible_output",
                evaluator_version="1.0",
                action=ConstraintAction.Revise,
                reason_id="visible_output_missing",
                evaluation_time_ms=context.evaluation_time_ms,
                dependency_ids=[],
                support_ids=[],
            )
        return constraint_finding(
            contract_version="0.1",
            constraint_id=self.constraint_id,
            evaluator_kind="visible_output",
            evaluator_version="1.0",
            action=ConstraintAction.Continue,
            reason_id="visible_output_present",
            evaluation_time_ms=context.evaluation_time_ms,
            dependency_ids=[],
            support_ids=[],
        )


pub model RequiresGovernedMemory with GovernanceConstraint[PolicyContext]:
    pub constraint_id: str

    def evaluate(self, context: PolicyContext, dependency_findings: list[ConstraintFinding]) -> ConstraintFinding:
        if context.governed_memory_count == 0:
            return constraint_finding(
                contract_version="0.1",
                constraint_id=self.constraint_id,
                evaluator_kind="governed_memory",
                evaluator_version="1.0",
                action=ConstraintAction.Reject,
                reason_id="governed_memory_missing",
                evaluation_time_ms=context.evaluation_time_ms,
                dependency_ids=[],
                support_ids=[],
            )
        return constraint_finding(
            contract_version="0.1",
            constraint_id=self.constraint_id,
            evaluator_kind="governed_memory",
            evaluator_version="1.0",
            action=ConstraintAction.Continue,
            reason_id="governed_memory_present",
            evaluation_time_ms=context.evaluation_time_ms,
            dependency_ids=[],
            support_ids=[],
        )


pub def evaluate_one[Context, Evaluator with GovernanceConstraint[Context]](
    constraint: Evaluator,
    context: Context,
    dependency_findings: list[ConstraintFinding],
) -> ConstraintFinding:
    return constraint.evaluate(context, dependency_findings)


adjudication_context = constraint_adjudication_context(
    contract_version="0.1",
    package_id="learning_support",
    domain_id="public_learning",
    package_revision="1.0",
    package_semantic_identity=admitted_package.package_semantic_identity,
    package_admission_binding=admitted_package.package_admission_binding,
    plan_id="standard_admission",
    plan_revision="1.0",
    evaluation_time_ms=1784304000000,
    available_support_ids=["decision_process_07", "public_participation_03"],
)
policy_context = PolicyContext(
    visible_output="A visible response",
    governed_memory_count=2,
    evaluation_time_ms=adjudication_context.evaluation_time_ms,
)
findings = [
    evaluate_one(RequiresVisibleOutput(constraint_id="visible_output"), policy_context, []),
    evaluate_one(RequiresGovernedMemory(constraint_id="governed_memory"), policy_context, []),
]
decision = adjudicate_findings(admitted_package, admitted_plan, adjudication_context, findings)
```

`policy_context` is package-owned evaluator input; Hees.ai does not interpret it. `adjudication_context` is the concrete Hees.ai contract used to validate package, plan, time, and available support identity. `findings` is a homogeneous list of the concrete `ConstraintFinding` model. The two evaluator models remain concrete at their call sites. This keeps package extension possible without requiring the generated runtime to represent `list[Trait[Context]]` or accepting arbitrary package data as adjudication authority.

Hees.ai validates the findings against the admitted plan. A finding from `visible_output` cannot nominate an action stronger than that definition permits, cannot claim another definition's identity, and cannot cite support outside the admitted context. If both findings are valid, Hees.ai chooses the strongest action. If a later constraint escalates, that escalation is final and no later definition may appear in the transcript.

Dependencies do not create implicit ordering. A definition may declare only earlier definition identifiers. Its evaluator receives exactly those earlier findings, in declared dependency order. The package may compile a richer dependency graph before deployment, but the runtime accepts only one explicit dense total order.

## Reference-level explanation

### Authority boundary

An admitted package must own the constraint plan, evaluator identities, action ceilings, failure action/reason pairs, and reason vocabulary. A caller must not add, remove, reorder, or replace definitions at runtime.

A constraint evaluator and its `ConstraintFinding` must be non-authoritative. A finding may nominate one package-allowed action/reason pair within the definition's declared ceiling and may cite bounded package-owned support identifiers. It must not admit or reject a proposal, override another definition, alter the plan, or select the final action.

Hees.ai must be the sole authority for plan validation, transcript validation, failure substitution, action ordering, conflict representation, short-circuit validation, and the final `AdjudicationResult`.

### Package identity and serialized constraint declarations

The complete trusted package identity used by constraint adjudication is RFC 005's typed `AdmittedPackageIdentity`: `package_id`, `domain_id`, `package_revision`, `package_semantic_identity`, `artifact_digest`, and `package_admission_binding`. The semantic identity, artifact digest, and admission binding have distinct governed meanings and must never be independently supplied or reconstructed by this RFC.

A package-relative serialized constraint declaration is carried by the sole optional RFC 005 `constraints` member. RFC 005 owns the common `member_id`, `member_kind`, `member_contract`, and `record_count` fields; exact binary member bytes; descriptor position; digest and length commitments; sequential admission; profile resource envelope; and inherited package identity. `member_contract` must be the exact string `0.1` and is the sole serialized constraint-contract version. The payload must not add `contract_version`, a nested payload envelope, another wrapper field, `artifact_contract`, `package_id`, `domain_id`, `package_revision`, `package_semantic_identity`, `artifact_digest`, `package_admission_binding`, or an equivalent containing-package identity field.

This RFC owns the payload fields below. They are top-level siblings of the four RFC 005 wrapper fields and are disjoint from them. Every payload and nested object is closed. Every listed field is required; contract `0.1` has no optional constraint-payload field. An absent value, unknown field, alias, case variation, generic metadata, or admission-invented default is invalid. Arrays preserve submitted order, including empty `depends_on` arrays; Hees.ai must not sort or deduplicate them. RFC 005 owns duplicate-aware parsing, exact binary byte equality, schema failure classification, and the final package-admission result.

#### Constraints member payload

After the common wrapper, a `constraints` member must contain exactly:

| Field | Value kind | Presence and meaning |
| --- | --- | --- |
| `plan_id` | string | Required canonical package-scoped plan identifier. |
| `plan_revision` | string | Required exact plan revision. |
| `evaluator_capabilities` | ordered capability objects | Required, non-empty, and bounded by the RFC 005 profile resource envelope. |
| `definitions` | ordered definition objects | Required, non-empty, and bounded by the RFC 005 profile resource envelope. |

`plan_id` must match `[a-z0-9][a-z0-9_-]*` and the profile identifier bound. `plan_revision` must match `[0-9]+(\.[0-9]+){1,2}` and the profile version bound. The RFC 005 descriptor `record_count` must equal `len(evaluator_capabilities) + len(definitions)`.

#### Evaluator-capability object

Every `evaluator_capabilities` entry must contain exactly two required string fields:

| Key | Meaning |
| --- | --- |
| `evaluator_kind` | Canonical package-owned evaluator-kind identifier. |
| `evaluator_version` | Exact evaluator version. |

`evaluator_kind` must match the identifier grammar and bound. `evaluator_version` must match the version grammar and bound. The complete `(evaluator_kind, evaluator_version)` tuple must be unique. Capability array order is package identity, but it supplies no evaluator precedence and makes no executable-attestation claim.

#### Constraint-definition object

Every `definitions` entry must contain exactly:

| Field | Value kind | Meaning |
| --- | --- | --- |
| `constraint_id` | string | Canonical package-scoped constraint identifier. |
| `evaluator_kind` | string | Exact kind from one capability tuple. |
| `evaluator_version` | string | Exact version from that same capability tuple. |
| `order` | exact non-negative integer | Zero-based dense plan order. |
| `depends_on` | array of strings | Ordered unique earlier constraint identifiers; may be empty. |
| `allowed_findings` | array of allowed-finding objects | Required non-empty ordered authority list. |
| `maximum_action` | string enum | Strongest action this definition permits. |
| `failure_action` | string enum | Definition-local fail-closed action. |
| `failure_reason_id` | string | Package-owned reason for the fail-closed substitute. |

`constraint_id`, `evaluator_kind`, `failure_reason_id`, and every dependency identifier must match the profile identifier bound. `evaluator_version` must match the profile version bound. Constraint identifiers and `order` values must be unique, and the definition at array index `i` must carry exact integer `order=i`; a negative, fractional, duplicate, gap, or alternative ordering is invalid. Each `(evaluator_kind, evaluator_version)` pair must resolve to exactly one capability. `depends_on` must contain unique identifiers within the RFC 005 profile resource envelope, each resolving to a definition with lower order, and its declared order is the exact dependency-finding order visible to the evaluator.

`allowed_findings` must be non-empty and bounded by the RFC 005 profile resource envelope. The complete `(action, reason_id)` tuple must be unique, while one reason identifier may appear in more than one tuple only when paired explicitly with different actions. Array order is identity-bearing and grants no priority. Every allowed action must be no stronger than `maximum_action`. `failure_reason_id` need not occur in `allowed_findings`; it authorizes only the substitute paired with `failure_action`.

#### Allowed-finding object and serialized actions

Every `allowed_findings` entry must contain exactly two required string fields:

| Key | Meaning |
| --- | --- |
| `action` | One exact serialized constraint action. |
| `reason_id` | Canonical package-owned evaluator reason identifier. |

The only serialized action strings in contract `0.1` are `continue`, `revise`, `clarify`, `reject`, and `escalate`. `maximum_action` uses the same complete set. `failure_action` permits only `reject` or `escalate`. PascalCase runtime variants such as `Continue` and `Escalate` are typed API values, not alternate package spellings. Uppercase, mixed case, hyphenated spellings, aliases, and numeric encodings are invalid. Every `reason_id` must match the profile identifier bound.

After successful RFC 005 package admission, Hees.ai must materialize the admitted runtime plan by binding the package-relative declaration to the inherited typed `AdmittedPackageIdentity`. This binding must not modify, migrate, reserialize, or re-hash the member bytes or containing artifact. The admitted runtime plan exposes the declaration fields plus that inherited identity. An adjudication-context claim must not overwrite it.

### Constraint plan

The admitted package must own exactly the admitted runtime plan supplied to adjudication. Its package identity becomes trusted only through RFC 005 admission. Canonical-looking caller fields, a separately supplied plan with matching identifiers, or a plan declaration that was not admitted with that package must never supply trusted plan or package identity.

The package-relative declaration's `evaluator_capabilities` array identifies the evaluators available to the plan. Every capability must have one unique `(evaluator_kind, evaluator_version)` tuple. Each definition's exact tuple must resolve to exactly one declared capability; unknown and duplicate capabilities must invalidate RFC 005 package admission. This is a structural identity claim only: matching kind and version values do not prove which executable bytes ran or that an evaluator behaved correctly. This declaration binds the normalized contract without requiring Hees.ai to define dynamic code loading, executable attestation, or registry transport.

Each constraint definition must contain:

- a stable package-scoped `constraint_id`;
- bounded package-owned `evaluator_kind` and exact `evaluator_version` values;
- one zero-based integer `order`;
- a bounded ordered list of `depends_on` constraint identifiers;
- a non-empty bounded ordered `allowed_findings` list of exact `(action, reason_id)` objects;
- a `maximum_action` that bounds every allowed pair and evaluator nomination; and
- a fail-closed `failure_action` of serialized `reject` or `escalate` plus one bounded package-owned `failure_reason_id`.

Allowed action/reason pairs must be unique. Every reason identifier must be package-owned, must satisfy the identifier grammar, and may be associated with one or more explicitly declared actions. A finding must match one complete allowed pair exactly; declaring a reason for one action must not authorize it for another action. The definition must not contain an allowed action stronger than its `maximum_action`.

The failure reason must satisfy the same package-owned identifier grammar but is not an evaluator nomination and need not appear in the allowed evaluator pairs. Its sole authorized use is the effective substitute paired with that definition's exact failure action. The pair is part of the identity-bearing package declaration; Hees.ai must not invent a substitute reason from an evaluator error or a runtime-specific diagnostic.

An effective finding is either one validated submitted `ConstraintFinding` or one deterministic Hees.ai-created substitute. A substitute must take the constraint identifier, evaluator kind and version, dependency identifiers, failure action, and failure reason unchanged from the admitted definition; take evaluation time from the admitted adjudication context; carry zero support identifiers; and mark its origin as `Substituted`. It must not retain any field from the rejected or missing submitted finding. A validated submitted finding is marked `Evaluated`. These origins drive the result's disjoint `evaluated_ids` and `substituted_ids` lists and make no executable-attestation claim.

Constraint identifiers and orders must be unique. Orders must be contiguous and appear as `0..len(definitions)-1`. Every dependency identifier must resolve exactly once and must refer to a definition with a lower order. Dependencies must be unique within a definition. A self-reference, forward reference, unknown dependency, duplicate, gap, or non-contiguous order must invalidate the complete plan.

Earlier-only dependencies make cycles structurally impossible after validation. Hees.ai must not infer order from dependency traversal, collection iteration, evaluator registration order, or source-file order.

The submitted transcript and evaluator exchanges must remain within the RFC 005 profile resource envelope. Every definition for which no invocation result is submitted is processed as missing and receives the normal definition-local fail-closed substitute unless an earlier effective escalation skips it. Envelope conformance does not prove an invocation occurred and makes no claim about CPU time, wall time, memory, energy, provider work, or internal evaluator complexity.

### Generic evaluator protocol

The public evaluator protocol must be generic over a package-owned evaluator context and must evaluate one concrete adopter at a time. The protocol result must be the concrete `ConstraintFinding` model. Package evaluator context is input to evaluator logic only and must not substitute for the concrete Hees.ai adjudication context.

The contract must not require a heterogeneous `list[GovernanceConstraint[Context]]`. Integrations may use static calls, generated dispatch, an external registry, or another concrete mechanism to select the evaluator named by a definition. Regardless of mechanism, the normalized transcript submitted to Hees.ai must be `list[ConstraintFinding]` in plan order.

A dependent evaluator may receive only the findings named by its definition's `depends_on` list. Those findings must be passed in declared dependency order. It must not receive undeclared prior findings, later findings, the mutable adjudication result, or an implementation's hidden diagnostics.

Evaluators must use immutable package context derived for the same caller-supplied `evaluation_time_ms` as the adjudication context. They must not substitute a wall clock or mutate shared governance state. Conformance requires the same evaluator version, definition, package evaluator context, dependency findings, and evaluation time to produce the same normalized finding.

### Constraint adjudication context

Hees.ai must accept one concrete `ConstraintAdjudicationContext` independently from package evaluator context. It must contain exact contract version, package identifier, domain identifier, package revision, package semantic identity, package admission binding, plan identifier, plan revision, caller-supplied evaluation time, and an ordered list of available package-owned support identifiers bounded by the RFC 005 profile resource envelope. It must not accept an independently supplied artifact digest.

The package, domain, package revision, semantic identity, admission binding, plan identifier, plan revision, and contract values are untrusted claims and must exactly match the separately trusted admitted package and plan. Canonical syntax alone must not promote them into result or receipt identity. The evaluation time must be a non-negative Unix epoch millisecond value and must exactly match every submitted finding. Available support identifiers must be unique, must satisfy the profile identifier bound, and must resolve to artifacts admitted for this evaluation. Their list order is authoritative for deterministic subset validation.

An arbitrary package `PolicyContext`, prompt, provider payload, or model output must not be accepted in place of `ConstraintAdjudicationContext`. Hees.ai may pass package-owned evaluator context to concrete evaluators outside adjudication, but it validates findings only against the standard context.

### Constraint finding

A finding must contain exactly:

- contract version `0.1`;
- the constraint identifier;
- the exact evaluator kind and version from the definition;
- one `ConstraintAction`;
- one bounded package-owned reason identifier;
- the caller-supplied evaluation time;
- the ordered dependency identifiers declared by the definition; and
- a bounded ordered list of package-owned support identifiers.

A finding must not contain free-form reasoning, arbitrary metadata, policy text, source text, hidden model reasoning, a final-decision flag, or a replacement order.

The action and reason identifier must exactly match one allowed pair in the definition, and the action must not be stronger than the definition's `maximum_action`. A finding must not invent a reason identifier merely because it satisfies the package identifier grammar. Dependency identifiers must exactly equal the definition's `depends_on` list. Support identifiers must be unique, must form an order-preserving subset of `ConstraintAdjudicationContext.available_support_ids`, and must resolve to artifacts available in the admitted evaluation. An accepted memory context from RFC 003 may provide such identifiers, but retrieval acceptance and relevance do not make the finding authoritative.

Echoed evaluator kind and version values must exactly match the definition, but that match is structural provenance only and must not be presented as proof that particular executable bytes ran.

### Action semantics

The typed runtime action set and normative strength order are below. The serialized package spellings remain the exact lowercase strings defined above.

| Action | Strength | Runtime meaning |
| --- | ---: | --- |
| `Continue` | 0 | This constraint adds no required intervention. |
| `Revise` | 1 | The current proposal must be revised before it may continue. |
| `Clarify` | 2 | The caller must obtain missing user or package context before continuing. |
| `Reject` | 3 | The current proposal must not be admitted. |
| `Escalate` | 4 | Automated evaluation must stop and transfer to the package-declared escalation path. |

For an adjudication that remains structurally valid, Hees.ai must choose the strongest effective action. When two or more findings have the same strongest action, the finding with the lowest package-declared order is primary. The result must retain all effective findings in plan order so the tie-break does not erase evidence.

An effective `Clarify` finding is valid only when its reason is RFC 009's closed `missing_in_scope_context` reason and the trusted response context establishes that gap. A constraint concerning unavailable evidence or memory, unsupported subject matter, invalid package state, unsafe behavior, provider unavailability, or malformed output must use `Revise`, `Reject`, or `Escalate`; it must not use `Clarify` to create a hidden answer path.

`Escalate` is the only effective action that short-circuits valid processing. `Reject`, `Clarify`, and `Revise` must not suppress later definitions because a later definition may require a stronger action. Definitions after an effective `Escalate` are skipped and receive no effective finding. Any submitted finding for a skipped definition makes the transcript globally invalid, so the result has validity `Invalid` and fail-closed action `Reject`; a malformed transcript must not manufacture escalation authority.

### Submitted and effective findings

The submitted transcript must stay within the RFC 005 profile resource envelope. Submitted constraint identifiers must be unique, must all resolve to the admitted plan, and must appear in strictly increasing plan order. Known gaps are allowed because they represent missing evaluations. Unknown identifiers, duplicates, descending entries, or entries after an effective escalation are global structural errors rather than definition-local gaps.

After validating the package, plan, adjudication context, and global transcript shape, Hees.ai must process definitions in plan order with one cursor over submitted findings:

1. If the next submitted finding names the current definition, Hees.ai validates its contract, evaluator identity, allowed action/reason pair, evaluation time, dependencies, and support references. A valid submission becomes the definition's effective finding and the definition identifier is recorded in `evaluated_ids`.
2. If the next submitted finding names a later definition or no submitted finding remains, the current definition is missing. Hees.ai creates one effective substitute with the definition's package-declared `failure_action` and `failure_reason_id`, and records the identifier in `substituted_ids`.
3. If a submitted finding for the current known definition fails definition-local validation, Hees.ai discards it, creates the same kind of fail-closed substitute, and records the identifier in `substituted_ids`.
4. If a definition depends directly or transitively on a substituted finding, Hees.ai must substitute that dependent definition as well because its declared dependency input was not successfully evaluated. An independent later definition may still use a valid submitted finding.
5. If the effective finding is `Escalate`, Hees.ai stops. Every remaining definition is recorded in `skipped_ids` and receives no effective finding. Any unconsumed submitted finding then makes the whole transcript globally invalid.

Every definition before and including the first effective `Escalate` must therefore have exactly one effective finding, either validated or substituted. Every later definition must be skipped and have no effective finding. If no effective finding escalates, every definition must have exactly one effective finding and `skipped_ids` must be empty.

An absent finding is represented by the next definition being missing. It consumes no claim about CPU, elapsed time, memory, or provider work; Hees.ai applies the normal substitution algorithm.

An unavailable admitted package or plan, mismatched adjudication context, incompatible top-level contract version, profile-envelope-exceeding transcript, unknown submitted identifier, duplicate submitted identifier, descending transcript, or submitted entry after effective escalation must produce the minimal `AdjudicationValidity.Invalid` result with fail-closed action `Reject` and the exact public reason selected below. Hees.ai must discard every provisional effective finding and execution identifier. Package-declared failure actions do not apply when the package, plan, context, profile envelope, or global transcript structure is itself untrustworthy. A package-declared definition-local failure action may still produce `Escalate` during an otherwise valid adjudication.

Hees.ai may retain rejected normalized findings as bounded local diagnostics, but it must not expose them as effective findings and must not expose free-form evaluator diagnostics or hidden reasoning.

### Structural action conflicts

In a structurally valid adjudication, an action conflict exists when two or more validated or substituted non-`Continue` effective findings nominate different action strengths. Hees.ai must set `has_action_conflict=true`, list the involved constraint identifiers in plan order, and still resolve the result through the normative strongest-action and tie-break rules. A globally invalid adjudication reports no action conflict because it has no authoritative effective findings.

Multiple findings with the same non-`Continue` action are reinforcing findings, not an action conflict. A `Continue` finding does not conflict with an intervention. Hees.ai does not infer semantic contradiction between policies that happen to choose the same action; a package that needs such semantics must encode them in a declared constraint whose bounded finding can nominate `Escalate`.

### Bounds and profile resource envelope

The RFC 005 profile resource envelope owns all exact UTF-8 byte, collection, and invocation ceilings for this contract: identifiers and versions; capability and definition counts; dependencies; allowed action/reason pairs; submitted findings; available support; support per finding; evaluator exchanges; and retained execution trace. A package cannot lower, raise, or select those ceilings. A changed ceiling requires a distinct profile contract and version with its own conformance corpus and measured resource evidence.

Package, domain, plan, constraint, kind, reason, and support identifiers must match the lowercase ASCII grammar `[a-z0-9][a-z0-9_-]*` within the profile identifier bound. Contract, evaluator-version, package-revision, and plan-revision values must match the ASCII grammar `[0-9]+(\.[0-9]+){1,2}` within the profile version bound and compare exactly. Structural identities must use the RFC 011 typed form. Zero, negative, overflowing, duplicate, malformed, or envelope-exceeding values must fail validation rather than being normalized or clamped.

### Adjudication result

Every submission must produce one deterministic `AdjudicationResult` variant and one reason from the closed table below.

A `Valid` result must contain the exact constraint contract version from the admitted plan; `evaluated_package`, containing the complete trusted RFC 005 `AdmittedPackageIdentity` snapshot; `evaluated_plan`, containing the admitted plan identifier and revision; the admitted caller-supplied evaluation time; final action; optional primary constraint identifier; ordered effective findings; ordered `evaluated_ids`, `substituted_ids`, and `skipped_ids`; whether an action conflict occurred; ordered conflicting constraint identifiers; whether valid processing short-circuited; and the terminal result reason. Package and plan identity must come only from the admitted snapshots, never from the adjudication-context echoes.

A valid result may contain validated and substituted effective findings and applies the strongest-action rules. Its three execution identifier lists must partition the plan definitions: evaluated and substituted definitions precede any skipped definitions, and skipped definitions occur only after effective escalation. `evaluated_ids` records definitions with structurally accepted submitted findings; it is not executable attestation. Definition-local substitution, including substitution caused by a missing or malformed finding, remains `AdjudicationValidity.Valid` and contributes its package-declared failure action to the ordinary strongest-action decision.

An `Invalid` result must contain only validity `Invalid`, action `Reject`, and one stable Hees.ai-owned invalid reason. It must omit trusted package identity, contract and plan identity, evaluation time, primary and effective findings, evaluated/substituted/skipped/conflict lists, short-circuit state, context echoes, support identifiers, and provisional processing. Canonical-looking package, plan, or evaluation fields from an invalid `ConstraintAdjudicationContext` are untrusted input and must never be copied into trusted result or receipt identity. Implementations may retain richer bounded local diagnostics outside the public result, but those diagnostics must not contain evaluator text, support content, hidden model reasoning, or unsafe input echoes.

The result must not contain chain-of-thought, hidden evaluator reasoning, free-form provider errors, or an assertion that cited support semantically proves the outcome.

Given the same RFC 005-admitted package and plan plus byte-identical typed `ConstraintAdjudicationContext` and submitted findings, conforming implementations must produce the same result variant, trusted identity presence, effective findings, evaluated/substituted/skipped identifiers, conflict representation, primary constraint, final action, short-circuit state, and stable reason identifier.

### Public result reasons

Every result reason must come from this closed table. Rows are the strict global validation precedence, and reason order within a row is strict reason precedence. Every reason is globally unique within RFC 006's `constraint_adjudication_0_1` namespace, so the reason alone identifies its stage and terminal mapping; a receipt does not export a separate stage field.

| Stage | Reasons in precedence order | Result variant and terminal action |
| --- | --- | --- |
| `package` | `package_not_admitted` | `Invalid` / `Reject` |
| `plan` | `constraint_plan_not_admitted` | `Invalid` / `Reject` |
| `contract` | `invalid_constraint_contract`, `unsupported_constraint_contract` | `Invalid` / `Reject` |
| `context` | `invalid_context_identifier`, `invalid_context_revision`, `invalid_context_structural_identity`, `invalid_evaluation_time`, `invalid_available_support`, `context_package_id_mismatch`, `context_domain_id_mismatch`, `context_package_revision_mismatch`, `context_package_semantic_identity_mismatch`, `context_package_admission_binding_mismatch`, `context_plan_id_mismatch`, `context_plan_revision_mismatch` | `Invalid` / `Reject` |
| `resource envelope` | `transcript_profile_envelope_exceeded` | `Invalid` / `Reject` |
| `transcript` | `invalid_submitted_identifier`, `unknown_submitted_constraint`, `duplicate_submitted_constraint`, `submitted_order_mismatch`, `post_escalation_submission` | `Invalid` / `Reject` |
| `valid` | `valid_continue`, `valid_revise`, `valid_clarify`, `valid_reject`, `valid_escalate` | `Valid` / `Continue`, `Revise`, `Clarify`, `Reject`, or `Escalate`, respectively |

These seven stages contain exactly 27 globally unique adjudication reasons. Serialized package-schema failures remain RFC 005 package-admission reasons and must not add, remove, or shadow a reason in this table.

The package reason means no successful RFC 005 admission identity exists. The plan reason means the admitted package has no admitted constraint declaration or the supplied runtime plan is not the identity-bound plan materialized from that package. Structurally invalid declarations fail RFC 005 package admission and therefore reach `package_not_admitted`, not a second runtime schema-validation result.

At the contract stage, `invalid_constraint_contract` means the context contract field violates its canonical grammar or byte bound. A syntactically valid value other than `0.1` reaches `unsupported_constraint_contract`. A finding-level contract mismatch belongs to definition-local validation and therefore produces a substitute during an otherwise valid adjudication rather than a global result reason.

At the context stage, `invalid_context_identifier` covers a malformed or over-bound package, domain, or plan identifier; `invalid_context_revision` covers a malformed or over-bound package or plan revision; `invalid_context_structural_identity` covers malformed semantic-identity or admission-binding syntax; and `invalid_evaluation_time` covers a value that is not a non-negative exact integer. `invalid_available_support` covers a malformed, duplicated, envelope-exceeding, or unresolved support list; valid submitted order is preserved as the authoritative order for subset checks. `context_package_id_mismatch`, `context_domain_id_mismatch`, `context_package_revision_mismatch`, `context_package_semantic_identity_mismatch`, and `context_package_admission_binding_mismatch` each compare the named well-formed context claim with the trusted package snapshot. `context_plan_id_mismatch` and `context_plan_revision_mismatch` do the same against the trusted admitted plan. A mismatch never changes those snapshots or makes the invalid result carry them.

At the resource-envelope stage, `transcript_profile_envelope_exceeded` applies when the submitted collection exceeds the closed RFC 005 profile resource envelope. A known gap is not a global resource failure; it receives the normal definition-local substitution.

At the transcript stage, `invalid_submitted_identifier` covers a malformed or over-bound submitted constraint identifier; well-formed identifiers absent from the plan use `unknown_submitted_constraint`; `duplicate_submitted_constraint` takes precedence when an identifier repeats; and any remaining non-increasing order uses `submitted_order_mismatch`. `post_escalation_submission` applies when structurally ordered input remains after the first effective package-authorized escalation. Finding contract, evaluator identity, action/reason, time, dependency, or support defects for a known current definition remain definition-local substitution and never become public invalid reasons.

The five valid reasons map one-to-one to the five final actions: `valid_continue` to `Continue`, `valid_revise` to `Revise`, `valid_clarify` to `Clarify`, `valid_reject` to `Reject`, and `valid_escalate` to `Escalate`. They are selected only after all definitions have been evaluated, substituted, or skipped and conflict and primary identity have been resolved. The reason reflects the final Hees.ai action, including an action produced by package-declared substitution; package-owned finding reason identifiers remain inside effective findings and must not replace the Hees.ai-owned result reason.

Hees.ai must stop at the first failing stage. Within a stage it must determine the set of applicable public reason kinds and select the first reason in the table. It must not select a reason from evaluator error text, parser wording, hash-map iteration, the first malformed finding encountered, or package-owned finding reasons. Local diagnostics may retain additional bounded classifications without changing the public reason.

### Receipt projection ownership

This RFC owns the complete in-memory `AdjudicationResult` and the trusted-versus-untrusted field distinction. RFC 006 exclusively owns the redacted receipt body, envelope, receipt identifier, private atomic projection, and public integrity verification. There is no second constraint-specific canonical encoding or public result-to-receipt authoring API.

For `Valid`, RFC 006 must take package identity only from `evaluated_package`, copy evaluation time and admitted plan identity, and project only evaluated, substituted, skipped, conflicting, and optional primary constraint identifiers from the validated execution. Complete findings and generic support identifiers remain private. `Invalid` maps to RFC 006's minimal body with no package, evaluation time, plan, execution, context echo, or support identifier.

### Validation order

Hees.ai must validate and adjudicate in this order:

1. Establish successful RFC 005 package admission. Failure returns `package_not_admitted` with the minimal `Invalid` result.
2. Establish that the package carries an admitted package-relative constraint declaration and that the supplied runtime plan is the identity-bound admitted form of that declaration. Failure returns `constraint_plan_not_admitted` with no trusted identity in the result.
3. Validate the top-level context contract grammar and exact supported version.
4. Normalize the complete standard adjudication context, then compare its package and plan claims with the trusted admitted snapshots.
5. Enforce the closed RFC 005 profile resource envelope for the submitted collection.
6. Validate submitted constraint identifier grammar, plan ownership, uniqueness, and strictly increasing plan order. Known gaps remain available for definition-local substitution.
7. Process definitions and submitted findings together in plan order. Validate each present known finding or create one package-declared substitute for a missing, locally invalid, or substitution-dependent definition. Record each processed identifier as evaluated or substituted.
8. Stop on the first effective `Escalate`, mark every remaining definition skipped, and verify that no submitted finding remains. A post-escalation entry returns the minimal `Invalid` result and discards all provisional processing.
9. If processing remains valid and no escalation occurs, continue through every definition with no skipped identifiers.
10. Detect structural action conflict, select the strongest effective action, apply the order tie-break, and construct a `Valid` result with trusted evaluated package and plan identity plus the unique terminal reason for that action.

This validation order and the public table determine the single result reason when multiple errors exist. Local diagnostics may record additional bounded reasons but must not change the public outcome.

## Design details

### Relationship to RFC 000

RFC 000 requires deterministic package-owned policy while keeping evaluator findings non-authoritative. This RFC defines the shared finding and constraint-adjudication machinery that preserves that separation.

### Relationship to RFC 001

RFC 001 imports the direct valid adjudication result into Spectrum. This RFC owns finding validation, substitution, conflict representation, primary constraint, and effective action; Spectrum composes that governed result with memory, behavior, and response state to choose the terminal outcome.

### Relationship to RFC 002

Content DNA records the exact policy identity that governed an admitted answer but does not contain complete findings or constraint definitions. This RFC supplies the admitted plan identity and deterministic execution result; RFC 002 owns the redacted answer-time projection.

### Relationship to current proposal admission

The existing `admit_model_proposal` function remains the implemented 0.0.1 contract until this RFC and a separate implementation are merged. Constraint adjudication is an additional governance stage, not a claim about current behavior.

A future integration may require a final `Continue` action before structural proposal admission, or may use `Revise`, `Clarify`, `Reject`, and `Escalate` to prevent admission. The package must declare that integration explicitly. A constraint finding alone must never bypass existing package, action, visible-output, or evidence checks.

### Precompiled total order

Package tooling may begin with priorities, dependency graphs, or richer partial orders. Before deployment, it must compile those declarations into the explicit dense order required here. Hees.ai validates only the deployed order and earlier-only dependencies; it does not perform a caller-dependent topological sort.

This keeps runtime behavior small and reproducible while still allowing richer authoring systems outside the public runtime boundary.

### Acceptance obligations

Conformance evidence must include independent synthetic constraints for at least policy-like, knowledge-like, resource-like, and temporal-like checks using the same generic protocol. The evidence must demonstrate evaluator-context/adjudication-context separation; exact standard context validation; deterministic complete evaluation; every action and tie; allowed and invented finding reason identifiers; structural conflicts; earlier-only dependency visibility; evaluated/substituted/skipped identity; valid escalation short-circuiting; fail-closed evaluator unavailability using the exact package-declared failure pair; action-ceiling violations; known gaps; unknown, duplicate, descending, and post-escalation findings as distinct cases; cycles and missing precedence rejected at RFC 005 package admission; exact version and package binding; support-reference validation; profile-envelope boundaries; clarification only for `missing_in_scope_context`; invalid/reject separation from package-authorized escalation; and repeatable results from byte-identical inputs.

Shared package goldens must include complete formatted values plus exact RFC 005 binary member bytes, member digest, descriptor record count, inherited package identity, and RFC 011 structural identities for a minimal one-capability/one-definition plan; multiple capabilities whose array order differs from definition order; empty and ordered non-empty dependencies; multiple allowed findings; every lowercase serialized action; both permitted failure actions; and profile-envelope boundary cases. JavaScript, Rust, and Incan consumers must agree on every payload field, array order, exact byte sequence, structural identity, and RFC 005 package-admission outcome.

Negative package fixtures must independently cover every missing or unknown field; aliases such as `contract_version`, `kind`, `version`, `allowed_pairs`, `allowed_actions`, or `failure_reason`; key and action case changes; absent required values; empty capability, definition, or allowed-finding arrays; omitted empty `depends_on`; malformed and envelope-exceeding integers; duplicate capability tuples, constraint identifiers, orders, dependencies, and allowed pairs; non-dense or array-mismatched order; self, forward, and unknown dependencies; a definition with no exact capability; malformed identifiers and versions; an allowed action above `maximum_action`; an unknown action; `continue`, `revise`, or `clarify` as `failure_action`; wrapper fields nested in payload; a generic `payload`; repeated package identity; and record-count mismatch. Every schema failure must remain an RFC 005 result rather than entering the 27-reason runtime adjudication table.

The fixture set must make every reason in the closed public result table reachable in isolation and must include multi-failure cases that prove the exact stage and within-stage precedence. Each valid terminal reason must map to exactly one action, including valid rejection and valid escalation produced by definition-local substitution. Package fixtures must cover an RFC 005-admitted package-relative constraint declaration, inherited identity binding without mutation or re-hashing, the distinct semantic identity, artifact digest, and admission binding, and rejection of a declaration that repeats its containing package identity.

Identity fixtures must prove that every `Valid` result receives package and plan identity only from the admitted snapshots, including `package_revision`, while every `Invalid` result omits package, plan, evaluation, and execution data even when its context echoes canonical matching values. RFC 006 projection fixtures must prove the exact valid execution partition, primary and conflict mappings, omission of complete findings and generic support identifiers, and the minimal invalid receipt. The constraint adjudication fixture must not define a competing receipt encoding, identifier, or redaction path.

At least one fixture must show a high-confidence or otherwise persuasive evaluator finding losing to a stronger package-authorized action, proving that evaluator confidence or wording cannot replace Hees.ai adjudication. Fixtures must use fictional domain-neutral content and must not persist hidden reasoning.

## Alternatives considered

### Store heterogeneous evaluator trait values in one list

Rejected because the composition contract does not need runtime trait objects and that shape is not a reliable generated-runtime boundary. Calling concrete evaluators through a generic function and composing their concrete findings preserves extension without making trait-object storage part of the public contract.

### Let each evaluator decide whether evaluation stops

Rejected because evaluator-controlled short-circuiting could hide later constraints and make package order non-authoritative. Only an effective `Escalate` ends a valid transcript.

### Use a partial order directly at runtime

Rejected because multiple valid traversals can produce different dependency visibility, primary findings, and failure timing. Rich ordering may be compiled externally; the admitted runtime plan is one dense total order.

### Stop on the first non-`Continue` finding

Rejected because an early revision or rejection could conceal a later package-authorized escalation. Definitions continue until an effective `Escalate`; globally malformed package, context, or transcript input instead returns `Invalid`/`Reject`.

### Let findings choose arbitrary actions

Rejected because an evaluator could invent authority not granted by the package. Every definition declares an action ceiling and a fail-closed action/reason pair, and Hees.ai validates both.

### Infer semantic policy conflicts inside Hees.ai

Rejected because arbitrary domain semantics cannot be derived from generic action values without embedding package vocabulary. Hees.ai represents structural action conflict; packages encode semantic conflict through explicit constraints.

### Use floating-point confidence to break ties

Rejected because confidence is evaluator-specific, may be non-deterministic across runtimes, and is not authority. Action strength and package order are sufficient and explicit.

## Drawbacks

Packages must precompile their constraints into a total order and declare evaluator action/reason and failure-pair authority up front. Binding inherited package identity only after RFC 005 admission adds a deliberate distinction between package-relative serialized declarations and admitted runtime plans. Evaluating through concrete call sites requires an external dispatch layer when many evaluator kinds exist. Continuing after `Revise`, `Clarify`, or `Reject` performs more work than first-failure evaluation, although the profile resource envelope bounds call count rather than CPU or elapsed time. Structural action conflicts do not discover deeper semantic contradictions. A closed public reason vocabulary and strict precedence require a contract revision when a new global failure distinction is needed, and strict version and transcript checks reject adapter mistakes that a permissive runtime could otherwise ignore.

## Layers affected

- **Public contract:** New package-relative plan declaration, identity-bound admitted plan, definition, allowed-finding, standard adjudication-context, action, finding, validity, result, closed result-reason, conflict, and generic evaluator protocol types.
- **Package validation:** RFC 005-governed dense total-order, earlier-only dependency, evaluator-capability, allowed action/reason, authority-ceiling, failure-pair, version, reference, and bound checks.
- **Runtime adjudication:** Admitted package/plan identity lookup, standard-context normalization and comparison, profile-envelope and transcript validation, definition-local fail-closed substitution, evaluated/substituted/skipped accounting, deterministic strongest-action selection, conflict reporting, and escalation short-circuit semantics.
- **External integration boundary:** Concrete evaluator selection remains external; integrations submit normalized typed findings in plan order.
- **Receipt boundary:** RFC 006 privately projects valid package, plan, and execution identity or the minimal invalid result; this RFC defines no competing export format.
- **Tests and documentation:** Synthetic independent evaluators, complete reason and precedence coverage, identity-provenance cases, malformed transcript fixtures, compatibility cases, and clear current-versus-proposed API documentation.

## Design Decisions

- Hees.ai composes a concrete `list[ConstraintFinding]`; it does not require heterogeneous `list[GovernanceConstraint[Context]]` storage.
- Concrete evaluators may share one generic protocol and are invoked one at a time through compiler-supported generic dispatch.
- Package evaluator context is separate from the concrete Hees.ai `ConstraintAdjudicationContext`; only the latter binds contract, package, plan, time, and available support identity for adjudication.
- Runtime plans use one explicit dense total order. Dependencies may reference only earlier definitions.
- Submitted findings are unique and strictly increasing but may have known gaps. Each processed definition receives one validated or substituted effective finding; definitions after effective escalation are skipped and receive none.
- Findings are non-authoritative. Package definitions declare allowed action/reason pairs, action ceilings, and fail-closed action/reason pairs; findings cannot invent reasons and Hees.ai chooses the final action.
- The strength order is `Escalate > Reject > Clarify > Revise > Continue`, with package order breaking equal-strength ties.
- Only an effective `Escalate` short-circuits a valid adjudication. Other interventions do not hide later constraints.
- Structural action conflicts are reported deterministically and never override the strongest-action rule.
- Unavailable admitted package or plan, invalid contract or context, profile-envelope-exceeding transcript, or invalid global transcript structure returns the minimal `AdjudicationValidity.Invalid` result with fail-closed `Reject`; known definition-local failures use that definition's declared `Reject` or `Escalate` failure pair.
- Valid results expose evaluated, substituted, and skipped definition identifiers; globally invalid results discard and omit all provisional execution accounting.
- Profile resource limits measure bounded exchanges and retained artifacts only; they prove nothing about CPU, elapsed time, memory, energy, or provider work.
- One caller-supplied evaluation time is part of every finding and result; evaluators and Hees.ai do not substitute a wall clock.
- RFC 005 owns the common member wrapper, exact binary bytes, the sole-member position, descriptor commitments, sequencing, profile resource envelope, and inherited package identity; this RFC owns only the exact closed constraint payload imported under `member_contract="0.1"`.
- Constraint payload objects have no absent members: empty dependencies use required `depends_on=[]`, and every other required array remains non-empty.
- Package actions serialize only as lowercase `continue`, `revise`, `clarify`, `reject`, and `escalate`; definition-local `failure_action` permits only `reject` or `escalate`.
- The package-relative serialized constraint declaration is carried only by the sole optional RFC 005 `constraints` member; successful package admission binds inherited identity without changing or re-hashing its bytes.
- The complete trusted constraint identity is RFC 005's `AdmittedPackageIdentity`, plus the admitted plan identifier and revision; semantic identity, artifact digest, and admission binding remain distinct and are not reconstructed here.
- Context identity fields are untrusted comparison claims. Only `Valid` receives trusted evaluated package and plan identity; `Invalid` is minimal and receives none.
- The public result-reason vocabulary is closed, globally unique within its RFC 006 namespace, and selected by strict precedence. Valid reasons map one-to-one to final actions, while package-owned finding and substitution reasons remain separate.
- RFC 006 exclusively owns receipt canonicalization, redaction, identifiers, envelopes, private projection, and public integrity verification.
