# Architecture

<div class="hees-architecture-hero">
  <img src="assets/governed-runtime-authority-flow.png" alt="An amber untrusted proposal and cyan evidence lattice enter a central graphite and jade governed runtime, which emits separate jade admitted and crimson rejected structural outcomes.">
  <div class="hees-architecture-hero-copy">
    <span class="hees-eyebrow">The authority boundary</span>
    <strong>The model proposes.<br>The runtime decides.</strong>
    <p>Hees separates generated values, package declarations, policy evaluation, and the terminal decision so that a well-formed model response never becomes authoritative merely because it exists.</p>
  </div>
</div>

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
  <li><span>Input</span><strong>Package + request</strong><p>The checked fictional package supplies declared actions, reviewed and rights-allowed memory atoms, evidence identities, and integer policy thresholds. The request is integrity-bound before provider work begins.</p></li>
  <li><span>Proposal</span><strong>Untrusted structured value</strong><p>Offline replay or the optional GPT-5.6 adapter supplies visible response units, an action identifier, evidence references, and identifier-only support mappings. Schema validity does not grant authority.</p></li>
  <li><span>Committee</span><strong>Non-authoritative observations</strong><p>Hees derives exact relation and synthesis targets. Role-bound evaluators return bounded observations against those targets; they do not vote and cannot select the terminal result.</p></li>
  <li><span>Classification</span><strong>Hees findings + package policy</strong><p>Hees validates target identities and complete coverage, classifies observations, and applies the package-owned thresholds in fixed public-reason precedence.</p></li>
  <li><span>Adjudication</span><strong>Bounded Spectrum operation</strong><p>The profile reaches the checked structural runtime only after earlier validation succeeds. The profile's limited Spectrum operation then returns exactly `admit` or `reject` with a closed reason.</p></li>
  <li><span>Artifacts</span><strong>Selected memory + Content DNA + receipt</strong><p>An admission freezes the exact selected package memory and atomically constructs the experimental Content DNA and profile receipt. A rejection exposes its exact reason and a redacted rejection receipt when identity is safely established.</p></li>
</ol>

The Console renders the returned profile projection; it does not reconstruct authority from transport JSON. Offline replay stores requests, proposals, observations, schema identities, and an integrity digest, but it stores no decision, finding, selected memory, Content DNA, or receipt. Every replay reruns Hees.

## Training by Committee without provider authority

<div class="hees-committee-boundary">
  <div><span>Hees</span><strong>Derive targets</strong><p>Construct canonical subject and premise identities from the package, request, and proposal.</p></div>
  <div><span>Adapters</span><strong>Return observations</strong><p>Evaluate only the supplied targets and return bounded integer scores plus their exact target identities.</p></div>
  <div><span>Hees</span><strong>Validate and classify</strong><p>Reject identity drift or incomplete coverage, then derive findings under package-owned policy.</p></div>
  <div><span>Spectrum</span><strong>Select the terminal state</strong><p>Compose the admitted inputs and deterministic structural result. No provider majority or self-reported confidence can override this boundary.</p></div>
</div>

This initial profile exercises a bounded proposal-pressure-testing slice of the permanent Training by Committee design. It is not model-weight training, semantic truth verification, or complete RFC 001 Spectrum conformance.

## Kernel and application topology

The public Incan library has a small facade and focused internal modules. The native application is also authored in Incan and uses ordinary external crates only at genuine platform boundaries such as raw terminal I/O and HTTPS transport.

| Layer | Implemented owner | Responsibility |
| --- | --- | --- |
| Nominal identifiers | `identifiers.incn` | Bounded identifier, digest, and revision types with distinct public namespaces |
| Generic structural kernel | `runtime.incn` | Fail-closed package and proposal admission against declared actions and evidence |
| Initial governed profile | `console_profile_*.incn` | Request binding, manifest planning, observation validation, finding classification, policy precedence, selected memory, and terminal composition |
| Authority artifacts | `content_dna.incn` and profile artifact module | Internal construction and sealing of Content DNA and receipt envelopes |
| Public facade | `lib.incn` and `console_profile.incn` | Checked public types and functions without exporting authority-bearing constructors |
| Native product | `workspaces/hees-console` | Replay, optional provider adapter, responsive terminal state, rendering, and source-safe inspection |

Public contract identifiers are distinct Incan newtypes. A `PackageId` cannot be substituted for a `DomainId` merely because both carry the same spelling. Every symbolic identifier derives from a shared bounded `IdType`; digest and revision specializations enforce their own forms. The pinned compiler invokes validated-newtype construction during derived JSON deserialization, so malformed identifier text cannot inhabit a decoded typed contract. That is still only type validity: authority requires a separate declaration or admission check.

## What the terminal result establishes

| The implemented profile establishes | It does not establish |
| --- | --- |
| The exact input passed the profile's declared structural and policy gates | Semantic truth or universal factual correctness |
| The action and referenced support belong to the admitted package state | Source ownership beyond the package's declared rights state |
| Committee observations matched Hees-derived targets and complete coverage rules | Provider authenticity, calibration, consensus, or a vote |
| Selected memory is the exact package memory frozen into this terminal result | General retrieval quality or complete RAG verification |
| Content DNA and the receipt were constructed only for the permitted terminal path | Complete conformance with every Draft Spectrum, Content DNA, or receipt RFC |

## Permanent product north star

Draft RFC 010 places evidence intake and package creation before governed interaction. A future hees.ai console workspace should let a developer inspect lawful source evidence, create candidate memory atoms without pre-granting review or rights, validate package declarations through Hees, pressure-test them through provider-neutral committee roles, run governed interactions, and inspect terminal Spectrum and Content DNA artifacts. The current fixed fictional package is a subordinate implementation profile, not the permanent product boundary.

[RFC 000](https://github.com/encero-systems/hees.ai/blob/main/rfcs/000-foundational-governance-authority.md) owns the foundational authority model. [RFC 001](https://github.com/encero-systems/hees.ai/blob/main/rfcs/001-spectrum-terminal-adjudication.md) defines the proposed generalized Spectrum boundary. [RFC 002](https://github.com/encero-systems/hees.ai/blob/main/rfcs/002-content-dna-answer-time-provenance.md) defines answer-time Content DNA. The [Spectrum and Content DNA whitepaper](whitepapers/spectrum-and-content-dna.md) explains their intended relationship, while [Contracts](contracts.md) and `src/lib.incn` remain the source of truth for checked behavior.
