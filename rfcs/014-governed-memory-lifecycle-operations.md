# RFC 014: Governed Memory Lifecycle Operations

- **Status:** Draft
- **Created:** 2026-08-19
- **Author(s):** Encero Systems
- **Related:**
    - RFC 000 (Foundational Governance Authority)
    - RFC 003 (Governed Memory and Retrieval Results) — complementary, not a dependency; see [Relationship to RFC 003](#relationship-to-rfc-003)
    - RFC 013 (Governed Continuity — Goal, Schedule, and Session Admission) — independent, commonly co-deployed
- **Issue:** https://github.com/encero-systems/hees.ai/issues/36
- **RFC PR:** —
- **Written against:** Hees.ai 0.0.1 / Incan 0.6.0-dev.6
- **Shipped in:** —

## Summary

Hees.ai should independently admit every proposed operation against a governed memory record — inspecting it, selecting it for a prompt, writing a new one, revoking it, or superseding it with a replacement — against package-declared per-class policy. A retrieval provider or runtime may nominate *which* record an operation targets, but only a package-declared `GovernedMemoryClass` and Hees.ai's admission of the proposed operation determine whether that operation is allowed. This is a lifecycle/access-control contract: it governs *what may be done* to a memory record once its identity is known, not how a record is retrieved, ranked, or first assembled into a retrieval envelope.

## Core model

1. **The package owns memory-class policy.** A package declares one or more `GovernedMemoryClass` entries — who owns a class of memory (`MemoryOwner`: `package`/`session`/`subject`/`runtime`), whether it's prompt-eligible, whether it's declared eligible for Hyperquant/retrieval nomination, whether it's runtime-writable, its maximum age, whether it requires explicit consent, whether it may be revoked or superseded, and its allowed keys and required provenance fields.
2. **The owner decides session binding.** A `package` class is package-authored, never runtime-writable, and its records carry no session. A `session` or `subject` class is session-scoped: every operation on it names a session, and a record matches only the session it carries. A `runtime` class binds a record to a session only when the record carries one.
3. **The package owns which classes each operation kind may touch.** A `GovernedMemoryOperation` binds one `MemoryOperationKind` (`select_prompt`/`inspect`/`write`/`revoke`/`supersede`) to the set of memory classes it may act on.
4. **The caller proposes; Hees.ai decides.** A caller assembles an untrusted `MemoryOperationProposal` — the operation, the target class and record identity, the current time, consent/provenance claims, and (for every operation but `write`) the existing record it claims to be acting on. Hees.ai validates it and returns exactly one `MemoryOperationDecision`.
5. **Hees.ai builds the record; the host stores it.** `evaluate_memory_operation` is a pure function. It never touches storage, but an admitted `write`, `revoke`, or `supersede` returns the resulting record, built and stamped by Hees.ai under the host's `WitnessKey`. The host persists that record unchanged and presents it as `existing_record` on every later operation; a record the host edits or assembles itself fails verification.
6. **Lifecycle eligibility is independent of retrieval and independent of continuity.** This RFC never nominates or ranks a record, and never depends on a session's goal/phase/schedule state.

## Motivation

RFC 000 establishes that only Hees.ai decides. But "decides" for memory has (at least) two genuinely separate questions: *is this candidate record eligible to enter context at all* (RFC 003's ingress/materialization concern), and, independently, *is this specific lifecycle action — reading it for a prompt, writing a new record, revoking one, superseding one — allowed for this class of memory, right now, with this consent and provenance* (this RFC's concern). A package with rich memory-class policy (a subject-preference class requiring explicit consent and supporting revocation; a package-reviewed class that is prompt- and Hyperquant-eligible but never writable; a runtime-trace class that is neither) has no shared contract for enforcing that policy today.

The gap is implemented as `governed_memory_operations.incn`, whose docstring disclaims RFC 003 conformance: "This module is adjacent to RFC 003 and does not implement its retrieval ingress." This RFC specifies that lifecycle contract on its own terms, distinct from RFC 003.

## Goals

- Define package-declared `GovernedMemoryClass` policy: owner, prompt/Hyperquant eligibility, writability, maximum age, consent requirement, revoke/supersede permission, allowed keys, and required provenance fields.
- Define the `MemoryOwner` session-binding rules and enforce them on every operation.
- Define package-declared `GovernedMemoryOperation` authority binding one operation kind to its allowed classes.
- Define the untrusted `MemoryOperationProposal` envelope, including the `existing_record` a non-`write` operation is evaluated against, which the caller presents exactly as Hees.ai returned it.
- Define `evaluate_memory_operation` as a pure, deterministic admission function over exactly one proposed operation, which builds and stamps every record it admits a mutation for.
- Enforce package-level policy validity: collection bounds, canonical identifiers, unique class and operation identifiers, internally consistent class flags (Hyperquant-eligible implies prompt-eligible; an immutable class cannot also allow revoke/supersede; a package-owned class is never runtime-writable), non-empty operation-to-class bindings, and no duplicate operation kind across declarations.
- Enforce proposal shape and per-record eligibility at proposal time: canonical identifiers and bounded key/provenance text, identity and session-binding match, non-future creation time, age-bound expiry, required-provenance completeness, declared key, and revoked/superseded/time-expired exclusion.
- Fail closed on every unknown class, unknown operation, disallowed class-for-operation, missing session, missing consent, missing provenance, or malformed proposal or record.

## Non-Goals

- Retrieving, ranking, or nominating which record an operation should target. A provider or runtime supplies `target_memory_id`/`existing_record`; this RFC only judges whether acting on that already-identified record is allowed. See [Relationship to RFC 003](#relationship-to-rfc-003).
- Performing the storage mutation itself. Hees.ai returns the record an admitted mutation produces; a host-owned store persists it, mirroring RFC 013's persistence split.
- Any dependency on session goal/phase/schedule state. See [Relationship to RFC 013](#relationship-to-rfc-013).
- Defining a canonical JCS encoding or a receipt/Content DNA projection for memory-operation decisions. `governed_memory_operations.incn` does not define these; see [Open questions](#open-questions).
- A subject identity separate from the session. `subject` records bind to a session exactly like `session` records; see [Open questions](#open-questions).

## Guide-level explanation

A package declares a memory class and the operations allowed on it:

```incan
preference_class = GovernedMemoryClass(
    memory_class_id=memory_class_id("subject_preference_memory"),
    owner=MemoryOwner.Subject,
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

Writing a new record into that subject-owned class requires a session, consent, a declared key, and provenance, and the host must hold no record for that identifier:

```incan
decision = evaluate_memory_operation(
    policy,
    MemoryOperationProposal(
        operation_id=write_operation.operation_id,
        operation_kind=MemoryOperationKind.Write,
        session_id=Some(session_id("session_000042")),
        memory_class_id=preference_class.memory_class_id,
        target_memory_id=memory_id("subject_preference_language_000042"),
        replacement_memory_id=None,
        memory_key=Some("preferred_language"),
        current_time_seconds=1_000_000,
        consent_present=true,
        provenance_fields=["consent_receipt_id"],
        existing_record=None,
        # profile_id/package_id/domain_id/package_revision/memory_policy_digest omitted for brevity
    ),
    host_witness_key,
)
# decision.terminal == MemoryOperationTerminal.Admitted, reason == "declared_memory_write"
# decision.resulting_record == Some(record built and stamped by Hees.ai); the host persists it unchanged
```

The same proposal with `session_id=None` is rejected with `memory_session_required`. Revoking that record later requires presenting the stored record exactly as Hees.ai returned it, in the session that record carries; a record that's already revoked, superseded, expired, presented from another session, identity-mismatched, or edited since Hees.ai stamped it is rejected rather than silently treated as already-gone. An admitted revoke returns the record with `revoked` set, restamped, for the host to persist in place of the old one.

## Reference-level explanation

### Package-declared authority

`GovernedMemoryPolicy` binds `GovernedMemoryClass` and `GovernedMemoryOperation` declarations to a package identity. `validate_governed_memory_policy` checks, in this order, stopping at the first failure:

1. At least one class and one operation are declared (`memory_policy_empty`).
2. Every collection is within its bound (`memory_policy_too_large`): at most 32 classes, at most 5 operations, at most 32 `allowed_keys` and at most 16 `required_provenance` entries per class, and at most 32 `allowed_class_ids` per operation. Bounds run before the digest and every duplicate scan, so an oversized policy is rejected in linear time.
3. The package identity, every class identifier, and every operation identifier are canonical text for their namespace (`invalid_memory_policy_identifier`): `profile_id`, `package_id`, `domain_id`, and class/operation identifiers use the shared Hees.ai identifier rule, `package_revision` the artifact-revision rule, and `memory_policy_digest` the `sha256:` digest rule. Identifier newtypes constructed directly skip their validating constructors, so the kernel re-checks the text.
4. `memory_policy_digest` is not a caller-chosen label: `digest_governed_memory_policy` recomputes it from every other policy field (classes and operations included), and a mismatch is rejected (`memory_policy_digest_mismatch`).
5. Class identifiers are unique (`duplicate_memory_class_id`), then operation identifiers (`duplicate_memory_operation_id`).
6. Each class, in declaration order:
    - `hyperquant_eligible` implies `prompt_eligible` (`hyperquant_memory_not_prompt_eligible`);
    - every `allowed_keys` and `required_provenance` entry is a canonical identifier — lowercase ASCII letters, digits, `_` and `-`, 1 to 128 characters, not starting with `_` or `-` (`invalid_memory_class_value`);
    - neither list contains a duplicate (`duplicate_memory_class_declaration`);
    - `maximum_age_seconds`, if present, is positive (`invalid_memory_maximum_age`);
    - a class that is not `runtime_writable` must not allow revoke or supersede (`immutable_memory_has_lifecycle_mutation`);
    - a `package`-owned class must not be `runtime_writable` (`package_memory_runtime_writable`).
7. No two operations share an `operation_kind` (`duplicate_memory_operation_kind`); then each operation declares a non-empty (`memory_operation_classes_empty`), duplicate-free (`duplicate_operation_memory_class`) `allowed_class_ids` list whose every entry names a declared class (`operation_memory_class_unknown`).

A valid policy returns reason `valid`. `owner` is a closed `MemoryOwner` value enum, so an unknown owner fails at deserialization rather than at validation.

`memory_policy_digest` is the SHA-256 of the type tag `hees.ai/memory-policy/v0` followed by the current serializer's JSON rendering of every other policy field; the record witness (below) authenticates the type tag `hees.ai/memory-record/v0` followed by the record projection's JSON the same way. The type tags keep one projection from being replayed as another. This encoding is interim: it does not yet conform to RFC 011 structural identity.

### Session ownership

`MemoryOwner` decides how a class binds its records to a session:

| Owner | Operation requires a proposal `session_id` | A record matches the proposal when |
| --- | --- | --- |
| `package` | no | the record carries no `session_id` |
| `session` | yes (`memory_session_required`) | the record carries a `session_id` equal to the proposal's |
| `subject` | yes (`memory_session_required`) | the record carries a `session_id` equal to the proposal's |
| `runtime` | no | the record carries no `session_id`, or one equal to the proposal's |

A record that fails its owner's rule is rejected with `memory_record_identity_mismatch`. A session-scoped record that carries no session therefore matches no session at all. `subject` marks memory about the person a session serves; because this contract carries no identity for that person beyond the session, `subject` records bind to a session exactly like `session` records.

### The proposal envelope

`MemoryOperationProposal` carries: the target operation id/kind, the full package identity, an optional `session_id`, the target `memory_class_id`/`target_memory_id`, an optional `replacement_memory_id` (accepted only on `supersede`), an optional `memory_key`, the current time, a `consent_present` claim, a `provenance_fields` claim, and `existing_record: Option[GovernedMemoryRecord]`. `consent_present` and `provenance_fields` are caller attestations: Hees.ai checks that they satisfy the class policy, not that they are true.

A proposal is well formed (`invalid_memory_proposal` otherwise) when its operation, class, target, replacement, and session identifiers are canonical identifier text, `memory_key` (if present) is a canonical identifier, and `provenance_fields` holds at most 16 canonical, duplicate-free identifiers.

`GovernedMemoryRecord` is the record an operation acts on: its own class and package identity, an optional owning session, an optional key, when it was created, when (if ever) it expires, whether it's revoked, an optional `superseded_by` pointer, its provenance fields, and a `record_witness`. Hees.ai builds every record itself: an admitted `write`, `revoke`, or `supersede` returns it in `MemoryOperationDecision.resulting_record`, and the host persists that record unchanged and presents it as `existing_record` on every later operation.

`record_witness` is a `KeyedWitness`: an HMAC-SHA256 tag over the record's other fields under a `WitnessKey` the host passes to every `evaluate_memory_operation` call, plus that key's identifier. It authenticates that the record was returned by `evaluate_memory_operation` under the host's key. A record stamped under another key identifier or another secret, a record with any field edited after stamping, a malformed witness, and a hand-assembled record carrying a placeholder witness all fail verification (`memory_record_witness_invalid`). The host keeps the key out of every model, provider, and package input. Anyone holding the key can stamp a record, so the key is the host's trust anchor; no public function stamps a record without it.

### Admission order

`evaluate_memory_operation(policy, proposal, witness_key)` validates in this order, stopping at the first failure:

1. The host's `witness_key` must have a canonical key identifier and a secret of 32 to 1024 bytes (`invalid_witness_key`); nothing else is trusted before the key is.
2. The policy must be structurally valid (`invalid_memory_policy`).
3. The proposal's package identity must exactly match the policy's (`package_identity_mismatch`).
4. `current_time_seconds` must be non-negative (`invalid_evaluation_time`).
5. The proposal must be well formed (`invalid_memory_proposal`).
6. The proposal's `operation_id` must name a declared operation (`unknown_memory_operation`).
7. That operation's declared `operation_kind` must match the proposal's (`memory_operation_kind_mismatch`).
8. The proposal's `memory_class_id` must name a declared class (`unknown_memory_class`).
9. That class must be one of the operation's `allowed_class_ids` (`memory_class_not_allowed_for_operation`).
10. A proposal whose kind is not `supersede` must not carry a `replacement_memory_id` (`replacement_memory_not_allowed`).
11. A proposal on a `session`- or `subject`-owned class must carry a `session_id` (`memory_session_required`).
12. Operation-specific rules apply (below), dispatched exhaustively on `MemoryOperationKind`.

### Operation-specific rules

- **Write**: requires `existing_record` to be absent (`memory_already_exists`) and the class to be `runtime_writable` (`memory_class_not_writable`), then applies the shared new-content checks below. Admits with reason `declared_memory_write` and returns the new record (see [Resulting records](#resulting-records)).
- **Inspect**, **SelectPrompt**, **Revoke**, **Supersede** all require `existing_record` to be present (`memory_record_required`), and the record must be *eligible*, checked in this order:
    - its package identity, class, and memory id must match the proposal (`memory_record_identity_mismatch`);
    - its session must satisfy the class owner's rule from [Session ownership](#session-ownership) (`memory_record_identity_mismatch`);
    - its `superseded_by` (if present) must be a canonical identifier, its `memory_key` (if present) a canonical identifier, and its `provenance_fields` at most 16 canonical, duplicate-free identifiers (`invalid_memory_record`);
    - its `record_witness` must verify under the host's `witness_key` over the record's other fields (`memory_record_witness_invalid`);
    - `created_at_seconds` must be non-negative and not after `current_time_seconds` (`memory_record_time_invalid`);
    - if the class declares `maximum_age_seconds`, the record's age (`current_time_seconds - created_at_seconds`) must be less than it; an age equal to the maximum is expired, matching `expires_at_seconds` on a record Hees.ai wrote (`memory_expired`);
    - the record must carry every one of the class's `required_provenance` fields (`memory_record_provenance_incomplete`);
    - the record's `memory_key` must satisfy the class key list, under the same rule as the shared key check below (`memory_record_key_not_allowed`);
    - the record must not be `revoked` (`memory_revoked`) or already `superseded_by` another record (`memory_superseded`);
    - if the record declares `expires_at_seconds`, evaluation time must be strictly before it; `expires_at_seconds == current_time_seconds` is expired (`memory_expired`).
- **Inspect** admits once the record is eligible, reason `declared_memory_inspection`.
- **SelectPrompt** additionally requires the class to be `prompt_eligible` (`memory_not_prompt_eligible`); admits with reason `declared_memory_read`.
- **Revoke** additionally requires the class to allow revocation (`memory_revoke_not_allowed`); admits with reason `declared_memory_revoke` and returns the revoked record.
- **Supersede** additionally requires, in order: the class to allow supersession (`memory_supersede_not_allowed`); a `replacement_memory_id` (`replacement_memory_required`) that differs from the target (`replacement_memory_must_differ`); then the shared new-content checks below. Admits with reason `declared_memory_supersede` and returns the superseded record.

A decision carries `replacement_memory_id` only for an admitted `supersede`, where it is the validated replacement; every other decision carries none.

### Resulting records

`MemoryOperationDecision.resulting_record` is present only on an admitted `write`, `revoke`, or `supersede`, and every record in it is stamped under the host's `witness_key`:

- **Write** returns a new record built from the proposal and the class policy: the proposal's `target_memory_id`, `memory_class_id`, and package identity; a `session_id` by the class owner rule (none for `package`, otherwise the proposal's, so a sessionless `runtime` write yields a record that matches any session); the proposal's `memory_key` and `provenance_fields`; `created_at_seconds = current_time_seconds`; `expires_at_seconds = created_at_seconds + maximum_age_seconds` when the class declares a maximum age (clamped to the largest representable time), otherwise none; `revoked = false`; and no `superseded_by`.
- **Revoke** returns the existing record with `revoked = true`.
- **Supersede** returns the existing record with `superseded_by` set to the validated replacement. The replacement record itself is created by a separate `write`.

`select_prompt`, `inspect`, and every rejection carry no record. The host persists a returned record unchanged. A record returned by `revoke` or `supersede` replaces the stored version of the same record. The earlier version still verifies, so the host's store, not Hees.ai, decides which version is current.

Hees.ai holds no store, so it cannot know which identifiers are in use. The host carries two obligations that follow from that. Before it proposes a `write`, it looks up `target_memory_id` in its store, and if any version of that record exists, revoked and superseded versions included, it supplies it as `existing_record`; Hees.ai then rejects the write with `memory_already_exists`. A host that proposes a `write` for an identifier it already holds, without supplying the record, would receive a fresh record and could overwrite a revocation. And a record returned by `write` is never stored over an existing record with the same identifier.

`supersede` checks consent, the key, and provenance against the proposal, but it does not create the replacement. The replacement is created by a separate `write`, which runs the same checks on its own proposal; nothing in the returned record links that write back to the supersede.

### Shared new-content checks (`Write` and `Supersede`)

In order:

- If the class requires explicit consent, `consent_present` must be true (`explicit_consent_required`).
- If the class declares a non-empty `allowed_keys` list, `memory_key` must be present and be one of them (`memory_key_not_allowed`); a class with an empty `allowed_keys` list places no key restriction.
- The proposal's `provenance_fields` must contain every one of the class's `required_provenance` entries (`memory_provenance_incomplete`).

### Public admission reasons

`evaluate_memory_operation` returns exactly one of these reasons.

Rejections (31): `invalid_witness_key`, `invalid_memory_policy`, `package_identity_mismatch`, `invalid_evaluation_time`, `invalid_memory_proposal`, `unknown_memory_operation`, `memory_operation_kind_mismatch`, `unknown_memory_class`, `memory_class_not_allowed_for_operation`, `replacement_memory_not_allowed`, `memory_session_required`, `memory_already_exists`, `memory_class_not_writable`, `memory_record_required`, `memory_record_identity_mismatch`, `invalid_memory_record`, `memory_record_witness_invalid`, `memory_record_time_invalid`, `memory_expired`, `memory_record_provenance_incomplete`, `memory_record_key_not_allowed`, `memory_revoked`, `memory_superseded`, `memory_not_prompt_eligible`, `memory_revoke_not_allowed`, `memory_supersede_not_allowed`, `replacement_memory_required`, `replacement_memory_must_differ`, `explicit_consent_required`, `memory_key_not_allowed`, `memory_provenance_incomplete`.

Admissions (5): `declared_memory_inspection`, `declared_memory_read`, `declared_memory_revoke`, `declared_memory_supersede`, `declared_memory_write`.

`unknown_memory_operation` means only that `operation_id` names no declared operation. Dispatch on `MemoryOperationKind` is exhaustive, so no reason is reserved for an unhandled kind. Stamping a resulting record cannot fail for a projection the serializer rendered; if it ever did, the operation would be rejected with `memory_record_witness_invalid` rather than admitted without a witness.

`validate_governed_memory_policy` returns `valid` or one of 16 reasons: `memory_policy_empty`, `memory_policy_too_large`, `invalid_memory_policy_identifier`, `memory_policy_digest_mismatch`, `duplicate_memory_class_id`, `duplicate_memory_operation_id`, `hyperquant_memory_not_prompt_eligible`, `invalid_memory_class_value`, `duplicate_memory_class_declaration`, `invalid_memory_maximum_age`, `immutable_memory_has_lifecycle_mutation`, `package_memory_runtime_writable`, `duplicate_memory_operation_kind`, `memory_operation_classes_empty`, `duplicate_operation_memory_class`, `operation_memory_class_unknown`.

`invalid_memory_policy` is a coarse wrapper, same as RFC 013's `invalid_continuity_package`: every policy validation failure, including a stale `memory_policy_digest`, collapses into it at the `evaluate_memory_operation` boundary. A caller who wants the specific cause calls `validate_governed_memory_policy` directly and reads its uncoarsened `reason` (e.g. `memory_policy_digest_mismatch`).

As with RFC 013, this vocabulary is not yet frozen into a closed, namespaced table — see [Open questions](#open-questions).

## Design details

### Relationship to RFC 000

This contract applies RFC 000's posture — the package declares authority, the caller proposes, Hees.ai decides, malformed input fails closed. `existing_record` is a serializable value the host stores between calls rather than an opaque in-memory capability, but it is one that a trusted Hees.ai operation returned: its keyed `record_witness` authenticates that origin under the host's key. What the witness does not prove is freshness: an earlier version of a record still verifies, so the host's store decides which version is current.

### Relationship to RFC 003

RFC 003 owns *ingress*: turning an untrusted provider's ranked identifier nominations into a materialized, package-owned accepted context, with its own closed 39-reason admission table across normalization/package/request/provider/nominations/atoms/context/complete stages. This RFC owns a completely different question, asked *after* a record's identity is already known by whatever means (RFC 003 ingress, direct package authorship, or a runtime-created session record): is the proposed *operation* on that specific record — read it into a prompt, inspect it, write it, revoke it, supersede it — authorized by package-declared class policy right now?

The two contracts do not compose structurally. `evaluate_memory_operation` never resolves a nomination, never touches a provider binding, and knows nothing about relevance ranking. `admit_memory_result` (RFC 003) never touches consent, revocation, supersession, or writability. A package that wants both retrieval-grounded prompt context and consent-gated subject-writable preferences declares both a governed-memory registry (RFC 003) and a memory-operation policy (this RFC); a runtime wanting to place a record in a prompt after RFC 003 accepted it as context would additionally propose a `SelectPrompt` operation against this RFC for that same record. This RFC takes no position on whether that additional check is required for RFC-003-sourced records specifically, or only for session- or subject-owned records that never go through RFC 003 ingress at all — that composition question is explicitly open (see [Open questions](#open-questions)).

### Relationship to RFC 013

Independent. A memory-operation decision never reads continuity state, and a continuity decision never calls `evaluate_memory_operation`. The two are commonly declared by the same package and evaluated back-to-back by the same caller, but neither function calls or depends on the other's types.

## Alternatives considered

### Fold this into RFC 003 as a post-materialization stage

Rejected. RFC 003's admission pipeline is about turning untrusted provider results into trusted context; consent, revocation, and supersession are lifecycle concerns that apply to package-authored and runtime-created records that never go through provider nomination at all (e.g. a `write_memory` proposal has no provider result to admit). Bolting lifecycle authority onto RFC 003's stage table would force every package to declare a (potentially nonsensical) provider binding just to write a subject preference.

### Let the runtime enforce class policy in application code

Rejected for the same reason RFC 000 rejects letting application code interpret policy generally: different runtimes would disagree on edge cases (age boundary inclusivity, key-allowlist emptiness meaning "no restriction" vs. "nothing allowed", provenance-field completeness, which owners bind to a session), and a package author would have no single place to declare memory-class rules that every implementation is bound to honor identically.

### Key session binding on the record's own `session_id`

Rejected. If a record with no `session_id` matched every session regardless of its class owner, a session- or subject-owned record written or stored without a session would be selectable from every other session. Binding is therefore decided by the class owner, and a session-scoped record without a session matches no session.

## Drawbacks

The composition question with RFC 003 (does every RFC-003-accepted record still need a `SelectPrompt` admission here before entering a prompt, or is RFC 003 acceptance itself sufficient for prompt-eligible package-owned atoms) is unresolved and could go either way depending on how strict callers want double-admission to be; leaving it open risks two conforming implementations disagreeing about how many admission calls a single prompt-context assembly requires. The admission-reason vocabulary is informal, matching RFC 013's drawback. `key_is_allowed`'s "empty `allowed_keys` means no restriction" rule is easy to read backwards (it means *unrestricted*, not *nothing allowed*) and may deserve a less surprising name in a future revision. `record_witness` authenticates origin, not freshness: a host that restores an earlier stored version of a record (for example the version from before a `revoke`) presents a record that still verifies, so revocation holds only as long as the host's store keeps the latest version. Every host must also manage a witness key: whoever holds it can stamp records, and losing or rotating it invalidates every stored record stamped under it. `subject` and `session` currently behave identically, because the contract has no subject identity that outlives a session.

## Layers affected

- **Public contract:** New `MemoryOperationKind`, `MemoryOperationTerminal`, `MemoryOwner`, `GovernedMemoryClass`, `GovernedMemoryOperation`, `GovernedMemoryPolicy`, `GovernedMemoryRecord`, `MemoryOperationProposal`, `MemoryOperationDecision`, and `MemoryPolicyValidation` types; new `validate_governed_memory_policy` and `evaluate_memory_operation` public functions, plus `digest_governed_memory_policy` for package authors to stamp a policy's digest before use. `evaluate_memory_operation` takes the host's `WitnessKey`, and `GovernedMemoryRecord.record_witness` is a `KeyedWitness`; both types come from the shared witness module. No public function stamps a record: only `evaluate_memory_operation` does, under the host's key.
- **Runtime validation:** Deterministic policy validation, proposal-identity binding, proposal and record shape, owner-based session binding, per-record eligibility, and per-operation-kind admission with a closed (informal, pending formal freeze) reason vocabulary.
- **Package compatibility:** Purely additive and opt-in per package, mirroring RFC 003 and RFC 013.
- **Storage boundary:** Hees.ai returns every record it admits a mutation for; storing it is the host's job, mirroring RFC 013's persistence split. The host persists the returned record unchanged.
- **Tests and documentation:** `tests/test_governed_memory_operations.incn` carries positive and fail-closed tests for every admission and rejection reason and every policy validation reason; formal cross-implementation fixtures remain open work.

## Design Decisions

- The caller supplies the exact existing record for every non-`write` operation; Hees.ai never looks one up itself.
- Hees.ai, not the caller, builds every record: an admitted `write`, `revoke`, or `supersede` returns the record stamped under the host's key, and the caller persists it unchanged. A caller without the key has no way to stamp a record.
- Session binding is decided by the class `owner`, not by whether the record happens to carry a `session_id`. `session` and `subject` classes require a session on every operation and match only the record's own session.
- A `package`-owned class is never runtime-writable, and its records carry no session; package memory changes through a new package revision, not at runtime.
- A memory class's `hyperquant_eligible` flag implies `prompt_eligible` — a class ineligible for prompts cannot be Hyperquant-nominated either, since nomination without prompt eligibility would be meaningless. The flag is declared and validated but not consumed: no operation in this contract reads it.
- An immutable class (`runtime_writable=false`) cannot also declare `revoke_allowed`/`supersede_allowed` — those are both write-shaped lifecycle mutations and are rejected together at policy-validation time.
- `SelectPrompt`, `Revoke`, and `Supersede` each layer one additional check on top of shared eligibility, rather than duplicating eligibility per operation kind.
- Consent and proposal-provenance checks are shared between `Write` and `Supersede` (both create new content) but not required for `Inspect`, `SelectPrompt`, or `Revoke`; every non-`write` operation still requires the existing record's provenance to be complete.
- A `replacement_memory_id` outside `supersede` is rejected rather than ignored, so a decision never carries an identifier Hees.ai did not validate.
- Collection bounds and identifier text are checked before the digest recomputation and every duplicate scan.
- This RFC is deliberately independent of RFC 003 and RFC 013 rather than layered on either, reflecting that the underlying implementation makes no structural call between the three.
- `GovernedMemoryPolicy.memory_policy_digest` is a public digest: a package author computes it, and it identifies the policy rather than authenticating it. `GovernedMemoryRecord.record_witness` is a keyed HMAC-SHA256 witness under the host's `WitnessKey`, so it authenticates that `evaluate_memory_operation` returned the record. The host keeps the key out of model, provider, and package inputs; anyone holding it can stamp records, so it is the host's trust anchor.
- `evaluate_memory_operation` requires the witness key and rejects an invalid one (`invalid_witness_key`) before any other check; there is no unkeyed mode.

## Open questions

- Does an RFC-003-accepted record still require a `SelectPrompt` admission under this RFC before entering a prompt, or is RFC 003 acceptance alone sufficient for `prompt_eligible` package-owned atoms? This determines whether the two contracts compose as "both required" or "either sufficient" for the package-memory case.
- Should the admission-reason vocabulary be frozen into a closed, namespaced table as part of this RFC?
- Should `subject` gain an identity that outlives a session, so a subject-owned record can be selected in a later session of the same subject? Until it does, `subject` binds to a session exactly like `session`.
- `key_is_allowed`'s empty-list-means-unrestricted semantics reads easy to misuse; worth a naming or shape revision before this leaves Draft?
- How should a host rotate witness keys: should `evaluate_memory_operation` accept a set of keys and select one by the witness's `key_id`, or should a dedicated migration operation verify a record under the old key and restamp it under the new one?
- Should the record witness bind freshness (for example a per-record version the host's store must advance), so a restored earlier version of a record no longer verifies?
- The policy digest and the record witness hash the current serializer's JSON behind a type tag. When should they move to RFC 011 structural identity, and does that change the type tags' version suffix?
