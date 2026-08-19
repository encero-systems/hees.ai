# RFC 013: Governed Continuity — Goal, Schedule, and Session Admission

- **Status:** Draft
- **Created:** 2026-08-19
- **Author(s):** Encero Systems
- **Related:**
    - RFC 000 (Foundational Governance Authority)
    - RFC 003 (Governed Memory and Retrieval Results) — complementary, not a dependency; see [Relationship to RFC 003](#relationship-to-rfc-003)
    - RFC 005 (Canonical Package Artifact Admission)
- **Issue:** https://github.com/encero-systems/hees.ai/issues/35
- **RFC PR:** —
- **Written against:** Hees.ai 0.0.1 / Incan 0.5
- **Shipped in:** —

## Summary

Hees.ai should independently admit every proposed change to a session's position in a package-declared goal: starting it, continuing the current phase, transitioning to a declared next phase, or closing it. The caller supplies wall time and proposes one operation at a time; Hees.ai validates that operation against package-declared goal, schedule, and phase authority and returns one terminal decision. Hees.ai does not read a clock, choose a goal on the caller's behalf, or persist session state itself — it evaluates a proposed transition against a caller-supplied prior state and either admits or rejects it.

## Core model

1. **The package owns the goal.** A deployable package declares one or more goals, each with an entry phase, completion phases, and the actions that goal permits overall.
2. **The package owns the schedule.** A goal's schedule declares an ordered, acyclic phase graph with per-phase minimum/target/maximum duration bounds, per-phase allowed actions, and declared next-phase edges, plus a total target duration and the clock sources the package accepts.
3. **The caller proposes; Hees.ai decides.** A caller assembles an untrusted `ContinuityProposal` — the operation (`start`/`continue`/`transition`/`close`), the target phase and action, the current time, and (for every operation but `start`) the prior admitted state. Hees.ai validates it and returns exactly one `ContinuityDecision`.
4. **Persistence is the caller's problem, admission is Hees.ai's.** `evaluate_continuity` is a pure function: given the same package, proposal, and prior state, it always returns the same decision. It does not read or write storage; a caller-owned adapter is responsible for storing only admitted decisions and replaying them to reconstruct `prior_state` for the next proposal.
5. **Later delivery admission remains independent.** An admitted continuity event proves that a phase/time/action transition is authorized. It does not itself admit a proposal's content, evidence, or memory selection — that is RFC 000's `admit_model_proposal` boundary, evaluated separately.

## Motivation

A package that declares a bounded learner goal — "help the learner do X within Y minutes, in this order" — has no way to make Hees.ai enforce that shape today. Nothing stops an implementation from silently extending a phase past its declared maximum, skipping a declared transition, or accepting an action the current phase never declared. Without a shared contract, every caller either re-derives this logic ad hoc (and disagrees with other implementations about edge cases like clock regression, tampered prior state, or a re-chained history) or skips real enforcement entirely and lets the model or the UI decide when to move on.

This gap was explored as a bounded research spike (see `GOVERNED_CONTINUITY_HYPERQUANT_SPIKE_DECISION.md`, 2026-07-24, in the customer-demo project) and implemented as `governed_continuity.incn`. The spike's own production recommendation was to "review and stabilize the generic Hees.ai goal, temporal and memory-operation contracts through their RFC path" before wider adoption. This RFC is that stabilization step for the goal/schedule/session half of that recommendation.

## Goals

- Define package-declared `GovernedGoal` and `GovernedSchedule`/`GovernedPhase` authority: entry/completion phases, per-goal and per-phase allowed actions, phase duration bounds, and a declared next-phase graph.
- Define the untrusted `ContinuityProposal` envelope and the caller-supplied `SessionContinuityState` it is evaluated against.
- Define `evaluate_continuity` as a pure, deterministic admission function over exactly one proposed operation.
- Enforce phase-graph validity at the package level: no duplicate goal/schedule/phase identifiers, an acyclic topologically-ordered next-phase graph, non-empty allowed-action sets, and internally consistent duration bounds (`0 <= minimum <= target <= maximum`).
- Enforce prior-state integrity at the proposal level: identity match against the package and the caller-claimed prior state, monotonic event index, non-regressing clock, and phase/goal graph consistency.
- Fail closed on every unknown goal, schedule, phase, action, clock source, or malformed proposal.

## Non-Goals

- Persisting or replaying continuity events. This RFC defines the admission function only; a caller-owned adapter (analogous to the customer-demo project's `SessionContinuityStore`) owns the append-only log, chain-of-custody digesting, and replay. That adapter pattern is implementation evidence for this RFC, not itself part of the public contract.
- Choosing which goal a session pursues, or reading a wall clock. The caller always supplies both.
- Validating delivery content, evidence, or selected memory for the action being proposed — that remains RFC 000's and (for memory) the sibling memory-operations contract's responsibility (see [Relationship to RFC 003](#relationship-to-rfc-003)).
- Declaring topic, subject-matter, or content-relevance scope for a phase. `GovernedPhase` deliberately carries no evidence or topic field — see [Design Decisions](#design-decisions).
- Defining exact byte-size bounds, a canonical JCS encoding, or a receipt/Content DNA projection for continuity decisions. `governed_continuity.incn` does not yet define these; see [Open questions](#open-questions).

## Guide-level explanation

A package declares one goal and its schedule:

```incan
goal = GovernedGoal(
    goal_id=goal_id("build_personal_wind_down_routine"),
    entry_phase_id=phase_id("understand_context"),
    completion_phase_ids=[phase_id("review_routine")],
    allowed_action_ids=[action_id("answer_from_package"), action_id("present_guided_card")],
)

schedule = GovernedSchedule(
    schedule_id=schedule_id("wind_down_learning_session"),
    goal_id=goal_id("build_personal_wind_down_routine"),
    total_target_seconds=720,
    allowed_clock_sources=["host_monotonic"],
    phases=[
        GovernedPhase(
            phase_id=phase_id("understand_context"),
            minimum_seconds=0, target_seconds=120, maximum_seconds=240,
            allowed_action_ids=[action_id("answer_from_package"), action_id("present_guided_card")],
            next_phase_ids=[phase_id("choose_routine")],
        ),
        # ...
    ],
)
```

At runtime, a caller starts a session by proposing `Start` with no prior state:

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
        proposed_phase_id=phase_id("understand_context"),
        proposed_action_id=action_id("present_guided_card"),
        clock_source="host_monotonic",
        current_clock_seconds=1000,
        prior_state=None,
        # profile_id/package_id/domain_id/package_revision/artifact_digest omitted for brevity
    ),
)
# decision.terminal == ContinuityTerminal.Admitted
# decision.resulting_state.phase_id == "understand_context"
```

Every later proposal supplies the caller-reconstructed `prior_state` from the previous admitted decision. Continuing in the same phase, transitioning to a declared next phase once the phase's minimum duration is met, and closing the goal once its total target duration is reached each go through the same function and the same terminal shape.

An off-schedule attempt — an undeclared transition, an action the phase didn't declare, a clock that moved backward, or a `prior_state` whose identity doesn't match the proposal — is rejected with one of the reasons in [Public admission reasons](#public-admission-reasons), never silently coerced into something admissible.

## Reference-level explanation

### Package-declared authority

`ContinuityPackage` binds `GovernedGoal` and `GovernedSchedule` declarations to a package identity (`profile_id`, `package_id`, `domain_id`, `package_revision`, `artifact_digest`). `validate_continuity_package` enforces, before any proposal is considered:

- at least one goal and one schedule are declared;
- goal identifiers and schedule identifiers are each unique;
- every schedule's `goal_id` names a declared goal, and every goal has at least one matching schedule;
- a goal's `entry_phase_id` and every `completion_phase_ids` entry exist in that schedule's phase list;
- a goal declares a non-empty `completion_phase_ids` and a non-empty `allowed_action_ids`;
- a schedule declares a positive `total_target_seconds`, at least one allowed clock source, and at least one phase;
- phase identifiers within a schedule are unique;
- every phase satisfies `0 <= minimum_seconds <= target_seconds <= maximum_seconds` and declares at least one allowed action;
- a phase's `next_phase_ids` excludes itself (no self-cycle) and names only phases declared later in the schedule's own phase list — the graph is acyclic by construction because every edge must point strictly forward.

A structurally invalid package fails every proposal with reason `invalid_continuity_package` before any proposal-specific check runs.

### The proposal envelope

`ContinuityProposal` carries: the proposed `ContinuityOperationKind`, a session identifier, a caller-supplied `event_id`/`event_index`, the full package identity (compared against the package Hees.ai was given, not trusted from the proposal), the target `goal_id`/`schedule_id`, the proposed phase and action, a `clock_source` string, the current clock in seconds, and `prior_state: Option[SessionContinuityState]`.

`SessionContinuityState` is the caller-reconstructed result of the last admitted decision: session and package identity, current goal/schedule/phase, when the goal and the current phase started, the last admitted clock value and event index, and whether the goal is closed. Hees.ai never derives this from storage; the caller supplies it as part of the proposal and Hees.ai only checks it for internal and cross-proposal consistency.

### Admission order

`evaluate_continuity` validates in this order, stopping at the first failure:

1. The package must be structurally valid (`invalid_continuity_package`).
2. The proposal's package identity must exactly match the package's (`package_identity_mismatch`).
3. The proposal's `goal_id` must name a declared goal (`unknown_goal`).
4. The proposal's `schedule_id` must name that goal's schedule, and the schedule's `goal_id` must match (`unknown_schedule`, `schedule_goal_mismatch`).
5. The proposal's `clock_source` must be one the schedule declares (`clock_source_not_allowed`).
6. The proposed phase must exist in the schedule (`unknown_phase`).
7. The proposed action must be allowed by both the goal and the proposed phase (`action_not_allowed_for_goal`, `action_not_allowed_for_phase`).
8. The clock and event index must be non-negative (`invalid_event_coordinates`).
9. Operation-specific rules apply (below), each producing a specific rejection reason or one admitted decision.

### Operation-specific rules

- **Start**: requires `prior_state` to be absent (`start_requires_empty_state`), `event_index == 0` (`start_event_index_invalid`), and the proposed phase to be the goal's declared `entry_phase_id` (`start_phase_not_declared`). Admits with reason `declared_goal_started`; both `started_at_seconds` and `phase_started_at_seconds` are set to the proposal's clock value.
- **Continue**, **Transition**, **Close** all require `prior_state` to be present (`prior_state_required`), and then:
    - the prior state's identity must exactly match the proposal's (session, package, goal, schedule identity — `prior_state_identity_mismatch`);
    - the prior session must not already be closed (`session_already_closed`);
    - `event_index` must equal `prior.last_event_index + 1` exactly (`event_index_not_monotonic`);
    - `current_clock_seconds` must not be less than `prior.last_clock_seconds` (`clock_regression`);
    - the prior phase must still exist in the schedule (`prior_phase_unknown`).
- **Continue** additionally requires the proposed phase to equal the prior phase (`continue_phase_mismatch`). Admits with reason `continue_current_phase`; `started_at_seconds` and `phase_started_at_seconds` carry forward unchanged.
- **Transition** requires the proposed phase to be one of the prior phase's declared `next_phase_ids` (`phase_transition_not_declared`), and the elapsed time in the prior phase to be at least that phase's `minimum_seconds` (`phase_minimum_not_met`). Admits with reason `declared_phase_transition`; `phase_started_at_seconds` resets to the current clock value.
- **Close** requires the proposed phase to equal the prior phase and that phase to be one of the goal's declared `completion_phase_ids` (`goal_close_not_declared`), and the elapsed time since the goal started to be at least `schedule.total_target_seconds` (`goal_budget_not_reached`). Admits with reason `declared_goal_closed`, and the resulting state's `closed` flag becomes `true`.

An unrecognized operation value reaches `unknown_continuity_operation` (defensive; the closed `str`-backed enum should make this unreachable through the typed public API).

### Public admission reasons

Every terminal decision carries exactly one reason string. The complete set observed in the current implementation:

`invalid_continuity_package`, `package_identity_mismatch`, `unknown_goal`, `unknown_schedule`, `schedule_goal_mismatch`, `clock_source_not_allowed`, `unknown_phase`, `action_not_allowed_for_goal`, `action_not_allowed_for_phase`, `invalid_event_coordinates`, `start_requires_empty_state`, `start_event_index_invalid`, `start_phase_not_declared`, `prior_state_required`, `prior_state_identity_mismatch`, `session_already_closed`, `event_index_not_monotonic`, `clock_regression`, `prior_phase_unknown`, `continue_phase_mismatch`, `phase_transition_not_declared`, `phase_minimum_not_met`, `goal_close_not_declared`, `goal_budget_not_reached`, `unknown_continuity_operation` (rejections); and `declared_goal_started`, `continue_current_phase`, `declared_phase_transition`, `declared_goal_closed` (admissions).

This RFC does not yet freeze these as a versioned, namespace-scoped closed table the way RFC 003/RFC 006 freeze memory-admission reasons — see [Open questions](#open-questions).

## Design details

### Relationship to RFC 000

RFC 000 establishes that nothing a model or provider proposes is trusted on its own and that Hees.ai holds terminal authority over delivery. This RFC applies the same posture to *time and position within a goal*: a caller proposes when to move on, but only a package-declared schedule and Hees.ai's admission of it can make that move real.

### Relationship to RFC 003

`governed_continuity.incn`'s sibling module, `governed_memory_operations.incn`, documents itself as "adjacent to RFC 003" and explicitly not an implementation of RFC 003's retrieval ingress. Continuity and RFC 003 are more distant still: this RFC never selects, nominates, or materializes memory. A package that combines both declares a schedule (this RFC) whose phases may, once implemented end-to-end, gate *which* declared topic scope or memory class is reachable in a given phase — but that gating is package/implementation-package policy layered on top of, not part of, either contract. Concretely, in the reference implementation this evidence pattern lives as an implementation-package-only `topic_atom_ids` extension per phase, validated by the calling implementation, not by `evaluate_continuity` itself — see [Design Decisions](#design-decisions).

### Relationship to a memory-operations RFC

`governed_memory_operations.incn` is a distinct, independent admission contract (memory-class lifecycle authority: inspect/select-for-prompt/write/revoke/supersede) with no structural dependency on this RFC. The two are commonly deployed together but evaluated independently — a continuity decision never depends on `evaluate_memory_operation`'s result and vice versa. A separate RFC is recommended for that contract rather than folding it into either this RFC or RFC 003; see the companion draft note in this same branch.

## Alternatives considered

### Let Hees.ai read a wall clock itself

Rejected for the same reason RFC 003 rejects it for evaluation time: repeated evaluation could disagree across independent runtimes evaluating the same proposal, and it would make `evaluate_continuity` impure. The caller supplies `current_clock_seconds` as part of the deterministic input.

### Persist session state inside Hees.ai/`evaluate_continuity`

Rejected. Coupling admission to a specific storage adapter would make the function impossible to test in isolation, make cross-runtime determinism harder to prove, and duplicate work every storage backend would need to redo identically. The current split — a pure admission function plus a caller-owned, independently-replayable event log — was validated in the customer-demo project's `SessionContinuityStore`, including adversarial fixtures for clock regression, non-monotonic event index, chain tampering, and re-chained prior-state substitution.

### Encode topic/content relevance as a kernel-level phase field

Rejected. `GovernedPhase` intentionally carries no evidence or topic field. Domain content and policy — "what is this phase actually about" — is implementation-package responsibility, not a generic kernel concept; folding it in here would make every continuity-only package (with no notion of topic scope at all) carry a meaningless field, and would blur the same authority boundary RFC 003 draws around package-owned content.

## Drawbacks

A caller must implement its own persistence adapter to get any value from this contract; the RFC defines no storage shape, so independent implementations may reasonably diverge on log format even while agreeing on admission semantics. The phase-graph-must-point-forward rule (used here to guarantee acyclicity by construction) forbids expressing a schedule where an earlier-declared phase is revisited from a later one, even where a package author might reasonably want a bounded loop (e.g., "review, then optionally repeat one earlier phase"); the current contract has no support for that shape. The admission-reason vocabulary above is not yet closed or namespaced the way RFC 003/006 close theirs, so it may need a breaking revision once formalized.

## Layers affected

- **Public contract:** New `ContinuityOperationKind`, `ContinuityTerminal`, `GovernedGoal`, `GovernedPhase`, `GovernedSchedule`, `ContinuityPackage`, `SessionContinuityState`, `ContinuityProposal`, `ContinuityDecision`, and `ContinuityValidation` types; new `validate_continuity_package` and `evaluate_continuity` public functions.
- **Runtime validation:** Deterministic package-graph validation, proposal-identity binding, and per-operation admission with a closed (informal, pending formal freeze) reason vocabulary.
- **Package compatibility:** Purely additive — a package with no continuity declaration is unaffected; continuity is opt-in per package, mirroring RFC 003's opt-in framing for memory.
- **Persistence boundary:** This RFC explicitly does not define one. A reference caller-owned adapter exists as implementation evidence (see Non-Goals) but is out of this contract's scope.
- **Tests and documentation:** The reference implementation already carries positive and fail-closed tests (`tests/test_governed_continuity_contract.incn`) and a documented adversarial persistence-adapter test suite in the customer-demo project; formal cross-implementation fixtures per this repo's usual RFC acceptance-obligations bar remain open work (see below).

## Design Decisions

- The caller supplies time and proposes each operation one at a time; Hees.ai never reads a clock, chooses a goal, or persists state.
- A phase graph is validated to be acyclic by construction: every `next_phase_ids` edge must point to a later-declared phase in the same schedule.
- `Continue`, `Transition`, and `Close` all require an exactly-matching, monotonically-advancing `prior_state`; `Start` requires its absence. This makes replay-safety a property of the admission function itself, not just of a well-behaved caller.
- A phase's declared `minimum_seconds` gates `Transition` away from it; the schedule's `total_target_seconds` gates `Close`. Neither is enforced by `Continue`, which always succeeds once identity and monotonicity hold and the action is declared-allowed.
- `GovernedPhase` carries time and action-authority bounds only — no topic, evidence, or content field. Topic scope is deliberately out of the kernel's vocabulary; see [Relationship to RFC 003](#relationship-to-rfc-003).
- Continuity admission and delivery/memory admission are independent dimensions, evaluated separately, matching RFC 003's split between envelope admission and provider state.

## Open questions

- Should the admission-reason vocabulary be frozen into a closed, namespaced table (RFC 003/006-style) as part of this RFC, or left informal until a receipt/Content DNA projection for continuity decisions is designed?
- Does a continuity decision need any receipt/Content DNA export at all, or is it purely an internal admission signal that a *separate* delivery decision's receipt may reference by event id?
- Should this RFC define exact byte-size/collection bounds (identifiers, phase counts, schedule counts) the way RFC 003 does, given `governed_continuity.incn` does not currently enforce any?
- The phase-graph-forward-only acyclicity rule forbids expressing an intentional bounded revisit/loop. Is that an acceptable permanent restriction, or should a future revision add an explicit, bounded loop declaration?
- Proposal issue [#35](https://github.com/encero-systems/hees.ai/issues/35) is now filed; this document should stay `Draft` until that discussion resolves.
