# hees.ai console submission finalization checklist

This checklist was reconciled against the [OpenAI Build Week Official Rules](https://openai.devpost.com/rules) on July 21, 2026. The rules can change and remain authoritative. Recheck them immediately before final submission.

Nothing in this document confirms that hees.ai console has been released, hosted, recorded, submitted, or exercised through one combined live GPT-5.6 run from a frozen release binary. The native proposal and six-call live committee paths were observed in separate diagnostics and are recorded with their exact transport and compiler limitations; placeholders remain blockers, not evidence.

## Public link and evidence matrix

| Submission claim or requirement | Public evidence needed | Final link or value |
| --- | --- | --- |
| Public licensed repository | Repository at frozen revision; Apache-2.0 license; third-party notices | Confirm the release tag points to the merged `main` revision; link its Release assets and archive notices in the submission form. |
| Meaningful Build Week extension | Dated July 13–21 commit range and public implementation/review PRs that distinguish prior work | Cite [RFC foundation PR #10](https://github.com/encero-systems/hees.ai/pull/10), [Console RFC PR #15](https://github.com/encero-systems/hees.ai/pull/15), and [implementation PR #17](https://github.com/encero-systems/hees.ai/pull/17), then record the observed commit range privately. |
| Codex collaboration | Timestamped Codex evidence, dated commits, and README lineage | Cite the public implementation record and the Build Week lineage; add the `/feedback` Session ID only in Devpost. |
| Majority core-functionality task | Codex `/feedback` Session ID | Danny runs `/feedback` in the core task and enters the resulting account-bound Session ID in Devpost. |
| Working Incan-authored decision path | Runner source, generated artifact identity, integration tests, and valid/adversarial run evidence | Verify the tagged source, CI, golden runs, and release artifact agree before recording. |
| Working Profile Studio | Evidence and memory staging, real Hees.ai candidate acceptance probe, separate public reason and exact profile diagnostic, blocked activation, reset, and active-profile preservation | Capture and record this flow from the tagged artifact; retain run evidence in the private submission ledger. |
| Explained profile contract | Public field-level Lantern Labs package/profile guide with ownership and validation path | [Governance profiles guide](../workspaces/docs-site/docs/governance-profiles.md) and published documentation site. |
| Bounded Training by Committee slice | Target derivation, complete observation coverage, Hees.ai classification, and authority-negative tests | Verify tagged-source tests and a matching recorded run before recording. |
| Optional live GPT-5.6 | Secret-gated `gpt-5.6-sol` adapter reaching the same runner, with model/configuration identity and public result | [Sanitized local observation](evidence/live-gpt56-proposal-2026-07-20.json): the native proposal path passed separately in 8.34 seconds; a six-call native live committee completed in 40.06 seconds with zero retries and reached an admitted real-Hees.ai result; the combined frozen release-binary path remains unproven |
| No-rebuild judge path | Hosted sandbox or functioning test build, supported platforms, clean-system smoke test, access window | Publish a tested archive in the `hees-console-v0.1.0` Release and verify extracted replay smoke on every claimed platform. |
| Release integrity | Tag, immutable commit, asset names, SHA-256 values, provenance, dependency licenses | Verify the published Release's tag, `SHA256SUMS`, manifests, provenance, and notices against the tagged source. |
| Product behavior | Frozen golden outputs for valid action, undeclared action, and scenario `3` unknown evidence | Verify golden tests and recorded release-binary runs agree before publication. |
| Product design | Frozen screenshots, narrow and monochrome checks, terminal-escaping tests | Capture from the tagged artifact and attach the selected images to Devpost. |
| Public demo video | Approved public YouTube video under three minutes with clear English audio | Danny uploads it after artifact validation and verifies it while signed out. |
| Testing instructions | Public `TESTING.md` at the frozen revision with exact judge steps | Link the tagged version of [TESTING.md](../TESTING.md) from Devpost. |
| Public documentation | Locally built mdBook published from a clean `gh-pages` branch | Stage the documentation from the tagged source, record `SOURCE_COMMIT` in the generated site, and verify it while signed out. |
| Green release gates | CI at the frozen commit, artifact smoke tests, publication-boundary audit | Record the observed CI and release workflow URLs in the private submission ledger. |
| Devpost entry | Submitted project page containing the approved fields and links | Danny creates the entry in his individual account after every external link is verified. |

## Freeze gates before recording

- [ ] The implementation slices have returned and an evidence-based completion audit has passed against the exact release candidate.
- [ ] The valid and adversarial scenarios rerun through the compiled Incan-authored runner; replay files contain no stored terminal result.
- [ ] Evidence and Memory staging mutate real session-local candidate state, `v` invokes the Hees.ai acceptance probe, a rejected candidate cannot become active, and `r` restores the shipped profile.
- [ ] Replay and optional live mode are described as transports normalized into the same compiled validation, findings, Spectrum, memory-selection, Content DNA, and receipt path.
- [ ] Scenario `3` is frozen as `Unknown evidence reference`, namespace `console_admission_0_1`, public reason `unknown_evidence`, with a golden output and test link.
- [ ] The release artifact has passed a clean-system, no-rebuild smoke test on every claimed platform.
- [ ] The functioning test build remains free and unrestricted through August 5, 2026 at 17:00 PDT. If a hosted equivalent is also claimed, it invokes the frozen artifact, exposes no unrestricted shell, and isolates sessions.
- [ ] Every live claim distinguishes the separately proven native proposal and six-call live-committee diagnostics from the unverified combined frozen release-binary path; the video uses replay for the product demonstration.
- [ ] CI, artifact hashes, provenance, dependency notices, supported platforms, and release links all identify the same frozen commit.
- [ ] The mdBook was built locally, scanned for private values and placeholders, published to `gh-pages` without relying on Actions, and verified while signed out.
- [ ] Screenshots and video surfaces contain no credentials, personal data, personal paths, private repositories, private packages, hidden prompts, raw provider metadata, unrestricted rationale, or unrelated work.
- [ ] The Devpost draft, video script, captions, README, testing instructions, and release notes agree on capabilities, limits, scenario values, and lineage.

### Manual Pages publication

The publisher is intentionally separate from documentation generation and has no default remote or branch. From a clean frozen checkout, stage the already scanned site into a new external directory, then publish it only with an explicit flag:

```bash
make docs-pages-stage PAGES_OUTPUT=/absolute/empty/hees-pages-stage
make docs-pages-publish \
  PAGES_OUTPUT=/absolute/empty/hees-pages-stage \
  PAGES_REMOTE=origin \
  PAGES_BRANCH=gh-pages
```

The command verifies the staged `SOURCE_COMMIT`, checks that the source checkout is clean and at that exact commit, creates a temporary detached worktree from the current remote `gh-pages` tip, and performs a normal non-force push. It refuses a missing publication flag, a changed remote tip, missing branch, source mismatch, or unsafe staged tree. Verify the public site while signed out after it completes.

## Official-rules reconciliation

### Eligibility and ownership

- [ ] Danny Meijer is an eligible adult resident of an API-supported country and is not subject to an exclusion in the official rules.
- [ ] The submission is original and owned by the entrant, team, or organization; all code, dependencies, images, fonts, music, services, data, and other materials are licensed or used with permission.
- [ ] The entrant has confirmed that the financial or preferential-support exclusions do not apply.

### Project and lineage

- [ ] The frozen project uses both Codex and GPT-5.6 and fits the selected Developer Tools category.
- [ ] It installs and runs consistently on every claimed platform and behaves exactly as described and shown.
- [ ] Public documentation separates pre-July-13 Hees.ai and Incan work from the meaningful extension built during the July 13–21 submission period.
- [ ] Dated commits, PRs, and Codex evidence support that distinction, and the entry asks judges to evaluate only the event-period extension.

### Required submission material

- [ ] The English description distinguishes the structural and policy proof working in `console_profile_0_1` from the intended semantic, factual, provenance, and rights-assurance layers, without claiming that those later layers are complete.
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
- [ ] The submitted Devpost page, YouTube video, repository, release, no-rebuild test path, and testing instructions remain available and mutually consistent; include a hosted equivalent only if one is actually supplied.

## Danny-only manual actions

These are the only account-bound or personal actions reserved for Danny. The repository work should prepare everything else for direct review.

1. Confirm personal eligibility, ownership, and that the financial or preferential-support exclusions do not apply. Entrant type is already fixed as Danny Meijer, individual.
2. Run Codex `/feedback` in the task where the majority of core functionality was built and enter the resulting Session ID in Devpost.
3. Approve the frozen title, tagline, Developer Tools category, current-slice/product-direction language, screenshot set, and final spoken script.
4. After approving and merging PR #17, create the exact `hees-console-v0.1.0` tag on a commit contained in `main`, verify every Linux x86-64, macOS Apple Silicon, and macOS Intel asset and hash, and manually publish the approved Release. macOS artifacts are not Developer ID-signed and not notarized; linker ad-hoc signing may exist solely for local execution and conveys no publisher identity.
5. Record or approve the final release-candidate demo, upload it publicly to YouTube, and verify it while signed out.
6. Confirm the no-rebuild test path and its free availability through the end of judging, including any account-bound hosting control.
7. Review the final Devpost draft in Danny's individual entrant account, submit before the official deadline, and verify the public project page while signed out.

## Final publication-boundary scan

Before release and again before submission, search the frozen repository, history, release artifact, screenshots, video frames, captions, logs, and public descriptions for:

- credentials, tokens, email addresses beyond the official testing addresses, environment values, provider headers, and request identifiers;
- absolute or home-directory paths, usernames, device names, private URLs, and private repository references;
- proprietary product names, client material, private corpora, downloaded models, unpublished research, hidden prompts, and chain-of-thought;
- unsupported claims that this release is submitted, production-ready, live-verified, or already provides complete semantic, factual, provenance, rights, or generalized Spectrum/RFC assurance; and
- placeholder markers, unfinished notes, and example domains or hashes presented as final values.

Any finding is a release blocker until it is removed, replaced with verified public evidence, or explicitly narrowed in the final copy.
