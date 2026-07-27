# Contracts

`src/lib.incn` is the complete checked public surface.

## External package descriptor

The descriptor API exports:

- `PackageLoaderDescriptor`
- `PackageLoaderValidation`
- `package_loader_descriptor`
- `validate_package_loader_descriptor`
- `package_loader_summary`

Despite the historical `Loader` name, this surface validates metadata only. It requires schema `0.1`, source kind `source_controlled_domain_package`, safe identifiers, and a repository-relative path ending in `package/domain.json`. It rejects traversal, dot segments, absolute paths, Windows drive forms, backslashes, and common embedded control characters. It does not call a filesystem API or establish that the referenced file exists.

## Runtime package

`GovernedPackage` contains a schema version, package and domain identifiers, a mission, action contracts, and evidence records. A deployable evidence record must be explicitly `RightsStatus.Allowed` and `ReviewStatus.Approved`; raw source text is not part of the model.

`validate_governed_package` rejects unsupported schema versions, unsafe or duplicate identifiers, missing missions or actions, unsafe source references, unapproved evidence, and evidence whose declared runtime rights are not allowed.

## Proposal admission

`ModelProposal` carries package/domain identifiers, a package-owned action identifier, visible output, and cited evidence identifiers. `admit_model_proposal` rejects invalid packages, identity mismatches, empty visible output, undeclared actions, missing required evidence, duplicate citations, and unknown citations.

Admission proves only those structural conditions. It does not prove factual correctness, semantic support, source ownership, licensing, cryptographic integrity, retrieval quality, model correctness, or policy completeness.

`AdmissionResult` records a terminal `RuntimeDecision`, a stable reason, cited evidence identifiers, and package errors. It contains no hidden reasoning or chain-of-thought.

## Initial console profile

`console_profile_0_1` is a separate, closed profile over the fictional Console acceptance corpus. It extends the generic runtime with one exact governed-development and interaction contract.

Its package contract is concrete: profile, package, domain and revision identity; exact source records and fingerprints; reviewed-memory atoms with source spans, provenance, review and rights state; permitted actions; visible-answer requirements; integer policy thresholds; evaluator roles and bounds; terminal reasons; selected-memory behavior; Content DNA; and receipt projection. The [Governance profiles guide](governance-profiles.md) maps those fields to the fictional Lantern Labs package and explains their authority owners.

The profile validates exact package, request-binding, and proposal identities; recomputes the package, provenance, request, proposal, manifest-target, Content DNA, and receipt digests; constructs the complete verifier manifest; validates exact observation coverage and fingerprints; and derives findings under package-owned basis-point thresholds. Provider observations remain non-authoritative inputs. The profile, not the provider-facing Console module, selects the public reason and terminal decision.

On the admitted path, the profile delegates structural checks to `admit_model_proposal`, freezes every and only the admitted package atoms referenced by the support mappings, constructs Content DNA from that ordered selection, and returns the visible units and provenance atomically. A rejected path exposes no visible units, selected memory, or Content DNA. Once the fixed package, request, and proposal identity are safely established, it returns a redacted rejection receipt; raw-contract, replay, package, request, and unsafe-proposal-identity failures return no receipt.

The native Incan Console calls the public profile directly. Its Profile Studio may stage or unstage supplied evidence and memory in a session-local candidate and invoke real profile validation, but the candidate remains non-active because this profile exposes no activation-authority API. The `console_runner_request_0_1` and `console_runner_response_0_1` schemas remain a bounded compatibility and diagnostic seam rather than the product's application boundary. Authority-bearing finding, Spectrum, evaluation, Content DNA, and receipt types stay internal; only their canonical terminal projection crosses the package ABI. Live mode accepts bounded provider-normalized inputs. Replay mode additionally binds the checked schema, model, configuration, prompt, and replay identities used by the fictional acceptance corpus. After decoding, both modes call the same authority path.

This first profile does not provide retrieval, a semantic verifier model, a general package compiler, or a stable production protocol. Its fixed counts, languages, source kinds, policy values, and fixture identities are deliberate acceptance-profile constraints.
