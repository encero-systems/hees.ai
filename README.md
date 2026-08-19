# Hees.ai

Hees.ai is an Incan-first governed-intelligence runtime. It turns evidence, reviewed memory, declared authority, policy, and evaluator requirements into executable governance profiles, then produces inspectable terminal decisions with selected memory, Content DNA, and receipts.

The model proposes. Hees.ai decides.

## Hyperquant retrieval

Hyperquant is Hees.ai's first-party family of bounded vector-retrieval profiles. It nominates package-owned `MemoryId` values with deterministic ranks and relevance metadata; it does not return trusted text or establish review, rights, temporal validity, support, or final authority.

The initial `exact_cosine_0_1` profile is an exhaustive full-precision oracle and small-corpus fallback. It validates and normalizes vectors, scores every indexed entry, retains only a bounded top-k trace, and resolves exact ties by canonical memory identifier. Compressed profiles will be compared against this oracle rather than weakening it.

The implementation is Incan-authored under `src/hyperquant/`. Until Incan supports nested public module namespace exports, the intended Hyperquant declarations are explicitly re-exported from `pub::hees_ai`; [Incan issue #948](https://github.com/encero-systems/incan/issues/948) tracks the preferred `from pub::hees_ai import hyperquant` surface.

See the [Hyperquant retrieval guide](workspaces/docs-site/docs/hyperquant.md) for its authority boundary, bounds, API, and profile roadmap.

## Guided programmes

The guided-programme preview defines bounded programme, card, choice, transition, progress and learner-operation contracts in Incan. A programme declaration can be validated for exact topology, reviewed and rights-allowed cards, language and audience catalogues, support references, completion and package-owned progress policy. Untrusted runtime frames and payload-enum actions can then be evaluated for operation eligibility.

This is deliberately a structural precursor. Runtime support identifiers are nominations, not selected memory, and an eligible operation is not an admitted package artifact or terminal Spectrum decision. The remaining integrations are canonical package admission, governed-memory materialization, Spectrum, Content DNA and receipts.

See the [guided-programme guide](workspaces/docs-site/docs/guided-programmes.md) for the complete public boundary and current limitations.

## hees.ai console

hees.ai console is the terminal-first, local-first development environment for governed AI. Its north-star workflow begins before the prompt: developers explore evidence, curate governed memory, create and validate reusable profiles, pressure-test material through Training by Committee, run live or saved interactions, and inspect Spectrum, selected memory, Content DNA, receipts and trace. This release begins with a supplied fictional package containing reviewed evidence and memory, then implements session-local candidate staging, profile validation, committee pressure-testing, governed interactions, and terminal artifacts. It does not yet ingest arbitrary evidence, derive memory atoms, persist edits, or activate a candidate.

The Console's authority boundary and profile contracts are designed to remain provider-neutral and domain-neutral. This release demonstrates that architecture through one fixed fictional domain and one optional GPT-5.6 adapter; it does not yet offer selectable domains or providers. Within that bounded slice, models may propose content, candidate atoms, and evaluator observations. They do not grant review or rights state, declare actions or policy, classify their own observations, select admitted memory, construct Content DNA, or issue a terminal decision.

> **Build Week release:** `console_profile_0_1` is the first bounded native Incan slice of this product. It combines a session-local Profile Studio over original fictional evidence, a real Hees.ai-owned candidate acceptance probe, five governed interactions, offline replay, an optional GPT-5.6 adapter, and self-contained native release packaging. Stable public download evidence remains a release gate.

### Governance profiles are the product unit

A governance profile binds a domain package to a controlled interaction. It names the evidence catalog, reviewed memory atoms, rights and review declarations, permitted actions, behavioral requirements, policy thresholds, evaluator roles, bounds, Spectrum behavior, terminal reasons, and receipt projection supported by that profile.

The permanent workflow is:

1. Load and inspect source evidence.
2. Derive or enter candidate memory atoms while keeping model suggestions visibly untrusted.
3. Establish package-owned review, rights, provenance, authority, and evidence declarations.
4. Configure actions, requirements, policy thresholds, and evaluator roles.
5. Ask Hees.ai to validate the profile instead of letting presentation code silently repair or admit it.
6. Pressure-test memory, profiles, proposals, prompts, and policy through Training by Committee.
7. Run live or saved inputs through the same compiled profile.
8. Inspect Spectrum, selected and discarded memory, Content DNA, the receipt, and a separately labelled trace.
9. Save, compare, replay, and export bounded artifacts without treating historical output as current authority.

The [Governance profiles guide](workspaces/docs-site/docs/governance-profiles.md) explains every declaration with a field-level fictional example.

### Why a governed console

Most AI developer tools begin with a prompt and stop at showing what a model returned. hees.ai console exposes the complete path from evidence and candidate memory through profile validation, governed interaction, terminal inspection, replay, and audit. Strict structured output can constrain shape; it cannot establish package authority, create provenance, interpret policy, select admitted memory, or issue a governance receipt. A reusable profile makes those responsibilities explicit, portable, and testable.

### Training by Committee

Training by Committee is the provider-neutral workflow for pressure-testing candidate atoms, governed packages, response proposals, prompts, and policy choices with multiple bounded evaluator roles. Committee outputs remain observations: Hees.ai derives their exact targets, validates identity and complete coverage, classifies findings under profile-owned policy, and retains terminal authority. This lets developers use models to challenge governed material without letting those models approve themselves.

### Build Week 2026 profile

`console_profile_0_1` makes the evidence-to-decision workflow tangible with an original fictional lesson-support package.

- **Profiles:** compare the shipped active profile with a session-local candidate, inspect its actions, requirements, policy, evidence, memory, and validation state.
- **Evidence and memory:** browse exact source identities, provenance, review and rights state; stage or unstage supported material in the candidate.
- **Real Hees.ai acceptance probe:** run candidate changes through the shipped Incan-authored acceptance interaction. The probe returns `ADMITTED` or `REJECTED` with Hees.ai's stable public reason and its exact profile diagnostic; for example, removing required evidence produces public reason `invalid_package` and diagnostic `invalid_package_atoms`. Candidate state remains `candidate only — not active` and cannot replace the shipped profile.
- **Training by Committee:** inspect Hees.ai-derived relation, contradiction, and synthesis targets, bounded evaluator observations, and the findings Hees.ai classifies under profile-owned thresholds.
- **Governed interactions:** run one admitted and four adversarial scenarios through the active profile.
- **Terminal artifacts:** inspect the Spectrum result, selected memory, Content DNA, receipt, and non-authoritative trace.
- **Two input transports:** use zero-credential replay or optional live GPT-5.6; after decoding, both enter the same compiled Hees.ai authority path.

> **GPT-5.6 proposes. Hees.ai decides.** GPT-5.6 is one optional proposal and observation source. It is never the profile owner or terminal authority.

This first Profile Studio is deliberately session-local. It does not ingest arbitrary documents, persist edited packages, or activate a candidate through an authority API that the public profile does not yet provide. Those are clear next steps in the permanent evidence and profile workflow, not reasons to reduce the current release to an admission harness.

#### Evidence-to-decision authority path

```text
fictional evidence -> candidate memory atoms
                              |
                  authorized review + rights declaration
                              |
                              v
                    reviewed memory atoms
                              |
             candidate profile -> Hees.ai acceptance probe
                              |
                  validation result only
                    (never activates)

                    shipped active profile
                              |
saved replay inputs ─┐        v
                    ├─> proposal + committee observations
live GPT-5.6 inputs ─┘        |
                              v
        validation -> findings -> bounded Spectrum -> decision
                              |
           governed run -> selected memory -> Content DNA + receipt
                                or
                    REJECTED + exact contract reason
```

Console owns native presentation, bounded transport, input bounds, and session-local candidate state in Incan. It calls the public Incan-authored Hees.ai profile directly and cannot fabricate or reinterpret the result. Replay stores proposal and observation inputs plus integrity metadata, not findings or a terminal decision. Optional live mode obtains the same classes of bounded input from GPT-5.6. Both reach identical validation, finding classification, Spectrum, memory-selection, Content DNA, and receipt code after transport normalization.

#### Judge quick start

The no-rebuild judge path below was proven against a historical pre-redesign candidate: it required no Incan compiler, package manager, source checkout, network connection, or API key. The current release becomes available only when the `hees-console-v0.1.0` GitHub Release is published with a tested archive for the judge's platform.

1. Open the [`hees-console-v0.1.0` release](https://github.com/encero-systems/hees.ai/releases/tag/hees-console-v0.1.0) and choose an archive whose platform is listed in that release's notes.
2. Compare the archive's SHA-256 digest with the published `SHA256SUMS` asset from the same release. The per-platform manifest records the archive's source identity, executable digest, and third-party notices.
3. Extract the archive and launch `./hees-console`. Offline replay is the zero-credential default.
4. Press `2` to open Evidence. Select a record with `↑` or `↓`, press `Space` to unstage it from the session-local candidate, and press `v` to validate. Confirm that Hees.ai rejects the incomplete candidate while the shipped active profile remains unchanged.
5. Press `r` to reset the candidate and `v` to validate it again. Press `1` to compare the restored candidate with the active profile.
6. Press `5` to open Interactions and run the admitted scenario. Press `6` to inspect the Spectrum decision, selected memory, Content DNA, and receipt.
7. Run the unknown-evidence and undeclared-action scenarios. Confirm exact reasons `unknown_evidence` and `unknown_action`, with no admitted answer, selected memory, or Content DNA.
8. Continue through unknown memory and non-admitted memory to inspect `unknown_memory` and `memory_not_admitted`.
9. A verified hosted equivalent may be supplied later, but it is not required when the published native test build remains available free of charge through judging.

See [TESTING.md](TESTING.md) for the complete judge path, expected trust labels, optional live-mode evidence, and troubleshooting boundaries.

#### Interaction keys

| Key | View or action |
| --- | --- |
| `1` | Profiles workspace: active profile, candidate, declarations, and validation |
| `2` | Evidence workspace: source and evidence catalog plus candidate staging |
| `3` | Memory workspace: reviewed and non-admitted atoms plus candidate staging |
| `4` | Committee workspace: targets, observations, findings, and policy effects |
| `5` | Interactions workspace: live or replay inputs and proposals |
| `6` | Decisions workspace: Spectrum, selected memory, Content DNA, receipt, and trace |
| `7` | Keyboard and authority help |
| `↑` / `↓` or `k` / `j` | Previous or next visible record or interaction |
| `Space` | Stage or unstage selected Evidence or Memory in the candidate profile |
| `v` | Run the candidate through the shipped Hees.ai acceptance probe and show its stable public reason plus exact profile diagnostic |
| `a` | Attempt candidate activation; this profile keeps it explicitly non-active |
| `r` | Reset the session-local candidate to the shipped reviewed profile |
| `tab` | Move to the next contextual tab or control |
| `enter` | Open the selected contextual inspector |
| `/` | Focus the combined free-text and tag filter |
| `s` | Focus filtering and ordering in the Status column header |
| `b` | Collapse or expand the interaction rail |
| `q` | Quit |

Profile edits are candidate state only. `v` reruns the shipped acceptance interaction through the real Hees.ai boundary; rendering code cannot turn a probe result into admission. Candidate rejection keeps the stable public reason separate from the profile-specific diagnostic, so `invalid_package` remains the contract reason while `invalid_package_atoms` identifies the exact failed invariant. `a` cannot promote the candidate because this profile does not yet expose a safe activation-authority API. While search has focus, type to filter, use `↑` and `↓` to highlight a tag, use `tab` to check or uncheck it, and use `ctrl-u` to clear the query. Interactive states use symbols and explicit text as complete signals, so authority remains legible without colour.

#### Modes

##### Offline replay

Replay is the zero-credential default transport. Its fixtures contain deterministic requests, proposals, bounded observations, schema identities, and integrity metadata. They contain no Hees.ai findings, Spectrum result, selected memory, Content DNA, receipt, or reusable authority. The Console validates each fixture, normalizes its inputs, and invokes the compiled Hees.ai profile again.

##### Optional live GPT-5.6

The implemented adapter uses the OpenAI Responses API with explicit model `gpt-5.6-sol`, the provider-supported strict JSON Schema subset, bounded reasoning effort and output tokens, a configured 15-second timeout per request, and no tool access. It returns the same classes of proposal and evaluator-observation input that replay supplies. After transport-specific decoding, live and replay invoke the same compiled validation, findings, Spectrum, memory-selection, Content DNA, and receipt path. Live preflight permits one proposal and at most eight sequential committee calls, every request body is limited to 65,536 UTF-8 bytes, and the adapter performs no retries. Nine calls therefore carry 135 seconds of aggregate configured timeout budget. That is not a global wall-clock ceiling because `ureq` 2.12.1 cannot interrupt DNS resolution. Live mode never silently falls back to replay while retaining a live label.

The only local credential surface is `OPENAI_API_KEY`, and the credential does not enter fixtures, process arguments, logs, screenshots, receipts, Content DNA, or exported traces.

> **Live network status:** a native diagnostic verified the GPT-5.6 proposal leg; a six-call Training by Committee diagnostic then reused that recorded proposal and reached a real admitted Hees.ai result. A combined run from the frozen release binary remains unproven, so offline replay is the demonstrated judge and video path. The [publication-safe local observation](submission/evidence/live-gpt56-proposal-2026-07-20.json) and [testing guide](TESTING.md) retain the exact timings, usage, harness boundary, and limitations.

The relevant provider contracts follow the official [GPT-5.6 Sol model](https://developers.openai.com/api/docs/models/gpt-5.6-sol) and [structured outputs](https://developers.openai.com/api/docs/guides/structured-outputs) documentation.

#### Supported platforms and access

| Surface | Status |
| --- | --- |
| Self-contained executable | The tagged release publishes an archive only after its native lane completes extracted offline-replay smoke. The release notes name every supported platform, architecture, minimum system requirement, artifact, and digest. Earlier candidates are historical development evidence only. |
| Publication state | The `hees-console-v0.1.0` release is the authoritative source for current artifacts. It is not a claim that an unpublished tag or draft release is available to judges. |
| Hosted equivalent | Not configured; any later hosted surface must run the same frozen executable in bounded, isolated, no-shell sessions |
| Source build | Contributor-only; commit-pinned Incan `0.5.0-dev.23`, Rust `1.93.0`, and `make ci`, with the exact release-candidate command documented below |

Unsupported platforms will be stated explicitly in the final release notes. Source portability is not evidence that a self-contained artifact works on a platform.

The [profile bounds and evidence table](workspaces/docs-site/docs/console-profile-0-1.md) records the enforced input, collection, provider, rendering, and retained-state ceilings plus the measured size, latency, and peak-memory results for the verified local macOS ARM64 candidate.

#### What this profile proves—and enables

Under `console_profile_0_1`, an admitted response proves that the compiled Hees.ai profile accepted the exact package, proposal, support mappings, complete observation set, profile-owned policy effects, structural admission, selected-memory set, Content DNA construction, and receipt projection required by this release. The adversarial scenarios prove that well-formed unknown evidence, unknown memory, non-admitted memory, and undeclared actions cannot borrow authority from the UI or model.

This is the working foundation for the wider Hees.ai outcome: semantic and factual verification, source and claim provenance, rights assurance, governed behavior, conflict management, richer Spectrum adjudication, and durable reusable profiles. Those later assurance layers are not inferred from this structural profile; they can build on an authority graph, selected-memory boundary, Content DNA path, and receipt model that already run end to end.

#### Profile security and privacy

The Build Week profile uses only original fictional lesson-support material. Automated repository and release guardrails reject files outside the public allowlists, known credential patterns, personal paths and email addresses, active-secret leakage, and forbidden material in packaged artifacts. A separate manual publication review remains mandatory because no pattern scanner can prove that prose or fixtures contain no private, proprietary, personal, or otherwise non-publishable meaning.

Offline replay does not require provider access. Live mode sends only the bounded inputs described in the [Console documentation](workspaces/docs-site/docs/console.md). OpenAI's current [API data controls](https://developers.openai.com/api/docs/guides/your-data) describe provider-side training, abuse-monitoring, application-state, and retention behavior; `store=false` does not by itself eliminate all provider retention. All model, source, fixture, provider, and error text is escaped before terminal rendering. Headless output redacts direct question and source text by default. Rejected model prose remains confined to the explicitly untrusted inspection view and cannot enter the trusted answer, receipt, Content DNA, or default exported response.

Report vulnerabilities through the private process in [SECURITY.md](SECURITY.md). Do not open a public issue containing credentials, private content, personal data, or exploit details.

#### Release evidence

The Build Week lineage, Codex collaboration, rules checklist, and evidence ledger live in [BUILD_WEEK.md](BUILD_WEEK.md). The Devpost copy, video script, screenshot plan, and operator controls live in the [submission pack](submission/README.md); they are production material rather than release evidence. The immutable release record is deliberately split across its stable containers:

- the [`hees-console-v0.1.0` release](https://github.com/encero-systems/hees.ai/releases/tag/hees-console-v0.1.0) carries tested archives, manifests, checksums, notices, and the tagged source identity;
- GitHub Actions records the exact CI and native-matrix runs that built those artifacts;
- the documentation site records the generated `SOURCE_COMMIT` for its publication; and
- the submission operator supplies the account-bound YouTube, Devpost, and Codex `/feedback` details in the final submission form, not in the tagged source tree.

The live GPT-5.6 status is intentionally narrower: a native provider-only diagnostic exercised the Incan credential loader, `ureq` HTTPS transport, strict schema, decoder, and typed proposal path successfully in 8.34 seconds; a separate native diagnostic completed six sequential live committee calls in 40.06 seconds with zero retries and reached an admitted real-Hees.ai result with six findings, selected memory, Content DNA, and a receipt; the final combined release-binary path remains unverified; see the [sanitized local observation](submission/evidence/live-gpt56-proposal-2026-07-20.json).

#### How GPT and Codex contributed

Incan is a long-running, human-directed language and compiler developed with substantial GPT assistance; it predates Build Week. During Build Week, Codex with GPT-5.6 helped turn Danny's long-running Hees.ai research—including governance profiles, Training by Committee, Spectrum, and Content DNA—into this coherent public Incan product in days. Danny retained the product, architecture, authority, and publication decisions. At runtime, the optional GPT-5.6 adapter is limited to untrusted proposals and evaluator observations; Hees.ai remains the final authority.

## Hees.ai library 0.0.1

The checked repository currently implements a `0.0.1` pre-v0.1 library preview. The public API is small enough to change before `0.1.0`.

Implemented now:

- a descriptor-shape contract for external source-controlled packages;
- a small in-memory governed-package contract;
- fail-closed structural package validation;
- fail-closed proposal admission against package-owned actions and reviewed, rights-allowed evidence records;
- exact and faithful compressed Hyperquant profiles that nominate bounded package-owned memory identifiers without granting authority;
- guided-programme declaration validation and operation eligibility with closed action payloads, deterministic topology, bounded progress and non-authoritative support nominations;
- the closed, fixture-bounded `console_profile_0_1` package, request, proposal, manifest, observation, finding, and reason contracts;
- deterministic relation and synthesis classification, checked structural-kernel delegation, and exact selected-memory freezing;
- admitted-answer Content DNA, admitted receipts, and identity-safe rejection receipts with frozen canonical SHA-256 goldens;
- an Incan-authored native Console application with session-local evidence and memory staging, a Hees.ai-owned candidate acceptance probe, active-versus-candidate state, terminal rendering, privacy-redacted headless output, deterministic replay, bounded trace projection, and optional live-provider composition;
- native application and provider-boundary tests, including candidate-profile state, responsive rendering, five real Hees.ai outcomes, and injected end-to-end live composition without network access;
- reproducible native release-candidate packaging with license, provenance, checksum, leakage, and extracted-archive smoke gates;
- a checked `src/lib.incn` public surface; and
- an external-consumer fixture and fictional external example.

Not implemented by the checked `0.0.1` library:

- a bundled local model inference engine; the implemented remote provider adapter remains optional and explicitly selected;
- governed retrieval-result admission, selected-memory materialization, RAG composition, or semantic claim verification;
- canonical guided-programme package admission or terminal programme decisions with Spectrum, Content DNA, and receipts;
- generic filesystem package loading or archive handling outside the closed in-memory console profile;
- an authoritative semantic evaluator: the console profile consumes bounded provider observations, then classifies and applies them under package policy;
- proof of source ownership, licensing, or content rights outside the explicit package status value;
- arbitrary package authoring, durable profile storage, governed activation of edited profiles, review queues, domain configuration, dashboards, or operations control surfaces; and
- a general-purpose production runtime or stable generic-library CLI; the separately versioned Console profile has its own bounded command surface.

`PackageLoaderValidation` validates descriptor metadata only. It never opens `package_path` and must not be presented as package admission.

### Toolchain

The current branch requires Incan `0.5.0-dev.23` from merged source commit [`121b1b789508d8fa83aa7f9400fef52e294afa62`](https://github.com/encero-systems/incan/commit/121b1b789508d8fa83aa7f9400fef52e294afa62). Release tooling pins that source identity separately from the canonical root `incan.lock`. The release workflow fails closed unless it obtains a byte-identical lock fixed point, the complete local gate, and a fresh native release matrix from the tagged Hees.ai head. Make the exact compiler binary available on `PATH`, or pass it explicitly to Make:

```bash
make ci INCAN=/path/to/incan
```

Use `INCAN_FLAGS="--locked --offline"` only after the Cargo dependencies have been cached locally. The default clean build is locked but network-capable.

### Build and test

```bash
make ci
```

The current gate formats and builds the public library, runs the package and runtime tests, compiles an actual external dependency, runs the fictional example, applies the repository boundary audit, and builds the documentation strictly.

The standalone Console has focused source and native smoke gates:

```bash
make console-test console-native-smoke INCAN=/path/to/incan-0.5.0-dev.23/bin/incan
```

They compile the Incan-authored Console, run the native application and provider-boundary suites, build the native artifact, and execute all five headless replay smokes against the fictional profile corpus.

The separate release-candidate lane wraps that proof in a checked archive:

```bash
make console-release-candidate \
  INCAN=/path/to/incan-0.5.0-dev.23/bin/incan \
  RELEASE_PLATFORM=macos-aarch64
```

The command is intentionally not a release publisher. It builds and audits the native Console, records the source commit plus clean-tree evidence and the Console lock digest, includes the project license, repository notice, and generated third-party license report, creates a normalized `tar.gz` envelope and SHA-256 file under `workspaces/hees-console/target/release/`, and runs only the extracted binary from a clean temporary working directory. The smoke receives a minimal environment with no API key and needs no compiler or source checkout at runtime.

The pinned registry contains candidate lanes for Linux x86_64, macOS ARM64, and macOS x86_64. Each lane builds the exact Incan source commit natively before compiling and smoke-testing Console; no mutable compiler branch or preinstalled toolchain is trusted. Windows and Linux ARM64 remain unsupported until equivalent native lanes execute successfully. The selected standard runner labels come from the current [GitHub-hosted runner reference](https://docs.github.com/en/actions/how-tos/write-workflows/choose-where-workflows-run/choose-the-runner-for-a-job).

Release-candidate archives are not Developer ID-signed and not notarized; linker ad-hoc signing may exist solely for local execution and conveys no publisher identity. The workflow has read-only repository permission and uploads short-lived Actions artifacts only; it does not create a GitHub release, sign an artifact, or publish the stable no-rebuild test-build links above. Archive metadata is deterministic for fixed bundle inputs, while bit-for-bit reproducibility of native compiler output is not claimed.

### External package descriptor

Public Hees.ai contracts use nominal identifier types such as `PackageId`, `ActionId`, and `EvidenceId` over one shared, bounded `IdType`. Its symbolic specialization accepts at most 128 lowercase ASCII letters, digits, underscores, or hyphens and requires a letter or digit first. Its fixed-form digest specialization supplies content-addressed `ContentDnaId` and `ReceiptId` values. Every concrete identifier therefore derives from the same bounded string base while remaining a plain JSON string on the wire. The public constructors and text projections preserve namespace separation in Incan code without changing the existing JSON contracts.

The pinned Incan compiler invokes validated-newtype construction during derived JSON deserialization ([Incan #904](https://github.com/encero-systems/incan/issues/904), [merged fix](https://github.com/encero-systems/incan/commit/3802fe8e03b1d61237abb0d48abbddb17c4044b4)). Malformed identifier text is therefore rejected before it can inhabit a typed Hees.ai contract. Admission still validates what those well-formed identifiers are allowed to reference; decoding success never establishes authority.

An implementation package can depend on a local checkout during pre-release development:

```toml
[dependencies]
hees_ai = { path = "../hees.ai" }
```

```incan
from pub::hees_ai import package_loader_descriptor, validate_package_loader_descriptor

descriptor = package_loader_descriptor(
    "lesson_support",
    "lesson_support",
    "packages/lesson_support/package/domain.json",
    "0.1",
    "source_controlled_domain_package",
)
validation = validate_package_loader_descriptor(descriptor)
```

The canonical descriptor path is repository-relative and ends in `package/domain.json`. The validator rejects absolute, traversal, dot-segment, Windows-drive, backslash, and embedded newline, carriage-return, or tab path forms. No descriptor value is passed to a filesystem API by this library.

### Runtime admission

The fictional [minimal governed agent](examples/minimal_governed_agent/README.md) demonstrates the separate runtime contract. A caller constructs a `GovernedPackage` and an untrusted `ModelProposal`; `admit_model_proposal` checks only the structural authority it can prove. The caller remains responsible for retrieval, model execution, semantic verification, digest integrity, and source-rights due diligence.

## Repository boundary

This repository contains the reusable Hees.ai kernel, public documentation, fictional examples and fixtures, tests, repository guardrails, and the public hees.ai console reference product. Private corpora, model files, confidential packages, unpublished research artifacts, and unrelated product code do not belong here.

Hees.ai is licensed under the [Apache License 2.0](LICENSE). Each Console `0.1.0` release candidate audits its locked platform dependency graph and includes that build's generated third-party license report plus the [repository notice](NOTICE). The checked [macOS ARM64 reference report](workspaces/hees-console/packaging/THIRD_PARTY_LICENSES.md) supports source review but is not substituted for another platform's generated report. The public release URL remains a publication gate.

See [the documentation](workspaces/docs-site/docs/index.md), [contribution guidance](CONTRIBUTING.md), [RFC process](rfcs/README.md), and [security policy](SECURITY.md).
