# Console profile 0.1 bounds and evidence

`console_profile_0_1` is the first bounded implementation profile for hees.ai console. The exact label displayed by the executable is `BUILD WEEK 2026 IMPLEMENTATION PROFILE — console_profile_0_1`. The profile remains subordinate to the provider-neutral and domain-neutral product contract in Draft RFC 010.

## Enforced ceilings

The table records enforced implementation limits, not recommended permanent-product defaults. Byte limits count UTF-8 bytes. Text and identifier limits count Unicode characters unless a byte unit is stated explicitly.

| Surface | Enforced ceiling |
| --- | --- |
| Raw runner request | 262,144 bytes, one canonical JSON record, at most 16 nested JSON containers |
| Raw runner response | 65,536 bytes including the terminal line feed |
| Provider request body | 262,144 bytes |
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
| Provider committee | At most 22 sequential calls, each with a 15-second timeout; the deterministic worst-case timeout ceiling is 330 seconds |
| Selected memory | At most 3 atoms in this fixed package, with no duplicates |
| Content DNA | Every and only selected memory, therefore at most 3 entries for this profile |
| Receipt identifiers | At most 8 admitted evidence identifiers and 8 selected-memory identifiers; the fixed package narrows selected memory to 3 |
| Inspector rendering | At most 8 displayed list items per section, 240 characters per displayed prose value, and 1,200 characters for expanded Content DNA or receipt JSON |
| Retained interaction state | One package, request, proposal, manifest, observation set, finding set, terminal result, selected-memory set, receipt, Content DNA value, and non-authoritative trace; no durable persistence |

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

The archive packages the executable, Apache-2.0 project license, repository notice, the current platform build's generated third-party license report, and exact release manifest. The release-candidate gate rebuilds the native Console, runs 17 native tests and 14 provider tests, audits dependency licenses, checks for source-path and active credential leakage, verifies the archive checksum and layout, extracts it into a clean temporary directory, and reruns all five offline scenarios without an Incan compiler, source checkout, package manager, network service, or API key.

The timing measurement used Hyperfine `--shell=none` with five warm-up runs and fifty measured fresh processes. It is a warm filesystem-cache result and does not claim cold-boot latency. Peak resident memory came from macOS `/usr/bin/time -l`; the maximum is reported rather than the mean.

## Current release gates

The earlier immutable-source GitHub matrix built, extracted, and smoke-tested exact-head candidates on macOS ARM64, macOS x86-64, and Linux x86-64 with the then-pinned `0.4.0` compiler. Those results are historical candidate evidence for their source commit. The current source tree requires the commit-pinned Incan `0.5.0-dev.19` compiler and must produce a fresh three-platform matrix before any current support claim. A platform becomes judge-facing only when its exact audited artifact is published with its checksum, provenance, dependency notices, and test instructions. Windows and Linux ARM64 remain unsupported.

The live adapter and its injected network-free composition tests are implemented, but no successful public GPT-5.6 canary is recorded yet. Offline replay remains fully functional without that evidence. The required no-rebuild judge path can be satisfied by the published native test build. Any optional hosted equivalent must run the same prebuilt executable without exposing an unrestricted shell, credentials, unrelated files, or cross-session persistence.

The optional atom-comparison inspector is present and explicitly reports `not_configured` for the current interaction. Candidate-memory creation and Hees-derived comparison are permanent Console work, but their absence cannot affect the terminal profile path.

The profile does not claim general evidence intake, package authoring, retrieval, semantic truth verification, model-weight training, complete Spectrum conformance, complete Content DNA conformance, RFC 006 receipt compatibility, the complete RFC 009 response lifecycle, or a production operations surface.
