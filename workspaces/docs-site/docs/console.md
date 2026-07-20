# hees.ai console

hees.ai console is the terminal-first, local-first development environment for governed AI. It begins with evidence and ends with an inspectable decision: developers create and validate reusable governance profiles, pressure-test material and proposals through Training by Committee, run live or saved interactions, and inspect Spectrum, selected memory, Content DNA, receipts, and traces.

The product is provider-neutral and domain-neutral. A Console profile declares the exact evidence, memory, rights, actions, requirements, policy, evaluator roles, bounds, terminal behavior, and artifacts available in one governed context.

The current executable implements `console_profile_0_1` over one original fictional lesson-support package. It provides a bounded session-local Profile Studio plus the complete interaction path; the fixture and optional provider do not define the permanent product.

> **GPT-5.6 proposes. Hees decides.** This line describes the optional live adapter in the initial profile. GPT-5.6 supplies structured, untrusted proposals and non-authoritative observations; the Incan-authored Hees profile validates the complete interaction and selects the terminal result.

## What the current profile does

The native workspace follows the product's governed-development sequence:

1. **Profiles** shows the shipped active profile beside the session-local candidate, including actions, requirements, policy, staged evidence and memory, and validation state.
2. **Evidence** exposes the fictional source and evidence catalog with exact identity, fingerprint, language, source span, review, rights, and provenance state.
3. **Memory** distinguishes reviewed atoms from known but non-admitted material.
4. **Committee** shows Hees-derived targets, bounded observations, Hees-classified findings, and profile-owned policy effects.
5. **Interactions** keeps replay or live input and the untrusted proposal visibly separate from the decision.
6. **Decisions** exposes Spectrum, selected memory, Content DNA, receipt, and trace. Discarded-memory comparison belongs to the permanent product direction rather than this bounded terminal projection.

In Evidence or Memory, a developer can stage or unstage a supported record in the candidate with `Space`, rerun the shipped acceptance interaction through the real Hees-owned boundary with `v`, and reset with `r`. Candidate validation keeps the stable contract reason separate from the profile-specific diagnostic: removing required evidence returns `invalid_package` and `invalid_package_atoms`. `a` demonstrates the authority boundary by leaving the candidate explicitly `candidate only — not active`; the current public profile does not expose a safe activation API, so UI state cannot replace the shipped active profile.

Offline replay is the zero-credential default transport. Each shipped replay contains an exact request binding, untrusted proposal, bounded observations, schema identities, and an integrity digest. It contains no stored decision, finding, selected memory, Content DNA, or receipt. Every replay invokes the real Hees profile again.

The full-screen Console keeps profile declarations, candidate state, source evidence, reviewed memory, proposal, support mappings, Hees-derived verifier manifest, provider observations, Hees findings, Spectrum result, selected memory, Content DNA, receipt, and non-authoritative execution trace in separate surfaces. Direct question and source text appear only in the interactive surface; headless output redacts them by default.

The optional live mode binds a question through Hees, sends a strict structured proposal request to the OpenAI Responses API, asks role-bound evaluators to inspect only the exact targets derived by Hees, and passes the normalized inputs through the same terminal profile. Replay supplies saved inputs rather than making provider calls. After transport-specific decoding, both modes enter identical validation, finding-classification, Spectrum, memory-selection, Content DNA, and receipt code. Live mode fails closed on missing credentials, provider failure, malformed output, excessive size or nesting, identity mismatch, and incomplete observation coverage; it never silently changes to replay while retaining a live label.

## Trust boundary

```text
fictional evidence -> candidate memory atoms
                              |
                  authorized review + rights declaration
                              |
                              v
                    reviewed memory atoms
                              |
                     governance profile
                              |
saved replay inputs ─┐        v
                    ├─> proposal + committee observations
live GPT-5.6 inputs ─┘        |
                              v
             compiled Incan-authored Hees profile
       validation -> findings -> bounded Spectrum
                              |
                governed terminal decision
                     /                  \
ADMITTED + selected memory + Content DNA + receipt   REJECTED + exact reason
```

Console owns presentation, bounded provider transport, replay loading, and session-local candidate state. It calls the public Hees profile directly and does not reconstruct terminal authority from JSON. Hees owns profile validation, package, request, proposal, manifest, finding, policy, Spectrum, selected-memory, Content DNA, and receipt behavior.

## Run offline

Once current-head assets are published, each release archive contains one native executable plus the project license, notice, third-party license report, and release manifest. The [current release gates](console-profile-0-1.md#current-release-gates) distinguish verified source behavior from downloadable artifact availability. After extracting a supported archive, launch the Console without a compiler, package manager, source checkout, network connection, or API key:

```bash
./hees-console
```

Keys `1` through `7` open Profiles, Evidence, Memory, Committee, Interactions, Decisions, and Help. In Evidence or Memory, use `↑` and `↓` to select a record, `Space` to stage or unstage it in the candidate, `v` to validate through Hees, `a` to test the explicitly blocked activation boundary, and `r` to reset. In Interactions, use `↑` and `↓`, or `j` and `k`, to move through the admitted and adversarial scenarios. Press `b` to collapse or expand the item rail and `q` to quit.

Search integrates tags into the free-text control. Press `/`, type a query, use `↑` and `↓` to highlight a tag, use `tab` to check or uncheck it, and use `ctrl-u` to clear the query. Interactive states use explicit text and stable symbols as complete signals without colour.

Headless mode evaluates one scenario and emits stable, control-free, privacy-redacted output:

```bash
./hees-console --headless --scenario valid
./hees-console --headless --scenario undeclared-action
./hees-console --headless --scenario unknown-evidence
./hees-console --headless --scenario unknown-memory
./hees-console --headless --scenario non-admitted-memory
```

## Run live

Live mode is explicit and requires `OPENAI_API_KEY`. The key is read only from the environment and is excluded from request bodies, arguments, output, traces, Content DNA, receipts, fixtures, and release artifacts.

```zsh
(
  read -rs "OPENAI_API_KEY?OpenAI API key: "
  print
  export OPENAI_API_KEY
  ./hees-console \
    --mode live \
    --question "What order should I use for the Lantern Path cards?"
)
```

The adapter uses model identifier `gpt-5.6-sol`, the provider-supported strict JSON Schema subset, low reasoning effort, bounded output tokens, a configured 15-second timeout per request, no tools, and sequential committee calls. Preflight permits one proposal call plus at most eight committee calls, so nine calls carry 135 seconds of aggregate configured timeout budget. That is not a global wall-clock ceiling because `ureq` 2.12.1 cannot interrupt DNS resolution. Each request body is limited to 65,536 UTF-8 bytes, and the adapter performs no retries. Provider availability is not required for offline replay.

### Live provider evidence

A native diagnostic verified the GPT-5.6 proposal leg; a six-call Training by Committee diagnostic then reused that recorded proposal and reached a real admitted Hees result. A combined run from the frozen release binary remains unproven, so offline replay is the judge and video path. The [sanitized local observation](https://github.com/encero-systems/hees.ai/blob/main/submission/evidence/live-gpt56-proposal-2026-07-20.json) and [repository testing guide](https://github.com/encero-systems/hees.ai/blob/main/TESTING.md) retain the exact timings, usage, harness boundary, and limitations.

## What this release proves—and where it leads

An admitted result proves that the frozen profile accepted the exact package, request, proposal, support mappings, complete observation set, package-owned finding policy, structural admission, selected-memory set, Content DNA construction, and receipt projection required by `console_profile_0_1`. The candidate workflow additionally proves that UI state cannot silently replace the active profile and that candidate changes reach a real Hees acceptance result with its stable public reason and exact profile diagnostic.

This is the foundation for semantic and factual verification, source and claim provenance, rights assurance, conflict management, governed behavior, richer Spectrum adjudication, and durable reusable profiles. Those later assurance layers require deeper contracts and evaluators; this release establishes the authority graph, evidence eligibility, selected-memory boundary, Content DNA path, and receipt model on which they can build.

The [Governance profiles guide](governance-profiles.md) explains the field-level package contract. The [initial-profile bounds and measurements](console-profile-0-1.md) page records enforced ceilings, verified local release-candidate measurements, supported evidence, and unresolved release gates. [RFC 010](https://github.com/encero-systems/hees.ai/blob/main/rfcs/010-hees-console.md) defines the permanent product contract.
