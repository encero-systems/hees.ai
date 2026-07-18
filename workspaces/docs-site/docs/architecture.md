# Architecture

The kernel has one public Incan library boundary and four focused internal modules:

```text
external implementation
  -> package descriptor shape -> package_loader.incn
  -> in-memory package + proposal -> runtime.incn
  -> closed initial profile + Spectrum composition -> console_profile.incn
  -> Content DNA and receipt envelope sealing -> content_dna.incn
  -> checked public exports -> lib.incn
```

The external implementation owns concrete domain content, model execution, retrieval, package authoring, and source-rights work. Hees owns the generic structural kernel and the deterministic authority decisions implemented by the closed initial console profile.

A proposal is untrusted. It becomes admitted only after the runtime verifies that:

1. the supplied runtime package is structurally valid;
2. package and domain identifiers match;
3. the proposal contains visible output;
4. the requested action is declared by the package; and
5. each cited evidence identifier refers to an approved, rights-allowed record in the package.

The public Incan library contains no storage engine, retrieval engine, or package-authoring control surface. The native Console is also authored in Incan and imports existing terminal and HTTPS crates only at explicit platform boundaries. The Hees profile owns package and proposal validation, digest checks, finding classification, terminal policy, selected memory, Content DNA, and receipts.

## Implemented console-profile flow

The experimental `console_profile_0_1` implements one complete acceptance path with fixed fictional domain constraints:

1. validate the closed package, request, and untrusted proposal;
2. construct exact verifier targets and bind their canonical digests;
3. validate complete relation and synthesis observation coverage;
4. classify observations and apply package-owned policy in fixed public-reason precedence;
5. delegate structural authority to the generic runtime kernel;
6. freeze the selected admitted memory;
7. construct Content DNA and the admitted receipt, or a redacted rejection receipt after identity is safely established; and
8. expose the answer only in the same terminal result as those artifacts.

The released Incan module topology is intentionally one-way: `content_dna.incn` seals closed envelope bodies, while `console_profile.incn` owns composition. Authority-bearing Content DNA and receipt types and constructors remain internal. The root library exposes only canonical terminal projections; Console renders those results without reconstructing authority.

## Proposed governed-runtime architecture

The Draft RFC series defines a broader target. The initial console profile now implements a deliberately narrow acceptance slice, not the complete generalized architecture. [RFC 000](https://github.com/encero-systems/hees.ai/blob/main/rfcs/000-foundational-governance-authority.md) establishes the authority model: packages own reviewed knowledge and policy, providers nominate bounded values, Spectrum makes the terminal decision, and admitted visible answers carry Content DNA.

[Spectrum](https://github.com/encero-systems/hees.ai/blob/main/rfcs/001-spectrum-terminal-adjudication.md) is the single terminal adjudication boundary. It composes the direct trusted results of package, memory, constraint, verification, behavior, and response contracts without letting any individual provider or evaluator decide the outcome.

[Content DNA](https://github.com/encero-systems/hees.ai/blob/main/rfcs/002-content-dna-answer-time-provenance.md) is the mandatory answer-time provenance artifact. Hees constructs it from every and only the reviewed memory selected by Spectrum, then returns it atomically with the admitted answer.

The [Spectrum and Content DNA whitepaper](whitepapers/spectrum-and-content-dna.md) explains the rationale and deployment implications. The RFCs remain the normative source for proposed contracts, while [Contracts](contracts.md) and `src/lib.incn` remain the source of truth for implemented behavior.
