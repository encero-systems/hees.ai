# Hees Console Devpost draft

> **Pre-freeze draft:** Do not paste this copy into Devpost until every `FINALIZE BEFORE RELEASE` and `MANUAL INPUT REQUIRED` field has been replaced, removed, or narrowed after the completion audit. The finished entry must describe only the frozen release candidate and public evidence.

## Submission metadata

| Field | Draft value |
| --- | --- |
| Title | Hees Console |
| Tagline | GPT-5.6 proposes. Hees decides. |
| Category | Developer Tools |
| Repository | **[FINALIZE BEFORE RELEASE: PUBLIC REPOSITORY URL AT THE FROZEN REVISION]** |
| Try it | **[FINALIZE BEFORE RELEASE: HOSTED SANDBOX OR NO-REBUILD TEST-BUILD URL]** |
| Video | **[MANUAL INPUT REQUIRED: PUBLIC YOUTUBE URL]** |
| License | Apache-2.0; **[FINALIZE BEFORE RELEASE: LICENSE AND THIRD-PARTY NOTICE URLS]** |

## Short description

Hees Console is a local-first developer tool for inspecting the authority boundary around AI output. Under the bounded live contract, GPT-5.6 may propose structured content and observations; Hees validates the exact inputs, classifies findings under package-owned policy, and makes the terminal decision. The Build Week profile applies that separation to a fictional scenario, with implemented zero-credential offline replay and an optional live adapter whose successful public canary remains unverified.

## The problem

Structured model output can make a response machine-readable, but schema validity does not make the model an authority. It does not prove that an action was declared, that cited evidence belongs to the governed package, that memory was reviewed and admitted, or that an evaluator's observation should have a particular policy effect. Those distinctions are easy to hide inside one chat-style response, leaving developers with no clear way to inspect which component proposed, observed, classified, or decided.

Hees Console addresses that developer problem by making the boundary explicit: models propose and observe, package policy defines the admissible space, and the Incan-authored Hees runtime decides. The product is aimed at developers who need a testable, provider-neutral governance boundary rather than another presentation layer around model prose.

## The product

The permanent Hees Console north star is a terminal-first, local-first, provider-neutral and domain-neutral developer product for building, validating, running, replaying, and inspecting governed AI interactions. That broader workflow remains Draft design work; it must not be inferred from this event profile.

For Build Week, the deliberately bounded `console_profile_0_1` profile uses one original fictional lesson-support package to demonstrate one governed interaction end to end. The checked release candidate provides these judge-visible surfaces; public release evidence remains a separate finalization gate:

- a visibly labelled, zero-credential offline replay path using neutral, integrity-checked proposal and observation fixtures;
- an optional `gpt-5.6-sol` Responses API path that supplies strict structured, untrusted proposals and bounded observations to the same runner;
- explicit separation between `UNTRUSTED PROPOSAL`, provider observations, `HEES-CLASSIFIED NON-AUTHORITATIVE FINDINGS`, and the terminal Hees result;
- one valid declared-action scenario that reaches `ADMITTED` and exposes selected canonical memory, experimental Console Content DNA, and a profile-specific receipt; and
- adversarial scenarios that reject an undeclared action and unknown or non-admitted evidence or memory without presenting rejected model prose as a trusted answer.

**Release-candidate evidence:** **[FINALIZE BEFORE RELEASE: FROZEN COMMIT, RELEASE, CI, ARTIFACT SMOKE TEST, AND HAPPY/ADVERSARIAL RUN LINKS]**.

## Technical implementation

The Build Week profile has three intentionally separate layers:

1. The fictional package declares the available actions, canonical reviewed memory, evidence, and package-owned policy.
2. The Incan-authored Console handles terminal presentation, provider transport, schema validation at the transport edge, escaping, secret isolation, and replay composition.
3. The Console calls the Incan-authored Hees profile directly. That profile validates the normalized bundle, derives exact evaluation targets, checks complete observation coverage, classifies findings under package-owned integer thresholds, performs the limited Spectrum operation, and returns the only terminal `ADMITTED` or `REJECTED` result.

Offline replay fixtures contain inputs, integrity metadata, and no stored Hees decision, findings, selected memory, Content DNA, or receipt. Every replay must invoke the runner again. In optional live mode, GPT-5.6 supplies proposals and observations only. It does not choose trusted status, classify policy effects, select admitted memory, construct provenance, or issue a receipt.

The profile uses strict JSON Schema contracts and SHA-256 bindings across the package, request, targets, proposals, observations, findings, replay inputs, and terminal artifacts. These are structural and integrity controls; they do not prove semantic truth or remote authenticity.

**Exact frozen architecture evidence:** **[FINALIZE BEFORE RELEASE: SOURCE, SCHEMA, RUNNER, MANIFEST, AND INTEGRATION-TEST URLS]**.

## Design

The Console is designed around inspection rather than chat. The checked implementation keeps the following distinctions explicit; the frozen artifact still needs full-width, narrow, monochrome, and non-interactive capture evidence before this section is finalized:

- every mode remains labelled `REPLAY` or `LIVE`;
- trusted and untrusted states use text and stable symbols, not colour alone;
- proposal text is escaped and confined to an explicitly untrusted surface;
- observations and Hees-classified findings are adjacent but not conflated;
- the terminal action, reason namespace, and reason are visible without opening raw protocol data; and
- selected memory and experimental Content DNA appear only on an admitted path; after safe package, request, and proposal identity establishment, a profile receipt records either admission or rejection without exposing rejected prose as trusted output.

The interaction is keyboard-first and deterministic for judges: keys `1` through `5` run one valid and four adversarial scenarios, while thirteen dedicated inspectors expose the package, sources, optional atom-comparison state, proposal, support mappings, manifest, observations, findings, Spectrum result, selected memory, Content DNA, receipt, and trace.

**Design evidence:** **[FINALIZE BEFORE RELEASE: FROZEN SCREENSHOTS, NARROW AND MONOCHROME CHECKS, TERMINAL-ESCAPING TESTS, AND VIDEO TIMECODES]**.

## Potential impact

Hees Console makes a specific governance question testable: who supplied each input, who interpreted it, and who had authority to decide? That matters for developers building AI systems in which a well-formed model response still must not bypass package declarations, evidence state, or application policy.

The bounded event profile is designed to demonstrate the approach without requiring network access, credentials, private content, or a source build. The broader product direction is a provider-neutral developer workflow in which teams can author packages, pressure-test proposals through bounded evaluator roles, replay interactions, and inspect terminal artifacts locally. The event entry does not claim those broader authoring and intake capabilities are implemented.

## Novelty

The central idea is not merely to validate a model's JSON. Hees Console makes proposal, observation, policy classification, and terminal authority separate product surfaces. Even the role-bound evaluator calls used for the bounded Training by Committee demonstration remain non-authoritative: Hees derives their targets, checks complete coverage, applies package-owned policy, and decides without a provider vote.

The same authority boundary is designed to serve deterministic offline replay and the optional live GPT-5.6 path. This gives judges a path to inspect the governance mechanism without granting a model authority and without making provider availability a condition of the default demo.

## Technologies used

- Incan `0.4.0` and the Hees `0.0.1` structural-admission kernel;
- a compiled Incan-authored Build Week profile runner;
- `crossterm` through explicit Incan interop for native terminal primitives;
- `ureq` through explicit Incan interop for the fixed native HTTPS boundary;
- JSON Schema Draft 2020-12 and SHA-256 integrity bindings;
- the OpenAI Responses API and explicit model `gpt-5.6-sol` for the optional live path;
- Codex with GPT-5.6 for the event-period implementation workflow; and
- Incan tests, repository boundary checks, native artifact smoke tests, and GitHub Actions **[FINALIZE BEFORE RELEASE: EXACT GREEN TEST MATRIX AND CI URLS]**.

## How Codex and GPT-5.6 were used

Hees and Incan were not created during Build Week. Before July 13, 2026, Incan was already a long-running, human-directed language and compiler project built with substantial GPT assistance over nearly a year, and earlier Hees design and implementation work also predated the event.

During the July 13–21 Build Week submission period, Codex with GPT-5.6 was used to design, implement, review, test, package, and document the bounded Hees Console profile and the public Hees extension required to support it. Dated commits and task evidence will distinguish that new work from the pre-existing projects.

Human decisions remained decisive. Danny chose the model-as-untrusted boundary, kept Hees as the terminal authority, separated the permanent Console product from the event profile, required offline replay as the default, selected original fictional content, and retained publication, release, hosting, and submission approval.

Under the optional live contract, GPT-5.6 is narrower still: it may return strict structured proposals and bounded relation or synthesis observations. Those values remain untrusted. Hees derives the exact targets, validates coverage, applies package policy, and decides.

**Build Week evidence:** **[FINALIZE BEFORE RELEASE: DATED COMMIT RANGE, IMPLEMENTATION/REVIEW PRS, CODEX TASK EVIDENCE, AND `/feedback` SESSION ID]**.

## Testing instructions

The primary judge path is offline replay and must not require rebuilding the project, installing Incan, creating an account, using a network connection, or supplying an API key.

1. Open **[FINALIZE BEFORE RELEASE: HOSTED SANDBOX URL]** or download **[FINALIZE BEFORE RELEASE: SUPPORTED PLATFORM ARTIFACT URL]**.
2. If downloading, verify **[FINALIZE BEFORE RELEASE: ASSET NAME AND SHA-256]** and launch it with **[FINALIZE BEFORE RELEASE: EXACT COMMAND]**.
3. Confirm the header identifies `console_profile_0_1` and mode `REPLAY`.
4. Run scenario `1`; inspect the untrusted proposal, observations, findings, `ADMITTED` result, selected memory, experimental Content DNA, and receipt.
5. Run scenario `2`; confirm `REJECTED`, namespace `console_admission_0_1`, reason `unknown_action`, with no trusted answer.
6. Run scenario `3`, `Unknown evidence reference`; confirm `REJECTED`, namespace `console_admission_0_1`, reason `unknown_evidence`, again with no trusted answer.

Complete instructions, platform support, expected values, and safe troubleshooting live in [TESTING.md](../TESTING.md). Optional live GPT-5.6 operation is not required for the judge path and must not be presented as verified until the public canary field is replaced.

## Current limitations

- This is one fictional, bounded implementation profile, not the complete permanent Hees Console and not a general evidence-ingestion, retrieval, RAG, vector-search, or package-authoring system.
- The profile has only `admit` and `reject`; it does not implement repair, clarification, escalation, or the complete Draft response lifecycle.
- The current executable's optional atom-comparison inspector reports `not_configured` and `package_effect=none`; it does not create a model-generated atom candidate during the demonstrated interaction.
- The bounded Training by Committee slice pressure-tests proposals; it is not model-weight training, fine-tuning, semantic truth, or provider voting.
- Experimental `console_content_dna_0_1` does not establish full RFC 002 conformance, and `console_profile_receipt_0_1` is not RFC 006-compatible.
- Admission does not prove factual correctness, universal claim support, source ownership, legal rights outside declared package state, provider correctness, producer authenticity, or remote attestation.
- Offline replay proves deterministic operation over integrity-checked inputs, not live GPT provenance, provider availability, or language quality.
- Supported platforms are only those backed by published, smoke-tested release artifacts: **[FINALIZE BEFORE RELEASE: SUPPORTED AND UNSUPPORTED PLATFORMS]**.
- Hosted and optional live availability remain bounded by the final published access window and provider requirements: **[FINALIZE BEFORE RELEASE: HOSTED WINDOW AND VERIFIED LIVE STATUS]**.

## Judging-criteria map

| Equally weighted criterion | Submission evidence |
| --- | --- |
| Technological implementation | Incan-authored terminal authority; strict contracts; neutral replay; optional structured GPT-5.6 adapter; dated Codex workflow; green source, integration, adversarial, packaging, and smoke tests **[FINALIZE: LINKS]** |
| Design | Coherent terminal workflow; explicit trust labels; deterministic keys; narrow and monochrome legibility; no-rebuild judge path **[FINALIZE: SCREENSHOTS, VIDEO TIMECODES, AND TEST LINK]** |
| Potential impact | A concrete developer audience and a runnable demonstration of how model output can remain useful without receiving terminal authority **[FINALIZE: DEMO AND TEST LINK]** |
| Quality of the idea | Proposal, observation, policy classification, and decision are separate surfaces; the same Hees boundary is designed to serve offline replay and optional live GPT-5.6 **[FINALIZE: ARCHITECTURE AND RUN LINKS]** |

## Public links

The final public URL set and the evidence each link must support are maintained in [FINALIZATION_CHECKLIST.md](FINALIZATION_CHECKLIST.md). No unverified URL or placeholder may be pasted into the submission form.
