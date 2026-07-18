# Hees Console submission finalization checklist

This checklist was reconciled against the [OpenAI Build Week Official Rules](https://openai.devpost.com/rules) on July 18, 2026. The rules can change and remain authoritative. Recheck them on the day of submission.

Nothing in this document confirms that Hees Console has been released, hosted, recorded, submitted, or tested in live GPT-5.6 mode. Placeholders are blockers, not evidence.

## Public link and evidence matrix

| Submission claim or requirement | Public evidence needed | Final link or value |
| --- | --- | --- |
| Public licensed repository | Repository at frozen revision; Apache-2.0 license; third-party notices | **[FINALIZE BEFORE RELEASE: REPOSITORY, COMMIT, LICENSE, AND NOTICE URLS]** |
| Meaningful Build Week extension | Dated July 13–21 commit range and public implementation/review PRs that distinguish prior work | **[FINALIZE BEFORE RELEASE: COMMIT RANGE AND PR URLS]** |
| Codex collaboration | Timestamped Codex evidence, dated commits, and README lineage | **[FINALIZE BEFORE RELEASE: CODEX EVIDENCE AND README URLS]** |
| Majority core-functionality task | Codex `/feedback` Session ID | **[MANUAL INPUT REQUIRED: SESSION ID]** |
| Working Incan-authored decision path | Runner source, generated artifact identity, integration tests, and valid/adversarial run evidence | **[FINALIZE BEFORE RELEASE: SOURCE, TEST, CI, AND RUN URLS]** |
| Bounded Training by Committee slice | Target derivation, complete observation coverage, Hees classification, and authority-negative tests | **[FINALIZE BEFORE RELEASE: SOURCE, TEST, AND RUN URLS]** |
| Optional live GPT-5.6 | Secret-gated `gpt-5.6-sol` canary reaching the same runner, with model/configuration identity and public result | **[FINALIZE BEFORE RELEASE: LIVE CANARY URL OR EXPLICIT `NOT VERIFIED`]** |
| No-rebuild judge path | Hosted sandbox or functioning test build, supported platforms, clean-system smoke test, access window | **[FINALIZE BEFORE RELEASE: TEST URL, PLATFORM MATRIX, SMOKE TEST, AND DATES]** |
| Release integrity | Tag, immutable commit, asset names, SHA-256 values, provenance, dependency licenses | **[FINALIZE BEFORE RELEASE: RELEASE, HASH, PROVENANCE, AND LICENSE URLS]** |
| Product behavior | Frozen golden outputs for valid action, undeclared action, and exact scenario `3` | **[FINALIZE BEFORE RELEASE: GOLDENS, TESTS, AND RUN URLS]** |
| Product design | Frozen screenshots, narrow and monochrome checks, terminal-escaping tests | **[FINALIZE BEFORE RELEASE: IMAGE AND TEST URLS]** |
| Public demo video | Approved public YouTube video under three minutes with clear English audio | **[MANUAL INPUT REQUIRED: PUBLIC YOUTUBE URL]** |
| Testing instructions | Public `TESTING.md` at the frozen revision with exact judge steps | **[FINALIZE BEFORE RELEASE: TESTING URL]** |
| Green release gates | CI at the frozen commit, artifact smoke tests, publication-boundary audit | **[FINALIZE BEFORE RELEASE: CI, ARTIFACT, AND AUDIT URLS]** |
| Devpost entry | Submitted project page containing the approved fields and links | **[MANUAL INPUT REQUIRED AFTER SUBMISSION: DEVPOST PROJECT URL]** |

## Freeze gates before recording

- [ ] The implementation slices have returned and an evidence-based completion audit has passed against the exact release candidate.
- [ ] The valid and adversarial scenarios rerun through the compiled Incan-authored runner; replay files contain no stored terminal result.
- [ ] Scenario `3` has one frozen label, input condition, namespace, public reason, golden output, and test link.
- [ ] The release artifact has passed a clean-system, no-rebuild smoke test on every claimed platform.
- [ ] The hosted or test-build path invokes the frozen artifact, exposes no unrestricted shell, isolates sessions, and is scheduled to remain free and unrestricted through August 5, 2026 at 17:00 PDT.
- [ ] Optional live GPT-5.6 claims are backed by a public canary, or every live claim is narrowed to an unverified optional adapter and the video uses replay only.
- [ ] CI, artifact hashes, provenance, dependency notices, supported platforms, and release links all identify the same frozen commit.
- [ ] Screenshots and video surfaces contain no credentials, personal data, personal paths, private repositories, private packages, hidden prompts, raw provider metadata, unrestricted rationale, or unrelated work.
- [ ] The Devpost draft, video script, captions, README, testing instructions, and release notes agree on capabilities, limits, scenario values, and lineage.

## Official-rules reconciliation

### Eligibility and ownership

- [ ] The entrant is an eligible adult resident of an API-supported country and is not subject to an exclusion in the official rules.
- [ ] If a team or organization enters, it has appointed an eligible, authorized representative.
- [ ] The submission is original and owned by the entrant, team, or organization; all code, dependencies, images, fonts, music, services, data, and other materials are licensed or used with permission.
- [ ] The entrant has confirmed that the financial or preferential-support exclusions do not apply.

### Project and lineage

- [ ] The frozen project uses both Codex and GPT-5.6 and fits the selected Developer Tools category.
- [ ] It installs and runs consistently on every claimed platform and behaves exactly as described and shown.
- [ ] Public documentation separates pre-July-13 Hees and Incan work from the meaningful extension built during the July 13–21 submission period.
- [ ] Dated commits, PRs, and Codex evidence support that distinction, and the entry asks judges to evaluate only the event-period extension.

### Required submission material

- [ ] The English text description explains the frozen product's features and functionality without claiming semantic truth, release readiness, live success, or full Draft RFC conformance beyond the evidence.
- [ ] The selected category is Developer Tools.
- [ ] The public YouTube video is shorter than three minutes, has clear English audio, demonstrates the working project, and explains the use of Codex and GPT-5.6.
- [ ] The video contains no unlicensed third-party trademarks, copyrighted music, or other material.
- [ ] The submission supplies a public, properly licensed repository URL. If the final repository is private instead, it has been shared with both addresses named in the official rules.
- [ ] The README explains how Codex accelerated the workflow, the human product, engineering, and design decisions, and the roles of GPT-5.6 and Codex.
- [ ] The submission contains the `/feedback` Session ID for the task in which the majority of core functionality was built.
- [ ] As a Developer Tools entry, it includes installation instructions, verified supported platforms, and a judge path that does not require a rebuild.

### Testing and submission

- [ ] A website, functioning demo, or test build is available free of charge and without restriction for the entire judging period, ending August 5, 2026 at 17:00 PDT.
- [ ] The signed-out/incognito judge path works from the public links without access to development credentials or a private account.
- [ ] Every submission material is in English or has the required English translation.
- [ ] The final form is submitted before July 21, 2026 at 17:00 PDT. Do not rely on post-deadline edits; the official rules permit only narrow exceptions.
- [ ] The submitted Devpost page, YouTube video, repository, release, hosted path, and testing instructions remain available and mutually consistent.

## Danny-only manual actions

These are the only account-bound or personal actions reserved for Danny. The repository work should prepare everything else for direct review.

1. Confirm entrant type, eligibility, ownership, and—if entering as a team or organization—the authorized representative.
2. Run Codex `/feedback` in the task where the majority of core functionality was built and supply **[MANUAL INPUT REQUIRED: SESSION ID]**.
3. Approve the frozen title, tagline, Developer Tools category, claims, limitations, screenshot set, and final spoken script.
4. Record or approve the final release-candidate demo, upload it publicly to YouTube, verify it while signed out, and supply **[MANUAL INPUT REQUIRED: PUBLIC YOUTUBE URL]**.
5. Confirm the no-rebuild test path and its free availability through the end of judging, including any account-bound hosting control.
6. Review the final Devpost draft in the entrant account, populate the representative/account fields, submit before the official deadline, verify the public project page while signed out, and supply **[MANUAL INPUT REQUIRED: DEVPOST PROJECT URL AND SUBMISSION CONFIRMATION]**.

## Final publication-boundary scan

Before release and again before submission, search the frozen repository, history, release artifact, screenshots, video frames, captions, logs, and public descriptions for:

- credentials, tokens, email addresses beyond the official testing addresses, environment values, provider headers, and request identifiers;
- absolute or home-directory paths, usernames, device names, private URLs, and private repository references;
- proprietary product names, client material, private corpora, downloaded models, unpublished research, hidden prompts, and chain-of-thought;
- unsupported claims such as “submitted,” “production ready,” “live GPT-5.6 verified,” “semantically true,” or “fully RFC/Spectrum compliant”; and
- placeholder markers including `FINALIZE`, `MANUAL INPUT`, `TODO`, `TBD`, and example domains or hashes presented as final values.

Any finding is a release blocker until it is removed, replaced with verified public evidence, or explicitly narrowed in the final copy.
