# Architecture

<div class="hees-architecture-hero">
  <img src="assets/governed-runtime-authority-flow.png" alt="An amber untrusted proposal and cyan evidence lattice enter a central graphite and jade governed runtime, which emits separate jade admitted and crimson rejected structural outcomes.">
  <div class="hees-architecture-hero-copy">
    <span class="hees-eyebrow">The authority boundary</span>
    <strong>The model proposes.<br>The runtime decides.</strong>
    <p>Hees turns evidence, reviewed memory, declared authority, and policy into executable governance profiles, then keeps generated values separate from the terminal decision.</p>
  </div>
</div>

## Evidence first, decision last

```text
source evidence -> candidate memory atoms -> reviewed memory atoms
                                                        |
                                                        v
                             candidate governance profile
                                                        |
                                  Training by Committee observations
                                                        |
saved replay inputs ─┐                                  v
                    ├─> compiled Hees profile -> bounded Spectrum
live model inputs ───┘                                  |
                                                        v
                         governed decision -> selected memory
                                                        |
                                          Content DNA -> receipt
```

The governance profile is the reusable product unit. It names the exact evidence catalog, reviewed memory, rights and review state, permitted actions, answer requirements, policy thresholds, evaluator roles, bounds, Spectrum behavior, terminal reasons, and receipt projection that apply to an interaction. A model may supply proposals and observations inside that space; it cannot write the space into existence.

The Build Week Profile Studio makes that distinction executable. Evidence and memory can be staged or unstaged in a session-local candidate and sent through the shipped acceptance interaction at the real Hees boundary. A rejected candidate probe cannot replace the shipped active profile. The [Governance profiles guide](governance-profiles.md) explains the complete contract through the fictional Lantern Labs fields.

## One boundary, three distinct roles

<div class="hees-authority-grid">
  <article class="hees-authority-card hees-authority-card-package">
    <span>01 · Declares</span>
    <h3>Governed package</h3>
    <p>Defines the admitted actions, reviewed memory, evidence identities, rights state, policy thresholds, and behavioral constraints available to one profile.</p>
  </article>
  <article class="hees-authority-card hees-authority-card-model">
    <span>02 · Proposes and observes</span>
    <h3>Models and adapters</h3>
    <p>Nominate bounded proposals or evaluator observations. Their values remain untrusted and non-authoritative even when they satisfy a strict transport schema.</p>
  </article>
  <article class="hees-authority-card hees-authority-card-hees">
    <span>03 · Decides</span>
    <h3>Hees runtime</h3>
    <p>Validates identity and structure, classifies observations under package-owned policy, selects the terminal Spectrum result, and emits only the artifacts permitted by that result.</p>
  </article>
</div>

This separation is the architectural invariant behind the public project. The provider cannot declare its own authority, a presentation host cannot reinterpret a rejection as an admission, and a receipt cannot substitute for the terminal decision that produced it.

## Implemented `console_profile_0_1` path

<ol class="hees-flow">
  <li><span>Profile</span><strong>Evidence + reviewed memory + declared authority</strong><p>The fictional package binds exact source identities, review and rights state, memory atoms, permitted actions, answer requirements, evaluator roles, and policy thresholds. The Profile Studio runs a candidate acceptance probe through Hees while protecting the active package.</p></li>
  <li><span>Request</span><strong>Integrity-bound question</strong><p>The active profile and direct question are bound before provider work begins, preventing later inputs from drifting to a different package or request.</p></li>
  <li><span>Proposal</span><strong>Untrusted structured value</strong><p>Offline replay or the optional GPT-5.6 adapter supplies visible response units, an action identifier, evidence references, and identifier-only support mappings. Schema validity does not grant authority.</p></li>
  <li><span>Committee</span><strong>Non-authoritative observations</strong><p>Hees derives exact relation and synthesis targets. Role-bound evaluators return bounded observations against those targets; they do not vote and cannot select the terminal result.</p></li>
  <li><span>Classification</span><strong>Hees findings + package policy</strong><p>Hees validates target identities and complete coverage, classifies observations, and applies the package-owned thresholds in fixed public-reason precedence.</p></li>
  <li><span>Adjudication</span><strong>Bounded Spectrum operation</strong><p>The profile reaches the checked structural runtime only after earlier validation succeeds. The profile's limited Spectrum operation then returns exactly `admit` or `reject` with a closed reason.</p></li>
  <li><span>Artifacts</span><strong>Selected memory + Content DNA + receipt</strong><p>An admission freezes the exact selected package memory and atomically constructs the profile-specific Content DNA and receipt. A rejection exposes its exact reason and a redacted rejection receipt when identity is safely established.</p></li>
</ol>

The Console renders the returned profile projection; it does not reconstruct authority from transport JSON. Offline replay stores requests, proposals, observations, schema identities, and an integrity digest, but it stores no decision, finding, selected memory, Content DNA, or receipt. Optional live mode supplies the same input classes through provider decoding. Both transports invoke identical compiled Hees behavior after normalization.

## Training by Committee without provider authority

<div class="hees-committee-boundary">
  <div><span>Hees</span><strong>Derive targets</strong><p>Construct canonical subject and premise identities from the package, request, and proposal.</p></div>
  <div><span>Adapters</span><strong>Return observations</strong><p>Evaluate only the supplied targets and return bounded integer scores plus their exact target identities.</p></div>
  <div><span>Hees</span><strong>Validate and classify</strong><p>Reject identity drift or incomplete coverage, then derive findings under package-owned policy.</p></div>
  <div><span>Spectrum</span><strong>Select the terminal state</strong><p>Compose the admitted inputs and deterministic structural result. No provider majority or self-reported confidence can override this boundary.</p></div>
</div>

This profile exercises a working proposal-pressure-testing slice of Training by Committee. It keeps evaluator roles bounded and non-authoritative while Hees derives targets, validates coverage, classifies observations, and decides.

## Kernel and application topology

The public Incan library has a small facade and focused internal modules. The native application is also authored in Incan and uses ordinary external crates only at genuine platform boundaries such as raw terminal I/O and HTTPS transport.

| Layer | Implemented owner | Responsibility |
| --- | --- | --- |
| Nominal identifiers | `identifiers.incn` | Bounded identifier, digest, and revision types with distinct public namespaces |
| Generic structural kernel | `runtime.incn` | Fail-closed package and proposal admission against declared actions and evidence |
| Initial governed profile | `console_profile_*.incn` | Request binding, manifest planning, observation validation, finding classification, policy precedence, selected memory, and terminal composition |
| Authority artifacts | `content_dna.incn` and profile artifact module | Internal construction and sealing of Content DNA and receipt envelopes |
| Public facade | `lib.incn` and `console_profile.incn` | Checked public types and functions without exporting authority-bearing constructors |
| Native product | `workspaces/hees-console` | Session-local Profile Studio, evidence and memory staging, candidate acceptance probing, replay, optional provider adapter, responsive terminal state, rendering, and source-safe inspection |

Public contract identifiers are distinct Incan newtypes. A `PackageId` cannot be substituted for a `DomainId` merely because both carry the same spelling. Every symbolic identifier derives from a shared bounded `IdType`; digest and revision specializations enforce their own forms. The pinned compiler invokes validated-newtype construction during derived JSON deserialization, so malformed identifier text cannot inhabit a decoded typed contract. That is still only type validity: authority requires a separate declaration or admission check.

## Current proof and product direction

| Working in this release | Direction enabled by the architecture |
| --- | --- |
| Exact source, review, rights, provenance, action, requirement, policy, and evaluator declarations are visible as one profile contract | General evidence intake, extraction, candidate-atom curation, governed activation, versioning, and durable IncQL-DB-backed workspaces |
| Candidate evidence and memory can change session-locally and reach a real Hees acceptance result without replacing the active profile | Reusable profile creation, validation, comparison, publication, and deployment across providers and domains |
| Hees binds requests, proposals, targets, observations, findings, and terminal artifacts to exact identities | Semantic and factual verification, claim-level support, source provenance, rights assurance, and conflict management |
| Training by Committee observations are target-bound and non-authoritative | Richer provider-neutral pressure testing of evidence, atoms, profiles, prompts, proposals, and policy |
| Spectrum, selected memory, Content DNA, and receipts run end to end for the bounded profile | Generalized Spectrum adjudication, complete Content DNA, governed response lifecycles, and durable governance receipts |

## Permanent product north star

RFC 010 places evidence intake and profile creation before governed interaction. The permanent Console will let developers inspect lawful source evidence, create candidate memory atoms without pre-granting review or rights, validate package declarations through Hees, pressure-test them through provider-neutral committee roles, run governed interactions, and inspect terminal Spectrum and Content DNA artifacts. The Build Week Profile Studio delivers the first working session-local portion of that workflow; the fictional package is its demonstration context, not its product boundary.

[RFC 000](https://github.com/encero-systems/hees.ai/blob/main/rfcs/000-foundational-governance-authority.md) owns the foundational authority model. [RFC 001](https://github.com/encero-systems/hees.ai/blob/main/rfcs/001-spectrum-terminal-adjudication.md) defines the proposed generalized Spectrum boundary. [RFC 002](https://github.com/encero-systems/hees.ai/blob/main/rfcs/002-content-dna-answer-time-provenance.md) defines answer-time Content DNA. The [Spectrum and Content DNA whitepaper](whitepapers/spectrum-and-content-dna.md) explains their intended relationship, while [Contracts](contracts.md) and `src/lib.incn` remain the source of truth for checked behavior.
