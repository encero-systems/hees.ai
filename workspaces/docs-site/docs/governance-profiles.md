# Governance profiles

A governance profile is the executable unit of governed AI development in hees.ai. It connects a domain package to a controlled interaction by declaring which evidence and memory are eligible, what a model may propose, how provider observations are interpreted, and which terminal artifacts Hees must produce.

The model does not author this contract. A profile remains reusable across model providers because proposals and evaluator observations enter as bounded inputs while evidence state, policy, Spectrum behavior, selected memory, Content DNA, and terminal authority remain governed by Hees.

## From evidence to a governed interaction

The permanent hees.ai console workflow is:

1. Load and inspect lawful source evidence.
2. Derive or enter candidate memory atoms while keeping model suggestions visibly untrusted.
3. Establish package-owned provenance, review, rights, authority, and evidence declarations.
4. Define permitted actions, answer requirements, policy thresholds, and evaluator roles.
5. Validate the resulting governance profile through Hees.
6. Pressure-test memory and proposals through Training by Committee.
7. Run live or saved inputs through the active compiled profile.
8. Inspect the Spectrum decision, selected and discarded memory, Content DNA, receipt, and trace.
9. Save, compare, replay, or export bounded artifacts without treating a historical decision as current authority.

The Build Week release makes this workflow tangible through the fictional Lantern Labs profile. Its Profile Studio is deliberately session-local: a developer can inspect the supplied evidence and memory, stage or unstage profile-supported material in a candidate, rerun the shipped acceptance interaction against that candidate through the Hees-owned boundary, and reset the workspace. Candidate activation is deliberately blocked as `candidate only — not active` because the current public profile does not expose a safe activation-authority API. General document ingestion, durable workspaces, arbitrary package compilation, and governed activation of edited profiles are later product capabilities.

## What the profile contract declares

“Package contract” is shorthand for a concrete set of declarations, not an opaque file or a prompt.

| Declaration | Example in `console_profile_0_1` | Owner | Effect on a run |
| --- | --- | --- | --- |
| Profile and package identity | `console_profile_0_1`, `lantern_labs`, revision `1.0.0` | Package author; validated by Hees | Binds every request, proposal, observation, and artifact to one exact governed context. |
| Source catalog | `source_lantern_path`, English fictional lesson note, exact fingerprint | Package author | Establishes which source bytes and source-safe identities are available to the profile. |
| Review and rights state | `approved`, `allowed` for the Lantern Path atom | Package author or authorized reviewer | Determines whether material may enter admitted memory. A model cannot grant either state. |
| Memory atom | `memory_lantern_sequence` linked to `evidence_lantern_path` and an exact source span | Package author; validated by Hees | Supplies a bounded claim and guidance unit that can be selected only through a valid support mapping. |
| Permitted actions | `explain_lesson`, `compare_observations`, `propose_practice_step` | Package author | Any other action, such as `assign_final_grade`, is rejected as `unknown_action`. |
| Answer requirements | `explain_sequence`, `ground_in_lesson` | Package author | Defines what the visible answer must cover and therefore which synthesis targets Hees derives. |
| Policy thresholds | minimum support `6500` basis points, maximum contradiction `3500` basis points | Package author; interpreted by Hees | Turns bounded evaluator observations into deterministic Hees findings. |
| Evaluator roles | evidence relation, contradiction cross-check, synthesis coverage | Hees-derived manifest and profile contract | Limits Training by Committee to exact targets and roles; evaluator output remains non-authoritative. |
| Terminal behavior | admitted or closed rejection reason, selected memory, Content DNA, receipt | Hees | Produces the only authoritative result. The Console renders it but cannot fabricate or reinterpret it. |

## Worked fictional example

The Lantern Path source says that learners place an amber card, then a blue card, then a green card. The profile does not place that paragraph directly into a model prompt and hope for the best. It governs the path from source to answer:

```text
source
  source_id:           source_lantern_path
  source_fingerprint:  sha256:5503ee...
  language:            en

reviewed memory atom
  memory_id:           memory_lantern_sequence
  evidence_id:         evidence_lantern_path
  source_span:         UTF-8 bytes 47..138
  review_state:        approved
  rights_state:        allowed
  evidence_kind:       lesson_fact
  provenance_digest:   sha256:b377db...

governance profile
  permitted action:    explain_lesson
  requirements:        explain_sequence, ground_in_lesson
  minimum support:     6500 basis points
  maximum contradiction: 3500 basis points
```

For the valid interaction, the model proposes the declared `explain_lesson` action, cites `evidence_lantern_path`, and maps its visible units to `memory_lantern_sequence`. Hees derives exact relation, contradiction, and synthesis targets. Training by Committee supplies bounded observations for those targets. Hees checks their identity and complete coverage, classifies them under the profile's thresholds, and performs the terminal Spectrum operation.

If the result is admitted, Hees freezes `memory_lantern_sequence` as selected memory, constructs Content DNA from that exact selection, and emits the receipt. If the proposal cites `evidence_missing_lantern`, Hees returns `unknown_evidence`. If it proposes `assign_final_grade`, Hees returns `unknown_action`. Valid identifier syntax never creates package authority.

The same profile also contains `memory_public_ranking_draft`, a deliberately non-admitted atom whose review state is `pending` and rights state is `denied`. The atom exists so developers can inspect the difference between material that is known to the workspace and material that is eligible for a governed answer. A proposal cannot use it merely because it appears in the package data.

## Try the session-local Profile Studio

The release exposes working candidate-profile controls rather than static future-product buttons:

| Key | Action |
| --- | --- |
| `1` | Open Profiles and inspect the shipped active profile beside the candidate. |
| `2` | Open Evidence. |
| `3` | Open Memory. |
| `↑` / `↓` | Select an evidence record or memory atom. |
| `Space` | Stage or unstage the selected record in the candidate profile. |
| `v` | Rerun the shipped acceptance interaction through the Incan-authored Hees boundary and display its stable public reason plus exact profile diagnostic. |
| `a` | Attempt activation; the current profile keeps the candidate non-active and explains the missing authority seam. |
| `r` | Reset the session-local candidate to the shipped reviewed profile. |

For the clearest demonstration, open Evidence, unstage one record, and validate. Hees rejects the incomplete candidate with stable public reason `invalid_package` and exact profile diagnostic `invalid_package_atoms` while the shipped active profile remains unchanged. Reset and validate again to restore the valid candidate. No action persists a package to disk, silently repairs a profile, or promotes candidate state into runtime authority.

## Who may decide what

| Surface | May propose or edit | May make authoritative |
| --- | --- | --- |
| Candidate source extraction and atom text | Developer or provider adapter | Nobody until package-owned review and validation succeed |
| Review, rights, provenance, authority class, actions, requirements, and policy | Authorized package authoring workflow | Hees validates the declared profile; a provider cannot self-declare authority |
| Proposal text and support mappings | Model or deterministic fixture | Never by themselves |
| Relation and synthesis observations | Bounded evaluator roles | Never by themselves |
| Findings and policy effects | Hees | Hees only |
| Spectrum result and selected memory | Hees | Hees only |
| Content DNA and receipt | Hees | Hees only |
| Rendering, navigation, local candidate state, and transport | Console | Presentation and platform behavior only |

## Replay and live mode use one authority path

Replay and live mode are input transports, not alternative governance implementations.

```text
saved replay inputs ─┐
                    ├─> normalize and validate ─> compiled Hees profile ─> decision and artifacts
live GPT-5.6 inputs ─┘
```

A replay stores an integrity-checked request, proposal, bounded observations, and schema identities. It does not store findings, a Spectrum result, selected memory, Content DNA, or a receipt. Live mode obtains the same classes of bounded proposal and observation input from GPT-5.6. After transport-specific decoding, both modes invoke the same validation, manifest derivation, observation classification, Spectrum operation, memory selection, Content DNA construction, and receipt code.

Replay therefore demonstrates real offline governance over saved inputs. It is not a mock and it is not evidence that a live provider call occurred.

## What this release proves—and where it leads

The Build Week profile proves that a self-contained Incan application can make evidence state, reviewed memory, package authority, model proposals, evaluator observations, Hees findings, terminal decisions, Content DNA, and receipts separate and inspectable. It proves deterministic admission and rejection under one exact fictional profile and provides a bounded Profile Studio for exercising candidate evidence state.

That is a meaningful foundation for the larger Hees direction: semantic and factual verification, source and claim provenance, rights assurance, governed behavior, conflict management, richer Spectrum adjudication, durable IncQL-DB-backed workspaces, and reusable profiles across domains and providers. Those capabilities become credible because the authority graph and terminal artifact path already exist; later profiles can deepen the assurance without handing the decision back to a model or UI host.

Continue with [hees.ai console](console.md) for the interaction guide, [Architecture](architecture.md) for the complete authority path, and [Console profile 0.1 bounds](console-profile-0-1.md) for the enforced limits of this release.
