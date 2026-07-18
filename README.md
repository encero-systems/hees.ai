# Hees

Hees is an Incan-first project for deterministic runtime governance of AI interactions. The checked `0.0.1` kernel performs fail-closed structural admission against package-owned actions and evidence, while the experimental `console_profile_0_1` implements a tightly bounded path from one fictional package and untrusted proposal through Hees-classified findings, Spectrum admission, selected memory, Content DNA, and a receipt. Draft RFC 010 defines Hees Console as the permanent developer product around that authority boundary; the checked kernel and released Console profiles, rather than the north-star design, determine what is implemented at any revision.

## Hees Console

Hees Console is the permanent terminal-first, local-first, provider-neutral and domain-neutral developer product for building, validating, running, and inspecting governed AI systems. It is not defined by one model, provider, fixture domain, event profile, or deployment topology.

> **Current status:** The permanent Console contract remains Draft under [RFC 010](rfcs/010-hees-console.md). The checked repository now contains the complete native Incan application for `console_profile_0_1`, deterministic offline replay, optional live GPT-5.6 composition, focused tests, and reproducible self-contained release-candidate packaging. No public release asset or hosted judge instance is available yet, so those remain explicit release gates rather than implied capabilities. The separate checked Hees library remains the implemented `0.0.1` preview described under [Hees library 0.0.1](#hees-library-001).

### Permanent product north star

The permanent Console workflow starts with evidence rather than a model response. A developer should be able to:

- intake lawful source evidence in a local-default workspace and inspect source-safe identities;
- inspect provider-suggested candidate memory without treating it as reviewed or admitted material;
- author package declarations and ask Hees to validate packages without giving the presentation host admission authority;
- use Training by Committee to pressure-test candidates, packages, proposals, prompts, and policies through provider-neutral evaluator roles;
- run governed interactions while keeping proposals, observations, Hees findings, package policy, and terminal authority separate;
- inspect Spectrum decisions, selected memory, Content DNA, governance receipts, and non-authoritative traces as distinct surfaces; and
- save integrity-bound scenarios for replay and audit that rerun Hees instead of reusing stored decisions.

These are Draft north-star capabilities, not claims about the checked `0.0.1` library or the first bounded profile. A released Console profile must name exactly which authoring, validation, interaction, inspection, persistence, and export capabilities it implements.

### Why a governed console

Most AI developer tools stop at showing what a model returned. Hees Console is intended to expose the complete path from evidence and candidate memory through package validation, governed interaction, terminal inspection, replay, and audit. Strict structured output can constrain shape, but it does not establish package authority, classify observations under package-owned policy, select a Spectrum result or admitted memory, construct Content DNA, or project a governance receipt. Making those boundaries inspectable gives developers a concrete way to test happy paths and adversarial contract failures.

### Training by Committee

Training by Committee is the permanent provider-neutral workflow for pressure-testing candidate atoms, governed packages, response proposals, and policy choices with multiple bounded evaluator roles. Committee outputs remain observations: Hees derives their targets, validates coverage, classifies findings under package-owned policy, and retains terminal authority. The workflow does not imply semantic truth, automatic review, model-weight training, or a provider-majority vote.

### Build Week 2026 implementation profile

The checked first release candidate implements the deliberately limited `console_profile_0_1` Build Week profile, not the complete permanent Console. It uses one original fictional lesson-support package, deterministic offline replay, and an optional GPT-5.6 adapter to prove one end-to-end governed interaction. It does not provide the permanent evidence workspace or general package-authoring experience and does not claim complete Spectrum, Content DNA, receipt, verification, behavior, or visible-response conformance under RFC 001–009.

> **GPT-5.6 proposes. Hees decides.** This statement describes the optional live adapter in the Build Week profile; GPT-5.6 is not a permanent Console dependency or authority.

#### What the profile demonstrates

- Load an original fictional lesson-support package containing package-authored, reviewed memory atoms, declared actions, evidence, and policy.
- Ask GPT-5.6 for a strict structured proposal in optional live mode, or use a neutral integrity-checked fixture in default offline replay mode.
- Inspect the ordered visible units that form the proposal's sole answer channel and their identifier-only support mappings.
- Inspect bounded relation and synthesis observations separately from the findings that Hees classifies under package-owned integer thresholds.
- See an exact `ADMITTED` or `REJECTED` result from the real compiled Incan-authored Hees profile, including the closed reason namespace and structural-admission result when reached.
- On admission, inspect the exact selected canonical memory, experimental `console_content_dna_0_1`, and `console_profile_receipt_0_1` constructed by Hees.
- Replay valid and adversarial scenarios through the same runner instead of displaying a stored decision.

The profile includes frozen contracts and fixtures for an optional model-generated atom candidate and its non-authoritative exact-match or mismatch comparison. The current executable does not create a candidate during an interaction: its `ATOM COMPARISON` inspector reports `not_configured` and `package_effect=none`. If configured by a later profile, a candidate still cannot receive a trusted memory identifier, alter the canonical package, acquire review or rights status, enter the admitted-memory context, or affect terminal selection.

The profile exercises one bounded proposal-pressure-testing part of Training by Committee. Separately role-bound evaluation calls produce relation and synthesis observations against exact targets derived by Hees. Those observations remain non-authoritative: Hees validates their complete coverage, applies package-owned thresholds, classifies the findings, and makes the terminal decision.

#### Build Week profile authority boundary

```text
fictional package + question
            |
            v
Incan-authored Hees Console
GPT-5.6 or replay fixture -> untrusted proposal + observations
            |
            v
Incan-authored Hees profile
validation -> findings -> limited Spectrum operation -> decision
            |
            v
ADMITTED + selected memory + Content DNA + receipt
or
REJECTED + exact violated contract
```

Console owns terminal presentation, provider transport, input bounds, and application state in Incan. It calls the public Incan-authored Hees profile directly and cannot fabricate or reinterpret the profile result. Offline replay contains normalized proposal and observation inputs only; every replay invokes Hees again.

#### Judge quick start

The local release candidate supports an offline path that requires no Incan compiler, package manager, source checkout, network connection, or API key. Public download and hosted-access steps remain intentionally incomplete until their publication gates pass.

1. Download the self-contained archive for **[FINALIZE BEFORE RELEASE: VERIFIED PUBLIC ARTIFACT PLATFORM]** from **[FINALIZE BEFORE RELEASE: RELEASE ASSET URL]**.
2. Compare the downloaded file's SHA-256 digest with **[FINALIZE BEFORE RELEASE: RELEASE ASSET SHA-256]**.
3. Extract the archive and launch `./hees-console`. Offline replay is the zero-credential default.
4. The valid scenario is evaluated immediately through Hees. Use `←` and `→` to inspect the fixed package and sources, optional atom-comparison state, untrusted proposal, support mappings, verifier manifest, observations, Hees-classified findings, `ADMITTED` decision, selected memory, experimental Console Content DNA, profile receipt, and non-authoritative trace.
5. Press `2` for the undeclared-action scenario. Confirm that Hees returns `REJECTED` with `unknown_action` in namespace `console_admission_0_1`.
6. Press `3` for unknown memory and `4` for non-admitted memory. Confirm the exact respective reasons `unknown_memory` and `memory_not_admitted`, with no trusted answer or admitted-only artifacts.
7. Alternatively, open **[FINALIZE BEFORE RELEASE: HOSTED SANDBOX URL]** and repeat the same four scenarios against the frozen executable.

See [TESTING.md](TESTING.md) for the complete judge path, expected trust labels, optional live-mode evidence, and troubleshooting boundaries.

#### Interaction keys

| Key | View or action |
| --- | --- |
| `1` | Valid declared-action scenario |
| `2` | Undeclared-action scenario |
| `3` | Unknown memory scenario |
| `4` | Non-admitted memory scenario |
| `←` or `→` | Previous or next inspector |
| `↑` or `↓` | Previous or next scenario |
| `enter` | Next inspector |
| `q` | Quit |

Colour reinforces status but is not the only status signal. Trusted and untrusted surfaces use explicit text labels and stable symbols so the boundary remains legible in monochrome and narrow terminals.

#### Modes

##### Offline replay

Replay is the zero-credential default. Its fixtures contain neutral deterministic proposals and observations plus integrity metadata; they contain no Hees decision, findings, selected memory, Content DNA, or receipt. The Console validates every fixture and reruns the compiled Hees decision path for every interaction.

##### Optional live GPT-5.6

The implemented adapter uses the OpenAI Responses API with explicit model `gpt-5.6-sol`, strict JSON Schema structured outputs, bounded reasoning effort and output tokens, timeouts, and no tool access. Live mode is an optional, explicitly selected path and never silently falls back to replay while retaining a live label. The only local credential surface is `OPENAI_API_KEY`, and the credential does not enter fixtures, process arguments, logs, screenshots, receipts, Content DNA, or exported traces.

> **Live evidence pending:** **[FINALIZE BEFORE RELEASE: LIVE CANARY COMMIT, CI OR RUN LINK, MODEL AND CONFIGURATION FINGERPRINTS, AND RESULT]**. Until this field is replaced with public evidence, live GPT-5.6 operation is a release target rather than a verified capability.

The relevant provider contracts follow the official [GPT-5.6 Sol model](https://developers.openai.com/api/docs/models/gpt-5.6-sol) and [structured outputs](https://developers.openai.com/api/docs/guides/structured-outputs) documentation.

#### Supported platforms and access

| Surface | Status |
| --- | --- |
| Self-contained executable | macOS ARM64 release candidate verified locally; **[FINALIZE BEFORE RELEASE: PUBLIC ASSET URL AND MINIMUM SYSTEM REQUIREMENTS]** |
| Additional local artifacts | Linux x86-64 and macOS x86-64 candidate lanes require exact GitHub-hosted execution before support is claimed |
| Hosted sandbox | **[FINALIZE BEFORE RELEASE: URL, AVAILABILITY WINDOW, ACCESS STEPS, AND BOUNDED NO-SHELL SESSION LIMITS]** |
| Source build | Contributor-only; **[FINALIZE BEFORE RELEASE: EXACT REPRODUCIBLE BUILD COMMANDS AND TOOL VERSIONS]** |

Unsupported platforms will be stated explicitly in the final release notes. Source portability is not evidence that a self-contained artifact works on a platform.

The [profile bounds and evidence table](workspaces/docs-site/docs/console-profile-0-1.md) records the enforced input, collection, provider, rendering, and retained-state ceilings plus the measured size, latency, and peak-memory results for the verified local macOS ARM64 candidate.

#### What profile admission proves

Under the `console_profile_0_1` release contract, an admitted response proves that the frozen Hees profile accepted the exact package, proposal, support mappings, complete observation set, package-owned policy effects, checked Hees `0.0.1` structural admission, selected-memory set, Content DNA construction, and receipt projection required by that limited profile.

Admission does not prove semantic truth, factual correctness, universal claim support, source ownership, legal rights outside the declared package state, producer authenticity, model calibration, or remote attestation. Provider observations can be wrong. Experimental `console_content_dna_0_1` exercises the RFC 002 admitted-answer field shape for this limited profile without claiming full RFC 002 conformance, and `console_profile_receipt_0_1` borrows RFC 006 redaction principles without claiming RFC 006 compatibility.

#### Profile security and privacy

The Build Week profile uses only original fictional lesson-support material. Repository and release guardrails reject private packages, personal data, credentials, local paths, downloaded models, hidden prompts, chain-of-thought, raw provider headers, unrestricted evaluator rationale, and unrelated runtime code.

Offline replay does not require provider access. Live mode sends only the bounded inputs described in the [Console documentation](workspaces/docs-site/docs/console.md); **[FINALIZE BEFORE RELEASE: LINK TO VERIFIED RETENTION NOTES]** remains a publication gate. All model, source, fixture, provider, and error text is escaped before terminal rendering. Headless output redacts direct question and source text by default. Rejected model prose remains confined to the explicitly untrusted inspection view and cannot enter the trusted answer, receipt, Content DNA, or default exported response.

Report vulnerabilities through the private process in [SECURITY.md](SECURITY.md). Do not open a public issue containing credentials, private content, personal data, or exploit details.

#### Release evidence

The Build Week lineage, Codex collaboration, rules checklist, and evidence ledger live in [BUILD_WEEK.md](BUILD_WEEK.md). The pre-freeze Devpost copy, video script, screenshot plan, and finalization controls live in the [submission pack](submission/README.md); those drafts are not release or submission evidence. Before release, the following placeholders must be replaced with public evidence:

- release tag and immutable source commit: **[FINALIZE BEFORE RELEASE: TAG AND COMMIT]**;
- public repository and implementation pull request: **[FINALIZE BEFORE RELEASE: REPOSITORY AND PR URLS]**;
- green CI and artifact smoke tests: **[FINALIZE BEFORE RELEASE: CI AND TEST URLS]**;
- release artifacts, provenance, and SHA-256 values: **[FINALIZE BEFORE RELEASE: RELEASE URL, PROVENANCE URL, AND HASHES]**;
- hosted sandbox and availability window: **[FINALIZE BEFORE RELEASE: HOSTED URL AND DATES]**;
- live GPT-5.6 canary: **[FINALIZE BEFORE RELEASE: CANARY EVIDENCE URL]**;
- screenshots and public demonstration video: **[FINALIZE BEFORE RELEASE: SCREENSHOT AND VIDEO URLS]**; and
- majority-core-functionality Codex `/feedback` Session ID: **[MANUAL INPUT REQUIRED BEFORE SUBMISSION: CODEX SESSION ID]**.

## Hees library 0.0.1

The checked repository currently implements a `0.0.1` pre-v0.1 library preview. The public API is small enough to change before `0.1.0`.

Implemented now:

- a descriptor-shape contract for external source-controlled packages;
- a small in-memory governed-package contract;
- fail-closed structural package validation;
- fail-closed proposal admission against package-owned actions and reviewed, rights-allowed evidence records;
- the closed, fixture-bounded `console_profile_0_1` package, request, proposal, manifest, observation, finding, and reason contracts;
- deterministic relation and synthesis classification, checked structural-kernel delegation, and exact selected-memory freezing;
- admitted-answer Content DNA, admitted receipts, and identity-safe rejection receipts with frozen canonical SHA-256 goldens;
- an Incan-authored native Console application that owns terminal rendering, privacy-redacted headless output, deterministic replay, bounded trace projection, and optional live-provider composition while calling the Hees profile directly;
- thirteen native application tests and fourteen provider-boundary tests, including injected end-to-end live composition without network access;
- reproducible native release-candidate packaging with license, provenance, checksum, leakage, and extracted-archive smoke gates;
- a checked `src/lib.incn` public surface; and
- an external-consumer fixture and fictional external example.

Not implemented by the checked `0.0.1` library:

- a bundled local model inference engine; the implemented remote provider adapter remains optional and explicitly selected;
- retrieval, vector search, RAG, or semantic claim verification;
- generic filesystem package loading or archive handling outside the closed in-memory console profile;
- an authoritative semantic evaluator: the console profile consumes bounded provider observations, then classifies and applies them under package policy;
- proof of source ownership, licensing, or content rights outside the explicit package status value;
- package authoring, review queues, domain configuration, dashboards, or other product control surfaces; and
- a general-purpose production runtime or stable generic-library CLI; the separately versioned Console profile has its own bounded command surface.

`PackageLoaderValidation` validates descriptor metadata only. It never opens `package_path` and must not be presented as package admission.

### Toolchain

The library preview is locked and verified with the released Incan `0.4.0` toolchain. Install that release and make `incan` available on `PATH`, or pass an explicit binary to Make:

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
make console-test console-native-smoke INCAN=/path/to/incan-0.4.0/bin/incan
```

They compile the Incan-authored Console, run thirteen native application tests and fourteen provider-boundary tests, build the native artifact, and execute all four headless replay smokes against the fictional RFC 010 corpus.

The separate release-candidate lane wraps that proof in a checked archive:

```bash
make console-release-candidate \
  INCAN=/path/to/incan-0.4.0/bin/incan \
  RELEASE_PLATFORM=macos-aarch64
```

The command is intentionally not a release publisher. It builds and audits the native Console, records the source commit plus clean-tree evidence and the Console lock digest, includes the project license, repository notice, and generated third-party license report, creates a normalized `tar.gz` envelope and SHA-256 file under `workspaces/hees-console/target/release/`, and runs only the extracted binary from a clean temporary working directory. The smoke receives a minimal environment with no API key and needs no compiler or source checkout at runtime.

The pinned registry contains candidate lanes only for Linux x86_64, macOS ARM64, and macOS x86_64 because those are the native archives published by the official [Incan 0.4.0 release](https://github.com/encero-systems/incan/releases/tag/v0.4.0). Windows and Linux ARM64 are unsupported at this revision. A native artifact becomes supported only after that exact archive executes in its target lane; an unrun matrix entry is not support evidence. The selected standard runner labels come from the current [GitHub-hosted runner reference](https://docs.github.com/en/actions/how-tos/write-workflows/choose-where-workflows-run/choose-the-runner-for-a-job).

Release-candidate archives are not identity-signed or notarized. macOS tooling may apply ad-hoc signatures needed for local execution, but those signatures establish no publisher identity. The workflow has read-only repository permission and uploads short-lived Actions artifacts only; it does not create a GitHub release, sign an artifact, deploy a hosted sandbox, or replace the unresolved judge-access placeholders above. Archive metadata is deterministic for fixed bundle inputs, while bit-for-bit reproducibility of native compiler output is not claimed.

### External package descriptor

An implementation package can depend on a local checkout during pre-release development:

```toml
[dependencies]
hees = { path = "../hees.ai" }
```

```incan
from pub::hees import package_loader_descriptor, validate_package_loader_descriptor

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

This repository contains the reusable Hees kernel, public documentation, fictional examples and fixtures, tests, repository guardrails, and the public Hees Console reference product. Private corpora, model files, confidential packages, unpublished research artifacts, and unrelated product code do not belong here.

Hees is licensed under the [Apache License 2.0](LICENSE). Console `0.1.0` release candidates include the checked [third-party license report](workspaces/hees-console/packaging/THIRD_PARTY_LICENSES.md) and [repository notice](NOTICE); the public release URL remains a publication gate.

See [the documentation](workspaces/docs-site/docs/index.md), [contribution guidance](CONTRIBUTING.md), [RFC process](rfcs/README.md), and [security policy](SECURITY.md).
