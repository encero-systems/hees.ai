# Architecture

The kernel has one public Incan library boundary and two internal modules:

```text
external implementation
  -> package descriptor shape -> package_loader.incn
  -> in-memory package + proposal -> runtime.incn
  -> checked public exports -> lib.incn
```

The external implementation owns concrete domain content, model execution, retrieval, package authoring, and source-rights work. Hees owns only the generic contracts and structural decisions represented here.

A proposal is untrusted. It becomes admitted only after the runtime verifies that:

1. the supplied runtime package is structurally valid;
2. package and domain identifiers match;
3. the proposal contains visible output;
4. the requested action is declared by the package; and
5. each cited evidence identifier refers to an approved, rights-allowed record in the package.

There is deliberately no provider adapter, storage engine, network service, package-file parser, archive format, digest algorithm, retrieval engine, or Workbench control surface in the implemented Hees 0.0.1 boundary.

## Proposed governed-runtime architecture

The Draft RFC series defines a broader target without claiming that the target is already implemented. [RFC 000](https://github.com/encero-systems/hees.ai/blob/main/rfcs/000-foundational-governance-authority.md) establishes the authority model: packages own reviewed knowledge and policy, providers nominate bounded values, Spectrum makes the terminal decision, and admitted visible answers carry Content DNA.

[Spectrum](https://github.com/encero-systems/hees.ai/blob/main/rfcs/001-spectrum-terminal-adjudication.md) is the single terminal adjudication boundary. It composes the direct trusted results of package, memory, constraint, verification, behavior, and response contracts without letting any individual provider or evaluator decide the outcome.

[Content DNA](https://github.com/encero-systems/hees.ai/blob/main/rfcs/002-content-dna-answer-time-provenance.md) is the mandatory answer-time provenance artifact. Hees constructs it from every and only the reviewed memory selected by Spectrum, then returns it atomically with the admitted answer.

The [Spectrum and Content DNA whitepaper](whitepapers/spectrum-and-content-dna.md) explains the rationale and deployment implications. The RFCs remain the normative source for proposed contracts, while [Contracts](contracts.md) and `src/lib.incn` remain the source of truth for implemented behavior.
