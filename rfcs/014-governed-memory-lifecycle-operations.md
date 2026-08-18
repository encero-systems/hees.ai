# RFC 014: Governed Memory Lifecycle Operations

- **Status:** Draft
- **Created:** 2026-08-19
- **Author(s):** Encero Systems
- **Related:**
    - RFC 000 (Foundational Governance Authority)
    - RFC 003 (Governed Memory and Retrieval Results) — complementary, not a dependency; see [Relationship to RFC 003](#relationship-to-rfc-003)
    - RFC 013 (Governed Continuity — Goal, Schedule, and Session Admission) — independent, commonly co-deployed
- **Issue:** — (not yet filed; see Open questions)
- **RFC PR:** —
- **Written against:** Hees 0.0.1 / Incan 0.5.0-rc2
- **Shipped in:** —

## Summary

Hees should independently admit every proposed operation against a governed memory record — inspecting it,
selecting it for a prompt, writing a new one, revoking it, or superseding it with a replacement — against
package-declared per-class policy. A retrieval provider or runtime may nominate *which* record an operation
targets, but only a package-declared `GovernedMemoryClass` and Hees's admission of the proposed operation
determine whether that operation is allowed. This is a lifecycle/access-control contract: it governs *what may be
done* to a memory record once its identity is known, not how a record is retrieved, ranked, or first assembled
into a retrieval envelope.

## Core model

1. **The package owns memory-class policy.** A package declares one or more `GovernedMemoryClass` entries — who
   owns a class of memory (`package`/`session`/`learner`/`runtime`), whether it's prompt-eligible, whether it's
   eligible for Hyperquant/retrieval nomination, whether it's runtime-writable, its maximum age, whether it
   requires explicit consent, whether it may be revoked or superseded, and its allowed keys and required
   provenance fields.
2. **The package owns which classes each operation kind may touch.** A `GovernedMemoryOperation` binds one
   `MemoryOperationKind` (`select_prompt`/`inspect`/`write`/`revoke`/`supersede`) to the set of memory classes it
   may act on.
3. **The caller proposes; Hees decides.** A caller assembles an untrusted `MemoryOperationProposal` — the
   operation, the target class and record identity, the current time, consent/provenance claims, and (for every
   operation but `write`) the existing record it claims to be acting on. Hees validates it and returns exactly one
   `MemoryOperationDecision`.
4. **Storage mutation is the caller's problem, admission is Hees's.** `evaluate_memory_operation` is a pure
   function. It does not write, revoke, or supersede anything itself; a caller-owned store performs the mutation
   only after Hees admits the proposal, and (for anything but `write`) only after supplying Hees the exact existing
   record to be evaluated.
5. **Lifecycle eligibility is independent of retrieval and independent of continuity.** This RFC never nominates
   or ranks a record, and never depends on a session's goal/phase/schedule state.

## Motivation

RFC 000 establishes that only Hees decides. But "decides" for memory has (at least) two genuinely separate
questions: *is this candidate record eligible to enter context at all* (RFC 003's ingress/materialization
concern), and, independently, *is this specific lifecycle action — reading it for a prompt, writing a new record,
revoking one, superseding one — allowed for this class of memory, right now, with this consent and provenance*
(this RFC's concern). A package with rich memory-class policy (a learner-preference class requiring explicit
consent and supporting revocation; a package-reviewed class that is prompt- and Hyperquant-eligible but never
writable; a runtime-trace class that is neither) has no shared contract for enforcing that policy today.

This gap was explored in the same research spike as RFC 013 (see `GOVERNED_CONTINUITY_HYPERQUANT_SPIKE_DECISION.md`,
2026-07-24) and implemented as `governed_memory_operations.incn`, whose own docstring already disclaims RFC 003
conformance: "Retrieval providers may nominate identifiers, but package declarations and Hees determine whether a
record is eligible for the proposed operation. This prototype is adjacent to RFC 003 and does not claim to
implement its retrieval ingress." This RFC formalizes that already-implemented, already-tested lifecycle contract
on its own terms, distinct from RFC 003.

## Goals

- Define package-declared `GovernedMemoryClass` policy: owner, prompt/Hyperquant eligibility, writability, maximum
  age, consent requirement, revoke/supersede permission, allowed keys, and required provenance fields.
- Define package-declared `GovernedMemoryOperation` authority binding one operation kind to its allowed classes.
- Define the untrusted `MemoryOperationProposal` envelope, including the caller-supplied `existing_record` a
  non-`write` operation is evaluated against.
- Define `evaluate_memory_operation` as a pure, deterministic admission function over exactly one proposed
  operation.
- Enforce package-level policy validity: unique class and operation identifiers, a known owner value, internally
  consistent eligibility flags (e.g. Hyperquant-eligible implies prompt-eligible; an immutable class cannot also
  allow revoke/supersede), non-empty operation-to-class bindings, and no duplicate operation kind across
  declarations.
- Enforce per-record eligibility at proposal time: identity match against the proposal and (when present) the
  session, non-future creation time, age-bound expiry, required-provenance completeness, and revoked/superseded/
  time-expired exclusion.
- Fail closed on every unknown class, unknown operation, disallowed class-for-operation, missing consent, missing
  provenance, or malformed proposal.

## Non-Goals

- Retrieving, ranking, or nominating which record an operation should target. A provider or runtime supplies
  `target_memory_id`/`existing_record`; this RFC only judges whether acting on that already-identified record is
  allowed. See [Relationship to RFC 003](#relationship-to-rfc-003).
- Performing the storage mutation itself (writing bytes, flipping a `revoked` flag, linking `superseded_by`). A
  caller-owned store does that only after admission, mirroring RFC 013's persistence split.
- Any dependency on session goal/phase/schedule state. See [Relationship to RFC 013](#relationship-to-rfc-013).
- Defining exact byte-size bounds, a canonical JCS encoding, or a receipt/Content DNA projection for memory-
  operation decisions. `governed_memory_operations.incn` does not yet define these; see [Open questions](#open-questions).

## Guide-level explanation

A package declares a memory class and the operations allowed on it:

```incan
preference_class = GovernedMemoryClass(
    memory_class_id=memory_class_id("learner_preference_memory"),
    owner="learner",
    prompt_eligible=true,
    hyperquant_eligible=false,
    runtime_writable=true,
    maximum_age_seconds=Some(2_592_000),
    explicit_consent_required=true,
    revoke_allowed=true,
    supersede_allowed=true,
    allowed_keys=["preferred_language", "presentation_mode"],
    required_provenance=["consent_receipt_id"],
)

write_operation = GovernedMemoryOperation(
    operation_id=memory_operation_id("write_memory"),
    operation_kind=MemoryOperationKind.Write,
    allowed_class_ids=[preference_class.memory_class_id],
)
```

Writing a new record requires consent and provenance and must not already exist:

```incan
decision = evaluate_memory_operation(
    policy,
    MemoryOperationProposal(
        operation_id=write_operation.operation_id,
        operation_kind=MemoryOperationKind.Write,
        memory_class_id=preference_class.memory_class_id,
        target_memory_id=memory_id("learner_preference_language_000042"),
        replacement_memory_id=None,
        memory_key=Some("preferred_language"),
        current_time_seconds=1_000_000,
        consent_present=true,
        provenance_fields=["consent_receipt_id"],
        existing_record=None,
        # profile_id/package_id/domain_id/package_revision/artifact_digest/session_id omitted for brevity
    ),
)
# decision.terminal == MemoryOperationTerminal.Admitted, reason == "declared_memory_write"
```

Revoking that same record later requires supplying the exact existing record Hees should judge eligibility
against; a record that's already revoked, superseded, expired, or identity-mismatched is rejected rather than
silently treated as already-gone.

## Reference-level explanation

### Package-declared authority

`GovernedMemoryPolicy` binds `GovernedMemoryClass` and `GovernedMemoryOperation` declarations to a package identity.
`validate_governed_memory_policy` enforces, before any proposal is considered:

- at least one class and one operation are declared;
- class identifiers and operation identifiers are each unique, and no two operations share the same
  `operation_kind`;
- each class's `owner` is one of `package`/`session`/`learner`/`runtime`;
- `hyperquant_eligible` implies `prompt_eligible` (`hyperquant_memory_not_prompt_eligible`);
- `allowed_keys` and `required_provenance` contain no duplicates and no empty or over-128-byte entries;
- `maximum_age_seconds`, if present, is positive;
- a class that is not `runtime_writable` must not allow revoke or supersede
  (`immutable_memory_has_lifecycle_mutation`) — an immutable class cannot have a mutable lifecycle;
- each operation declares a non-empty, duplicate-free `allowed_class_ids` list, and every referenced class exists.

### The proposal envelope

`MemoryOperationProposal` carries: the target operation id/kind, the full package identity, an optional
`session_id`, the target `memory_class_id`/`target_memory_id`, an optional `replacement_memory_id` (for
`supersede`), an optional `memory_key`, the current time, a `consent_present` claim, a `provenance_fields` claim,
and `existing_record: Option[GovernedMemoryRecord]`.

`GovernedMemoryRecord` is the caller-supplied, already-created record an operation acts on: its own class and
package identity, an optional owning session, an optional key, when it was created, when (if ever) it expires,
whether it's revoked, and an optional `superseded_by` pointer.

### Admission order

`evaluate_memory_operation` validates in this order, stopping at the first failure:

1. The policy must be structurally valid (`invalid_memory_policy`).
2. The proposal's package identity must exactly match the policy's (`package_identity_mismatch`).
3. `current_time_seconds` must be non-negative (`invalid_evaluation_time`).
4. The proposal's `operation_id` must name a declared operation (`unknown_memory_operation`).
5. That operation's declared `operation_kind` must match the proposal's (`memory_operation_kind_mismatch`).
6. The proposal's `memory_class_id` must be declared and must be one of the operation's `allowed_class_ids`
   (`unknown_memory_class`, `memory_class_not_allowed_for_operation`).
7. Operation-specific rules apply (below).

### Operation-specific rules

- **Write**: requires `existing_record` to be absent (`memory_already_exists`) and the class to be
  `runtime_writable` (`memory_class_not_writable`), then applies the shared consent/key/provenance checks below.
  Admits with reason `declared_memory_write`.
- **Inspect**, **SelectPrompt**, **Revoke**, **Supersede** all require `existing_record` to be present
  (`memory_record_required`), and the record must be *eligible*:
    - its identity (package, class, memory id, and — when the proposal names a session — that session) must match
      the proposal (`memory_record_identity_mismatch`); a package-owned record with no `session_id` at all is
      eligible regardless of the proposal's session, but a session-owned record must match exactly;
    - `created_at_seconds` must be non-negative and not in the future relative to `current_time_seconds`
      (`memory_record_time_invalid`);
    - if the class declares `maximum_age_seconds`, the record must not have exceeded it (`memory_expired`);
    - the record must carry every one of the class's `required_provenance` fields (`memory_record_provenance_incomplete`);
    - the record must not be `revoked` (`memory_revoked`) or already `superseded_by` another record
      (`memory_superseded`);
    - if the record declares `expires_at_seconds`, evaluation time must be strictly before it (`memory_expired`).
- **Inspect** admits unconditionally once the record is eligible, reason `declared_memory_inspection`.
- **SelectPrompt** additionally requires the class to be `prompt_eligible` (`memory_not_prompt_eligible`); admits
  with reason `declared_memory_read`.
- **Revoke** additionally requires the class to allow revocation (`memory_revoke_not_allowed`); admits with reason
  `declared_memory_revoke`.
- **Supersede** additionally requires: the class to allow supersession (`memory_supersede_not_allowed`); consent
  when the class requires it (`explicit_consent_required`); a `replacement_memory_id` that is present and differs
  from the target (`replacement_memory_required`, `replacement_memory_must_differ`); then the same key/provenance
  checks as `Write` (below). Admits with reason `declared_memory_supersede`.

### Shared consent/key/provenance checks (`Write` and `Supersede`)

- If the class requires explicit consent, `consent_present` must be true (`explicit_consent_required`).
- If the class declares a non-empty `allowed_keys` list, `memory_key` must be present and be one of them
  (`memory_key_not_allowed`); a class with an empty `allowed_keys` list places no key restriction.
- The proposal's `provenance_fields` must contain every one of the class's `required_provenance` entries
  (`memory_provenance_incomplete`).

### Public admission reasons

The complete set observed in the current implementation:

`invalid_memory_policy`, `package_identity_mismatch`, `invalid_evaluation_time`, `unknown_memory_operation`,
`memory_operation_kind_mismatch`, `unknown_memory_class`, `memory_class_not_allowed_for_operation`,
`memory_already_exists`, `memory_class_not_writable`, `memory_record_required`,
`memory_record_identity_mismatch`, `memory_record_time_invalid`, `memory_expired`,
`memory_record_provenance_incomplete`, `memory_revoked`, `memory_superseded`, `memory_not_prompt_eligible`,
`memory_revoke_not_allowed`, `memory_supersede_not_allowed`, `explicit_consent_required`,
`replacement_memory_required`, `replacement_memory_must_differ`, `memory_key_not_allowed`,
`memory_provenance_incomplete` (rejections); and `declared_memory_inspection`, `declared_memory_read`,
`declared_memory_revoke`, `declared_memory_supersede`, `declared_memory_write` (admissions).

As with RFC 013, this vocabulary is not yet frozen into a closed, namespaced table — see
[Open questions](#open-questions).

## Design details

### Relationship to RFC 003

RFC 003 owns *ingress*: turning an untrusted provider's ranked identifier nominations into a materialized,
package-owned accepted context, with its own closed 40-reason admission table across normalization/package/
request/provider/nominations/atoms/context/complete stages. This RFC owns a completely different question, asked
*after* a record's identity is already known by whatever means (RFC 003 ingress, direct package authorship, or a
runtime-created session record): is the proposed *operation* on that specific record — read it into a prompt,
inspect it, write it, revoke it, supersede it — authorized by package-declared class policy right now?

The two contracts do not compose structurally. `evaluate_memory_operation` never resolves a nomination, never
touches a provider binding, and knows nothing about relevance ranking. `admit_memory_result` (RFC 003) never
touches consent, revocation, supersession, or writability. A package that wants both retrieval-grounded prompt
context and consent-gated learner-writable preferences declares both a governed-memory registry (RFC 003) and a
memory-operation policy (this RFC); a runtime wanting to place a record in a prompt after RFC 003 accepted it as
context would additionally propose a `SelectPrompt` operation against this RFC for that same record. This RFC
takes no position on whether that additional check is required for RFC-003-sourced records specifically, or only
for session/learner-owned records that never go through RFC 003 ingress at all — that composition question is
explicitly open (see [Open questions](#open-questions)).

### Relationship to RFC 013

Independent. A memory-operation decision never reads continuity state, and a continuity decision never calls
`evaluate_memory_operation`. The two are commonly declared by the same package and evaluated back-to-back by the
same caller (as in the customer-demo project's pacing implementation, where a governed interaction both prepares
memory via memory operations and separately records a continuity action), but neither function calls or depends on
the other's types.

## Alternatives considered

### Fold this into RFC 003 as a post-materialization stage

Rejected. RFC 003's admission pipeline is about turning untrusted provider results into trusted context; consent,
revocation, and supersession are lifecycle concerns that apply to package-authored and runtime-created records
that never go through provider nomination at all (e.g. a `write_memory` proposal has no provider result to admit).
Bolting lifecycle authority onto RFC 003's stage table would force every package to declare a (potentially
nonsensical) provider binding just to write a learner preference.

### Let the runtime enforce class policy in application code

Rejected for the same reason RFC 000 rejects letting application code interpret policy generally: different
runtimes would disagree on edge cases (age boundary inclusivity, key-allowlist emptiness meaning "no restriction"
vs. "nothing allowed", provenance-field completeness), and a package author would have no single place to declare
memory-class rules that every implementation is bound to honor identically.

## Drawbacks

The composition question with RFC 003 (does every RFC-003-accepted record still need a `SelectPrompt` admission
here before entering a prompt, or is RFC 003 acceptance itself sufficient for prompt-eligible package-owned atoms)
is unresolved and could go either way depending on how strict callers want double-admission to be; leaving it open
risks two conforming implementations disagreeing about how many admission calls a single prompt-context assembly
requires. The admission-reason vocabulary is informal, matching RFC 013's drawback. `key_is_allowed`'s "empty
`allowed_keys` means no restriction" rule is easy to read backwards (it means *unrestricted*, not *nothing
allowed*) and may deserve a less surprising name in a future revision.

## Layers affected

- **Public contract:** New `MemoryOperationKind`, `MemoryOperationTerminal`, `GovernedMemoryClass`,
  `GovernedMemoryOperation`, `GovernedMemoryPolicy`, `GovernedMemoryRecord`, `MemoryOperationProposal`,
  `MemoryOperationDecision`, and `MemoryPolicyValidation` types; new `validate_governed_memory_policy` and
  `evaluate_memory_operation` public functions.
- **Runtime validation:** Deterministic policy validation, proposal-identity binding, per-record eligibility, and
  per-operation-kind admission with a closed (informal, pending formal freeze) reason vocabulary.
- **Package compatibility:** Purely additive and opt-in per package, mirroring RFC 003 and RFC 013.
- **Storage boundary:** Explicitly out of scope, mirroring RFC 013's persistence split.
- **Tests and documentation:** The reference implementation already carries positive and fail-closed tests
  (`tests/test_governed_memory_operations.incn`); formal cross-implementation fixtures remain open work.

## Design Decisions

- The caller supplies the exact existing record for every non-`write` operation; Hees never looks one up itself.
- A memory class's `hyperquant_eligible` flag implies `prompt_eligible` — a class ineligible for prompts cannot be
  Hyperquant-nominated either, since nomination without prompt eligibility would be meaningless.
- An immutable class (`runtime_writable=false`) cannot also declare `revoke_allowed`/`supersede_allowed` — those
  are both write-shaped lifecycle mutations and are rejected together at policy-validation time.
- `SelectPrompt`, `Revoke`, and `Supersede` each layer one additional check on top of shared eligibility, rather
  than duplicating eligibility per operation kind.
- Consent and provenance-completeness checks are shared between `Write` and `Supersede` (both create a new
  admitted state) but not required for `Inspect`, `SelectPrompt`, or `Revoke` (none of which create new content).
- This RFC is deliberately independent of RFC 003 and RFC 013 rather than layered on either, reflecting that the
  underlying implementation makes no structural call between the three.

## Open questions

- Does an RFC-003-accepted record still require a `SelectPrompt` admission under this RFC before entering a
  prompt, or is RFC 003 acceptance alone sufficient for `prompt_eligible` package-owned atoms? This determines
  whether the two contracts compose as "both required" or "either sufficient" for the package-memory case.
- Should the admission-reason vocabulary be frozen into a closed, namespaced table as part of this RFC?
- Should this RFC define exact byte-size/collection bounds, given `governed_memory_operations.incn` does not
  currently enforce any beyond structural non-emptiness?
- `key_is_allowed`'s empty-list-means-unrestricted semantics reads easy to misuse; worth a naming or shape revision
  before this leaves Draft?
- No proposal issue exists yet for this RFC. Per this repo's process, one should be opened (and discussed) before
  this document moves past `Draft`.
