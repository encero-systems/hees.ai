# RFC 013: Governed Continuity — Goal, Schedule, and Session Admission

- **Status:** Draft
- **Created:** 2026-08-19
- **Author(s):** Encero Systems
- **Related:**
    - RFC 000 (Foundational Governance Authority) — see [Relationship to RFC 000](#relationship-to-rfc-000) for the one deliberate deviation
    - RFC 003 (Governed Memory and Retrieval Results) — complementary, not a dependency; see [Relationship to RFC 003](#relationship-to-rfc-003)
    - RFC 005 (Canonical Package Artifact Admission)
    - RFC 014 (Governed Memory Lifecycle Operations) — independent, commonly co-deployed; see [Relationship to RFC 014](#relationship-to-rfc-014)
- **Issue:** https://github.com/encero-systems/hees.ai/issues/35
- **RFC PR:** —
- **Written against:** Hees.ai 0.0.1 / Incan 0.6.0-dev.6
- **Shipped in:** —

## Summary

Hees.ai should independently admit every proposed change to a session's position in a package-declared goal: starting it, continuing the current phase, transitioning to a declared next phase, closing it, or expiring it once its current phase has run past its maximum. The caller supplies monotonic time and proposes one operation at a time; Hees.ai validates that operation against package-declared goal, schedule, and phase authority and returns one terminal decision. Hees.ai does not read a clock, choose a goal on the caller's behalf, or persist session state itself — it evaluates a proposed transition against a caller-supplied prior state and either admits or rejects it.

## Core model

1. **The package owns the goal.** A deployable package declares one or more goals, each with an entry phase, completion phases, the actions that goal permits overall, and whether an overrun session may be expired.
2. **The package owns the schedule.** A goal's schedule declares an ordered, acyclic phase graph with per-phase minimum/target/maximum duration bounds, per-phase allowed actions, and declared next-phase edges, plus a total target duration and the clock sources the package accepts.
3. **The caller proposes; Hees.ai decides.** A caller assembles an untrusted `ContinuityProposal` — the operation (`start`/`continue`/`transition`/`close`/`expire`), the target phase and action, the clock source and current time, and (for every operation but `start`) the prior admitted state. Hees.ai validates it and returns exactly one `ContinuityDecision`.
4. **Persistence is the caller's problem, admission is Hees.ai's.** `evaluate_continuity` is a pure function: given the same package, proposal, prior state, and host witness key, it always returns the same decision. It does not read or write storage; a caller-owned adapter is responsible for storing only admitted decisions and supplying the latest `resulting_state` as `prior_state` for the next proposal.
5. **Later delivery admission remains independent.** An admitted continuity event proves that a phase/time/action transition is authorized. It does not itself admit a proposal's content, evidence, or memory selection — that is RFC 000's `admit_model_proposal` boundary, evaluated separately.

## Motivation

A package that declares a bounded goal — "complete X within Y minutes, in this order" — has no way to make Hees.ai enforce that shape without a continuity contract. Nothing stops an implementation from silently extending a phase past its declared maximum, skipping a declared transition, or accepting an action the current phase never declared. Without a shared contract, every caller either re-derives this logic ad hoc (and disagrees with other implementations about edge cases like clock regression, tampered prior state, or a re-chained history) or skips real enforcement entirely and lets the model or the UI decide when to move on.

The implementation in `governed_continuity.incn` covers this gap; this RFC stabilizes its goal/schedule/session contract before wider adoption.

## Goals

- Define package-declared `GovernedGoal` and `GovernedSchedule`/`GovernedPhase` authority: entry/completion phases, per-goal and per-phase allowed actions, phase duration bounds, and a declared next-phase graph.
- Define the untrusted `ContinuityProposal` envelope and the caller-supplied `SessionContinuityState` it is evaluated against.
- Define `evaluate_continuity` as a pure, deterministic admission function over exactly one proposed operation.
- Enforce package validity: bounded collections and durations, canonical identifier text, no duplicate goal/schedule/phase identifiers or clock sources, an acyclic topologically ordered next-phase graph, non-empty allowed-action sets, internally consistent duration bounds (`0 <= minimum <= target <= maximum`), and a total target that a session can actually reach.
- Enforce prior-state integrity at the proposal level: identity match against the package and the proposal, a keyed witness under the host's key, a bound clock source, numeric invariants, monotonic event index, non-regressing clock, and phase/goal graph consistency.
- Give a session whose phase overran its maximum an admitted terminal path (`Expire`) when its goal declares one, without letting that operation cut a session short.
- Fail closed on every unknown goal, schedule, phase, action, clock source, out-of-range number, or malformed identifier.

## Non-Goals

- Persisting or replaying continuity events. This RFC defines the admission function only; a caller-owned adapter owns the append-only log, any chain-of-custody digesting, and replay. That adapter is not part of the public contract.
- Choosing which goal a session pursues, or reading a clock. The caller always supplies both.
- Validating delivery content, evidence, or selected memory for the action being proposed — that remains RFC 000's and (for memory lifecycle operations) RFC 014's responsibility.
- Declaring topic, subject-matter, or content-relevance scope for a phase. `GovernedPhase` deliberately carries no evidence or topic field — see [Design Decisions](#design-decisions).
- Defining a canonical JCS encoding or a receipt/Content DNA projection for continuity decisions. `governed_continuity.incn` does not define these; see [Open questions](#open-questions).

## Guide-level explanation

A package declares one goal and its schedule. The identifiers below are invented for illustration:

```incan
goal = GovernedGoal(
    goal_id=goal_id("complete_lantern_lesson"),
    entry_phase_id=phase_id("orient"),
    completion_phase_ids=[phase_id("review")],
    allowed_action_ids=[action_id("answer_from_package"), action_id("present_guided_card")],
    expiry_allowed=true,
)

schedule = GovernedSchedule(
    schedule_id=schedule_id("lantern_lesson_session"),
    goal_id=goal_id("complete_lantern_lesson"),
    total_target_seconds=720,
    allowed_clock_sources=["host_monotonic"],
    phases=[
        GovernedPhase(
            phase_id=phase_id("orient"),
            minimum_seconds=0, target_seconds=120, maximum_seconds=240,
            allowed_action_ids=[action_id("answer_from_package"), action_id("present_guided_card")],
            next_phase_ids=[phase_id("practice")],
        ),
        # ...
    ],
)
```

At runtime, the host holds a `WitnessKey` whose secret never enters a model, provider, or package input, and starts a session by proposing `Start` with no prior state:

```incan
decision = evaluate_continuity(
    package,
    ContinuityProposal(
        operation=ContinuityOperationKind.Start,
        session_id=session_id("session_one"),
        event_id=session_event_id("event_000"),
        event_index=0,
        goal_id=goal.goal_id,
        schedule_id=schedule.schedule_id,
        proposed_phase_id=phase_id("orient"),
        proposed_action_id=action_id("present_guided_card"),
        clock_source="host_monotonic",
        current_clock_seconds=1000,
        prior_state=None,
        # profile_id/package_id/domain_id/package_revision/continuity_declaration_digest omitted for brevity
    ),
    host_witness_key,
)
# decision.terminal == ContinuityTerminal.Admitted
# decision.resulting_state.unwrap().phase_id == phase_id("orient")
# decision.resulting_state.unwrap().clock_source == "host_monotonic"
```

Every later proposal supplies the `resulting_state` of the previous admitted decision, unchanged, as `prior_state`, and names the same clock source the session started on. Continuing in the same phase, transitioning to a declared next phase once the phase's minimum duration is met, closing the goal once its total target duration is reached, and expiring a session whose phase ran past its maximum each go through the same function and the same terminal shape. Hees.ai reads no clock and runs no timer, so it never expires a session by itself: the host proposes `Expire` when its own clock shows the phase maximum has passed.

An off-schedule attempt — an undeclared transition, an action the phase didn't declare, a clock that moved backward, a switch to a different clock source, or a `prior_state` whose identity or numbers don't hold together — is rejected with one of the reasons in [Public admission reasons](#public-admission-reasons), never silently coerced into something admissible.

## Reference-level explanation

### Bounds

A package may declare any number of goals, schedules, phases per schedule, clock sources per schedule, and allowed actions per goal or phase; the lists that refer to phases may hold any number of entries. What a package holds is not bounded by a number. The kernel declares one public bound as a constant in `governed_continuity.incn`:

| Constant | Value | Bounds |
| --- | --- | --- |
| `MAX_CONTINUITY_INTEGER` | 9007199254740991 (2^53 − 1) | every duration, `total_target_seconds`, clock value, and event index |

Every identifier — including each clock-source name — must be canonical symbolic identifier text: 1 to 128 characters of lowercase ASCII letters, digits, `_`, and `-`, not starting with `_` or `-`. `package_revision` must be valid artifact-revision text and `continuity_declaration_digest` a lowercase `sha256:` digest. Constructing an identifier newtype directly skips its validating constructor, so the kernel re-checks identifier text rather than trusting the type.

Because every time value and event index is confined to `0..=MAX_CONTINUITY_INTEGER` before the kernel compares or subtracts it, the kernel's time arithmetic cannot overflow.

### Package-declared authority

`ContinuityPackage` binds `GovernedGoal` and `GovernedSchedule` declarations to a package identity (`profile_id`, `package_id`, `domain_id`, `package_revision`, `continuity_declaration_digest`). `validate_continuity_package` checks, in this order, stopping at the first failure:

1. at least one goal and one schedule are declared (`continuity_declarations_empty`);
2. every duration is within [Bounds](#bounds) (`continuity_bounds_exceeded`);
3. every identifier, clock-source name, revision, and digest is canonical text (`invalid_continuity_identifier`);
4. `continuity_declaration_digest` matches `digest_continuity_package`, recomputed from every other package field, goals (including `expiry_allowed`) and schedules included (`continuity_declaration_digest_mismatch`) — so a package mutated after its digest was stamped fails closed rather than carrying a stale identity;
5. goal identifiers are unique (`duplicate_goal_id`), and schedule identifiers are unique (`duplicate_schedule_id`);
6. for each schedule, in declaration order:
    - its `goal_id` names a declared goal (`schedule_goal_unknown`);
    - it declares a positive `total_target_seconds`, at least one allowed clock source, and at least one phase (`schedule_declaration_empty`);
    - its clock sources are unique (`duplicate_clock_source`), and its phase identifiers are unique (`duplicate_phase_id`);
    - every phase satisfies `0 <= minimum_seconds <= target_seconds <= maximum_seconds` (`invalid_phase_budget`) and declares at least one allowed action (`phase_actions_empty`);
    - a phase's `next_phase_ids` excludes itself (`phase_self_cycle`), names only declared phases (`unknown_next_phase`), and names only phases declared later in the schedule's own phase list (`phase_graph_not_topological`) — the graph is acyclic by construction because every edge points strictly forward;
7. for each goal, in declaration order:
    - it declares a non-empty `completion_phase_ids` and a non-empty `allowed_action_ids` (`goal_declaration_empty`);
    - for each schedule declared for it, its `entry_phase_id` (`goal_entry_phase_unknown`) and every `completion_phase_ids` entry (`goal_completion_phase_unknown`) exist in that schedule, and `total_target_seconds` does not exceed the largest sum of `maximum_seconds` along any declared path from the entry phase to a completion phase (`schedule_target_unreachable`) — otherwise no session could ever close, because the phase maximum blocks every `Close` before the total target is reached; a completion phase that is unreachable from the entry phase fails the same way;
    - at least one schedule is declared for it (`goal_schedule_missing`).

A package that passes returns reason `valid`.

Each goal also declares `expiry_allowed`, which says whether the host may end an overrun session with `Expire` (see [Operation-specific rules](#operation-specific-rules)). It needs no validation of its own and is covered by the declaration digest.

`digest_continuity_package` is SHA-256 over the type tag `hees.ai/continuity-declaration/v0`, a line feed, and the current serializer's JSON rendering of that projection; the state witness hashes the type tag `hees.ai/continuity-state/v0` the same way. The type tag keeps a digest or witness of one projection type from ever matching another. This encoding is interim: it hashes the serializer's JSON, not a canonical form, and does not yet conform to [RFC 011](011-canonical-structural-identity.md) structural identity.

### The proposal envelope

`ContinuityProposal` carries: the proposed `ContinuityOperationKind`, a session identifier, a caller-supplied `event_id`/`event_index`, the full package identity (compared against the package Hees.ai was given, not trusted from the proposal), the target `goal_id`/`schedule_id`, the proposed phase and action, a `clock_source` name, the current clock in seconds, and `prior_state: Option[SessionContinuityState]`.

`SessionContinuityState` is the caller-supplied state expected to be the `resulting_state` of the previous admitted decision: session and package identity, current goal/schedule/phase, when the goal and the current phase started, the last admitted clock value and event index, the `clock_source` the session started on, whether the goal is closed, whether it was closed by `Expire` (`expired`, false for every other operation), and a `state_witness`. Hees.ai never derives this from storage; the caller supplies it as part of the proposal, and Hees.ai checks it for internal and cross-proposal consistency before trusting any of its values.

### Host witness key

`evaluate_continuity(package, proposal, witness_key)` takes the host's `WitnessKey` (a non-secret `key_id` and a secret of 32 to 1024 bytes). A key that fails `witness_key_is_valid` is rejected with `invalid_witness_key` before anything else is checked or trusted.

`state_witness` is a `KeyedWitness`: the key's `key_id` and an HMAC-SHA256 tag under the key's secret over the type tag `hees.ai/continuity-state/v0` and the state's JSON with `state_witness` set to the unstamped placeholder. Every field, `expired` included, is therefore covered. `evaluate_continuity` stamps every state it returns and verifies a supplied `prior_state` under the same key (`prior_state_witness_invalid`); a witness from another key identifier, under a different secret, over any edited field, or that is malformed fails that check. The witness authenticates that the state was returned by `evaluate_continuity` under the host's key. The kernel exposes no other way to stamp a state, so a caller without the key cannot produce one that verifies.

The host must keep the key out of every model, provider, and package input. Anyone holding the key can stamp states, so the key is the host's trust anchor: it authenticates states the host's own kernel produced, not the honesty of whoever holds it. The kernel still checks the state's numeric invariants (`prior_state_inconsistent`) before using any of its values.

### Clock-source binding

The session is bound to the clock source of its admitted `Start`. The resulting state records that `clock_source` and includes it in the witness, and every later proposal must name the same source (`clock_source_changed`). Two monotonic clocks have unrelated epochs, so comparing a reading from one with a reading from another would make the clock-regression and phase-duration checks meaningless.

### Admission order

`evaluate_continuity` validates in this order, stopping at the first failure:

1. The host's witness key must pass `witness_key_is_valid` (`invalid_witness_key`).
2. The package must pass `validate_continuity_package` (`invalid_continuity_package`).
3. Every proposal identifier, its clock-source name, its revision, and its digest must be canonical text (`invalid_proposal_identifier`).
4. The proposal's package identity must exactly match the package's (`package_identity_mismatch`).
5. The proposal's `goal_id` must name a declared goal (`unknown_goal`).
6. The proposal's `schedule_id` must name a declared schedule (`unknown_schedule`), and that schedule's `goal_id` must be the proposal's goal (`schedule_goal_mismatch`).
7. The proposal's `clock_source` must be one the schedule declares (`clock_source_not_allowed`).
8. The proposed phase must exist in the schedule (`unknown_phase`).
9. The proposed action must be allowed by the goal (`action_not_allowed_for_goal`) and by the proposed phase (`action_not_allowed_for_phase`). This applies to every operation, `Expire` included.
10. `current_clock_seconds` and `event_index` must both lie in `0..=MAX_CONTINUITY_INTEGER` (`invalid_event_coordinates`).
11. Operation-specific rules apply (below), each producing a specific rejection reason or one admitted decision.

### Operation-specific rules

- **Start**: requires `prior_state` to be absent (`start_requires_empty_state`), `event_index == 0` (`start_event_index_invalid`), and the proposed phase to be the goal's declared `entry_phase_id` (`start_phase_not_declared`). Admits with reason `declared_goal_started`; `started_at_seconds`, `phase_started_at_seconds`, and `last_clock_seconds` are set to the proposal's clock value, `clock_source` to the proposal's clock source, and `evaluate_continuity` stamps a fresh `state_witness` on the resulting state.
- **Continue**, **Transition**, **Close**, and **Expire** all require `prior_state` to be present (`prior_state_required`), and then, in order:
    - the prior state's identity must exactly match the proposal's (session, package, goal, and schedule identity — `prior_state_identity_mismatch`);
    - the prior state's `state_witness` must verify under the host's witness key (`prior_state_witness_invalid`; see [Host witness key](#host-witness-key));
    - the prior state's `clock_source` must equal the proposal's (`clock_source_changed`);
    - the prior phase must exist in the schedule (`prior_phase_unknown`);
    - the prior state must satisfy every invariant an admitted state holds (`prior_state_inconsistent`): `0 <= started_at_seconds <= phase_started_at_seconds <= last_clock_seconds <= MAX_CONTINUITY_INTEGER`; `last_event_index` within `0..=MAX_CONTINUITY_INTEGER`; an `expired` state is also `closed`; `last_clock_seconds - phase_started_at_seconds` exceeds the prior phase's `maximum_seconds` exactly when the state is `expired`; a state in the goal's entry phase has `phase_started_at_seconds == started_at_seconds`; a state with `last_event_index == 0` is in the entry phase with `last_clock_seconds == started_at_seconds`; and a `closed` state that is not `expired` is in one of the goal's completion phases with `last_clock_seconds - started_at_seconds >= total_target_seconds`;
    - the prior session must not already be closed (`session_already_closed`) — an expired session is closed, so every operation on it is rejected here;
    - `event_index` must equal `prior.last_event_index + 1` exactly (`event_index_not_monotonic`);
    - `current_clock_seconds` must not be less than `prior.last_clock_seconds` (`clock_regression`);
    - for every operation except `Expire`, the elapsed time in the prior phase (`current_clock_seconds - prior.phase_started_at_seconds`) must not exceed that phase's declared `maximum_seconds` (`phase_maximum_exceeded`) — checked for `Continue`, `Close`, and `Transition` alike, so a session cannot sit in one phase past its declared maximum by repeatedly proposing `Continue`. `Expire` takes the opposite rule below.
- **Continue** additionally requires the proposed phase to equal the prior phase (`continue_phase_mismatch`). Admits with reason `continue_current_phase`; `started_at_seconds` and `phase_started_at_seconds` carry forward unchanged.
- **Transition** requires the proposed phase to be one of the prior phase's declared `next_phase_ids` (`phase_transition_not_declared`), and the elapsed time in the prior phase to be at least that phase's `minimum_seconds` (`phase_minimum_not_met`). Admits with reason `declared_phase_transition`; `phase_started_at_seconds` resets to the current clock value.
- **Close** requires the proposed phase to equal the prior phase and that phase to be one of the goal's declared `completion_phase_ids` (`goal_close_not_declared`), and the elapsed time since the goal started to be at least `schedule.total_target_seconds` (`goal_budget_not_reached`). Admits with reason `declared_goal_closed`; the resulting state's `closed` flag becomes `true`, `expired` stays `false`, and both start times carry forward.
- **Expire** requires, in order, that the goal declares `expiry_allowed` (`expiry_not_declared`), that the proposed phase equals the prior phase (`expire_phase_mismatch`), and that the elapsed time in the prior phase exceeds that phase's `maximum_seconds` (`phase_maximum_not_exceeded`) — at exactly the maximum it is still rejected, so `Expire` can never cut a session short. Admits with reason `phase_maximum_expired`; the resulting state's `closed` and `expired` flags both become `true` and both start times carry forward. Hees.ai reads no clock and runs no timer: it never expires a session on its own, and the host proposes `Expire` when its clock shows the maximum has passed.

Every admitted state records the proposal's clock value as `last_clock_seconds`, its event index as `last_event_index`, its clock source as `clock_source`, `expired` as `true` only for `Expire`, and a fresh `state_witness` stamped under the host's key.

An operation value outside the five declared kinds reaches `unknown_continuity_operation`. The closed `str`-backed enum makes this unreachable through the typed public API; the branch is defensive.

### Public admission reasons

Every terminal decision carries exactly one reason string. The complete set:

`invalid_witness_key`, `invalid_continuity_package`, `invalid_proposal_identifier`, `package_identity_mismatch`, `unknown_goal`, `unknown_schedule`, `schedule_goal_mismatch`, `clock_source_not_allowed`, `unknown_phase`, `action_not_allowed_for_goal`, `action_not_allowed_for_phase`, `invalid_event_coordinates`, `start_requires_empty_state`, `start_event_index_invalid`, `start_phase_not_declared`, `prior_state_required`, `prior_state_identity_mismatch`, `prior_state_witness_invalid`, `clock_source_changed`, `prior_phase_unknown`, `prior_state_inconsistent`, `session_already_closed`, `event_index_not_monotonic`, `clock_regression`, `phase_maximum_exceeded`, `continue_phase_mismatch`, `phase_transition_not_declared`, `phase_minimum_not_met`, `goal_close_not_declared`, `goal_budget_not_reached`, `expiry_not_declared`, `expire_phase_mismatch`, `phase_maximum_not_exceeded`, `unknown_continuity_operation` (rejections); and `declared_goal_started`, `continue_current_phase`, `declared_phase_transition`, `declared_goal_closed`, `phase_maximum_expired` (admissions).

`invalid_continuity_package` is a coarse wrapper: every package validation failure collapses into it at the `evaluate_continuity` boundary. A caller who wants the specific cause calls `validate_continuity_package` directly and reads its `reason` field, which is not coarsened. Its complete set is `valid` and the failures `continuity_declarations_empty`, `continuity_bounds_exceeded`, `invalid_continuity_identifier`, `continuity_declaration_digest_mismatch`, `duplicate_goal_id`, `duplicate_schedule_id`, `schedule_goal_unknown`, `schedule_declaration_empty`, `duplicate_clock_source`, `duplicate_phase_id`, `invalid_phase_budget`, `phase_actions_empty`, `phase_self_cycle`, `unknown_next_phase`, `phase_graph_not_topological`, `goal_declaration_empty`, `goal_entry_phase_unknown`, `goal_completion_phase_unknown`, `schedule_target_unreachable`, and `goal_schedule_missing`.

This RFC does not yet freeze these as a versioned, namespace-scoped closed table the way RFC 003/RFC 006 freeze memory-admission reasons — see [Open questions](#open-questions).

## Design details

### Relationship to RFC 000

RFC 000 establishes that nothing a model or provider proposes is trusted on its own and that Hees.ai holds terminal authority over delivery. This RFC applies the same posture to *time and position within a goal*: a caller proposes when to move on, but only a package-declared schedule and Hees.ai's admission of it can make that move real.

It deliberately deviates from RFC 000's direct-capability invariant: `prior_state` is a caller-persisted serializable value rather than a capability the kernel holds. It is trusted only when its keyed witness verifies under the host's key and its numeric invariants hold (see [Host witness key](#host-witness-key)).

### Relationship to RFC 003

`governed_continuity.incn`'s sibling module, `governed_memory_operations.incn`, documents itself as "adjacent to RFC 003" and explicitly not an implementation of RFC 003's retrieval ingress. Continuity and RFC 003 are more distant still: this RFC never selects, nominates, or materializes memory. A package that combines both declares a schedule (this RFC) whose phases may gate *which* declared topic scope or memory class is reachable in a given phase — but that gating is package policy layered on top of, not part of, either contract, and `evaluate_continuity` does not validate it. See [Design Decisions](#design-decisions).

### Relationship to RFC 014

[RFC 014](014-governed-memory-lifecycle-operations.md) specifies the memory-lifecycle admission contract (inspect, select for prompt, write, revoke, supersede), implemented in `governed_memory_operations.incn`. It has no structural dependency on this RFC. The two are commonly deployed together but evaluated independently — a continuity decision never depends on `evaluate_memory_operation`'s result and vice versa.

## Alternatives considered

### Let Hees.ai read a clock itself

Rejected for the same reason RFC 003 rejects it for evaluation time: repeated evaluation could disagree across independent runtimes evaluating the same proposal, and it would make `evaluate_continuity` impure. The caller supplies `current_clock_seconds` as part of the deterministic input.

### Let a session switch between declared clock sources

Rejected. A schedule may declare several acceptable clock sources so that different hosts can run the same package, but monotonic clocks from different sources share no epoch. Allowing a switch mid-session would let a caller move the clock forward or backward at will, defeating the regression and phase-duration checks. A session therefore stays on the source its `Start` named.

### Persist session state inside Hees.ai/`evaluate_continuity`

Rejected. Coupling admission to a specific storage adapter would make the function impossible to test in isolation, make cross-runtime determinism harder to prove, and duplicate work every storage backend would need to redo identically. The split here is a pure admission function plus a caller-owned, independently replayable event log.

### Encode topic/content relevance as a kernel-level phase field

Rejected. `GovernedPhase` intentionally carries no evidence or topic field. Domain content and policy — "what is this phase actually about" — is package responsibility, not a generic kernel concept; folding it in here would make every continuity-only package (with no notion of topic scope at all) carry a meaningless field, and would blur the same authority boundary RFC 003 draws around package-owned content.

## Drawbacks

A caller must implement its own persistence adapter to get any value from this contract; the RFC defines no storage shape, so independent implementations may reasonably diverge on log format even while agreeing on admission semantics.

The phase-graph-must-point-forward rule (used here to guarantee acyclicity by construction) forbids expressing a schedule where an earlier-declared phase is revisited from a later one, even where a package author might reasonably want a bounded loop (e.g., "review, then optionally repeat one earlier phase"); the contract has no support for that shape.

A session that overruns its current phase's `maximum_seconds` can only end through `Expire`, and only when its goal declares `expiry_allowed`. For a goal that does not, every `Continue`, `Transition`, `Close`, and `Expire` is rejected and `Start` requires an empty prior state, so the caller must discard the session and start a new one. `Expire` also depends on the host proposing it: Hees.ai runs no timer, so an overrun session stays open until the host acts.

The admission-reason vocabulary above is not yet closed or namespaced the way RFC 003/006 close theirs, so it may need a breaking revision once formalized.

`state_witness` is only as strong as the host's custody of its key: anyone holding the key can stamp an arbitrary state, and a leaked key lets a caller fabricate any state that satisfies the numeric invariants. Nor can the kernel detect a host that calls `evaluate_continuity` honestly but supplies a fabricated `current_clock_seconds` at every step, since the caller-supplied clock is trusted by design (see [Alternatives considered](#alternatives-considered)). The witness proves a state came from the host's kernel under its key; it does not prove the host's clock was honest.

The witness also does not prove a state is the latest one. Every state Hees.ai returned for a session still verifies, so a caller that presents the state from before an admitted `Close` or `Expire` can have a later event admitted from it, and presenting one state twice forks the session. Hees.ai holds no store and cannot detect this. The host must keep exactly one current state per session, replace it with each admitted `resulting_state`, and supply only that state as `prior_state`.

## Layers affected

- **Public contract:** `ContinuityOperationKind`, `ContinuityTerminal`, `GovernedGoal`, `GovernedPhase`, `GovernedSchedule`, `ContinuityPackage`, `SessionContinuityState` (including `clock_source`, `expired`, and the keyed `state_witness`), `ContinuityProposal`, `ContinuityDecision`, and `ContinuityValidation` types; the `validate_continuity_package` and `evaluate_continuity` functions, plus `digest_continuity_package` for callers to stamp a package's real digest; the shared `WitnessKey` and `KeyedWitness` types that `evaluate_continuity` takes and returns; and the bound constants listed in [Bounds](#bounds). There is deliberately no public function that stamps or recomputes a state witness.
- **Runtime validation:** Deterministic, bounded package validation, proposal-identity binding, clock-source binding, prior-state invariant checks, and per-operation admission with a closed (informal, pending formal freeze) reason vocabulary.
- **Package compatibility:** Purely additive — a package with no continuity declaration is unaffected; continuity is opt-in per package, mirroring RFC 003's opt-in framing for memory.
- **Persistence boundary:** This RFC explicitly does not define one (see Non-Goals).
- **Tests and documentation:** `tests/test_governed_continuity_contract.incn` covers an admitted Start → Continue → Transition → Close chain and an admitted Expire that feed each real `resulting_state` into the next proposal, keyed-witness rejection under another key identifier, a wrong secret, an edited field, another type tag, and a malformed witness, every reachable admission and rejection reason above, every package validation reason, and the at-limit and one-over values of each bound. Formal cross-implementation fixtures per this repo's usual RFC acceptance-obligations bar remain open work.

## Design Decisions

- The caller supplies time and proposes each operation one at a time; Hees.ai never reads a clock, chooses a goal, or persists state.
- A phase graph is validated to be acyclic by construction: every `next_phase_ids` edge must point to a later-declared phase in the same schedule.
- A schedule's `total_target_seconds` must be reachable within the phase maximums along some declared path from the goal's entry phase to a completion phase, so every valid package admits at least one closable session.
- `Continue`, `Transition`, `Close`, and `Expire` all require an exactly matching, monotonically advancing `prior_state`; `Start` requires its absence. This rejects a proposal that skips, repeats, or reorders events relative to the state it presents. It does not make an older state stale: see Drawbacks.
- A session is bound to the clock source its `Start` named; every later proposal must use the same source.
- A phase's declared `minimum_seconds` gates `Transition` away from it; the schedule's `total_target_seconds` gates `Close`; a phase's declared `maximum_seconds` gates `Continue`, `Transition`, and `Close` uniformly, so a session cannot remain in one phase past its declared maximum by repeatedly proposing `Continue`.
- `Expire` is the one admitted way out of an overrun phase. It is opt-in per goal (`expiry_allowed`, covered by the declaration digest), admitted only strictly after the phase maximum, and produces a closed state marked `expired` so a reader can tell it from a normal close. The host proposes it; Hees.ai runs no timer.
- `SessionContinuityState` carries a keyed `state_witness` (HMAC-SHA256 under the host's `WitnessKey`) that `evaluate_continuity` stamps and verifies, and the kernel checks the state's numeric invariants before using it. The witness authenticates that the state was returned by `evaluate_continuity` under the host's key; the key is the host's trust anchor and must stay out of model, provider, and package inputs.
- The declaration digest and the state witness each hash a distinct type tag ahead of the current serializer's JSON. That encoding is interim and does not yet conform to RFC 011 structural identity.
- Every collection, duration, clock value, and event index is bounded, and every identifier is re-checked as canonical text, before any quadratic scan or arithmetic runs.
- `GovernedPhase` carries time and action-authority bounds only — no topic, evidence, or content field. Topic scope is deliberately out of the kernel's vocabulary; see [Relationship to RFC 003](#relationship-to-rfc-003).
- Continuity admission and delivery/memory admission are independent dimensions, evaluated separately, matching RFC 003's split between envelope admission and provider state.

## Open questions

- Should the admission-reason vocabulary be frozen into a closed, namespaced table (RFC 003/006-style) as part of this RFC, or left informal until a receipt/Content DNA projection for continuity decisions is designed?
- Does a continuity decision need any receipt/Content DNA export at all, or is it purely an internal admission signal that a *separate* delivery decision's receipt may reference by event id?
- The phase-graph-forward-only acyclicity rule forbids expressing an intentional bounded revisit/loop. Is that an acceptable permanent restriction, or should a future revision add an explicit, bounded loop declaration?
- When should the declaration digest and the state witness move from the interim type-tagged serializer JSON to RFC 011 structural identity, and how does a host migrate persisted states stamped under the interim encoding?
