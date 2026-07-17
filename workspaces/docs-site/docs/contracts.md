# Contracts

`src/lib.incn` is the complete checked public surface.

## External package descriptor

The descriptor API exports:

- `PackageLoaderDescriptor`
- `PackageLoaderValidation`
- `package_loader_descriptor`
- `validate_package_loader_descriptor`
- `package_loader_summary`

Despite the historical `Loader` name, this surface validates metadata only. It requires schema `0.1`, source kind
`source_controlled_domain_package`, safe identifiers, and a repository-relative path ending in `package/domain.json`.
It rejects traversal, dot segments, absolute paths, Windows drive forms, backslashes, and common embedded control
characters. It does not call a filesystem API or establish that the referenced file exists.

## Runtime package

`GovernedPackage` contains a schema version, package and domain identifiers, a mission, action contracts, and evidence
records. A deployable evidence record must be explicitly `RightsStatus.Allowed` and `ReviewStatus.Approved`; raw source
text is not part of the model.

`validate_governed_package` rejects unsupported schema versions, unsafe or duplicate identifiers, missing missions or
actions, unsafe source references, unapproved evidence, and evidence whose declared runtime rights are not allowed.

## Proposal admission

`ModelProposal` carries package/domain identifiers, a package-owned action identifier, visible output, and cited evidence
identifiers. `admit_model_proposal` rejects invalid packages, identity mismatches, empty visible output, undeclared
actions, missing required evidence, duplicate citations, and unknown citations.

Admission proves only those structural conditions. It does not prove factual correctness, semantic support, source
ownership, licensing, cryptographic integrity, retrieval quality, model correctness, or policy completeness.

`AdmissionResult` records a terminal `RuntimeDecision`, a stable reason, cited evidence identifiers, and package errors.
It contains no hidden reasoning or chain-of-thought.
