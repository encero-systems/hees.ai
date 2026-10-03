# Contracts

`src/lib.incn` is the complete checked public surface.

## External package descriptor

The descriptor API exports:

- `PackageLoaderDescriptor`
- `PackageLoaderValidation`
- `package_loader_descriptor`
- `validate_package_loader_descriptor`
- `package_loader_summary`

Despite the historical `Loader` name, this surface validates metadata only. It requires schema `0.1`, source kind `source_controlled_domain_package`, safe identifiers, and a repository-relative path ending in `package/domain.json`. It rejects traversal, dot segments, absolute paths, Windows drive forms, backslashes, and common embedded control characters. It does not call a filesystem API or establish that the referenced file exists.

## Runtime package

`GovernedPackage` contains a schema version, package and domain identifiers, a mission, action contracts, and evidence records. A deployable evidence record must be explicitly `RightsStatus.Allowed` and `ReviewStatus.Approved`; raw source text is not part of the model.

`validate_governed_package` rejects unsupported schema versions, unsafe or duplicate identifiers, missing missions or actions, unsafe source references, unapproved evidence, and evidence whose declared runtime rights are not allowed.

## Proposal admission

`ModelProposal` carries package/domain identifiers, a package-owned action identifier, visible output, and cited evidence identifiers. `admit_model_proposal` rejects invalid packages, identity mismatches, empty visible output, undeclared actions, missing required evidence, duplicate citations, and unknown citations.

Admission proves only those structural conditions. It does not prove factual correctness, semantic support, source ownership, licensing, cryptographic integrity, retrieval quality, model correctness, or policy completeness.

`AdmissionResult` records a terminal `RuntimeDecision`, a stable reason, cited evidence identifiers, and package errors. It contains no hidden reasoning or chain-of-thought.

## Initial console profile

`console_profile_0_1` is a separate, closed profile over the fictional Console acceptance corpus. It extends the generic runtime with one exact governed-development and interaction contract.

Its package contract is concrete: profile, package, domain and revision identity; exact source records and fingerprints; reviewed-memory atoms with source spans, provenance, review and rights state; permitted actions; visible-answer requirements; integer policy thresholds; evaluator roles and bounds; terminal reasons; selected-memory behavior; Content DNA; and receipt projection. The [Governance profiles guide](governance-profiles.md) maps those fields to the fictional Lantern Labs package and explains their authority owners.

The profile validates exact package, request-binding, and proposal identities; recomputes the package, provenance, request, proposal, manifest-target, Content DNA, and receipt digests; constructs the complete verifier manifest; validates exact observation coverage and fingerprints; and derives findings under package-owned basis-point thresholds. Provider observations remain non-authoritative inputs. The profile, not the provider-facing Console module, selects the public reason and terminal decision.

On the admitted path, the profile delegates structural checks to `admit_model_proposal`, freezes every and only the admitted package atoms referenced by the support mappings, constructs Content DNA from that ordered selection, and returns the visible units and provenance atomically. A rejected path exposes no visible units, selected memory, or Content DNA. Once the fixed package, request, and proposal identity are safely established, it returns a redacted rejection receipt; raw-contract, replay, package, request, and unsafe-proposal-identity failures return no receipt.

The native Incan Console calls the public profile directly. Its Profile Studio may stage or unstage supplied evidence and memory in a session-local candidate and invoke real profile validation, but the candidate remains non-active because this profile exposes no activation-authority API. The `console_runner_request_0_1` and `console_runner_response_0_1` schemas remain a bounded compatibility and diagnostic seam rather than the product's application boundary. Authority-bearing finding, Spectrum, evaluation, Content DNA, and receipt types stay internal; only their canonical terminal projection crosses the package ABI. Live mode accepts bounded provider-normalized inputs. Replay mode additionally binds the checked schema, model, configuration, prompt, and replay identities used by the fictional acceptance corpus. After decoding, both modes call the same authority path.

This first profile does not provide retrieval, a semantic verifier model, a general package compiler, or a stable production protocol. Its fixed counts, languages, source kinds, policy values, and fixture identities are deliberate acceptance-profile constraints.

## Governed continuity

The continuity API exports:

- `ContinuityPackage`, `GovernedGoal`, `GovernedSchedule`, and `GovernedPhase`
- `ContinuityProposal`, `ContinuityOperationKind`, and `SessionContinuityState`
- `ContinuityDecision`, `ContinuityTerminal`, and `ContinuityValidation`
- `digest_continuity_package`
- `validate_continuity_package` and `evaluate_continuity`
- `WitnessKey`, `KeyedWitness`, `witness_key_is_valid`, `MIN_WITNESS_KEY_BYTES`, and `MAX_WITNESS_KEY_BYTES`

Its design is under review in Draft [RFC 013](https://github.com/encero-systems/hees.ai/blob/main/rfcs/013-governed-continuity-goal-schedule-session-admission.md); this exported surface may change with it.

A `ContinuityPackage` declares goals and schedules. A goal names its entry phase, completion phases, and allowed actions, and declares whether a session may expire. A schedule belongs to one goal and declares a total target duration, its allowed clock sources, and an ordered phase graph; each phase declares minimum, target, and maximum durations, allowed actions, and the next phases it may move to. The caller stamps `continuity_declaration_digest` with `digest_continuity_package`. `validate_continuity_package` recomputes that digest and rejects a mismatch, empty declarations, duplicate identifiers, unknown goal or phase references, inconsistent phase durations, phases without actions, self-cycles, and next phases that do not appear later in the schedule.

`evaluate_continuity` admits or rejects one caller-proposed `start`, `continue`, `transition`, `close`, or `expire` event. It takes the package, the proposal, and the host's `WitnessKey`, and rejects an invalid key before anything else. It requires a valid package with matching package identity, a declared goal, schedule, and phase, a clock source the schedule allows, and an action that both the goal and the phase allow. `start` requires no prior state, event index `0`, and the goal's entry phase. Every other operation requires the prior `SessionContinuityState`: its identity must match the proposal, its `state_witness` must verify under the host's key, it must not be closed, the event index must be exactly one greater, and the clock must not move backward. For `continue`, `transition`, and `close`, the time spent in the current phase must not exceed that phase's maximum. `transition` additionally requires a declared next phase and the current phase's minimum duration; `close` requires a completion phase and the schedule's total target duration. `expire` is admitted only after the time spent in the current phase exceeds that phase's maximum, and only when the goal declares that a session may expire; it closes the session and marks the resulting state `expired`. Once a phase maximum has passed, every other operation is rejected. An admitted decision carries the resulting witnessed state; a rejected decision carries no state.

Hees.ai reads no clock, runs no timer, and stores no session state. The host supplies the time, keeps the resulting state, passes it back with the next proposal, and proposes `expire` when a session overruns. The state witness is an HMAC-SHA256 tag under the host's `WitnessKey`, computed over a type-tagged projection of the state. A state that was edited, assembled by hand, or stamped under another key does not verify. The host keeps the key out of every model, provider, and package input; anyone who holds the key can stamp a state. The witness does not prove that a state is the latest one: every state Hees.ai returned for a session still verifies. The host keeps exactly one current state per session and supplies only that state.

## Governed memory operations

The memory-operation API exports:

- `GovernedMemoryPolicy`, `GovernedMemoryClass`, and `GovernedMemoryOperation`
- `GovernedMemoryRecord`, `MemoryOperationProposal`, and `MemoryOperationKind`
- `MemoryOperationDecision`, `MemoryOperationTerminal`, and `MemoryPolicyValidation`
- `digest_governed_memory_policy`
- `validate_governed_memory_policy` and `evaluate_memory_operation`
- `MemoryOwner`, and the witness key exports listed under governed continuity

Its design is under review in Draft [RFC 014](https://github.com/encero-systems/hees.ai/blob/main/rfcs/014-governed-memory-lifecycle-operations.md); this exported surface may change with it.

A `GovernedMemoryPolicy` declares memory classes and operations. Each class names its owner and declares prompt eligibility, runtime writability, an optional maximum age, whether explicit consent is required, whether revoke and supersede are allowed, its allowed keys, and its required provenance fields. Each operation binds one operation kind to the classes it may act on. The caller stamps `memory_policy_digest` with `digest_governed_memory_policy`. `validate_governed_memory_policy` recomputes that digest and rejects a mismatch, an empty policy, duplicate class or operation identifiers, duplicate operation kinds, operations without classes or with unknown classes, invalid class declarations, and classes that are not runtime-writable but allow revoke or supersede.

`evaluate_memory_operation` admits or rejects one `select_prompt`, `inspect`, `write`, `revoke`, or `supersede` proposal. It takes the policy, the proposal, and the host's `WitnessKey`, and rejects an invalid key before anything else. It requires a valid policy with matching package identity, a declared operation of the proposed kind, and a memory class that operation allows. `write` requires no existing record, a runtime-writable class, consent where the class requires it, an allowed key, and the class's required provenance fields. Every other operation requires the existing `GovernedMemoryRecord`: its identity must match the proposal, its `record_witness` must verify under the host's key, and it must not be revoked, superseded, expired, or missing required provenance. `select_prompt` additionally requires a prompt-eligible class. `revoke` and `supersede` require the class to allow them, and `supersede` also requires a replacement identifier that differs from the target, plus the consent, key, and provenance a write needs.

The decision reports the terminal result, one reason, the operation and memory identifiers, and, for an admitted `write`, `revoke`, or `supersede`, the resulting record. Hees.ai builds and stamps that record: a new record for `write`, and the existing record marked revoked or superseded for the other two. Hees.ai performs no storage mutation; the host stores the returned record unchanged. The record witness is an HMAC-SHA256 tag under the host's `WitnessKey`, with the same properties as the continuity state witness. It proves that Hees.ai returned the record, not that the record is the latest version; the host's store decides which version is current. Before proposing a `write`, the host supplies any record it already holds for that identifier, revoked and superseded versions included, so that Hees.ai rejects the write.

## Governed memory retrieval admission

The retrieval-admission API exports:

- declaration models `GovernedMemoryDeclaration`, `GovernedMemoryAtom`, `MemoryProviderBinding`, `MemoryValidity`, `MemoryValidityMode`, `MemoryReviewStatus`, and `MemoryRuntimeRights`
- package admission `validate_memory_declaration`, `admit_memory_declaration`, `admit_package_without_memory`, `AdmittedMemoryPackage`, `AdmittedMemoryPackageIdentity`, and `MemoryDeclarationValidation`
- envelope models `MemoryRequest`, `MemoryProviderResult`, and `MemoryNomination`
- `admit_memory_result`
- record models `MemoryAdmissionRecord`, `NormalizedMemoryAdmission`, `MemoryContext`, `MaterializedMemoryAtom`, `MemoryRecordVariant`, `MemoryEnvelopeAdmission`, `MemoryAdmissionStage`, `MemoryResultState`, and `MemoryResultReason`
- the contract version, the reason namespace, and the `MAX_MEMORY_*` and `MAX_RELEVANCE_BPS` bounds

This is the runtime part of [RFC 003](https://github.com/encero-systems/hees.ai/blob/main/rfcs/003-governed-memory-and-retrieval-results.md), which is in progress; this exported surface may change with it.

A `GovernedMemoryDeclaration` holds a package's memory atoms, its approved provider bindings, and its authority, risk, and sensitivity classification lists. Each atom carries bounded claim, guidance, and applicability text, a source reference and fingerprint, a review status, runtime rights, classification references, a validity interval, and labels. `admit_memory_declaration` validates the declaration and returns an `AdmittedMemoryPackage` with a trusted identity. A caller cannot construct that value directly.

`admit_memory_result` takes the admitted package, a `MemoryRequest`, and a `MemoryProviderResult`, and returns one `MemoryAdmissionRecord`. A provider result contains memory identifiers, ranks, and relevance values only. Admission runs eight stages in order and stops at the first failure:

1. `normalization`: bounds and the syntax of every field.
2. `package`: an admitted package that declares governed memory.
3. `request`: the contract version, each package claim against the trusted identity, and the result's echo of the request.
4. `provider`: a binding that exactly equals an approved one, and a nomination count the provider state permits.
5. `nominations`: count, unique identifiers, dense zero-based ranks, and relevance in `0..10000`.
6. `atoms`: every identifier resolves, under the binding's corpus, to an approved, rights-allowed atom valid at the request's evaluation time.
7. `context`: the aggregate bytes of the selected atoms.
8. `complete`: `accepted_complete`, `accepted_partial`, or `accepted_unavailable`.

One invalid item rejects the whole result. An accepted `complete` or `partial` result returns the package's atoms in rank order; an accepted `unavailable` result and every rejection return none. A rejection in the first two stages returns a record with no package identity and no input other than caller identifiers that are themselves canonical. Every later rejection returns the trusted evaluated identity and the bounded request and result as untrusted echoes.

Acceptance establishes structural eligibility and provenance binding. It does not establish that an atom supports a claim, and relevance carries no authority. Hees.ai reads no clock: every time-dependent check uses the request's `evaluation_time_ms`.

Package artifact admission is not implemented. `admit_memory_declaration` validates an in-memory declaration in its place, the identity digests are type-tagged SHA-256 digests that do not conform to RFC 011, and the bounds are fixed constants.

## Generic governed profile evaluation

The generic governed profile API exports:

- package models `GovernedProfilePackage`, `GovernedAction`, `GovernedOutcomeKind`, `GovernedEvidence`, `GovernedMemory`, `GovernedPolicy`, `GuidedMaterial`, and `GuidedTransition`
- package stamping helpers `digest_governed_profile_package` and `digest_governed_memory_provenance`
- request and proposal models and constructors `GovernedRequest`, `bind_governed_request`, `GovernedProposal`, `governed_proposal`, and `digest_governed_proposal`
- committee inputs `CommitteeObservation`, `CommitteeVerdict`, and `committee_observation`
- `validate_governed_profile_package`, `evaluate_governed_profile_with_artifacts`, `evaluate_governed_profile_in_memory_context`, and `evaluate_governed_profile_json`
- result types `CompleteGovernedEvaluation`, `GovernedSpectrumResult`, `GovernedFinding`, `AdmittedGuidedMaterial`, `GovernedContentDna`, `GovernedReceipt`, and `GovernedVisibleOutputSource`

Its design is under review in Draft [RFC 015](https://github.com/encero-systems/hees.ai/blob/main/rfcs/015-generic-governed-profile-evaluation.md); this exported surface may change with it.

A `GovernedProfilePackage` declares actions with their outcome kinds, reviewed evidence, reviewed memory atoms, optional guided material, and a committee policy that names the required evaluator roles. Each refusal or escalation action declares the `boundary_text` shown for that outcome. The caller stamps the package's `profile_package_digest` with `digest_governed_profile_package` and each memory atom's `provenance_digest` with `digest_governed_memory_provenance`; `validate_governed_profile_package` recomputes both and rejects any mismatch.

`evaluate_governed_profile_with_artifacts` validates the package, the request, and the proposal's binding to both. It then delegates declared-action and reviewed-evidence checks to `admit_model_proposal`, validates the committee observations against the package's required roles and derives Hees.ai-owned findings from them, resolves the selected memory and any guided material, and maps the declared action's outcome kind to a `deliver`, `refuse`, or `escalate` decision. A `deliver` result carries the visible output, the selected memory, any admitted guided-material identity, and JSON projections of Content DNA and a receipt. A `refuse` or `escalate` result carries the package's `boundary_text` as its visible output and a receipt, but no selected memory or Content DNA; a proposal that supplies its own text for such an action is rejected. An admitted receipt records whether the visible output came from the proposal or from the package, and the digest of the text shown. A rejected result carries no visible output, selected memory, or Content DNA; it carries a redacted receipt only once the package, request, and proposal identity are established. `evaluate_governed_profile_json` returns the same complete result as JSON.

`evaluate_governed_profile_in_memory_context` runs the same evaluation with one more rule. It takes the `MemoryAdmissionRecord` from retrieval admission and rejects a proposal unless that record is an accepted record for the same package and domain identifier and every memory identifier the proposal nominates is in its materialized context. Each of those rejections carries a receipt. The package revision is not compared, because retrieval admission and profile evaluation use different revision grammars.

Committee observations remain non-authoritative inputs. The surface does not author packages, retrieve memory, invoke models, or materialize guided payloads.

Every identity digest in these three contracts is SHA-256 over a type tag followed by the current serializer's JSON for one projection, so a digest of one projection type never matches another. The encoding is interim and does not conform to RFC 011 structural identity.
