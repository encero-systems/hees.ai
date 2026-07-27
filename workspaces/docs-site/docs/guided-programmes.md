# Guided programmes

A guided programme is a package-declared learning path whose cards, transitions, support requirements, audience, language and progress policy are evaluated by Hees. The learner application may render the programme and propose an operation, but it cannot create a transition, use undeclared support or grant itself persistence authority.

This contract lets one governed content package support direct questions, guided material and bounded personalization without turning those experiences into unrelated applications. The presentation may differ, while the underlying evidence, reviewed memory and authority remain package-owned.

## What a package declares

A programme declaration contains an exact programme and package identity, a revision, allowed languages and audiences, an entry card, a completion card, a progress policy and a bounded catalog of cards. Each card declares its reviewed and rights-allowed state, eligible evidence and memory identifiers, optional session-only choices, a deterministic forward edge and whether it is a completion card.

The current contract permits at most 128 cards and 256 history entries. Programme validation rejects duplicate identities, unknown transitions, unreviewed or rights-blocked cards, unsupported language or audience declarations, invalid completion topology and required-progression cycles.

## Runtime input remains untrusted

The runtime supplies a `ProgrammeRuntimeFrame` and a `ProgrammeAction`. Both are untrusted input. A frame states the exact package, programme and revision being used, the current card and history, the active language and audience, and the memory and evidence nominated for the interaction. An action proposes one closed operation:

- enter the programme;
- advance along the declared forward edge;
- backtrack through the observed history;
- select a package-declared session choice;
- complete at the declared completion card;
- resume matching progress;
- save progress when the package allows explicit saving;
- discard saved progress when the package allows explicit saving.

The evaluator rejects extra fields that do not belong to the proposed action. Valid data shape alone does not create authority: the action origin, target, nominated support, language, audience, programme revision and progress history must all agree with the declaration.

## Retrieval nominates; Hees decides

Hyperquant may nominate memory identifiers for a learner interaction. It does not decide that a card is supported and it does not authorize navigation. The programme boundary checks that every memory and evidence identifier required by the active card appears in the support nominations supplied for the interaction.

This separation is deliberate. Retrieval can remain optimized, approximate and replaceable while programme eligibility remains deterministic and declaration-driven. A high similarity score cannot make an undeclared card, transition or source eligible. The nominations still require governed-memory admission before they may become terminally selected support.

## Operation eligibility

`evaluate_programme_action` returns a `ProgrammeEvaluation`. Its serializable `ProgrammeDecisionTrace` explains whether the action is eligible, the closed reason, the current and next card, any session value and any requested memory operation.

The trace and operation projection are not reusable authority tokens. They are safe inspection output from the structural evaluator. A later Hees authority stage must evaluate the original admitted package, governed support and runtime state; it must not accept a caller-constructed evaluation, copied trace or copied projection as proof of admission or terminal authority.

The evaluator is intentionally side-effect free. It does not render cards, retrieve memory, write progress or activate packages. A later Hees stage may use the projected operation as candidate input only while rebinding the original governed inputs; a rejected evaluation carries no operation forward.

## Progress is package-owned policy

`SessionOnly` allows navigation and session choices without durable progress operations. `ExplicitSave` makes save and discard operations eligible for later authority evaluation. The host cannot enable persistence by setting a runtime boolean.

Resume input remains untrusted. Hees verifies its package, programme and revision identities, current card and complete bounded history before making the resume operation eligible.

## Current integration boundary

The public contract currently proves declaration validation and direct operation eligibility across the generated Hees library boundary. It does not claim that a caller-constructed programme is an admitted package artifact, that nominated support is governed memory, or that an eligible programme operation is a terminal Spectrum decision.

Those are the next authority integrations: bind the declaration to an admitted package, bind nominations to the governed-memory result, then carry the eligible operation through the terminal Spectrum, Content DNA and receipt lifecycle. Until those bindings exist, applications should describe this surface as guided-programme validation and operation eligibility.

## Minimal public use

An external Incan application imports the programme models and evaluator from `pub::hees_ai`, builds or loads a package-owned declaration, supplies the current runtime frame and proposed action, and then inspects the evaluation:

```incan
evaluation = evaluate_programme_action(programme, frame, action)
trace = evaluation.trace
operation = evaluation.operation

if trace.eligible:
    match operation:
        Some(eligible) =>
            # Submit this direct eligible operation to the later Hees authority stage.
            pass
        None =>
            # An eligible trace without an operation cannot advance.
            pass
```

The result uses direct public fields rather than treating object privacy as an authority boundary. The terminal integration must consume the original governed inputs and derive its own capability; it must never trust a caller-constructed `ProgrammeEvaluation`.
