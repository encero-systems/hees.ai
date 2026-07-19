# RFC 010: Hees Console

- **Status:** Draft
- **Created:** 2026-07-18
- **Author(s):** Encero Systems
- **Related:**
    - RFC 000 (Foundational Governance Authority)
    - RFC 001 (Spectrum Terminal Adjudication)
    - RFC 002 (Content DNA Answer-Time Provenance)
    - RFC 003 (Governed Memory and Retrieval Results)
    - RFC 004 (Composable Governance Constraints)
    - RFC 005 (Canonical Package Artifact Admission)
    - RFC 006 (Export-Safe Governance Receipts)
    - RFC 007 (Evidence-Grounded Claim Verification Findings)
    - RFC 008 (Governed Behavior Envelopes)
    - RFC 009 (Governed Visible Response Lifecycle)
- **Issue:** https://github.com/encero-systems/hees.ai/issues/14
- **RFC PR:** —
- **Written against:** Hees 0.0.1 / Incan 0.4.0
- **Shipped in:** —

## Summary

Hees should provide a permanent, terminal-first, local-first, provider-neutral and domain-neutral developer product named Hees Console for building, validating, running, and inspecting governed AI systems. Local workspaces and offline-capable workflows are the default, not a prohibition on remote provider adapters, hosted developer access, or other profile-declared execution environments. The Console should help developers turn source evidence into candidate governed-memory material, create and validate governed packages through Hees contracts, run provider proposals and evaluator observations through Hees-owned policy and Spectrum decisions, and inspect selected memory, Content DNA, receipts, replays, and audit evidence without transferring authority to a model or presentation host. A separately specified initial implementation profile may demonstrate a deliberately bounded subset, but its event, fixture, provider, and packaging constraints do not define the permanent product.

## Core model

1. **Hees Console is a permanent developer product.** It is the public terminal-first, local-first environment for understanding and exercising Hees contracts, not a disposable demonstration shell. A profile may use remote adapters or expose the Console through a hosted terminal without making remote infrastructure authoritative.
2. **The product is provider-neutral and domain-neutral.** Provider adapters and governed packages vary independently; no permanent Console capability requires one provider, transport, deployment topology, or fixture domain.
3. **Local package work belongs in the public product.** Developers may load lawful source evidence, inspect derived atom candidates, author package declarations, and validate governed packages through Hees without using a separate operations platform. Local-first describes workspace ownership and safe defaults, not an exclusive execution topology.
4. **Models propose and observe; Hees decides.** A model may propose content, candidate atoms, or bounded evaluator observations. Only Hees may admit package state, classify observations under admitted policy, select a terminal Spectrum result and memory, construct Content DNA, and project authority-bearing receipts.
5. **Training by Committee is governed pressure testing.** Multiple provider-neutral evaluator roles may help developers compare candidates and improve package material, prompts, or policies, but their observations remain non-authoritative and do not imply model-weight training or truth.
6. **Content DNA is terminal output, never caller-authored input.** The Console may inspect package-owned provenance facts and the terminal derivation, but only Hees constructs Content DNA from the governed outcome and every and only selected memory.
7. **Profiles make partial implementations honest.** A Console profile names an exact supported capability set, contracts, bounds, and failure behavior. A bounded profile cannot imply that the permanent product or every related Draft RFC is implemented.
8. **Replay and audit rerun governance.** Stored scenarios contain bounded inputs and integrity metadata, not reusable decisions or fabricated authority. Replaying a scenario invokes the real Hees path again.
9. **The public Console is not an orchestration or operations control plane.** Local package creation, inspection, testing, and audit belong here; multi-tenant operations, organization workflows, fleet deployment, private catalogs, and managed production control remain separate products or integrations.
10. **Implementation truth remains explicit.** Released Console profiles and the public Hees API, not north-star prose or screenshots, determine what exists.

## Motivation

Hees 0.0.1 proves a deliberately small runtime boundary: a caller supplies an in-memory package and an untrusted proposal, and Hees checks package validity, identity, visible output, declared action, and evidence references. That kernel is useful but does not yet give a developer a coherent place to assemble governed material, exercise provider-neutral flows, inspect decisions, or understand why an interaction was admitted or rejected.

A developer console can make the complete authority graph tangible. A developer should be able to load evidence, inspect candidate atoms, establish review and rights declarations, create a governed package, run an interaction, examine evaluator observations and Hees findings, follow Spectrum's terminal selection, and inspect the resulting selected memory, Content DNA, and receipt. Those activities are not merely event-demo presentation. They are the enduring developer workflow around the Hees runtime.

The Console also needs a clear boundary from production orchestration. Public local authoring and inspection should not require a private control plane, while the public repository should not absorb organization-specific approval routing, managed deployments, private package catalogs, customer operations, or fleet administration. The dividing line is product responsibility, not whether a screen edits a package.

The first implementation can still be smaller than this north star. A bounded implementation profile can prove a self-contained executable, visible provider-versus-Hees separation, strict replay, and one end-to-end governed interaction. Treating its release constraints as the product definition, however, would permanently confuse one delivery slice with the purpose of Hees Console.

## Goals

- Define Hees Console as a durable public developer product around Hees contracts.
- Define provider-neutral adapter and domain-neutral package boundaries.
- Support terminal-first evidence intake, candidate-memory inspection, package authoring, package validation, governed interaction, terminal inspection, replay, and audit with local workspace defaults as permanent product capabilities.
- Make Training by Committee visible without granting evaluator outputs authority or implying model-weight training.
- Keep package review, rights, authority, and policy facts package-owned and Hees-validated rather than model-authored.
- Keep Content DNA construction inside Hees while making its source-safe derivation and terminal artifact inspectable.
- Make proposals, observations, findings, Spectrum decisions, selected memory, Content DNA, and receipts distinct inspectable surfaces.
- Define profile negotiation and exact non-claims so partial implementations remain truthful.
- Define a public/commercial boundary that permits useful local-first developer workflows without duplicating an orchestration or operations product.
- Define a subordinate initial implementation profile with exact inputs, cryptographic bindings, reasons, replay behavior, packaging, and acceptance evidence.
- Require self-contained offline-capable release artifacts for profiles that claim them without imposing offline operation on every future provider adapter.
- Preserve RFC lifecycle truth relative to RFC 000–009 and the checked Hees 0.0.1 public API.

## Non-Goals

- Making the permanent Console dependent on one provider API, model family, fixture, or lesson domain.
- Treating the initial implementation profile as the complete permanent product contract.
- Allowing a provider, host, replay, fixture, package, or caller to author terminal decisions, selected memory, Content DNA, or authority-bearing receipts.
- Treating candidate atoms as reviewed memory before package-owned review, rights, provenance, and validation succeed.
- Proving unrestricted truth, source ownership, legal rights, evaluator calibration, producer authenticity, or remote attestation.
- Training or fine-tuning model weights inside the Console merely because the product exposes Training by Committee workflows.
- Building a multi-tenant orchestration service, organization approval system, private package catalog, deployment control plane, fleet manager, billing system, or managed production operations product.
- Making every source connector, extraction engine, package topology, provider SDK, model runtime, or deployment target part of this RFC.
- Claiming that the initial profile implements the complete Draft Spectrum, Content DNA, governed-memory, constraint, package-artifact, receipt, verifier, behavior, or response-lifecycle contracts.
- Shipping private content, client packages, unpublished research, credentials, downloaded model artifacts, local paths, or unrelated product code in public fixtures or releases.
- Requiring a network, provider credential, or live model call for a profile that advertises offline operation.
- Silently changing the Hees library version when releasing a separately versioned Console profile.

## Guide-level explanation

### Permanent developer workflow

A developer starts the terminal-first Hees Console with a local workspace by default. A profile may attach remote provider adapters or expose the same governed workflow through a restricted hosted terminal, but workspace persistence and transmission remain explicit. The developer adds one or more source-evidence records, inspects the exact bytes and source-safe identity that will be governed, and asks a selected adapter to suggest bounded atom candidates. Candidate text is visibly untrusted. The developer may compare it with source evidence, edit package-authored material, establish review and rights declarations, choose authority and evidence classifications, and ask Hees to validate the resulting package.

The Console shows package validation as a Hees result rather than silently repairing invalid input. Unknown fields, invalid source bindings, missing review state, denied rights, conflicting identifiers, or failed canonical identities remain explicit. The developer may iterate on package material, but neither a model suggestion nor the UI itself can declare a package admitted without the applicable Hees contract.

For Training by Committee, the developer selects provider adapters and evaluator roles that inspect exact candidate-to-evidence or proposal-to-memory relationships. The Console displays bounded observations separately from Hees-derived findings and package policy. Developers can use those results to pressure-test atom quality, prompts, response candidates, or policy thresholds. The committee does not vote a terminal decision into existence, and a score does not become a truth claim.

During a governed interaction, one adapter returns an untrusted proposal and one or more adapters may return bounded observations over Hees-derived targets. Hees validates the package, request, proposal, support mappings, target identities, and observation coverage; applies package-owned policy; invokes Spectrum; freezes terminal selected memory; and, for an admitted answer, constructs Content DNA. The Console renders the proposal, observations, findings, policy effects, terminal decision, selected memory, Content DNA, and receipt as separate inspectable layers.

Developers may save local scenarios for replay and audit. A replay stores the governed inputs that its profile permits and integrity metadata, then reruns Hees. The Console may compare two runs or adapters, but a replayed decision is never accepted as a live capability. Real questions, evidence, and provider outputs remain local by default and require explicit export.

## Reference-level explanation

### Product identity, profiles, and evolution

The public product name is `Hees Console`, and the installed launch command is `hees-console`. The Console has its own semantic version independent from the Hees library. Product versions identify the application; profile identifiers identify exact governed behavior and supported contract surfaces.

Every run must name one exact Console profile. A profile manifest must declare its identifier, supported package and request contracts, provider-input contracts, terminal variants, reason namespace, bounds, available authoring and inspection capabilities, persistence behavior, and required Hees contract versions. Missing, unknown, or incompatible profile requirements fail closed. A UI must not expose a control whose authority-bearing contract the active profile cannot execute.

Console releases may add profiles for general package authoring, additional remote or local provider adapters, richer committee workflows, complete RFC 001–009 contracts, more domains, or other platforms without redefining the product. A release must enumerate its profiles and cannot use the product version as a substitute for profile capability discovery.

### Evidence workspaces and candidate memory

The permanent Console must support a local evidence workspace whose source records are explicit, bounded, and attributable. The workspace may use profile-supported import adapters, but every source must resolve to exact bytes, a source-safe reference, a source kind, a fingerprint, language, and a rights declaration before it can contribute governed package material. Import convenience cannot weaken the owning package contract.

A provider adapter may propose candidate memory atoms or transformations. Candidate values remain visually and structurally distinct from canonical package atoms. The Console may show source spans, diffs, validation failures, and committee observations, but it must not let a model set trusted review state, rights state, authority class, evidence kind, provenance identity, or package admission.

Human or package-authoring processes own those declarations. Hees validates the resulting package according to the active profile and applicable RFC contracts. The Console may persist local drafts and validation records, but a draft is not admitted memory and cannot enter a governed interaction as if validation succeeded.

### Governed package creation and validation

Package creation and inspection are permanent public Console capabilities. A developer may author package identity, sources, atoms, actions, requirements, policies, and profile-supported members locally; inspect canonical bytes and digests; run positive and adversarial validation; and export a profile-supported package artifact.

The Console must invoke Hees contracts for authority-bearing validation. Presentation code may provide forms, editors, diffs, import adapters, and safe preflight checks, but it must not implement a parallel package-admission policy or silently normalize an invalid package into a different valid package. Every exported artifact must identify the profile and contract versions under which it was validated.

The permanent product may eventually adopt RFC 005 package admission directly. Until that contract is implemented, a profile must name its narrower package format and must not describe a profile-specific digest as an RFC 005 capability.

### Training by Committee

Training by Committee is the Console workflow for iteratively pressure-testing candidate atoms, governed packages, response proposals, and policy choices with multiple bounded evaluator roles. The workflow may compare providers, prompts, configurations, or candidate revisions and may help a developer decide what to edit or review next.

Committee outputs are observations. Hees derives exact evaluator targets, validates their identity and complete coverage, and applies package-owned classification rules to produce findings. Findings remain non-authoritative inputs to constraints and Spectrum. Neither a majority, provider reputation, score magnitude outside policy, host preference, nor call order may override structural validation or choose the terminal result.

The term `Training by Committee` does not imply that the Console changes model weights. Fine-tuning or model-training pipelines may consume separately authorized artifacts in another system, but they are outside this RFC and cannot turn historical committee output into runtime authority.

### Governed interactions and terminal inspection

For each interaction, the Console must preserve one visible proposal channel and keep support, observations, findings, traces, receipts, and explanation chrome from substituting for an answer. The active profile defines the proposal and observation contracts, while Hees owns validation, classification, constraint composition, Spectrum selection, selected-memory finality, Content DNA construction, and terminal receipt projection.

The Console must let a developer inspect, where the active profile supports them:

- the request and its integrity binding;
- the admitted package and memory context;
- the untrusted proposal and identifier-only support mappings;
- the Hees-derived verifier manifest;
- provider observations and their exact target identities;
- Hees-derived findings and package-owned policy effects;
- the Spectrum terminal decision and public reason;
- terminal selected and discarded memory;
- Content DNA and its source-safe entry derivation;
- the applicable governance receipt; and
- a separately labelled non-authoritative operator trace.

Content DNA is never editable terminal metadata. The Console may inspect the package-owned provenance fields from which Hees derives entries and may independently verify export-safe canonical identities, but the runtime artifact must come atomically from the governed terminal operation.

### Replay and audit

The permanent Console may retain local scenarios when the user explicitly chooses to do so. A scenario must name its profile, exact package identity, request binding, normalized provider inputs permitted by that profile, schema identities, and an integrity digest. It must not store an authority capability or allow a stored decision, Content DNA envelope, or receipt to bypass a new Hees run.

Audit views may compare requests, package revisions, proposal digests, target digests, observations, findings, decisions, and terminal artifacts across runs. Comparison establishes identity and behavioral differences, not objective truth or producer authenticity. Export is explicit, bounded, and redacted according to the active profile.

### Authority and process boundary

The permanent Console has these ownership domains:

| Surface | Owner | Permitted authority |
| --- | --- | --- |
| Local source and package drafts | Developer and profile-supported authoring adapters | Candidate material only until Hees validation succeeds. |
| Provider calls and normalized capture | Provider adapter | Untrusted candidates, proposals, and observations only. |
| Package, admitted memory, request, proposal, manifest, finding, policy, Spectrum, selected-memory, Content DNA, and receipt contracts | Hees runtime | Validation, classification, policy composition, and terminal authority. |
| Workspace, editors, diffs, terminal views, subprocess lifecycle, packaging, secret access, and local persistence | Console host | Presentation and platform behavior only. |
| Replay or audit store | Console workspace | Integrity-checked input and historical export only; never live authority. |
| Organization workflows, managed deployments, and fleet operations | External products or integrations | Outside the public Console contract. |

The host must not reconstruct opaque Hees capabilities from JSON, duplicate package or terminal policy, remove a failing reference, reclassify an observation, choose selected memory, construct Content DNA, or fabricate a receipt. A host-side schema or transport failure is a typed host failure and must not be displayed as a Hees decision.

### Provider adapter boundary

The permanent Console must define a provider-neutral adapter boundary around profile-owned normalized inputs and outputs. An adapter may call a remote API, local model, deterministic fixture, or another implementation, but the normalized value and exact profile contracts determine what Hees receives. Provider name, transport, prompt wording, and raw response formatting have no authority unless a profile explicitly binds a source-safe fingerprint for observation identity.

Adapters own authentication, transport, timeout, refusal, rate-limit, and raw-response handling. Secrets, authorization headers, hidden reasoning, and unrestricted provider diagnostics must not enter the Hees runner, governed package, receipt, replay, screenshot, or exported audit artifact. A profile may require provider fingerprints for reproducibility while still treating the output as untrusted.

### Public Console and operations-product boundary

The public Console includes local evidence intake, candidate-atom inspection, package editing, Hees validation, governed test runs, committee evaluation, replay, audit, and artifact inspection. Those capabilities are necessary for a developer to understand and use the public Hees contracts.

The public Console does not include multi-user approval routing, organization policy administration, customer tenancy, managed private catalogs, production deployment orchestration, fleet health, billing, usage governance, or hosted operations automation. Integrations may invoke the Console or Hees artifacts, but this RFC does not define a public substitute for those systems.

Public repository fixtures and documentation must remain original, fictional, and source-safe. The product may operate on a developer's local lawful material without publishing that material or making it part of the repository.

### Privacy, security, and publication boundary

Permanent workspaces may contain sensitive sources and questions. The Console must default to local workspace storage, least retention, explicit provider transmission, explicit export, source-safe display, and bounded redaction. A profile may use remote adapters or a restricted hosted terminal, but those environments receive only the exact profile-declared values needed for their task. Workspace secrets and private source paths never enter packages or governance artifacts unless a separate explicit public-safe reference is authored.

The Console UI may display a question because direct interaction requires it. Console-generated captures, logs, diagnostics, and exports redact question and source text by default; including that material requires an explicit user export action and the active profile's redaction checks. Public repository fixtures, generated screenshots, tests, and documentation use only original fictional content and contain no client package, personal data, unpublished research, downloaded model, credential, private locator, or unrelated product material.

The Console must never expose raw authorization values, hidden prompts, chain-of-thought, unrestricted provider rationale, secret-bearing subprocess arguments, environment dumps, or unrestricted shell access. Digests remain potentially correlatable and must be handled according to workspace policy even when their preimages are absent. Dependency, fixture, font, image, container-base, and build-tool licenses must be reviewed before release. Digests and build provenance establish covered identity and integrity, not producer authenticity, factual correctness, or legal rights.

### Bounds and resource behavior

Every profile must define exact ceilings for raw bytes, nesting, identifiers, source evidence, package members, candidate atoms, visible units, answer bytes, request text, evidence and memory references, requirements, verifier targets, premise content, observations, replay envelopes, runner exchange, selected memory, Content DNA, receipts, traces, rendering, and retained state.

Hees enforces raw byte ceilings before parsing and collection ceilings before proportional allocation. Count and byte arithmetic uses checked exact integers. The host may impose stricter platform limits but cannot raise Hees limits or truncate one input into a different valid value. The permanent product requires profile-specific measurements rather than one universal number.

### Acceptance evidence

Permanent Hees Console conformance requires public executable evidence that:

- a local-default workspace can create candidate memory without treating candidates as reviewed atoms;
- a developer can author and validate a governed package through Hees contracts and receive exact failures without host-side admission;
- local and remote provider adapters can produce equivalent normalized proposals and observations without changing Hees authority;
- Training by Committee preserves observation, finding, policy, and terminal separation;
- governed interactions expose proposal, manifest, observations, findings, Spectrum decision, selected memory, Content DNA, receipt, and trace as distinct surfaces;
- Content DNA is constructed only by Hees from direct terminal state and every and only selected memory;
- replay reruns Hees and cannot reuse a decision or authority artifact;
- local retention, provider transmission, export, and redaction behavior match the active profile; and
- product documentation distinguishes current profile capability from the permanent north star and from external operations products.

## Initial implementation profile: Build Week 2026

This section specifies one subordinate release profile, not permanent Hees Console requirements. Build Week 2026 is the forcing function for a bounded first slice: one fixed fictional package, one optional initial provider adapter, deterministic offline replay, a self-contained terminal executable, and one end-to-end governed interaction. Every event, provider, fixture, packaging, hosting, schedule, and submission detail below applies only to this section's profile.

The first public implementation is labelled `BUILD WEEK 2026 IMPLEMENTATION PROFILE — console_profile_0_1`. It demonstrates one original response candidate, relation and synthesis observations, Hees-owned classification, a bounded Spectrum decision, terminal selected memory, experimental Content DNA, and a profile-specific receipt.

That profile does not provide the permanent evidence-workspace or general package-authoring experience. It loads a fixed package so the first end-to-end authority path can be packaged, tested, hosted, and judged under the event schedule. With no credential, it runs five shipped replay scenarios through the compiled Incan-authored Hees profile: one admitted interaction plus undeclared-action, unknown-evidence, unknown-memory, and non-admitted-memory rejections. With explicit live configuration, its GPT-5.6 adapter supplies the same strict proposal and observation contracts. The UI labels mode and profile at all times. Provider refusal, timeout, malformed output, target mismatch, or incomplete coverage fails closed and never silently becomes replay while still labelled live.

### Profile identity and scope

`console_profile_0_1` is the Build Week 2026 implementation profile. Its release contract family uses these exact identifiers:

| Surface | Contract identifier |
| --- | --- |
| Fictional package | `console_package_0_1` |
| Optional atom comparison candidate | `console_atom_candidate_0_1` |
| Optional atom comparison result | `console_atom_comparison_0_1` |
| Model proposal | `console_proposal_0_1` |
| Relation observation | `console_relation_observation_0_1` |
| Synthesis observation | `console_synthesis_observation_0_1` |
| Hees-classified finding | `console_finding_0_1` |
| Runner request | `console_runner_request_0_1` |
| Runner response | `console_runner_response_0_1` |
| Replay envelope | `console_replay_0_1` |
| Non-authoritative execution trace | `console_trace_0_1` |
| Experimental Console Content DNA | `console_content_dna_0_1` |
| Profile-specific Console receipt | `console_profile_receipt_0_1` |
| Terminal reason namespace | `console_admission_0_1` |

The profile supports one prebuilt fictional lesson-support package, one original answer candidate, exactly one support mapping per visible unit, relation and synthesis observations, Hees-owned score classification, `admit` or `reject`, terminal selected memory, admitted-answer Content DNA, and a profile-specific receipt. It does not support general evidence import, package editing, model repair, package-authored clarification, behavior-envelope selection, the seven RFC 009 terminal variants, or complete RFC 001–009 conformance.

The Build Week engineering freeze and submission schedule control what this profile can ship; they must not weaken validation, alter public reasons, create a demo-only authority path, or become permanent product requirements.

### Fictional package

The profile operates only over a small original fictional lesson-support fixture. The package under `console_package_0_1` must contain exactly `contract_version`, `profile_id`, `package_id`, `domain_id`, `package_revision`, `artifact_digest`, `mission`, `sources`, `actions`, `requirements`, `atoms`, and `policy`. `contract_version` must equal `console_package_0_1`, and `profile_id` must equal `console_profile_0_1`.

`artifact_digest` must be `sha256:` followed by the lowercase SHA-256 digest of the RFC 8785 JCS artifact projection that removes the top-level `artifact_digest` and every atom's derived `provenance_digest` while preserving every other field and array order. The mission is a bounded non-empty package-authored string.

Each source must contain exactly `source_id`, `source_ref`, `source_kind`, `source_fingerprint`, `language`, `rights_state`, and `text`. `source_fingerprint` is the lowercase `sha256:` digest of the exact UTF-8 bytes of `text`, and source `rights_state` must equal `fictional_use_allowed`. Each action contains exactly `action_id` and `evidence_required`. Each requirement contains exactly `requirement_id` and `description`. Source, action, requirement, memory, and evidence identifiers are safe, ordered, and unique within their typed namespaces.

Each atom must contain exactly `memory_id`, `evidence_id`, `source_id`, `source_ref`, `source_kind`, `source_fingerprint`, `source_span`, `claim`, `guidance`, `language`, `review_state`, `review_revision`, `rights_state`, `authority_class`, `evidence_kind`, and `provenance_digest`. `source_span` contains exactly `start_utf8_byte` and `end_utf8_byte`, selects a non-empty UTF-8-aligned range in the bound source text, and binds the claim to that range. Source identity, fingerprint, and language must match the containing source. Review state is `approved`, `pending`, or `rejected`; rights state is `allowed` or `denied`. Only an atom with approved review, allowed rights, valid source binding, and valid provenance enters admitted memory.

An atom `provenance_digest` is the lowercase `sha256:` digest of the RFC 8785 JCS object containing `package`, whose exact members are `package_id`, `domain_id`, `package_revision`, and `artifact_digest`, plus `entry`, whose exact members are `memory_id`, `source_ref`, `source_kind`, `source_fingerprint`, `review_state`, `review_revision`, `rights_state`, `authority_class`, and `evidence_kind`. The artifact digest is computed first from the projection that omits derived provenance; atom provenance is computed second and inserted without changing artifact identity.

The fixture includes canonical reviewed, rights-allowed atoms and at least one pending, rejected, or rights-denied record for adversarial tests. A provider cannot add, remove, review, license, or admit package memory.

An optional `console_atom_candidate_0_1` contains exactly `contract_version`, `profile_id`, `package_id`, `domain_id`, `source_ref`, `source_fingerprint`, `claim`, `guidance`, `language`, and `candidate_digest`. It contains no trusted identifiers, review, rights, authority, provenance, admission, terminal, Content DNA, receipt, or hidden-reasoning field. `candidate_digest` is the lowercase `sha256:` digest of the RFC 8785 JCS candidate after removing only `candidate_digest`.

An optional Hees `console_atom_comparison_0_1` result contains exactly `contract_version`, `profile_id`, `package_id`, `domain_id`, `candidate_digest`, `matched_memory_id`, `comparison_state`, and `package_effect`. Comparison state is `exact_match` or `mismatch`, and package effect is always `none`. Hees derives `matched_memory_id`; the host or provider cannot nominate it. Candidate absence, failure, or mismatch never changes the terminal path.

The optional candidate and comparison intentionally omit package revision and artifact identity because they are non-terminal, display-only comparisons with `package_effect` fixed to `none`. Hees recomputes a comparison against the currently loaded package; a comparison result cannot be submitted in the runner request, retained as package admission, or reused to affect another revision.

### Request binding and proposal

Every interaction contains one closed request binding with exactly `request_id`, `question`, and `request_digest`. `request_id` is a safe bounded identifier. `question` is a bounded string containing at least one non-whitespace Unicode scalar value and is preserved exactly without Unicode, case, newline, or whitespace normalization. `request_digest` is `sha256:` followed by the lowercase SHA-256 digest of the exact RFC 8785 JCS object containing only `request_id` and `question` in that logical object.

The question is direct interaction content, not public governance metadata. The terminal UI displays it only in the direct interaction surface. It must not appear in Content DNA, an observation, finding, non-authoritative trace, automatic log, Console-generated capture, or default audit export. A user may explicitly export a profile-validated redacted scenario that includes question text. Shipped replay requests and all shipped screenshots use only original fictional content.

An untrusted `console_proposal_0_1` contains exactly `contract_version`, `profile_id`, `package_id`, `domain_id`, `package_revision`, `artifact_digest`, `request_id`, `request_digest`, `proposal_id`, `action_id`, `evidence_ids`, `visible_units`, and `support_mappings`. Every package and request identity must equal the trusted runner input and admitted package before proposal semantics are evaluated.

Each visible unit contains exactly `unit_id`, `text`, and `requirement_ids`. Units are non-empty, bounded, uniquely identified, and ordered; their exact texts are the sole model-generated answer channel. Each support mapping contains exactly `support_claim_id`, `unit_id`, one `memory_id`, and optional typed `evidence_ids`. The profile requires exactly one mapping per visible unit. Evidence and memory identifiers are distinct typed namespaces and cannot substitute for each other. Hees derives support-claim text as the exact visible-unit text.

The adapter to Hees 0.0.1 derives `ModelProposal.visible_output` by joining exact visible-unit texts with one line-feed scalar and copies top-level evidence identifiers unchanged. Hees computes `candidate_digest` as the lowercase `sha256:` digest of the exact RFC 8785 JCS normalized proposal object. Because the proposal includes `request_digest`, candidate identity is bound to the exact request. A provider cannot supply or override `candidate_digest`.

### Verifier manifest and cryptographic target binding

After validating the package, request binding, proposal, and support mappings, Hees derives the complete expected verifier manifest. The profile requires:

- one evidence-relation target for each visible unit against the complete ordered admitted-memory union;
- one evidence-relation target for each derived support claim against its exact cited memory;
- one contradiction-cross-check target for the complete ordered visible response against the complete ordered admitted-memory union;
- one synthesis target for the complete ordered visible response against the exact request; and
- one synthesis target for the complete ordered visible response against each exact package requirement.

Each manifest target has one closed target body containing exactly `profile_id`, `package_id`, `domain_id`, `package_revision`, `artifact_digest`, `request_digest`, `candidate_digest`, `target_id`, `evaluator_role`, `target_role`, `subject_digest`, and `premises`. `premises` is an ordered array whose entries contain exactly `memory_id` and `content_digest`. `target_digest` is `sha256:` followed by the lowercase SHA-256 digest of the exact RFC 8785 JCS target body.

Hees computes `subject_digest` as `sha256:` followed by the lowercase SHA-256 digest of one exact target-role-specific RFC 8785 JCS projection:

- `visible_unit_union`: `subject_kind` equal to `visible_unit` plus the exact `unit` object containing `unit_id`, `text`, and ordered `requirement_ids`;
- `support_claim_memory`: `subject_kind` equal to `support_claim` plus `support_claim_id`, `unit_id`, and the exact derived `text`;
- `proposal_union`: `subject_kind` equal to `visible_response` plus the exact ordered `visible_units` array;
- `request_coverage`: `subject_kind` equal to `request_synthesis` plus the exact ordered `visible_units` array and `request_digest`; or
- `requirement_coverage`: `subject_kind` equal to `requirement_synthesis` plus the exact ordered `visible_units` array and one exact package `requirement` object containing `requirement_id` and `description`.

Every evaluator-visible memory premise uses the exact projection containing `memory_id`, `claim`, `guidance`, `language`, `source_ref`, `source_kind`, `source_fingerprint`, `review_state`, `review_revision`, `rights_state`, `authority_class`, and `evidence_kind`. Its `content_digest` is the lowercase `sha256:` digest of that exact RFC 8785 JCS projection. The `visible_unit_union` and `proposal_union` targets use the complete admitted-memory order; a `support_claim_memory` target uses exactly its one cited memory; synthesis targets use an empty memory-premise array because their exact request or requirement criterion is bound in `request_digest` or `subject_digest`.

The adapter sends the exact subject projection, exact premise projections, request binding where required, and Hees-derived target identity to the evaluator. Provider output echoes only the bound digests and bounded scores. Hees independently rederives every projection and digest. A host cannot make different question, subject, requirement, premise content, premise membership, or premise order authoritative by copying an expected digest into a provider call.

### Observations, findings, and policy

A relation observation under `console_relation_observation_0_1` contains exactly `contract_version`, `profile_id`, `observation_id`, `package_id`, `domain_id`, `package_revision`, `artifact_digest`, `request_id`, `request_digest`, `candidate_digest`, `target_id`, `target_digest`, `evaluator_role`, `target_role`, `support_bps`, `contradiction_bps`, `unresolved_bps`, `model_fingerprint`, `prompt_fingerprint`, and `configuration_fingerprint`. Evaluator role is `evidence_relation` or `contradiction_cross_check`; target role is `visible_unit_union`, `support_claim_memory`, or `proposal_union`.

A synthesis observation under `console_synthesis_observation_0_1` has the same identity, digest, and fingerprint fields, evaluator role `synthesis_coverage`, target role `request_coverage` or `requirement_coverage`, and `covered_bps`, `gap_bps`, and `unresolved_bps`. Each score triple contains exact integers from zero through ten thousand and sums to exactly ten thousand.

Observations contain no question, subject text, premise text, answer substitute, policy, status, terminal action, selected memory, Content DNA, receipt data, raw response metadata, rationale, or hidden reasoning. Matching digests establish normalized target identity, not that an evaluator is correct or authentic.

The fictional package policy contains exactly `constraint_plan_id`, `constraint_plan_revision`, `response_contract_id`, `response_contract_revision`, `min_support_bps`, `max_contradiction_bps`, `max_relation_unresolved_bps`, `min_coverage_bps`, `max_gap_bps`, and `max_synthesis_unresolved_bps`. Numeric thresholds are respectively 6500, 3500, 2500, 6500, 3500, and 2500 basis points.

Hees classifies relation observations in this precedence: `contradicted` when contradiction exceeds its maximum; `uncertain` when unresolved exceeds its maximum; `supported` when support meets its minimum; otherwise `unsupported`. Hees classifies synthesis observations in this precedence: `not_covered` when gap exceeds its maximum; `uncertain` when unresolved exceeds its maximum; `covered` when coverage meets its minimum; otherwise `not_covered`.

Each Hees `console_finding_0_1` contains exactly `contract_version`, `profile_id`, `finding_id`, `observation_id`, `package_id`, `domain_id`, `package_revision`, `artifact_digest`, `request_id`, `request_digest`, `candidate_digest`, `target_id`, `target_digest`, `evaluator_role`, `target_role`, `classification`, `constraint_plan_id`, and `constraint_plan_revision`. A finding repeats no question, subject, premise, or answer text. It remains non-authoritative; the bounded Spectrum operation consumes the complete finding set and package policy.

Missing, duplicate, unexpected, malformed, identity-mismatched, digest-mismatched, refused, timed-out, or unavailable required observations fail closed. Identity mismatch includes any difference in package identifier, domain identifier, package revision, artifact digest, request identifier, request digest, candidate digest, target digest, evaluator role, target role, or target identifier. Coverage is exact set-and-order coverage of the Hees-derived manifest; the host may not add, remove, reorder, or reinterpret targets.

### Runner and terminal reasons

The host submits one closed `console_runner_request_0_1` containing the exact profile identifier, mode, package artifact, request binding, normalized proposal, complete relation and synthesis observations, replay identity when applicable, and build and schema identities required for compatibility checks. Optional atom-comparison material is not part of the terminal request. The request contains raw serializable inputs only and cannot contain or stand in for a direct admitted-memory, finding, Spectrum, selected-memory, Content DNA, or receipt capability.

Inside one invocation, Hees validates the package identifier, domain identifier, package revision, and artifact digest against the admitted package before proposal semantics; validates the request digest and proposal request identity; creates admitted memory; derives the manifest and target digests; validates observation identity and coverage; classifies observations; composes findings; invokes the bounded Spectrum operation; freezes selected memory; constructs experimental Content DNA; and projects the profile-specific receipt. Direct capabilities never cross the runner protocol.

`console_runner_response_0_1` contains the exact profile, safely established identities, `decision` equal to `admit` or `reject`, reason namespace `console_admission_0_1`, one closed reason, the checked Hees 0.0.1 structural reason when reached, and admitted visible units, selected memory, Content DNA, and receipt only where the terminal state permits them. A rejected response never exposes model prose as trusted output.

Public failure precedence is:

| Stage | Closed reasons in precedence order |
| --- | --- |
| 1. Raw runner request | `request_too_large`, `invalid_json` |
| 2. Runner and replay contract | `unsupported_request_contract`, `invalid_request_schema`, `replay_integrity_mismatch` |
| 3. Package and admitted memory | `package_unavailable`, `invalid_package`, `memory_context_invalid` |
| 4. Package revision and request identity | `package_id_mismatch`, `domain_id_mismatch`, `package_revision_mismatch`, `artifact_digest_mismatch`, `request_id_invalid`, `request_digest_mismatch` |
| 5. Proposal provider and contract | `proposal_provider_unavailable`, `unsupported_proposal_contract`, `invalid_proposal_schema`, `proposal_too_large`, `proposal_request_mismatch` |
| 6. Visible units | `missing_visible_output`, `invalid_visible_unit` |
| 7. Declared action | `unknown_action` |
| 8. Evidence, support, and memory | `duplicate_evidence_reference`, `evidence_required`, `unknown_evidence`, `support_mapping_invalid`, `duplicate_memory_reference`, `unknown_memory`, `memory_not_admitted` |
| 9. Manifest and observations | `manifest_construction_failed`, `unsupported_observation_contract`, `observation_identity_mismatch`, `observation_coverage_invalid`, `observation_malformed`, `observation_unavailable` |
| 10. Package finding policy | `support_not_established`, `contradiction_detected`, `synthesis_incomplete`, `finding_uncertain` |
| 11. Checked structural admission | `structural_admission_rejected` |
| 12. Terminal memory | `selected_memory_invalid` |
| 13. Experimental Content DNA | `content_dna_construction_failed` |
| 14. Profile receipt | `receipt_projection_failed` |
| 15. Admission | `admitted` |

Provider wording, model identity, map order, process timing, terminal size, and rendering cannot select the public reason. The checked Hees structural admission remains mandatory for every otherwise eligible proposal.

### Content DNA, receipt, and trace

On `admit`, Hees freezes an ordered duplicate-free selected-memory set containing every and only admitted memory referenced by admitted support mappings. Experimental `console_content_dna_0_1` is constructed afterward from direct terminal state.

Its closed body contains exactly `contract_version`, `state` equal to `admitted_answer`, `package`, `proposal_id`, `spectrum_decision_id`, `terminal`, `policy`, `entries`, `source_digests`, and `answer_digest`. Package contains exactly package and domain identifiers, package revision, and artifact digest. Policy contains exactly constraint-plan and response-contract identifiers and revisions. Terminal contains exactly decision, reason namespace, and reason.

Each ordered entry contains exactly `memory_id`, `source_ref`, `source_kind`, `source_fingerprint`, `provenance_digest`, `review_state`, `review_revision`, `rights_state`, `authority_class`, and `evidence_kind`. Entries cover every and only selected memory. Source digests are the ordered duplicate-free first-use projection. Answer digest binds the exact ordered visible units. The envelope contains exactly `body` and `content_dna_id`, whose identifier is the lowercase `sha256:` digest of the canonical body.

This experimental artifact exercises the RFC 002 admitted-answer field shape but is not complete RFC 002 conformance because the profile lacks the complete upstream RFC 001, RFC 005, and RFC 009 source contracts and no no-answer state is implemented.

The runner may construct `console_profile_receipt_0_1` only after package, request, and proposal identity are safely established. Its envelope contains exactly `body` and `receipt_id`, where `receipt_id` is `sha256:` followed by the lowercase SHA-256 digest of the exact RFC 8785 JCS body. The body contains exactly `contract_version`, `profile_id`, `package_id`, `domain_id`, `package_revision`, `artifact_digest`, `request_id`, `request_digest`, `proposal_id`, `candidate_digest`, `decision`, `reason_namespace`, `reason`, and `structural_reason`; admitted outcomes additionally contain `admitted_evidence_ids`, `selected_memory_ids`, and `content_dna_id`. Rejected outcomes omit those admitted-only members.

The profile receipt borrows RFC 006 redaction principles but is not RFC 006-compatible. It includes `request_digest` but no question text because a caller-chosen `request_id` alone cannot bind the governed request to its exact question. That digest improves identity binding while remaining correlatable across receipts, so receipt display, persistence, and export follow the workspace's explicit redaction policy. The receipt contains no source or answer text, provider or model field, build identity, replay metadata, observation or finding detail, policy trace, prompt, credential, hidden reasoning, local path, timestamp, or arbitrary diagnostic.

`console_trace_0_1` is a separate non-authoritative operator artifact for bounded build, toolchain, runner, schema, mode, replay, provider, model, prompt, configuration, proposal, observation, finding, and policy-effect identities. It contains no question, request digest, answer or source prose, credentials, raw provider payload, unrestricted rationale, or hidden reasoning. Trace construction failure cannot change a terminal result or receipt.

### Replay and GPT-5.6 adapter

The default `console_replay_0_1` envelope contains exactly its contract and profile identifiers, fictional scenario identity, the normalized request binding, deterministic normalized proposal, deterministic normalized relation and synthesis observations, schema digests, and one envelope digest. It contains no atom candidate, Hees decision, finding classification, selected memory, Content DNA, receipt, credential, raw header, hidden prompt, or hidden reasoning.

Including the request binding makes replay self-contained and lets Hees rederive request and requirement synthesis targets. The replay digest covers the exact package revision and artifact identity carried by the proposal and observations, request, proposal, observations, schema identities, and array order. Mutating package revision, artifact digest, question text, request digest, visible units, requirements, premise content, premise order, target digest, or observations invalidates integrity or fails the corresponding runner identity check.

Replay values are neutral deterministic fixtures and use profile-reserved fixture fingerprints. They are described as recorded provider output only if a separate live canary cryptographically binds the exact envelope to retained execution evidence. An optional atom-comparison fixture remains a separate display-only UI input and cannot affect replay admission.

The initial live adapter uses the OpenAI Responses API with explicit `gpt-5.6-sol`, strict JSON Schema structured output, bounded reasoning effort, bounded output tokens, timeouts, and no tools. The adapter produces a proposal plus relation and synthesis observations; the profile reserves a separate optional display-only atom-candidate operation without requiring or invoking it for a governed interaction. The only credential surface is `OPENAI_API_KEY` or equivalent hosted secret injection. Provider failure never silently substitutes replay while the mode remains live.

GPT-5.6 is the initial adapter, not a permanent Console dependency or authority. A later adapter that produces the same normalized profile values receives the same Hees processing and terminal result.

### Interaction, packaging, and submission boundary

The initial UI must show the fixed package and sources, optional atom comparison, untrusted proposal, distinct evidence and memory support, manifest target identities, provider observations, Hees findings, `BUILD WEEK 2026 IMPLEMENTATION PROFILE — console_profile_0_1`, terminal reason, selected memory, experimental Content DNA, profile receipt, trace, and replay integrity.

Keyboard actions select and rerun the valid, undeclared-action, unknown-evidence, unknown-memory, and non-admitted-memory scenarios; move through the package, source, optional atom-comparison, proposal, support, manifest, observation, finding, Spectrum, selected-memory, Content DNA, receipt, and trace inspectors; and quit. Colour cannot carry meaning alone. All source, question, model, provider, fixture, and error text is escaped before terminal rendering. Rejected prose appears only inside an untrusted inspection view.

The release publishes a self-contained prebuilt executable that defaults to offline replay and requires no Incan compiler, external language runtime, package manager, source checkout, network, or API key. At least one Linux artifact must be built and smoke-tested; a macOS artifact is claimed only when verified under the same frozen profile. A hosted terminal invokes the same executable without exposing a shell, unrelated files, persistent cross-session data, or credentials.

Build Week video, submission, deadline, and hosted-judge requirements are release obligations for this profile. They do not belong to the permanent provider, domain, package-authoring, or authority contract.

### Profile privacy, security, and publication boundary

The profile inherits the permanent Console's privacy and security rules. Its provider adapters receive only the exact profile-declared values required for their task. Questions, subject text, and premise content are absent from observations, findings, Content DNA, and traces as defined above; the redacted receipt carries only `request_digest` for request identity. All shipped sources, fixtures, schemas, replays, generated screenshots, tests, documentation, video, and submission material use only original fictional content.

### Profile bounds and resource behavior

This profile must enforce exact ceilings for maximum fictional fixtures, request and target bindings, canonicalization, subprocess exchange, terminal rendering, and resident state, and it must publish clean measurements for every claimed platform. A release without either enforced ceilings or the corresponding supported-platform measurements is non-conformant.

### Profile acceptance evidence

The Build Week 2026 profile requires:

- positive fixtures proving one admitted interaction reaches real Hees structural admission and atomically returns selected memory, experimental Content DNA, and a profile receipt;
- adversarial fixtures for invalid package, stale package revision, artifact-digest mismatch, request-digest mismatch, proposal-request mismatch, undeclared action, evidence and memory failures, missing observations, target-digest mismatch, premise-content and order mutation, unsupported content, contradiction, incomplete synthesis, provider failure, and tampered replay with exact reasons;
- manifest fixtures proving independent package revision, artifact, request, candidate, subject, requirement, premise-content, premise-order, target, observation, and finding digest agreement;
- authority-negative fixtures proving a model, evaluator, host, replay, copied response, copied Content DNA, or copied receipt cannot create or override a terminal decision;
- offline artifact tests proving all shipped scenarios run without a compiler, external language runtime, package manager, checkout, network, or credential;
- one secret-gated GPT-5.6 canary proving exact structured outputs reach the same runner without provider authority;
- escaping, privacy, hosted-session, license, build-provenance, and publication-boundary checks; and
- documentation and submission materials that label the implementation profile and do not present its fixed package or adapter as permanent requirements.

### Relationship to permanent RFC contracts

This profile is deliberately narrower than the Draft RFC contract family:

| RFC | Profile relationship and explicit non-claim |
| --- | --- |
| RFC 000 | Uses Hees's authority boundary without introducing another terminal authority. |
| RFC 001 | Implements one bounded Spectrum-shaped operation with `admit` or `reject`; it cannot reconstruct complete RFC 001 capabilities from JSON. |
| RFC 002 | Exercises the admitted-answer field shape; it does not claim the complete upstream capability or no-answer state. |
| RFC 003 | Uses one fixed admitted-memory context rather than general retrieval. |
| RFC 004 | Uses one fixed score-classification and terminal mapping rather than the complete plan, dependency, substitution, conflict, and escalation model. |
| RFC 005 | Uses a profile-specific JCS package identity and does not claim RFC 005 admission or reload capability. |
| RFC 006 | Emits a narrower redacted profile receipt that is not RFC 006-compatible. |
| RFC 007 | Adds explicit request, subject, premise-content, and target digests without implementing the complete package member, calibration, capability, or projection contracts. |
| RFC 008 | Permits one declared action and has no multi-candidate behavior selection or opaque selected-behavior capability. |
| RFC 009 | Uses one original candidate, one mapping per visible unit, and only `admit` or `reject`. |

### Profile cost

Shipping `console_profile_0_1` before every permanent capability is permitted only if its executable, UI, documentation, and release materials consistently label the profile and its non-claims.

The profile remains complex despite being bounded. Cryptographic request and target binding, a compiled runner, strict replay, a full-screen terminal, self-contained packaging, hosted isolation, and a live adapter all add work beyond the small Hees kernel. Those costs are justified only if the profile remains truthful and reusable as the first product slice.

## Design details

### Relationship to RFC 000

RFC 000 owns Hees's permanent authority model. Hees Console exposes that model across package creation, committee evaluation, governed interaction, and terminal inspection without introducing another terminal authority.

### Relationship to RFC 001

The permanent Console should inspect complete Spectrum decisions and capabilities when RFC 001 is implemented.

### Relationship to RFC 002

The permanent Console treats Content DNA as Hees-owned terminal provenance and may inspect its source-safe derivation and public verification.

### Relationship to RFC 003

Evidence workspaces and candidate-atom inspection prepare package material; they do not bypass RFC 003 governed-memory admission.

### Relationship to RFC 004

Training by Committee may feed non-authoritative findings into package-owned constraints.

### Relationship to RFC 005

The permanent Console should author and validate canonical package artifacts when RFC 005 is available.

### Relationship to RFC 006

The permanent Console should inspect and verify RFC 006 receipts when their direct source contracts exist.

### Relationship to RFC 007

Training by Committee and interaction verification use RFC 007-shaped exact targets and non-authoritative observations.

### Relationship to RFC 008

The permanent Console may inspect behavior candidates and selected behavior when RFC 008 exists.

### Relationship to RFC 009

The permanent Console preserves RFC 009's singular visible-answer channel, identifier-only support, lifecycle, repair, and clarification boundaries when supported.

## Alternatives considered

### Define Console as an event demo

Rejected because an event-specific provider, package, deadline, and interaction would obscure the durable developer workflow and make future package authoring or provider adapters look like scope expansion rather than the product's purpose.

### Keep package creation outside the public Console

Rejected because developers need a public local path from evidence and candidate atoms to a validated governed package. Package creation is not inherently a managed operations function; organization workflows and production control remain separate.

### Make one provider the permanent product boundary

Rejected because Hees governs normalized proposals and observations, not provider brands. Provider-specific requirements belong to adapters and implementation profiles.

### Let the presentation host validate and decide

Rejected because schema shape does not confer package, policy, Spectrum, selected-memory, Content DNA, or receipt authority. The host coordinates and renders; Hees decides.

### Let committee scores directly choose admission

Rejected because evaluation is fallible and provider-controlled. Hees must validate exact targets, classify observations under package policy, and retain terminal authority.

### Let callers submit Content DNA

Rejected because copied provenance metadata could diverge from terminal selected memory. Hees constructs Content DNA atomically from direct terminal state; the Console only inspects it.

### Store complete replay outcomes

Rejected because replaying a stored answer or decision tests presentation rather than governance. Replays store bound inputs and rerun Hees.

### Wait for RFC 001–009 to be completely implemented

Rejected because exact implementation profiles can prove useful end-to-end boundaries without claiming complete contracts. The profile mechanism makes partial progress explicit and migratable.

### Require source rebuilds for every profile

Rejected for distributable profiles because a frozen prebuilt artifact is stronger release evidence and a better no-rebuild path for consumer verification. Development profiles may still support source execution when explicitly documented.

## Drawbacks

The permanent product contract is broader than the first implementation and therefore demands disciplined profile labelling, capability discovery, docs truth, and migration. Local evidence and package authoring introduce source parsing, workspace persistence, rights declarations, canonicalization, and usability risks that a fixed demonstration package avoids. Provider neutrality adds adapter contracts and cross-provider fixtures. Training by Committee adds target identity, calibration, cost, and privacy concerns even though it does not grant authority.

Separating the public local-first Console from an operations product also requires continuous boundary review. Too little public functionality would make Hees hard to adopt; too much organization-specific workflow would duplicate a different product. The exact line must be expressed through responsibilities and tested repository content rather than product naming alone.

## Layers affected

- **Public product contract:** Permanent Console purpose, profiles, capability discovery, local workflows, and evolution.
- **Evidence workspace:** Source identity, candidate-memory inspection, local drafts, retention, and explicit export.
- **Package authoring:** Package members, validation, canonical identity, review and rights declarations, and artifact export through Hees contracts.
- **Training by Committee:** Provider-neutral targets, observations, Hees findings, policy classification, and comparison views.
- **Hees runtime:** Package admission, request binding, proposal validation, manifest derivation, finding composition, Spectrum, selected memory, Content DNA, and receipts.
- **Provider adapters:** Strict normalized candidate, proposal, and observation contracts plus secrets, timeouts, and refusal handling.
- **Runner protocol:** Closed profile inputs and outputs, cryptographic bindings, reason precedence, and direct-capability isolation.
- **Replay and audit:** Local scenario persistence, integrity, rerun semantics, comparison, redaction, and export.
- **Presentation:** Trust-labelled editors, package and interaction inspection, terminal views, escaping, accessibility, and current-profile disclosure.
- **Distribution and hosting:** Self-contained artifacts, supported platforms, provenance, license evidence, isolation, and restricted hosted sessions.
- **Public/commercial boundary:** Public local-first developer workflows versus external organization and production operations.
- **Documentation and testing:** Current-versus-north-star truth, profile non-claims, cross-implementation goldens, adversarial fixtures, and publication safety.

## Design Decisions

- Hees Console is a permanent terminal-first, local-first, provider-neutral and domain-neutral developer product; local-first does not prohibit remote adapters or restricted hosted access.
- Local evidence intake, candidate-atom inspection, package authoring, and Hees validation belong in the public Console.
- The public Console does not absorb multi-tenant orchestration, organization workflows, managed deployment, or fleet operations.
- Models and evaluator providers emit untrusted candidates, proposals, and observations; Hees contracts retain admission and terminal authority.
- Training by Committee is a provider-neutral pressure-testing workflow, not automatic review, truth, or model-weight training.
- Content DNA is constructed only by Hees from direct terminal outcome and selected memory; the Console inspects rather than authors it.
- Exact profiles define implemented capability and non-claims beneath the permanent product contract.
- Replay stores bound inputs and reruns Hees; it never supplies a reusable decision.
- Every profile must cryptographically bind the exact governed identities it claims and publish its capability non-claims.
- Released profile manifests and the public Hees API are the source of implementation truth.

## Unresolved questions

- What exact profile manifest and capability-discovery contract lets the Console evolve from a bounded initial profile to general package authoring without ambiguous UI or silent compatibility changes?
- Which source-import and extraction adapters belong in the permanent public Console, and which remain external integrations, while still guaranteeing exact source bytes and source-safe identity?
- What is the first general package-authoring contract after a fixed-package profile, and how should draft, validated, admitted, and exported states be represented without pre-empting RFC 005?
- Which Training by Committee artifacts may be persisted or exported by default, and what calibration, cost, and privacy evidence is required before the workflow is considered stable?
- What exact cross-profile resource ceilings and workspace-retention defaults are safe on supported developer machines, and what stricter limits apply to self-contained or constrained-device releases?
- Which platforms must the first permanent-product release support, and under what reproducibility and license gates?

<!-- Rename this section to "Design Decisions" once all questions have been resolved. An RFC cannot move from Draft to Planned until no unresolved questions remain. -->
