# Agent Instructions for Hees

Hees is an Incan-first governed-intelligence runtime. It turns evidence, reviewed memory, declared authority, policy, and evaluator requirements into executable governance profiles, then produces inspectable terminal decisions with selected memory, Content DNA, and receipts.

**The model proposes. Hees decides.** Nothing an LLM or other provider produces — content, candidate memory atoms, or evaluator observations — is trusted output on its own. Hees validates, classifies, and holds terminal authority.

## Key references

| Topic | Location |
| --- | --- |
| Project overview | [README.md](README.md) |
| Contributor workflow | [CONTRIBUTING.md](CONTRIBUTING.md) |
| Judge/reviewer test plan | [TESTING.md](TESTING.md) |
| RFC index and process | [rfcs/README.md](rfcs/README.md) |
| Security reporting | [SECURITY.md](SECURITY.md) |
| Build Week lineage/evidence | [BUILD_WEEK.md](BUILD_WEEK.md) |
| Incan agent rules (sibling repo) | [Incan `AGENTS.md`](https://github.com/encero-systems/incan/blob/main/AGENTS.md) |

## Boundaries

Hees is intentionally small. Do not add:

- Concrete domains, private corpora, model artifacts, or product control surfaces beyond the existing fictional Build Week package.
- Research spikes — there is no `__research__/` directory here; keep exploratory material out of the tracked tree entirely rather than adding one.
- Confidential information, credentials, personal data, raw source material, or content without documented redistribution rights.

Hees should be built in Incan, with Incan, and for Incan (dogfooding). Native Rust in this repo (`crossterm`, `unicode-width`, `unicode-segmentation`, `ureq`, declared under `[workspace.rust-dependencies]` in `incan.toml`) exists only for interop Incan cannot yet express directly — terminal rendering and HTTP for the console. Do not add new authored Rust merely because it is convenient; if a genuine Incan gap blocks you, reduce it to a minimal repro and link it to the owning Incan issue.

Do not run destructive git commands (`git checkout -- <path>`, `git restore <path>`, `git clean`, `git reset --hard`, `stash drop`, or equivalent) without explicit user approval that quotes the exact paths or commands.

## Workflow

1. Work on a branch named `<type>/<issue>-<slug>` (e.g. `chore/27-governed-effect-capabilities`).
2. New runtime capabilities and material public-contract changes start as an [RFC proposal](rfcs/README.md) issue, not a direct implementation PR.
3. Check the Incan toolchain version this repo expects before relying on a specific compiler behavior — `incan.lock` (`incan-version`) and `workspaces/hees-console/packaging/release-platforms.json` are the sources of truth, not any version number written in prose docs, which can drift.
4. Add positive **and** fail-closed negative tests for any contract change — a rejection path is as load-bearing as an admission path here.
5. Keep `src/lib.incn` exports deliberate and documented.
6. Run `make ci` from a clean checkout before treating work as done.

## Common commands

| Command | Purpose |
| --- | --- |
| `make fmt` | Format Incan source |
| `make lib` | Build the library |
| `make test` | Run library tests |
| `make consumer` | Build/check the external-consumer workspace |
| `make example` | Build/check the minimal governed-agent example |
| `make boundary` / `make boundary-self-test` | Boundary contract checks |
| `make docs` | Build docs |
| `make console-build` / `make console-test` | Build/test the hees-console workspace |
| `make console-native-smoke` | Native release smoke test |
| `make console-release-candidate` | Full release-candidate gate (contract test + console test + native smoke + license audit) |
| `make ci` | Full CI gate — run this before opening a PR |

## RFC process

RFCs live under `rfcs/` as `NNN-short-title.md`, numbered sequentially starting at `000`. Each RFC needs its own dedicated proposal issue (an umbrella issue may relate several RFCs but cannot substitute for one). Status lifecycle:

`Draft` → `Planned` → `In Progress` → `Implemented`, with `Rejected` and `Superseded` as terminal off-ramps.

- **Draft**: design/review in progress, unresolved questions allowed, no implementation plan yet.
- **Planned**: design accepted, no open questions, implementation not started.
- **In Progress**: implementation actually underway; a progress checklist may appear and must reflect real work.
- **Implemented**: merged, released, `Shipped in` records the actual release.

Until an RFC **and** its implementation are both merged, the README and checked public API remain the source of truth for what Hees actually implements — RFCs describe intent, not current state. RFCs must not contain private package contents, client material, raw corpora, credentials, local paths, model artifacts, or unpublished research results.

## Security

Report vulnerabilities through GitHub's private vulnerability-reporting feature for this repository, per [SECURITY.md](SECURITY.md) — never in a public issue with exploit details, credentials, or private package contents.

## PR checklist

- [ ] Branch named `<type>/<issue>-<slug>`.
- [ ] New capability or contract change has a merged/in-progress RFC, not just an implementation PR.
- [ ] Positive and fail-closed negative tests added for contract changes.
- [ ] `src/lib.incn` exports are deliberate and documented.
- [ ] `make ci` passes from a clean checkout.
- [ ] No confidential info, credentials, personal data, or undocumented-rights source material introduced.
- [ ] Public API or compatibility impact is explained in the PR description.
- [ ] No destructive git operations run without explicit, path-quoted user approval.
