# Testing hees.ai console

This is the judge and reviewer test plan for hees.ai console `0.1.0` and its Build Week 2026 `console_profile_0_1` release. The primary flow begins with evidence, memory atoms, and a candidate-profile acceptance probe, then continues through Training by Committee, a bounded Spectrum evaluation, the governed interaction, Content DNA, and receipt. Every field labelled `FINALIZE BEFORE RELEASE` must be replaced with verified public evidence before these instructions become the final judge path.

## Fastest path: published offline test build

The Build Week profile archive runs without an Incan compiler, package manager, source checkout, network connection, or API key. An earlier immutable candidate passed on macOS ARM64, macOS x86-64, and Linux x86-64, but the redesigned final head still requires a fresh three-platform matrix and published audited archives. The following fields are release blockers, not current download instructions.

### 1. Download and verify

| Field | Verified release value |
| --- | --- |
| Supported platform and architecture | **[FINALIZE BEFORE RELEASE: PLATFORM AND ARCHITECTURE]** |
| Release tag | **[FINALIZE BEFORE RELEASE: `hees-console-v0.1.0` RELEASE URL]** |
| Artifact name | **[FINALIZE BEFORE RELEASE: EXACT ASSET NAME]** |
| Artifact URL | **[FINALIZE BEFORE RELEASE: IMMUTABLE ASSET URL]** |
| SHA-256 | **[FINALIZE BEFORE RELEASE: EXACT LOWERCASE SHA-256]** |
| Build provenance | **[FINALIZE BEFORE RELEASE: PROVENANCE URL]** |
| Dependency licenses | **[FINALIZE BEFORE RELEASE: LICENSE REPORT URL]** |

Download the artifact and verify it using the exact platform command:

```bash
shasum -a 256 -c hees-console-0.1.0-macos-aarch64.tar.gz.sha256
# Linux:
sha256sum -c hees-console-0.1.0-linux-x86_64.tar.gz.sha256
```

Do not run an artifact whose digest differs from the published value.

### 2. Launch

```bash
tar -xzf hees-console-0.1.0-<platform>.tar.gz
cd hees-console-0.1.0-<platform>
./hees-console
```

The initial view must identify Console `0.1.0`, profile `console_profile_0_1`, mode `REPLAY`, and the shipped active profile. Offline startup must not ask for an API key or silently access the network.

### 3. Exercise the Profile Studio

The first judge action establishes that the Console is a governed-AI development environment rather than a response viewer:

1. Press `2` to open Evidence.
2. Use `↑` or `↓` to select a reviewed, rights-allowed evidence record and inspect its source identity, fingerprint, language, source span, review state, rights state, memory identity, and provenance digest.
3. Press `Space` to unstage the selected record from the session-local candidate profile.
4. Press `v` to rerun the shipped acceptance interaction against the candidate through the real Incan-authored Hees boundary.
5. Confirm that the candidate probe returns `REJECTED` with stable public reason `invalid_package` and exact profile diagnostic `invalid_package_atoms` while the shipped active profile remains unchanged.
6. Press `a` and confirm that activation remains blocked as `candidate only — not active`; this release does not let UI state bypass a missing activation-authority API.
7. Press `r` to reset the candidate to the shipped reviewed profile, then press `v` and confirm the restored valid result.
8. Press `1` to inspect the active and candidate profile identities, declared actions, requirements, policy, staged evidence, staged memory, and validation state.

The equivalent workflow is available in Memory with `3`. Candidate changes are in-memory only and must not persist after exit.

### 4. Run the required scenarios

| Selection | Scenario | Expected trusted result | What to inspect |
| --- | --- | --- | --- |
| Initial row | Declared action with reviewed, rights-allowed evidence and admitted memory | `ADMITTED` / `console_admission_0_1` / `admitted` | Visible units, distinct evidence and memory identifiers, observations, Hees-classified findings, structural reason, Spectrum result, selected memory, Content DNA, receipt |
| `↓` once | Undeclared action | `REJECTED` / `console_admission_0_1` / `unknown_action` | The untrusted proposal remains inspectable, but no trusted answer, selected memory, or Content DNA appears |
| `↓` twice | Unknown evidence | `REJECTED` / `console_admission_0_1` / `unknown_evidence` | A schema-valid evidence identifier that the package never declared cannot acquire authority |
| `↓` three times | Unknown memory | `REJECTED` / `console_admission_0_1` / `unknown_memory` | The untrusted proposal remains inspectable, but no trusted answer, selected memory, or Content DNA appears |
| `↓` four times | Known but non-admitted memory | `REJECTED` / `console_admission_0_1` / `memory_not_admitted` | The package-owned memory exists but cannot be selected into a trusted answer |

Replay fixtures do not store terminal results. They contain bounded request, proposal, and observation inputs plus schema and integrity identities. After replay decoding, those inputs enter the same compiled Hees validation, finding-classification, Spectrum, selected-memory, Content DNA, and receipt path used after live-provider decoding. To establish that the real runner executed, compare the displayed runner identity and receipt or Content DNA values with **[FINALIZE BEFORE RELEASE: RELEASE GOLDEN OUTPUT AND RUNNER-INTEGRITY TEST URL]**. A replay digest proves saved-input integrity, not GPT provenance.

### 5. Inspect the trust boundary

The following checks establish the complete evidence-to-decision boundary:

- The Profiles, Evidence, and Memory workspaces distinguish shipped active state from the session-local candidate.
- Staging changes affect only the candidate; `v` invokes the real Hees acceptance probe, exposes public reason `invalid_package` separately from profile diagnostic `invalid_package_atoms`, and `a` cannot grant activation authority.
- `UNTRUSTED PROPOSAL` is visually and textually separate from `ADMITTED` or `REJECTED`.
- Relation and synthesis observations contain bounded integer scores, while the resulting classifications are shown as `HEES-CLASSIFIED NON-AUTHORITATIVE FINDINGS`.
- Training by Committee presents separately role-bound observations as proposal pressure tests; Hees validates complete coverage, classifies the findings, and decides without a provider-majority vote.
- The provider does not supply the finding classification, terminal action, selected memory, Content DNA, or receipt.
- An admitted response shows every and only the canonical package memory referenced by the admitted support mappings.
- Profile-specific Console Content DNA binds the admitted visible units, package and policy identity, terminal decision, and selected package-owned memory without reproducing source or answer prose in the provenance entries.
- The profile receipt contains terminal governance identity but excludes provider, model, build, replay, observation, and finding-detail metadata.
- Replay mode remains visibly labelled in every view and exported run record.
- Rejected model text stays inside the escaped untrusted inspection view and never appears as a trusted answer.

## Optional hosted equivalent

A hosted equivalent is not required once a native test build is published and remains free and unrestricted through the judging period. If one is supplied, it must invoke the same frozen executable, expose the Console directly rather than an unrestricted shell, isolate sessions, avoid persisting judge input, and remain available through August 5, 2026 at 17:00 PDT.

**Hosted equivalent:** not configured. The current head has no release artifact, so neither path is presently judgeable without a source build. Before submission, publish and verify the frozen native test build or replace this field with a verified hosted URL, availability window, frozen artifact identity, and isolation result.

## Optional live GPT-5.6 test

Live mode is optional for judges. It requires network access, an OpenAI API key with available quota, and an explicit selection that remains visibly labelled `LIVE`. Never paste a key into an issue, log, screenshot, fixture, command argument, or exported artifact.

One complete live invocation is preflight-limited to one proposal call and at most eight sequential committee calls. Each request body is limited to 65,536 UTF-8 bytes, proposal output is limited to 2,048 tokens, observation output is limited to 512 tokens per call, each request has a configured 15-second timeout, and the adapter performs no retries. Nine calls therefore carry 135 seconds of aggregate configured timeout budget. This is not a global wall-clock ceiling because `ureq` 2.12.1 cannot interrupt DNS resolution. At the current published GPT-5.6 Sol rates, those source-level request and output ceilings imply a conservative upper bound of $3.14 for one invocation. Treat that number as an implementation-derived safety estimate rather than a provider billing guarantee, fund only the approved ceiling, and run exactly one canary unless a new budget is approved.

1. Set `OPENAI_API_KEY` in the environment using your platform's secret-safe method.
2. From the extracted archive, start `./hees-console --mode live --question "What order should I use for the Lantern Path cards?"`.
3. Confirm that the question is the original fictional Lantern Path prompt and that the UI remains labelled `LIVE`.
4. Confirm that the Console identifies model `gpt-5.6-sol`, displays a strict structured untrusted proposal and bounded observations, and sends the complete normalized bundle to the same runner identity used by replay.
5. Confirm that provider refusal, timeout, rate limit, malformed structured output, or incomplete observation coverage produces a typed fail-closed state and never silently substitutes replay values under a live label.
6. Remove the environment credential after the test.

**Live network status:** a native provider-only diagnostic exercised the Incan credential loader, `ureq` HTTPS POST, accepted strict schema, product decoder, and typed proposal path successfully in 8.34 seconds, with no retry. It did not record request or response hashes or usage. Separately, external `curl` submitted the exact product-generated request and supplies locally observed hashes, usage, and the exact decoded proposal. A second native diagnostic reused that proposal, preflighted exactly six targets, completed six sequential GPT-5.6 committee calls in 40.06 seconds with zero retries, decoded three relation and three synthesis observations, and passed the complete set through the real Hees profile. Hees classified six findings, selected `memory_lantern_sequence`, constructed Content DNA and a receipt, and admitted the result. The committee diagnostic did not repeat the proposal call in the same process, retained no token-usage or cost record, and required a temporary generated-Rust workaround for the known Incan `Iterator.sum` defect. The native proposal-only call did not require that workaround. A combined proposal-plus-committee run from the frozen release binary remains unproven. The [sanitized local observation](submission/evidence/live-gpt56-proposal-2026-07-20.json) records the separate observations and their limitations. The video and primary judge path use offline replay.

The source defines nineteen provider-boundary tests for request construction, strict decoding, injected-transport composition, failure classification, budget preflight, duplicate-authority rejection, and fail-closed behavior. The last complete redesigned provider run executed seventeen; a complete nineteen-test run remains blocked by the current Incan compiler defect. The adapter is designed against the official [GPT-5.6 Sol model](https://developers.openai.com/api/docs/models/gpt-5.6-sol), [structured outputs](https://developers.openai.com/api/docs/guides/structured-outputs), and [API data controls](https://developers.openai.com/api/docs/guides/your-data) documentation.

## Source verification for contributors

The current checked library remains Hees `0.0.1` and uses commit-pinned Incan `0.5.0-dev.19`:

```bash
make ci
```

That command verifies formatting, the public library build, package and runtime tests, an external consumer, the fictional example, the repository boundary, the documentation build, native Console tests, and release-contract tests. Focused Console verification is available now:

```bash
make console-test console-native-smoke \
  INCAN=/path/to/incan-0.5.0-dev.19/bin/incan

make console-release-candidate \
  INCAN=/path/to/incan-0.5.0-dev.19/bin/incan \
  RELEASE_PLATFORM=macos-aarch64

make console-release-lint console-release-set-test
```

The exact tag `hees-console-v0.1.0` must point to a commit already contained in `origin/main`. Its tag-triggered workflow rebuilds all three supported native artifacts, validates the complete nine-file source-bound release set, writes aggregate checksums, and creates a draft GitHub Release. It never publishes the Release automatically. Review the draft assets, hashes, source identity, macOS signing posture, limitations, and notes before manually publishing it.

Before publication, bind the release evidence to the exact tagged commit: record the aggregate local gate, CI and documentation runs, three-platform native build, archive and executable hashes, manifest source identity, extracted replay smoke, and any signing or notarization result. Historical candidate runs are useful development evidence but cannot substitute for the tagged release evidence.

## Current profile and product direction

| Working in `console_profile_0_1` | Direction beyond this release |
| --- | --- |
| Supplied fictional evidence catalog with exact source, review, rights, and provenance state | General evidence intake, extraction, multilingual source processing, and candidate-atom curation |
| Session-local staging, Hees acceptance probing, reset, and explicit blocked activation | Durable IncQL-DB workspaces, governed activation, versioning, comparison, and export of authored profiles |
| One bounded Training by Committee proposal pressure test | Provider-neutral pressure testing across evidence, candidate atoms, profiles, prompts, and policy |
| Deterministic structural and policy admission with `admit` and `reject` | Semantic and factual verification, source and claim provenance, rights assurance, repair, clarification, and escalation |
| Profile-specific Spectrum operation, Content DNA, and receipt | Complete generalized Spectrum, Content DNA, response-lifecycle, and governance-receipt contracts |
| Integrity-checked offline saved inputs plus optional live GPT-5.6 transport | Additional remote and local provider adapters normalized into the same profile authority path |
| Historical pre-redesign candidates on macOS ARM64, macOS x86-64, and Linux x86-64; the current head has zero release artifacts | Current and additional platforms only after each published artifact passes extracted no-rebuild smoke |

## Troubleshooting without weakening the boundary

| Symptom | Safe response |
| --- | --- |
| Digest mismatch | Stop and download the asset again from the published release; do not bypass verification. |
| Unsupported platform | Use a documented supported artifact or a verified hosted equivalent if one is published; do not infer support from source portability. |
| Replay integrity failure | Treat the fixture as invalid; do not run or display a stored fallback decision. |
| Runner unavailable or malformed response | Show a typed host failure; do not fabricate a Hees rejection or admission. |
| Missing API key | Stay in explicitly labelled replay mode or configure live mode deliberately; do not ask judges to expose a credential. |
| Live timeout, refusal, rate limit, or malformed output | Fail closed under the documented typed state; do not relabel replay as live. |
| Hosted session expired | Use the published native test build, or follow the verified hosted restart instruction if a hosted equivalent is later supplied. |

## What a successful test establishes

A successful offline judge run establishes that the published executable can mutate bounded candidate-profile state, validate it through Hees without changing the active profile, and rerun five saved-input scenarios through the real Incan-authored authority path without rebuilding the project. It exposes the exact path from evidence and reviewed memory atoms through profile policy, Training by Committee, the bounded Spectrum operation, the governed decision, selected memory, Content DNA, and receipt.

This structural and policy proof is the foundation for the product's next assurance layers. Semantic and factual verification, source and claim provenance, rights assurance, richer response states, and durable profile authoring require additional profiles and contracts; they are not inferred from the fictional answer or provider observations in this release.
