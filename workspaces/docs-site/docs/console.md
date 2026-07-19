# Hees Console

Hees Console is the permanent terminal-first, local-first developer product for building, validating, running, and inspecting governed AI systems. The product is provider-neutral and domain-neutral. A Console profile declares the exact contracts, capabilities, bounds, and failure behavior available in one release.

The current executable implements the deliberately bounded `console_profile_0_1`. It uses one original fictional lesson-support package to make the authority boundary visible without implying that the fixture, provider, or event profile defines the permanent product.

> **GPT-5.6 proposes. Hees decides.** This line describes the optional live adapter in the initial profile. GPT-5.6 supplies structured, untrusted proposals and non-authoritative observations; the Incan-authored Hees profile validates the complete interaction and selects the terminal result.

## What the current profile does

Offline replay is the zero-credential default. Each shipped replay contains an exact request binding, untrusted proposal, bounded observations, schema identities, and an integrity digest. It contains no stored decision, finding, selected memory, Content DNA, or receipt. Every replay invokes the real Hees profile again.

The full-screen Console keeps the fixed package, source evidence, optional atom-comparison state, proposal, support mappings, Hees-derived verifier manifest, provider observations, Hees findings, Spectrum result, selected memory, Content DNA, receipt, and non-authoritative execution trace in separate inspectors. Direct question and source text appear only in the interactive surface; headless output redacts them by default.

The optional live mode binds a question through Hees, sends a strict structured proposal request to the OpenAI Responses API, asks role-bound evaluators to inspect only the exact targets derived by Hees, and passes the normalized inputs through the same terminal profile. It fails closed on missing credentials, provider failure, malformed output, excessive size or nesting, identity mismatch, and incomplete observation coverage. It never silently changes to replay while retaining a live label.

## Trust boundary

```text
fixed fictional package + direct question
                    |
                    v
Incan-authored Console adapter
provider or replay -> untrusted proposal + non-authoritative observations
                    |
                    v
Incan-authored Hees profile
validation -> findings -> bounded Spectrum operation -> terminal result
                    |
                    v
ADMITTED + selected memory + Content DNA + receipt
or
REJECTED + exact public reason
```

Console owns presentation, bounded provider transport, replay loading, and interaction state. It calls the public Hees profile directly and does not reconstruct terminal authority from JSON. Hees owns package, request, proposal, manifest, finding, policy, Spectrum, selected-memory, Content DNA, and receipt behavior.

## Run offline

The release archive contains one native executable plus the project license, notice, third-party license report, and release manifest. After extracting a supported archive, launch the Console without a compiler, package manager, source checkout, network connection, or API key:

```bash
./hees-console
```

Use `1` through `5` to select the admitted and adversarial scenarios. The arrow keys or `h`, `j`, `k`, and `l` move between scenarios and inspectors, `enter` advances to the next inspector, and `q` quits. Headless mode evaluates one scenario and emits stable, control-free, privacy-redacted output:

```bash
./hees-console --headless --scenario valid
./hees-console --headless --scenario undeclared-action
./hees-console --headless --scenario unknown-evidence
./hees-console --headless --scenario unknown-memory
./hees-console --headless --scenario non-admitted-memory
```

## Run live

Live mode is explicit and requires `OPENAI_API_KEY`. The key is read only from the environment and is excluded from request bodies, arguments, output, traces, Content DNA, receipts, fixtures, and release artifacts.

```bash
OPENAI_API_KEY=... ./hees-console \
  --mode live \
  --question "What order should I use for the Lantern Path cards?"
```

The adapter uses model identifier `gpt-5.6-sol`, strict JSON Schema structured outputs, low reasoning effort, bounded output tokens, a fifteen-second per-call timeout, no tools, and sequential committee calls. Provider availability is not required for offline replay.

## What admission means

An admitted result proves that the frozen profile accepted the exact package, request, proposal, support mappings, complete observation set, package-owned finding policy, checked structural admission, selected-memory set, Content DNA construction, and receipt projection required by `console_profile_0_1`.

Admission does not prove semantic truth, factual correctness, universal claim support, source ownership, legal rights outside the declared package state, provider authenticity, model calibration, or remote attestation. Provider observations can be wrong; they remain bounded inputs that Hees validates and classifies.

The [initial-profile bounds and measurements](console-profile-0-1.md) page records the enforced ceilings, verified local release-candidate measurements, supported evidence, and unresolved release gates. [RFC 010](https://github.com/encero-systems/hees.ai/blob/main/rfcs/010-hees-console.md) defines the permanent product and the subordinate initial profile without treating either as complete implementation truth.
