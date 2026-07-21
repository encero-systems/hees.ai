# Console profile 0.1 bounds and evidence

`console_profile_0_1` is the first bounded implementation profile for hees.ai console. It combines a session-local Profile Studio over the supplied fictional evidence catalog with one complete governed-interaction path. The exact profile label remains `console_profile_0_1`. The authority architecture and profile contracts are designed for provider- and domain-neutral extension, while this release intentionally ships one fixed fictional domain and one optional GPT-5.6 adapter.

## Profile Studio contract

The release exposes one shipped active profile and one session-local candidate derived from it. Evidence and memory records may be staged or unstaged in the candidate, and `v` reruns the shipped acceptance interaction against that candidate through the real Incan-authored Hees boundary. Candidate validation exposes the stable public reason separately from the exact profile diagnostic; removing required evidence returns `invalid_package` and `invalid_package_atoms`. Candidate activation remains blocked as `candidate only — not active` because the public profile does not yet expose a safe activation-authority API. `r` resets the candidate to the shipped profile. No candidate change persists after exit or alters the active profile used by governed interactions.

## Enforced ceilings

The table records enforced implementation limits, not recommended permanent-product defaults. Byte limits count UTF-8 bytes. Text and identifier limits count Unicode characters unless a byte unit is stated explicitly.

| Surface | Enforced ceiling |
| --- | --- |
| Raw runner request | 262,144 bytes, one canonical JSON record, at most 16 nested JSON containers |
| Raw runner response | 65,536 bytes including the terminal line feed |
| Provider request body | 65,536 UTF-8 bytes |
| Provider response envelope | 131,072 bytes and at most 16 nested JSON containers |
| Structured proposal output | 32,768 bytes and at most 2,048 output tokens |
| Structured observation output | 8,192 bytes and at most 512 output tokens |
| Normalized proposal | 131,072 UTF-8 bytes after serialization |
| Request question | 512 characters and at least one non-whitespace character |
| Identifier | 128 characters using the closed lowercase identifier grammar |
| Source reference | 256 characters under the closed fictional-reference grammar |
| Package mission | 512 characters |
| Fixed package | Exactly 3 sources, 3 actions, and 4 atoms; 1 through 4 requirements |
| Source text | 4,096 characters per source |
| Atom content | 512 characters each for claim and guidance |
| Visible response | 1 through 8 ordered visible units, each at most 1,024 characters |
| Proposal evidence | At most 8 unique evidence identifiers |
| Unit requirements | 1 through 4 unique requirement identifiers per visible unit |
| Support mappings | Exactly one per visible unit and at most 8 total; at most 4 evidence identifiers per mapping |
| Verifier manifest | At most 22 targets: 17 relation or contradiction targets and 5 synthesis targets |
| Provider committee | The generic manifest can describe 22 targets, but live preflight permits at most 8 sequential committee calls and one proposal call; each request has a configured 15-second timeout, so 9 calls carry 135 seconds of aggregate configured timeout budget; this is not a global wall-clock ceiling because `ureq` 2.12.1 cannot interrupt DNS resolution |
| Selected memory | At most 3 atoms in this fixed package, with no duplicates |
| Content DNA | Every and only selected memory, therefore at most 3 entries for this profile |
| Receipt identifiers | At most 8 admitted evidence identifiers and 8 selected-memory identifiers; the fixed package narrows selected memory to 3 |
| Inspector rendering | At most 8 displayed list items per section, 240 characters per displayed prose value, and 1,200 characters for expanded Content DNA or receipt JSON |
| Retained workspace state | One shipped active profile, one session-local candidate with staged evidence and memory plus validation state, and one interaction containing request, proposal, manifest, observations, findings, terminal result, selected memory, receipt, Content DNA, and non-authoritative trace; no durable persistence |

The runner and provider reject excessive nesting before invoking a JSON parser. Closed typed decoding and canonical round-trip checks reject unknown or duplicate authority-bearing fields. A host may impose stricter platform limits but cannot raise Hees limits or truncate one input into a different valid value.

## Measured macOS ARM64 release candidate

The following measurements were recorded on 2026-07-19 from clean source commit `982932a095c3a61806b6032a74adb36d703e1925`, using released Incan `0.4.0` on macOS `26.5.2`, Apple M5 Max ARM64. They describe one local candidate and do not establish support for another platform. This snapshot is evidence for the measured implementation, not a substitute for the checksum sidecar of the eventual public release.

| Measurement | Observed value |
| --- | --- |
| Native executable | 6,159,184 bytes |
| Complete compressed archive | 2,364,971 bytes |
| Candidate archive SHA-256 | `3bfaa19d5ccc2e99457ab922add3b9b980e70aea5e42ea98c128fae211500ee3` |
| Valid headless report | 7,185 bytes with direct question and source text redacted |
| Warm-cache headless execution | 9.3 ms mean, 1.2 ms standard deviation, 7.7–13.7 ms range over 50 fresh processes |
| Peak resident set size | 5,603,328 bytes maximum across five fresh-process runs |
| Shipped package JSON | 6,891 bytes |
| Largest shipped replay JSON | 13,325 bytes |
| All five shipped replay JSON files | 22,276 bytes |

The historical measured archive packages the executable, Apache-2.0 project license, repository notice, that platform build's generated third-party license report, and exact release manifest. Its release-candidate gate rebuilt the native Console, ran 17 native tests and 14 provider tests, audited dependency licenses, checked for source-path and active credential leakage, verified the archive checksum and layout, extracted it into a clean temporary directory, and reran all five offline scenarios without an Incan compiler, source checkout, package manager, network service, or API key. The tagged release repeats the frozen suites and attaches its audited artifact results to the Release; those artifacts, rather than historical measurements, establish judge-facing claims.

The timing measurement used Hyperfine `--shell=none` with five warm-up runs and fifty measured fresh processes. It is a warm filesystem-cache result and does not claim cold-boot latency. Peak resident memory came from macOS `/usr/bin/time -l`; the maximum is reported rather than the mean.

## Current release gates

The earlier immutable-source GitHub matrix built, extracted, and smoke-tested exact-head candidates on macOS ARM64, macOS x86-64, and Linux x86-64 with the then-pinned `0.4.0` compiler. Those results are historical candidate evidence for their source commit. The tagged release uses its commit-pinned Incan `0.5.0-dev.23` compiler and establishes support only for platforms whose exact audited artifacts are published with checksums, provenance, dependency notices, and test instructions. Windows and Linux ARM64 remain unsupported unless a later tagged release adds equivalent evidence.

The live adapter and its injected network-free composition tests are implemented. A native provider-only diagnostic exercised the Incan credential loader, `ureq` HTTPS POST, accepted strict schema, product decoder, and typed proposal path successfully in 8.34 seconds. Separately, external `curl` submitted the exact product-generated request and supplies locally observed hashes, usage, and the exact decoded proposal. A second native diagnostic reused that proposal, preflighted exactly six Hees-derived targets, completed six sequential live GPT-5.6 committee calls in 40.06 seconds with zero retries, decoded three relation and three synthesis observations, and reached an admitted real-Hees result with six findings, selected memory, Content DNA, and a receipt. The committee diagnostic did not repeat the proposal call in the same process, retained no usage or cost record, and ran in a temporary generated harness rather than the frozen release binary. The [sanitized observation record](https://github.com/encero-systems/hees.ai/blob/hees-console-v0.1.0/submission/evidence/live-gpt56-proposal-2026-07-20.json) preserves the separate observations and their limitations without a credential, hidden prompt, raw reasoning, or provider response identifier. A combined proposal-plus-committee run from the frozen release binary remains unproven. Offline replay remains fully functional. The no-rebuild judge path is established only by the published tagged native test build. Any optional hosted equivalent must run the same prebuilt executable without exposing an unrestricted shell, credentials, unrelated files, or cross-session persistence.

The optional atom-comparison inspector remains separate from Profile Studio candidate staging and reports `not_configured` for the current interaction. It concerns model-generated atom comparison, not the session-local selection of supplied reviewed evidence and memory.

This release is the working foundation for general evidence intake, durable profile authoring, semantic and factual verification, source and claim provenance, rights assurance, richer Spectrum and Content DNA contracts, and broader governed-response lifecycles. Those later capabilities require deeper profiles; they are not implied by the bounded fictional package or its evaluator observations.
