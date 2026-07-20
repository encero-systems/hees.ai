# hees.ai console Devpost draft

> **Operator gate:** Copy this draft into Devpost only after the tagged release audit. Replace the plain operator instructions below with observed external values; do not add unsupported claims to the submission.

## Submission metadata

| Field | Value |
| --- | --- |
| Title | hees.ai console |
| Tagline | GPT-5.6 proposes. Hees decides. |
| Category | Developer Tools |
| Entrant | Danny Meijer, individual |
| Repository | [Hees.ai](https://github.com/encero-systems/hees.ai/tree/hees-console-v0.1.0), at the tagged release revision |
| Try it | [Published `hees-console-v0.1.0` release](https://github.com/encero-systems/hees.ai/releases/tag/hees-console-v0.1.0) |
| Video | Add the approved public YouTube URL after upload and signed-out verification. |
| License | [Apache-2.0](https://github.com/encero-systems/hees.ai/blob/hees-console-v0.1.0/LICENSE); third-party notices ship with each platform archive. |

### Why Developer Tools

The available categories are Developer Tools, Apps for Your Life, Work and Productivity, and Education. Developer Tools is the accurate category because hees.ai console is built for developers creating governed and controlled AI systems. The fictional lesson package demonstrates the technology; it does not make the product an education application.

## Short description

hees.ai console is the evidence-first development environment for governed AI. Its product direction helps developers turn sources into candidate memory, govern those atoms, and assemble reusable profiles that declare rights, actions, policy and evaluator roles. This Build Week release delivers the working bounded slice: a native Incan Profile Studio over supplied fictional evidence where developers inspect evidence and memory, stage or unstage a session-local candidate, validate it through Hees, pressure-test proposals through Training by Committee, and inspect Spectrum, selected memory, Content DNA and receipts. GPT-5.6 proposes. Hees decides.

## The problem

AI development usually begins with a prompt and ends with model output. Governance is added afterwards as a filter, a moderation call, or a line of application logic. That leaves the most important questions implicit:

- Which evidence was reviewed and allowed into the system?
- Which memory may support an answer?
- What is the model permitted to claim or do?
- Who interprets evaluator observations?
- What exact policy produced the decision?
- Can the result be replayed and audited without trusting a stored answer?

Structured output does not solve those questions. A model can return perfect JSON, cite a well-formed identifier, and still have no authority to use that evidence or perform that action.

hees.ai console changes the unit of AI development from **a prompt** to **a governance profile**. The profile exists before the model runs. It makes evidence, reviewed memory, rights, actions, requirements, evaluator roles, policy, bounds, terminal reasons, and audit artifacts one executable contract.

## The product

The working release begins with a supplied fictional evidence package and a session-local candidate. It proves the governed path from inspectable evidence through profile validation, pressure testing, decision, Content DNA, and receipt. The evidence-first workflow below is the permanent product direction this bounded slice makes tangible; general intake, durable authoring, and profile activation remain future work.

1. Load and inspect source evidence.
2. Turn bounded source spans into candidate memory atoms without treating model suggestions as reviewed material.
3. Establish package-owned provenance, review, rights, authority, and evidence declarations.
4. Define permitted actions, answer requirements, policy thresholds, and evaluator roles.
5. Validate the governance profile through Hees.
6. Pressure-test memory, proposals, prompts, and policy through Training by Committee.
7. Run live or saved inputs through the active compiled profile.
8. Inspect the proposal, observations, Hees findings, Spectrum result, selected memory, Content DNA, receipt, and trace.
9. Compare, replay, and export bounded evidence without turning historical output into current authority.

The Build Week release makes that workflow tangible with a fictional Lantern Labs Profile Studio. Developers can browse the supplied sources and reviewed memory with their identity, provenance, review, rights, and authority metadata; stage or unstage material in a session-local candidate; rerun the shipped acceptance interaction against that candidate through the real Hees-owned boundary; and reset it. A missing required atom returns stable public reason `invalid_package` plus exact profile diagnostic `invalid_package_atoms`. Candidate activation remains explicitly blocked because this first public profile does not yet expose a safe activation-authority API. The active shipped profile cannot be silently replaced by UI state.

After profile work, the same Console runs one admitted and four adversarial interactions. It keeps `UNTRUSTED PROPOSAL`, evaluator observations, `HEES-CLASSIFIED FINDINGS`, terminal decision, selected memory, Content DNA, receipt, and trace visually separate.

**Product evidence:** Link the published release, capture set, recorded demonstration timecodes, and profile-validation run from the same tagged revision when preparing the Devpost form.

## What a governance profile declares

The fictional `console_profile_0_1` package makes the contract concrete:

| Declaration | Fictional example | Why it matters |
| --- | --- | --- |
| Identity | profile `console_profile_0_1`; package `lantern_labs`; revision `1.0.0` | Binds every request, proposal, observation, and artifact to one exact context. |
| Source | `source_lantern_path`, English fictional lesson note, exact fingerprint | Establishes the source bytes and source-safe identity available to the profile. |
| Reviewed memory | `memory_lantern_sequence`, evidence `evidence_lantern_path`, exact source span, `approved`, `allowed` | Makes package-declared review, rights, provenance, and answer eligibility explicit; this release validates those declarations and their governed use, not external ownership or licensing facts. |
| Permitted action | `explain_lesson` | Causes the plausible but undeclared `assign_final_grade` action to fail as `unknown_action`. |
| Requirements | `explain_sequence`, `ground_in_lesson` | Defines the visible-answer coverage targets Hees derives. |
| Policy | minimum support `6500` basis points; maximum contradiction `3500` basis points | Converts bounded observations into deterministic Hees findings. |
| Committee roles | evidence relation, contradiction cross-check, synthesis coverage | Restricts evaluators to exact Hees-derived targets; no provider vote chooses the result. |
| Terminal artifacts | Spectrum result, selected memory, Content DNA, receipt | Makes the governed outcome inspectable and exportable. |

The package also contains `memory_public_ranking_draft`, with review state `pending` and rights state `denied`. It is intentionally visible but ineligible. The distinction demonstrates a central Hees idea: material can be known to a workspace without being permitted to enter a governed answer.

## How it works

```text
evidence -> candidate memory atoms
                    |
        authorized review + rights declaration
                    |
                    v
          reviewed memory atoms
                    |
          reusable governance profile
                    |
saved replay inputs ─┐
                    ├─> proposal -> Training by Committee observations
live GPT-5.6 inputs ─┘                    |
                                         v
                         compiled Incan-authored Hees profile
                     validation -> findings -> bounded Spectrum
                                         |
                              governed terminal decision
                                         |
                      selected memory -> Content DNA -> receipt
```

Replay and live mode are transports into one authority path. Replay fixtures contain integrity-checked requests, proposals, bounded observations, and schema identities. They do not contain findings, a Spectrum result, selected memory, Content DNA, or a receipt. Optional live mode obtains the same classes of bounded input from GPT-5.6. After transport-specific decoding, both invoke the same validation, manifest derivation, finding classification, Spectrum operation, memory selection, Content DNA construction, and receipt code.

One live invocation is preflight-limited to one proposal call plus at most eight sequential committee calls. Each request has a configured 15-second timeout, so nine calls carry 135 seconds of aggregate configured timeout budget, with no retries. This is not a global wall-clock ceiling because `ureq` 2.12.1 cannot interrupt DNS resolution. Every provider request body is limited to 65,536 UTF-8 bytes. These limits constrain the optional transport; they do not transfer governance authority to the provider.

The Console owns native terminal interaction, bounded transport, secret isolation, escaping, and session state. It calls the public Incan-authored Hees profile directly. Presentation code cannot reconstruct or reinterpret terminal authority.

## Training by Committee

Training by Committee is governed pressure testing, not provider voting or model-weight training. Hees derives the exact relation, contradiction, and synthesis targets from the package, request, and proposal. Provider-neutral evaluator roles return bounded observations against those targets. Hees verifies identity and complete coverage, interprets the scores through profile-owned thresholds, and produces the findings used by Spectrum.

This separation lets developers use model evaluators to challenge material and proposals without granting those evaluators the right to approve themselves. The provider-neutral design can extend to multiple models; this release's live adapter is pinned to `gpt-5.6-sol`.

## The demonstrated interactions

- **Admitted:** `explain_lesson` uses declared evidence and reviewed, rights-allowed memory. Hees admits it, selects `memory_lantern_sequence`, constructs Content DNA, and emits a receipt.
- **Unknown evidence:** the proposal cites schema-valid `evidence_missing_lantern`. Hees rejects `unknown_evidence`; syntax cannot create provenance or authority.
- **Undeclared action:** the proposal requests `assign_final_grade`. Hees rejects `unknown_action`; the model cannot invent permission.
- **Unknown memory:** the proposal references memory outside the package. Hees rejects `unknown_memory`.
- **Non-admitted memory:** the proposal references the known but pending and rights-denied ranking draft. Hees rejects `memory_not_admitted`.

## Why it matters

Governed AI should not depend on hoping that a system prompt survives contact with a model. A reusable profile gives developers a testable object that can move across providers and environments while preserving declared evidence, memory eligibility, behavior, policy, and terminal authority.

The Build Week release proves a practical foundation: native profile and evidence exploration, real candidate-state validation, deterministic happy and adversarial runs, provider-neutral pressure testing, selected-memory attribution through Content DNA, receipts, and offline no-rebuild replay through the actual Hees implementation. Its visible refusals demonstrate the concrete boundary: a well-formed model proposal still cannot borrow evidence or action authority that the profile never granted.

The product direction builds from this foundation toward semantic and factual assurance, source and claim provenance, rights assurance, conflict management, richer Spectrum adjudication, governed behavior envelopes, durable IncQL-DB-backed workspaces, and reusable profiles across domains and languages. The current slice does not pretend that journey is complete; it demonstrates why the architecture can support it.

## Design

hees.ai console is a native, keyboard-first Incan product rather than a chat transcript or JSON log. Its information architecture follows the governed-development workflow:

1. Profiles
2. Evidence
3. Memory
4. Committee
5. Interactions
6. Decisions
7. Help

Wide terminals use a framed three-pane workspace with one source of truth for widths, wrapping, and borders. Compact terminals switch to deterministic full-width destinations rather than squeezing unreadable columns. Text and symbols carry every authority state without depending on colour.

**Design evidence:** Attach wide, compact, Profile, Evidence, admitted, rejected, and monochrome captures from the tagged release artifact to the Devpost gallery.

## Technical implementation

- native hees.ai console application authored in Incan;
- commit-pinned Incan compiler and lockfile;
- direct call into the public Incan-authored Hees profile;
- strict typed repository contracts, with the OpenAI-supported strict JSON Schema subset at the provider edge;
- SHA-256 identities across package, request, proposal, targets, observations, replay inputs, Content DNA, and receipts;
- `crossterm` through explicit Incan interop for native terminal primitives;
- `ureq` through explicit Incan interop for the optional HTTPS boundary;
- five deterministic offline scenarios that rerun the real Hees path;
- bounded `gpt-5.6-sol` Responses API adapter for optional live proposals and evaluator observations; and
- native tests, Hees profile tests, provider-boundary tests, public-consumer checks, packaging gates, and extracted-archive smoke tests.

**Verification:** Link the exact tagged source revision, release checksums and manifests, CI runs, and clean extracted-archive smoke evidence from the published release.

## How Codex and GPT-5.6 were used

Incan and Hees were not invented during Build Week. Incan is a long-running, human-directed language and compiler project developed with substantial GPT assistance. Danny's Hees research, governance architecture, Spectrum, Content DNA, and profile direction also predate this submission period.

During Build Week, Codex with GPT-5.6 helped turn that long-running Hees research into a coherent, usable public package within days. It accelerated repository boundary work, RFC refinement, product design, native Incan implementation, test generation, adversarial review, compiler bug isolation, release engineering, documentation, architecture visuals, and submission preparation.

Danny remained the decision-maker. He defined the evidence-first product direction, kept models non-authoritative, made governance profiles the product unit, required Hees to own terminal decisions, selected the fictional publication-safe domain, chose the native Incan showcase, directed the TUI redesign, approved the release posture, and retains final review and submission authority.

At runtime, GPT-5.6 has a narrower role. It may produce bounded proposal and evaluator-observation inputs. It cannot set review or rights state, declare package authority, classify findings, select memory, construct Content DNA, or issue the decision and receipt.

**Build Week evidence:** Cite the dated public pull requests and task evidence, then enter the account-bound Codex `/feedback` Session ID in the Devpost field after it is generated.

## Try it

The primary judge path is the native offline release. It requires no Incan compiler, source checkout, account, API key, or network connection after download. macOS artifacts are not Developer ID-signed and not notarized; linker ad-hoc signing may exist solely for local execution and conveys no publisher identity.

1. Download the archive for the judge's platform from the [published `hees-console-v0.1.0` release](https://github.com/encero-systems/hees.ai/releases/tag/hees-console-v0.1.0).
2. Verify it against that release's `SHA256SUMS` asset and the selected platform manifest.
3. Extract the archive and launch `./hees-console`.
4. Open Evidence with `2`, unstage a record with `Space`, and validate with `v`. Confirm that Hees rejects the incomplete candidate with public reason `invalid_package` and exact diagnostic `invalid_package_atoms` while the active profile remains unchanged.
5. Reset with `r`, validate again, and inspect the restored candidate in Profiles with `1`.
6. Open Interactions with `5` and run the admitted scenario.
7. Open Decisions with `6` and inspect selected memory, Content DNA, and the receipt.
8. Run the unknown-evidence and undeclared-action scenarios and confirm their exact rejection reasons.

Complete platform, macOS signing posture, expected-result, and troubleshooting instructions live in [TESTING.md](../TESTING.md).

## Current slice and product direction

| Working in this release | Product direction |
| --- | --- |
| Supplied fictional evidence catalog and reviewed-memory package | General evidence intake, extraction, candidate-atom curation, and durable IncQL-DB workspaces |
| Session-local stage, unstage, validate, and reset workflow | Safe activation, versioning, comparison, export, and reuse of authored profiles |
| Structural and policy admission under one exact profile | Semantic and factual verification, claim-level support, source provenance, and rights assurance |
| Bounded Training by Committee proposal pressure test | Richer provider-neutral pressure testing across evidence, atoms, prompts, packages, and policy |
| Limited Spectrum operation, Content DNA, and profile receipt | Complete generalized Spectrum, Content DNA, response-lifecycle, and receipt contracts |
| Offline replay plus optional live GPT-5.6 transport | Additional remote and local model adapters using the same profile authority boundary |
| Historical pre-redesign candidates on Linux x86-64, macOS Apple Silicon, and macOS Intel | Platforms listed in the tagged Release after extracted no-rebuild smoke; macOS builds are not Developer ID-signed and not notarized, and linker ad-hoc signing conveys no publisher identity |

Optional live GPT-5.6 was verified in two bounded native diagnostics: one proposal call, followed separately by six committee calls using that proposal and a real Hees admission with six classified findings, selected memory, Content DNA and a receipt. These were separate diagnostics, not one frozen-binary run. The judge path therefore remains offline replay, which stores integrity-checked inputs—not decisions—and reruns the compiled Hees authority path. The [sanitized local observation](evidence/live-gpt56-proposal-2026-07-20.json) preserves the exact evidence and limitations.

## Judging-criteria map

| Criterion | Evidence |
| --- | --- |
| Technological Implementation | Native Incan application, real Hees acceptance probe and terminal authority, replay/live transport normalization, strict contracts, adversarial scenarios, and extracted native release evidence |
| Design | Evidence-first navigation, working candidate-profile action, explicit authority hierarchy, responsive native TUI, no-rebuild judge path, and recorded captures |
| Potential Impact | Reusable governance profiles make evidence, rights, policy, model behavior, and decisions testable across providers; demonstrate this through the profile flow in the video. |
| Quality of the Idea | Training by Committee remains non-authoritative; Spectrum, selected memory, Content DNA, and receipts remain Hees-owned; link the architecture page and tagged run evidence. |

## Public links

Use [FINALIZATION_CHECKLIST.md](FINALIZATION_CHECKLIST.md) to complete the release audit, then paste only observed public URLs and values into the Devpost form.
