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

This separation is deliberate. Retrieval can remain optimized, approximate and replaceable while programme eligibility remains deterministic and declaration-driven. A high similarity score cannot make an undeclared card, transition or source eligible. At terminal admission, Hees derives selected support only from the declared card and independently validates its reviewed, rights-allowed package support projection.

## Operation eligibility

`evaluate_programme_action` returns a `ProgrammeEvaluation`. Its serializable `ProgrammeDecisionTrace` explains whether the action is eligible, the closed reason, the current and next card, any session value and any requested memory operation.

The trace and operation projection are not reusable authority tokens. They are safe inspection output from the structural evaluator. `evaluate_programme_terminal` evaluates the original package projection, reviewed support and runtime state again; it never accepts a caller-constructed evaluation, copied trace or copied projection as proof of admission.

Both evaluators are intentionally side-effect free. They do not render cards, retrieve memory, write progress or activate packages. The terminal evaluator produces an authoritative decision and provenance projections, but a separate package installation path remains responsible for verifying the artifact on disk and a separate progress store remains responsible for persisting any admitted operation.

## Progress is package-owned policy

`SessionOnly` allows navigation and session choices without durable progress operations. `ExplicitSave` makes save and discard operations structurally eligible for terminal admission. The host cannot enable persistence by setting a runtime boolean.

Resume input remains untrusted. Hees verifies its package, programme and revision identities, current card and complete bounded history before making the resume operation eligible.

## Terminal programme admission

`evaluate_programme_terminal` is the terminal boundary for a guided-programme operation. It accepts the original `ProgrammeAuthorityPackage` and `ProgrammeInteraction`, validates the programme and source-safe support projection again, evaluates the original action, and derives the exact admitted card and selected memory from the declared card. It never accepts a caller-constructed `ProgrammeEvaluation` as a substitute for that work.

On admission, Hees emits the card identity an application may render, the ordered selected-memory and evidence identifiers, a Content DNA envelope and a receipt. A rejected operation has no admitted card, no selected memory and no Content DNA. When the installed package projection itself is malformed, Hees withholds a receipt as well because there is no established package identity to attest to.

The current boundary accepts a runtime-ready package projection. It does not yet implement a package-file loader that verifies the artifact digest on disk, invoke Hyperquant itself, render the card payload, write durable progress or make a clinical or semantic truth claim. Those responsibilities remain separate; the application and retrieval layers must supply the original inputs, while Hees remains the authority that decides whether the declared operation may proceed.

## Minimal public use

An external Incan application imports the programme models and terminal evaluator from `pub::hees_ai`, supplies the installed package projection and original learner interaction, then renders only an admitted card projection:

```incan
evaluation = evaluate_programme_terminal(package, interaction)

if evaluation.terminal.admitted:
    match evaluation.admitted_card:
        Some(card) =>
            # Render the exact package card identified by this projection.
            pass
        None =>
            # A renderable operation cannot proceed without an admitted card.
            pass
```

The result uses direct public fields rather than treating object privacy as an authority boundary. The terminal evaluator consumes the original governed inputs and derives its own decision; it never trusts a caller-constructed `ProgrammeEvaluation`.
