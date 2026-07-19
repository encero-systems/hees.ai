# Testing Hees Console

This is the judge and reviewer test plan for the Build Week 2026 `console_profile_0_1` release targeted for Hees Console `0.1.0`. It tests one bounded, fictional-domain implementation profile, not the permanent provider-neutral and domain-neutral Console north star or its future evidence-intake and package-authoring workflow. The release is still in development, so every field labelled `FINALIZE BEFORE RELEASE` must be replaced with verified public evidence before these instructions are presented as the final judge path.

## Fastest path: hosted offline replay

1. Open **[FINALIZE BEFORE RELEASE: HOSTED SANDBOX URL]** during **[FINALIZE BEFORE RELEASE: ACCESS AVAILABILITY WINDOW]**.
2. Confirm the header says `REPLAY` and `BUILD WEEK 2026 IMPLEMENTATION PROFILE — console_profile_0_1` before running a scenario.
3. The valid declared-action scenario runs immediately through Hees. Use `←` and `→` to move through the inspectors.
4. Compare the escaped `UNTRUSTED PROPOSAL`, bounded observations, Hees-classified findings, selected memory, experimental Console Content DNA, and profile receipt.
5. Press `2` for the undeclared-action scenario and confirm that the trusted result says `REJECTED`, namespace `console_admission_0_1`, reason `unknown_action`.
6. Press `3` for unknown evidence and confirm `unknown_evidence`; press `4` for unknown memory and confirm `unknown_memory`; press `5` for non-admitted memory and confirm `memory_not_admitted`. No rejection may expose a trusted answer.
7. Inspect a rejection receipt and confirm that it records the rejection while selected memory and Content DNA remain absent.
8. Press `q` to close the session. The hosted surface must expose the Console directly, not an unrestricted shell, and the session must not persist judge input across sessions.

**Hosted-path evidence:** **[FINALIZE BEFORE RELEASE: HOSTED SMOKE TEST, SESSION-ISOLATION RESULT, FROZEN ARTIFACT IDENTITY, AND SCREENSHOTS]**.

## Local offline replay

The locally verified Build Week profile archive runs without an Incan compiler, package manager, source checkout, network connection, or API key. The following download fields remain blocked until an exact archive is published.

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

```text
[FINALIZE BEFORE RELEASE: COPY-PASTE DOWNLOAD AND SHA-256 VERIFICATION COMMANDS FOR EACH SUPPORTED PLATFORM]
```

Do not run an artifact whose digest differs from the published value.

### 2. Launch

```text
[FINALIZE BEFORE RELEASE: EXACT PLATFORM-SPECIFIC COMMAND THAT STARTS `hees-console` IN DEFAULT REPLAY MODE]
```

The initial view must identify Console `0.1.0`, profile `console_profile_0_1`, mode `REPLAY`, the fictional package, and the active scenario. The dedicated manifest and trace inspectors expose runner, schema, and replay-integrity identities. Offline startup must not ask for an API key or silently access the network.

### 3. Run the required scenarios

| Key | Scenario | Expected trusted result | What to inspect |
| --- | --- | --- | --- |
| `1` | Declared action with reviewed, rights-allowed evidence and admitted memory | `ADMITTED` / `console_admission_0_1` / `admitted` | Visible units, distinct evidence and memory identifiers, observations, Hees-classified findings, structural reason, selected memory, Content DNA, receipt |
| `2` | Undeclared action | `REJECTED` / `console_admission_0_1` / `unknown_action` | The untrusted proposal remains inspectable, but no trusted answer, selected memory, or Content DNA appears |
| `3` | Unknown evidence | `REJECTED` / `console_admission_0_1` / `unknown_evidence` | A schema-valid evidence identifier that the package never declared cannot acquire authority |
| `4` | Unknown memory | `REJECTED` / `console_admission_0_1` / `unknown_memory` | The untrusted proposal remains inspectable, but no trusted answer, selected memory, or Content DNA appears |
| `5` | Known but non-admitted memory | `REJECTED` / `console_admission_0_1` / `memory_not_admitted` | The package-owned memory exists but cannot be selected into a trusted answer |

Replay fixtures do not store terminal results. To establish that the real runner executed, compare the displayed runner identity and receipt or Content DNA values with **[FINALIZE BEFORE RELEASE: RELEASE GOLDEN OUTPUT AND RUNNER-INTEGRITY TEST URL]**. A replay-digest check proves fixture integrity, not GPT provenance.

### 4. Inspect the trust boundary

The following checks are more important than the wording of the fictional answer:

- `UNTRUSTED PROPOSAL` is visually and textually separate from `ADMITTED` or `REJECTED`.
- Relation and synthesis observations contain bounded integer scores, while the resulting classifications are shown as `HEES-CLASSIFIED NON-AUTHORITATIVE FINDINGS`.
- Training by Committee presents separately role-bound observations as proposal pressure tests; Hees validates complete coverage, classifies the findings, and decides without a provider-majority vote.
- The provider does not supply the finding classification, terminal action, selected memory, Content DNA, or receipt.
- An admitted response shows every and only the canonical package memory referenced by the admitted support mappings.
- Experimental Console Content DNA binds the admitted visible units, package and policy identity, terminal decision, and selected package-owned memory without reproducing source or answer prose in the provenance entries.
- The profile receipt contains terminal governance identity but excludes provider, model, build, replay, observation, and finding-detail metadata.
- Replay mode remains visibly labelled in every view and exported run record.
- Rejected model text stays inside the escaped untrusted inspection view and never appears as a trusted answer.

## Optional live GPT-5.6 test

Live mode is optional for judges. It requires network access, an OpenAI API key with available quota, and an explicit selection that remains visibly labelled `LIVE`. Never paste a key into an issue, log, screenshot, fixture, command argument, or exported artifact.

1. Set `OPENAI_API_KEY` in the environment using your platform's secret-safe method.
2. Start live mode with **[FINALIZE BEFORE RELEASE: EXACT DOCUMENTED LIVE-MODE COMMAND OR INTERACTION]**.
3. Ask **[FINALIZE BEFORE RELEASE: EXACT FICTIONAL LIVE CANARY QUESTION]**.
4. Confirm that the Console identifies model `gpt-5.6-sol`, displays a strict structured untrusted proposal and bounded observations, and sends the complete normalized bundle to the same runner identity used by replay.
5. Confirm that provider refusal, timeout, rate limit, malformed structured output, or incomplete observation coverage produces a typed fail-closed state and never silently substitutes replay values under a live label.
6. Remove the environment credential after the test.

**Verified live canary:** **[FINALIZE BEFORE RELEASE: DATE, COMMIT, MODEL AND CONFIGURATION FINGERPRINTS, CANARY RESULT, AND PUBLIC EVIDENCE URL]**.

Until that field is replaced, live operation remains an intended release capability rather than a verified claim. The adapter is designed against the official [GPT-5.6 Sol model](https://developers.openai.com/api/docs/models/gpt-5.6-sol) and [structured outputs](https://developers.openai.com/api/docs/guides/structured-outputs) documentation.

## Source verification for contributors

The current checked library remains Hees `0.0.1` and uses released Incan `0.4.0`:

```bash
make ci
```

That command verifies formatting, the public library build, package and runtime tests, an external consumer, the fictional example, the repository boundary, the documentation build, native Console tests, and release-contract tests. Focused Console verification is available now:

```bash
make console-test console-native-smoke \
  INCAN=/path/to/incan-0.4.0/bin/incan

make console-release-candidate \
  INCAN=/path/to/incan-0.4.0/bin/incan \
  RELEASE_PLATFORM=macos-aarch64
```

**Green verification evidence:** **[FINALIZE BEFORE RELEASE: LOCAL COMMAND TRANSCRIPT SUMMARY AND GITHUB CI URLS AT THE RELEASE COMMIT]**.

## Expected limitations

- `console_profile_0_1` has only `admit` and `reject`; it does not implement repair, clarification, escalation, or all Draft response lifecycle states.
- The fictional package demonstrates one bounded original lesson-support domain. It is not a general ingestion, retrieval, vector-search, RAG, or package-authoring system.
- The current executable does not create a model-generated atom candidate. Its optional comparison inspector reports `not_configured` and `package_effect=none`; frozen candidate and comparison contracts exist for later profile use but cannot affect the current admission path.
- This profile exercises only a bounded proposal-pressure-testing slice of the permanent Training by Committee workflow. It is not model-weight training or fine-tuning. Role-bound live-provider observations remain non-authoritative; Hees classifies findings and decides, and no provider majority or vote can select the terminal result. Replay uses neutral observation fixtures rather than a provider recording.
- Experimental `console_content_dna_0_1` does not establish full RFC 002 conformance, and `console_profile_receipt_0_1` is not RFC 006-compatible.
- Offline replay proves deterministic operation over integrity-checked fixture inputs. It does not prove live GPT provenance, provider availability, or live language quality.
- Supported local platforms are limited to those with published and smoke-tested release artifacts; **[FINALIZE BEFORE RELEASE: EXACT UNSUPPORTED OR UNTESTED PLATFORMS]**.

## Troubleshooting without weakening the boundary

| Symptom | Safe response |
| --- | --- |
| Digest mismatch | Stop and download the asset again from the published release; do not bypass verification. |
| Unsupported platform | Use the hosted sandbox or a documented supported artifact; do not infer support from source portability. |
| Replay integrity failure | Treat the fixture as invalid; do not run or display a stored fallback decision. |
| Runner unavailable or malformed response | Show a typed host failure; do not fabricate a Hees rejection or admission. |
| Missing API key | Stay in explicitly labelled replay mode or configure live mode deliberately; do not ask judges to expose a credential. |
| Live timeout, refusal, rate limit, or malformed output | Fail closed under the documented typed state; do not relabel replay as live. |
| Hosted session expired | Start a fresh bounded session using **[FINALIZE BEFORE RELEASE: HOSTED RESTART INSTRUCTION]**. |

## What a successful test establishes

A successful offline judge run establishes that the published executable can rerun the four frozen scenarios through the real Incan-authored Build Week profile and expose that profile's exact trust boundary without rebuilding the project. It does not establish that the fictional answer is true, that provider observations are correct, that source rights exist beyond declared fixture state, that the permanent Console workflow is implemented, or that the limited artifacts conform to the complete Draft RFC suite.
