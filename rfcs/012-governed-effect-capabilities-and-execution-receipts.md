# RFC 012: Governed Effect Capabilities and Execution Receipts

- **Status:** Draft
- **Created:** 2026-08-10
- **Author(s):** Encero Systems
- **Related:**
    - RFC 000 (Foundational Governance Authority)
    - RFC 004 (Composable Governance Constraints)
    - RFC 005 (Canonical Package Artifact Admission)
    - RFC 006 (Export-Safe Governance Receipts)
    - RFC 008 (Governed Behavior Envelopes)
    - RFC 009 (Governed Visible Response Lifecycle)
    - RFC 011 (Canonical Structural Identity for Incan Models)
- **Issue:** https://github.com/encero-systems/hees.ai/issues/27
- **RFC PR:** —
- **Written against:** Hees.ai 0.0.1 / Incan 0.5.0-dev.14
- **Shipped in:** —

## Summary

This RFC defines a capability-grant and receipt boundary for real-world effects proposed by a model or agent through Hees.ai. A model may propose an action, but it cannot grant authority, select a secret-bearing transport, execute an effect, approve itself, or author the resulting receipt. Hees.ai accepts an effect only when an admitted package-bound grant, deterministic constraint decision, and any required external approval authorize the exact bounded request. The trusted executor returns a redacted execution receipt that preserves what was requested, permitted, decided, attempted, and observed without exposing credentials, raw tool payloads, private content, or hidden reasoning.

## Core model

1. **Content and authority are separate.** A visible response, model proposal, or agent plan can describe a desired action but has no effect authority.
2. **Grants are explicit and bounded.** Authority comes only from a package-bound capability grant that names the operation class, target constraints, data and locality constraints, approval rule, budget, and expiry or invalidation condition.
3. **The requested effect is immutable.** The executor receives one canonical action request identity that binds the proposal, admitted package, selected capability grant, parameters, and idempotency semantics.
4. **Hees.ai decides before execution.** Constraints and required approvals produce an allow, deny, approval-required, expired, or verification-failed decision before an executor is invoked.
5. **Execution is not adjudication.** An executor performs only an allowed request through its own host capability. It cannot reinterpret a broad grant, mint a new grant, or upgrade a failed decision.
6. **Receipts are owned evidence.** The trusted boundary produces the execution receipt atomically with the terminal execution result; models, providers, applications, and executors cannot manufacture an authoritative substitute.
7. **Every effect remains replay-aware.** A capability contract states whether the request is idempotent, deduplicated by an idempotency key, or non-repeatable. Retrying a request is never silently equivalent to a first attempt.
8. **Unknown authority fails closed.** Unknown grant versions, operations, target constraints, approval records, receipt fields, or execution outcomes cannot be treated as allowed.

## Motivation

Hees.ai already distinguishes untrusted proposals from governed outcomes and keeps visible answer content, package admission, constraints, and export-safe receipts under separate contracts. That still leaves a material gap: a system can safely decide what response to show while being unable to prove whether a suggested action was actually authorized and performed.

Treating a model's tool call as authorization would collapse that boundary. The model may have inferred a target incorrectly, the requested action may exceed the intended scope, the local runtime may not have the required host capability, or a prior approval may have expired. A generic audit log is also insufficient: it normally cannot say which package-bound grant covered the exact effect, whether a deterministic verifier ran, or whether a retry duplicated a non-idempotent operation.

Hees.ai needs a small authority-plane contract that composes with existing governance rather than becoming an agent framework, an IAM system, or an executor product.

## Goals

- Define one closed capability-grant model for package-bound, proposed effects.
- Bind every decision and execution attempt to canonical package, proposal, grant, request, policy, and approval identities.
- Require exact target and parameter constraints without storing credentials or raw secret-bearing payloads in the grant or receipt.
- Define deterministic pre-execution decisions and terminal execution outcomes.
- Define redacted execution receipts, including idempotency and replay classification.
- Keep model proposals, policy decisions, host capabilities, external approval, executor behavior, and receipt construction under distinct authorities.
- Allow local, offline execution where a host capability and grant permit it; do not require a cloud control plane.

## Non-Goals

- Defining a general identity-and-access-management system, user directory, secrets vault, network proxy, scheduler, or workflow engine.
- Choosing an LLM, agent protocol, tool-calling format, model runtime, provider, or application UI.
- Letting a capability grant contain credentials, raw prompt content, raw document content, arbitrary URLs, or unbounded request data.
- Replacing Incan's runtime host-capability contract or granting a process permissions it does not already possess.
- Defining broad organizational approval processes, signatures, federated trust, attestation, or non-repudiation.
- Claiming that an allowed and completed effect is correct, beneficial, legally compliant, or reversible.
- Turning existing visible-response, Content DNA, or proposal receipts into an effect log.

## Guide-level explanation

A package may declare that a governed proposal can request a bounded action such as saving a reviewed progress record, writing a project-scoped artifact, or invoking a named local integration. It does not contain the secret needed by that integration and it does not grant blanket access to a provider or filesystem.

```incan
# Proposed contract shape; not implemented in Hees.ai 0.0.1.
grant = capability_grant(
    id="project-progress-save",
    operation="progress.save",
    target="project-progress",
    approval="operator-required",
    locality="local-only",
)

request = propose_effect(grant, progress_update)
decision = adjudicate_effect(request, approved_by_operator)
result, receipt = execute_effect(decision)
```

The code is illustrative. `propose_effect` does not execute anything; it creates an untrusted candidate. `adjudicate_effect` verifies the package-bound grant, bounded target, applicable constraints, and approval requirement. Only an allowed decision can reach `execute_effect`. The application sees a clear receipt saying that the exact request was denied, needed approval, expired, failed before an external attempt, or was attempted and reached a terminal executor outcome.

## Reference-level explanation

### Terminology and ownership

- **Capability grant:** a closed, admitted, package-bound declaration of authority for one operation class under named bounds.
- **Effect proposal:** untrusted model or agent output that nominates a grant and bounded request parameters.
- **Action request:** the canonical, immutable, validated request constructed by Hees.ai after proposal normalization and grant resolution.
- **Decision:** the terminal pre-execution result of grant, constraint, approval, and verifier evaluation.
- **Executor:** the trusted host-facing component that attempts an allowed action through an already available runtime capability.
- **Execution receipt:** the private Hees.ai projection returned atomically with the terminal executor result.

The package admission boundary owns grant membership and package identity. The model or provider owns only its untrusted proposal. Hees.ai owns request normalization, deterministic governance decision, and receipt projection. The executor owns transport-specific implementation and observed terminal outcome, but no governance authority. An application or operator may provide an approval record under a profile-defined trusted boundary, but cannot substitute a decision or receipt.

### Capability grants

A capability grant must be committed by an RFC 005-admitted package and inherit that package's complete identity. A runtime-supplied, provider-supplied, mutable sidecar, or caller-created grant has no authority.

Each grant must contain exactly one versioned identity and the following bounded declarations:

- a stable grant identifier and revision;
- one closed operation class and a named executor or tool identity;
- a target kind and an allowlisted target selector or canonical target reference;
- a parameter schema with explicit value, size, and collection bounds;
- data-classification, locality, and export restrictions;
- the required constraint or verifier profile;
- the approval requirement, including whether approval is absent, optional, or required;
- a maximum-use budget when more than one use is permitted; and
- an expiry or deterministic invalidation condition.

The grant must not contain a credential, token, plaintext secret, mutable endpoint, unconstrained URL, raw document body, or arbitrary tool argument map. A target selector may name a locally registered resource, an admitted package member, or another canonical identifier only when the relevant host contract resolves it. A non-empty selector must be exact or bounded enough for deterministic matching; a display name alone is not sufficient.

Grants authorize only the declared action request shape. They do not authorize related operations, future operation names, unaudited parameter extensions, or a different package revision. Unknown grant fields, operation classes, target kinds, constraints, or profile versions must fail closed.

### Effect proposals and canonical action requests

An effect proposal must reference one candidate grant and supply only the parameters permitted by that grant's schema. It remains untrusted even if its values validate. A proposal cannot choose its authority profile, approval state, execution mode, locality classification, receipt contents, or idempotency classification.

After validating the proposal and resolving the exact admitted grant, Hees.ai constructs one canonical action request. The request identity must bind the proposal identity when present, package identity, grant identity and revision, operation class, normalized target reference, normalized parameter identity, applicable policy and verifier profile identities, requested locality, and an explicit idempotency key or non-repeatable classification. The executor must receive this request or a capability-safe projection of it; it must not reconstruct an equivalent request from free-form provider output.

### Decision before effect

Before invocation, Hees.ai must evaluate the grant, request bounds, package state, constraints, required verifier evidence, approval state, use budget, and expiry or invalidation condition. The closed pre-execution outcomes are `allowed`, `denied`, `approval_required`, `expired`, and `verification_failed`. A malformed, unsupported, unavailable, or unknown input is a fail-closed denial with a stable reason; it must not fall through to execution.

An `allowed` decision must name the exact action-request identity, grant identity, governing profile identities, applied approval reference when required, remaining-use state when relevant, and the executor identity. Approval must be explicit, bound to the same request or a narrower immutable scope, and valid at decision time. A model proposal, a display confirmation, a prior unrelated approval, or a successful previous attempt is not approval. A model or executor must never approve its own request.

### Executor boundary and terminal outcomes

The executor may run only after receiving an `allowed` decision directly from the trusted Hees.ai boundary. It must check that its local host capability can perform the named operation and target. It may not compensate for a missing host capability by selecting a remote provider, broader target, or alternate operation.

Terminal executor outcomes are `succeeded`, `rejected_before_attempt`, `failed_before_attempt`, `failed_after_attempt`, and `outcome_unknown`. The boundary must distinguish an executor that never attempted an external effect from one whose outcome is unknown after a possible attempt. A transport retry is a new execution attempt unless the action request's idempotency contract permits deterministic deduplication using the exact idempotency key. Non-repeatable actions must not be retried automatically.

An executor result is operational evidence, not a declaration of business correctness. A successful result only establishes the stated terminal executor outcome under its recorded scope.

### Execution receipts

The trusted Hees.ai operation must return a terminal result and execution receipt atomically. The receipt must be a closed, versioned projection containing:

- receipt contract and receipt kind;
- the package, proposal, grant, action-request, decision, and executor identities that are safely established;
- the terminal pre-execution or executor outcome and stable reason;
- applied policy, verifier, and approval identities when present;
- attempt ordinal, idempotency or replay classification, and budget state when safely available;
- a redacted target reference or target identity, never raw secret-bearing parameters;
- visibility and redaction status; and
- an optional bounded external-operation reference when the executor can expose one safely.

The receipt must omit credentials, tokens, raw prompts, model output, raw request bodies, raw document content, private provider payloads, hidden reasoning, traces, stack traces, arbitrary diagnostic text, local paths, network locations, and unbounded tool responses. A receipt can prove only the integrity and provenance scope defined by its contract. It does not prove that an effect was correct, authorized outside the recorded boundary, approved by a particular real-world person, or reversible.

RFC 006 remains the export-safe receipt contract for its existing governed outcomes. This RFC defines a distinct future execution-receipt kind and must not widen RFC 006's current proposal receipt with effect data by implication. Any shared canonical identity or export format must be reconciled explicitly with RFCs 006 and 011 before implementation.

### Relationship to Incan runtime capabilities

An Incan runtime host capability and a Hees.ai capability grant answer different questions. The host capability says what the running process can technically perform. The Hees.ai grant says what a governed package-bound request is permitted to ask that process to perform. An effect requires both; either one may deny it. Neither contract may silently synthesize the other, and neither grants a model authority to bypass the other.

## Design details

### Syntax

This RFC introduces no Incan authoring syntax or generic tool-call protocol. Any package manifest or Incan model surface that serializes grants must be specified with a closed schema before implementation and must preserve the authority boundary defined here.

### Compatibility and migration

Hees.ai 0.0.1 has no governed generic effect capability or execution receipt and therefore remains unchanged. Existing proposal and response flows continue to be content-plane only. A future implementation must make effect execution opt-in by admitted package contract; a package without a grant cannot gain an effect path through this RFC.

### Verification and acceptance evidence

Before this RFC advances, the implementation evidence must include positive and fail-closed fixtures for: unknown or altered grants; unbound or broadened targets; parameter-bound violations; expired and exhausted grants; absent, stale, mismatched, and self-issued approvals; missing host capability; policy or verifier failure; no-attempt versus possible-attempt failures; idempotent duplicate submission; non-repeatable retry rejection; and receipt redaction. Cross-runtime identity fixtures must prove that the canonical request and receipt identities are stable without depending on display or wire serialization.

## Alternatives considered

### Let model tool calls carry authority

Rejected. A model can nominate an action but cannot establish its scope, policy, approval, or execution outcome.

### Add a generic audit log after execution

Rejected. A log cannot reliably bind a request to an admitted grant, pre-execution decision, approval, and idempotency semantics, and it often leaks sensitive operational payloads.

### Reuse visible-response receipts for effects

Rejected. Response receipts are deliberately content-safe and must not become an authority or execution channel.

### Make grants generic process permissions

Rejected. A package-level effect grant must be narrower than a process permission and must compose with, rather than replace, host capabilities.

### Treat approval as a UI confirmation string

Rejected. Approval has to be an explicit bounded record tied to the same action request or narrower immutable scope.

## Drawbacks

The contract adds a number of identities and decision states that small local applications must understand. It also deliberately prevents convenient implicit fallback—for example, switching a local action to a remote provider when the local capability is absent. This is an intentional cost of evidence-bearing authority, but it means implementations need good inspection and operator-facing explanations.

## Layers affected

- **Governance specification** — grant, request, decision, executor, receipt, and replay semantics must remain closed and fail closed.
- **Package admission** — admitted packages must bind the exact grant declaration, identity, bounds, and revision before it can be used.
- **Constraint and response lifecycle** — untrusted proposals may nominate actions, but existing terminal authority and visible-response boundaries must remain intact.
- **Runtime integration** — executors must require both an allowed Hees.ai decision and a matching available host capability; no executor may create grants or receipts.
- **Identity and receipts** — canonical request and execution-receipt identities, redaction, and export rules must align explicitly with RFCs 006 and 011.
- **Documentation and inspection** — tools must explain requested versus allowed versus attempted effects, applicable bounds, approval state, and receipt scope without exposing secret payloads.

## Unresolved questions

- What exact closed operation and target vocabularies should the first implementation support?
- Which approval-record format and trusted issuer boundary are sufficient for local single-operator use without importing a general identity system?
- Which canonical identity and export encoding should execution receipts use after reconciliation with RFCs 006 and 011?
- How should a target selector express bounded file or data-store scope without exposing raw local paths or becoming a filesystem permission language?
- Which action classes can safely support automatic idempotent retries, and which must always require a fresh decision?
