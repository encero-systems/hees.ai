# Spectrum and Content DNA

## Status

This whitepaper explains the architectural intent behind Spectrum and Content DNA. The working `console_profile_0_1` release now exercises a bounded Spectrum operation, selected-memory finality, answer-time Content DNA, and receipts over one fictional profile. The generalized contracts continue in [RFC 000](https://github.com/encero-systems/hees.ai/blob/main/rfcs/000-foundational-governance-authority.md), [RFC 001](https://github.com/encero-systems/hees.ai/blob/main/rfcs/001-spectrum-terminal-adjudication.md), and [RFC 002](https://github.com/encero-systems/hees.ai/blob/main/rfcs/002-content-dna-answer-time-provenance.md).

## The problem is authority, not only generation

A language model can produce useful explanations, but fluent generation does not establish that an answer follows reviewed knowledge, respects policy, handles conflicting material consistently, or can be traced to the exact sources that governed it. Retrieval alone does not solve this problem. A retrieved passage is a nomination: it may be relevant without supporting the answer, may be outdated or rights-restricted, and may conflict with another reviewed source.

Hees separates language generation from governance. Packages contain reviewed knowledge and policy. Providers nominate bounded results. The model proposes visible language. Hees validates those inputs and applies deterministic contracts. Spectrum owns the terminal decision, while Content DNA records the exact reviewed memory selected for the admitted answer.

This separation matters most when the deployment must behave consistently across different models, providers, languages, and devices. The model can change without silently acquiring authority over policy or provenance.

## Spectrum

Spectrum is the Hees adjudication core that turns admitted governed inputs into one terminal outcome. It does not generate content and does not author policy. It applies the policy and reviewed memory already admitted from a package, composes bounded non-authoritative findings, resolves declared conflicts, selects the memory that may govern the response, and chooses the final response path.

The word terminal is important. A retrieval provider may rank memory, a verifier may score a claim-premise relationship, a constraint evaluator may nominate an action, and a behavior selector may choose an eligible frame. None of those intermediate results can admit an answer. Spectrum is the single point at which those results become one governed decision.

Spectrum preserves several distinctions that conventional orchestration often collapses:

- Retrieved memory is not automatically selected memory.
- Selected memory is not the same as every premise examined by a verifier.
- A verifier finding is not a policy action.
- A behavior selection is not response admission.
- A trace is not an authority capability.
- A receipt is not proof of unrestricted truth.

For an admitted answer, Spectrum freezes the exact ordered selected-memory set and the complementary discarded-memory set. This terminal selection is the source from which Hees constructs Content DNA.

## Content DNA

Content DNA is answer-time provenance. It binds one terminal answer to every and only the reviewed governed-memory atoms selected by Spectrum, together with their source-safe provenance, review state, rights state, package identity, governing policy, proposal identity, and Spectrum decision.

It is not a list of model-authored citations. It is also not a copy of a build-time source manifest. A package authoring system can know where reviewed memory came from, but it cannot know which memory a future live answer will use. A model can name sources, but it cannot author its own provenance authority. Only Hees has both the admitted package facts and the terminal Spectrum selection required to construct the answer-specific value.

Content DNA contains identifiers, governance state, source-safe references, and canonical digests rather than source passages or answer prose. The visible answer is bound by digest, and authorized applications can resolve the source-safe references independently. This avoids creating a second content channel while still making the relationship deterministic and auditable.

## The governed flow

The proposed runtime flow is:

1. A package-authoring system compiles reviewed knowledge, policy, source-safe provenance, rights state, and acceptance fixtures into a governed package.
2. Hees admits the exact package artifact and establishes its trusted identity.
3. A retrieval provider nominates logical memory identifiers under a package-approved binding.
4. Hees validates the complete retrieval result and materializes package-owned memory rather than trusting provider-returned text.
5. A model proposes bounded behavior and visible response values through the declared provider contract.
6. Verifiers and other evaluators return bounded observations for exact governed targets.
7. Spectrum applies package policy, resolves the response lifecycle, and freezes the terminal selected-memory set.
8. Hees constructs and validates Content DNA from the selected package-owned memory.
9. The admitted visible answer and Content DNA are returned atomically; if provenance construction fails, the answer is not admitted.
10. Export-safe receipts or traces may explain the outcome without becoming a second terminal authority.

An implementation may fuse internal stages to reduce allocation or latency, but it cannot change the authority flow or expose a partial answer before terminal provenance succeeds.

## Why Content DNA is more than a receipt

A governance receipt records a terminal outcome in a compact, redacted form. It can identify the proposal, package, terminal variant, reason, and admitted logical identifiers. Content DNA answers a narrower but deeper question: which reviewed memories, from which source-safe provenance and under which governing identity, made this particular answer admissible?

The two artifacts therefore remain separate. An admitted proposal receipt references the Content DNA identifier. The Content DNA document carries the selected-memory provenance. Neither artifact recreates the direct in-process Spectrum authority merely because its canonical digest verifies.

## Conflict and uncertainty

Reviewed sources may disagree, apply to different periods, or carry different authority. Spectrum does not solve this by asking a model to improvise a compromise. Contradictions and policy conflicts must enter through typed package declarations or accepted bounded findings. Package policy determines whether the result may answer with qualification, must request clarification, must reject, or may escalate.

Content DNA then reflects the memory actually selected under that policy. It must not include every retrieved source merely to appear comprehensive, and it must not omit a selected source because that source complicates the explanation. Exact coverage makes disagreement auditable without exposing private deliberation or hidden model reasoning.

## Multilingual behavior

Spectrum and Content DNA are language-independent governance responsibilities. English, Afrikaans, isiZulu, Arabic, or another language may change the model, tokenizer, speech layer, translated content, or verifier calibration, but it must not change who owns terminal authority or provenance.

Translated and language-specific memory still requires package review, rights state, source provenance, applicability, and policy identity. If multiple language variants resolve to one conceptual source, the package must declare that relationship explicitly rather than letting a model infer equivalence. Content DNA identifies the exact reviewed memory variant selected for the answer, which allows an application to explain whether the answer relied on original-language material, an approved translation, or another governed representation.

## Offline and constrained deployment

The authority model does not require a network service. Package admission, Spectrum adjudication, Content DNA construction, and receipt projection can run locally after installation. Provider execution can also remain local when a deployment supplies a compatible on-device model and retrieval implementation; Console `0.1.0` itself does not bundle that provider. Provider-neutral contracts keep those chosen components non-authoritative.

Consumer-device constraints still shape the detailed contracts. Memory counts, finding batches, canonicalization buffers, retained repair state, Content DNA entries, and traces require absolute bounds and representative measurements alongside the resident model. Low-memory implementations may stream or fuse internal work, but truncating Content DNA, dropping selected memory, or returning the answer before provenance completion is not an acceptable optimization.

## Profile authoring and Hees

Profile-authoring workflows own preparation: source intake, semantic transformation, human review, provenance compilation, rights and policy declarations, package construction, and acceptance suites. Those workflows may live in the local-first hees.ai console or another contract-compatible tool. Hees owns authority-bearing validation and runtime behavior: package admission, provider-result validation, Spectrum adjudication, response admission, and Content DNA construction.

That boundary keeps runtime behavior portable. Different authoring surfaces can produce the same accepted profile contract, and another Hees implementation can consume it, without changing who decides the live outcome. Authoring tools may generate synthetic expected Content DNA for fixtures, but Hees must recompute the live value from the terminal selected memory.

## Current proof and assurance direction

The working profile makes testable claims today: authority is explicit, provider outputs remain bounded nominations, terminal behavior follows admitted policy, admitted answers have exact selected-memory provenance, and independent implementations can be checked against the same contracts.

The larger Hees direction adds semantic and factual verification, source and claim provenance, rights assurance, producer identity, conflict management, governed behavior, and richer response lifecycles to this foundation. Those assurance layers require explicit contracts and evidence. They are not replaced by a digest or evaluator score, and they do not turn hidden model reasoning into authority.

## Normative map

- [RFC 000](https://github.com/encero-systems/hees.ai/blob/main/rfcs/000-foundational-governance-authority.md) defines the foundational authority model and invariants.
- [RFC 001](https://github.com/encero-systems/hees.ai/blob/main/rfcs/001-spectrum-terminal-adjudication.md) defines Spectrum inputs, memory roles, deterministic adjudication, terminal decision, and trace boundary.
- [RFC 002](https://github.com/encero-systems/hees.ai/blob/main/rfcs/002-content-dna-answer-time-provenance.md) defines Content DNA states, body, entries, exact coverage, canonical identity, validation, and receipt relationship.
- Later RFCs define governed memory, constraints, package artifacts, receipts, verifier findings, behavior envelopes, and visible-response lifecycle as specialized contracts under that foundation.
