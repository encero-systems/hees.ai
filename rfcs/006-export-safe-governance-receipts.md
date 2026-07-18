# RFC 006: Export-Safe Governance Receipts

- **Status:** Draft
- **Created:** 2026-07-17
- **Author(s):** Encero Systems
- **Related:**
    - RFC 000 (Foundational Governance Authority)
    - RFC 001 (Spectrum Terminal Adjudication)
    - RFC 002 (Content DNA Answer-Time Provenance)
    - RFC 003 (Governed Memory and Retrieval Results)
    - RFC 004 (Composable Governance Constraints)
    - RFC 005 (Canonical Package Artifact Admission)
    - RFC 009 (Governed Visible Response Lifecycle)
- **Issue:** https://github.com/encero-systems/hees.ai/issues/7
- **RFC PR:** —
- **Written against:** Hees 0.0.1 / Incan 0.4.0
- **Shipped in:** —

## Summary

Hees should privately project a terminal governed outcome into a closed, redacted `GovernanceReceiptBody`, canonicalize that body with the RFC 005 JCS profile, compute `receipt_id` as `sha256:<SHA-256 of the canonical body bytes>`, and atomically return the canonical envelope `{body, receipt_id}` from the governing operation itself. A proposal receipt references the exact RFC 002 Content DNA identifier when an admitted answer or package-authored clarification produces Content DNA. The receipt identifier proves deterministic content identity and integrity for the exported body. Only the direct return from that trusted Hees operation carries in-process authority; caller-reconstructed bytes do not, and an unsigned receipt does not prove Hees origin to an external verifier.

## Core model

1. **One canonical JSON profile.** Receipts reuse RFC 005's RFC 8785 JCS over I-JSON profile. They do not define another serializer.
2. **Non-circular body identity.** `GovernanceReceiptBody` excludes `receipt_id`. Hees hashes the canonical body bytes, then places the resulting identifier beside the body in a two-member envelope.
3. **Closed private projections.** Each governing Hees operation privately maps only allowlisted, structurally admitted fields from its result and returns result plus receipt atomically. There is no public result-to-body or body-to-authoritative-receipt constructor.
4. **Three separate claims.** The digest establishes body integrity; direct return from the trusted Hees operation establishes authority in that process and control flow; external producer authenticity requires a separately verified detached attestation.
5. **No implicit graph.** Core contract `0.1` contains no parent receipt, chain, nonce, wall-clock timestamp, signature, or attestation member.
6. **Content DNA remains distinct.** A proposal receipt may reference `content_dna_id`, but RFC 002 owns the Content DNA body, selected-memory provenance, answer binding, construction, and validation.

## Motivation

Hees 0.0.1 returns in-memory structural admission results but does not export receipts. External systems need compact deterministic records without gaining permission to copy prompts, model output, source text, local paths, provider payloads, or malformed input into something that appears authoritative.

Receipt identity is also easy to make circular or misleading. Hashing an envelope that contains its own identifier is circular; hashing an incomplete tuple creates collisions between materially different exported bodies; signing core fields without a key and trust contract confuses integrity with authenticity. A canonical body-first construction avoids those errors while keeping signatures and attestations separable.

RFC 003 assigns portable memory-receipt encoding and ownership to this RFC. The in-memory `MemoryAdmissionRecord` remains the complete runtime record, while Hees constructs a narrower export-safe body under one canonical receipt contract.

## Goals

- Define one exact JCS canonical body and envelope representation shared with RFC 005.
- Define non-circular `receipt_id` construction over the complete canonical body bytes.
- Define closed receipt kinds for package admission, memory admission, constraint adjudication, and proposal admission where their source contracts expose safe terminal data.
- Define exact safe mappings from governed results, including minimal pre-normalization failure receipts.
- Carry only safely established package identity, terminal decision/validity/action, stable reason namespace and identifier, ordered admitted evidence or memory identifiers, and governing evaluation time where already admitted.
- Identify a valid constraint execution through its admitted plan and bounded structural evaluated, substituted, skipped, primary, and conflict identifiers without exporting complete findings.
- Make body projection and receipt identifier construction private to each governing Hees operation, with one atomic result-and-receipt return rather than a public receipt-authoring API.
- Make rejected outcomes empty of arbitrary cited or provider-supplied identifiers.
- Define bounded allowlisted diagnostics without free-form values.
- Bind admitted-answer and package-authored-clarification proposal receipts to the exact atomically returned RFC 002 Content DNA identifier without embedding Content DNA entries.
- Separate receipt content integrity, authority within Hees processing, and producer authenticity outside the process.
- Require unknown receipt contracts, kinds, fields, reason namespaces, and versions to fail closed.

## Non-Goals

- Exporting raw evidence, reviewed memory content, visible answers, prompts, model output, provider bindings, relevance scores, nominations, source text, parser excerpts, filesystem paths, environment values, credentials, or authoring history.
- Proving semantic support, factual correctness, source rights, policy quality, human approval, or model behavior.
- Proving that an unsigned envelope originated from Hees, a particular device, a package author, or an operator.
- Defining embedded signatures, keys, certificates, attestations, transparency logs, receipt chains, parent links, graph traversal, revocation, or non-repudiation.
- Defining a second canonical format, digest algorithm negotiation, wall-clock creation time, random nonce, or process-local counter.
- Replacing RFC 002 Content DNA, embedding its source-safe entries, or claiming that a generic admitted-memory array provides answer-time provenance.
- Allowing package-authoring tools, providers, control planes, or device applications to author an authoritative Hees receipt. They may consume and verify receipts or carry detached attestations.
- Treating a caller-constructed body, a parsed envelope, or successful integrity verification as an authoritative in-process Hees outcome.
- Inventing receipt byte or member ceilings before they can be derived from accepted governing-contract bounds and measured fixtures.

## Guide-level explanation

This RFC describes a proposed public contract. Hees 0.0.1 does not construct, canonicalize, hash, export, or verify governance receipts.

After a governing operation reaches a terminal result, private Hees logic copies only fields allowed for that receipt kind, canonicalizes the complete body, computes the identifier, and returns the result and envelope together. Callers cannot submit a constructed result or body to a public exporter. RFC 009 now supplies the exact proposal source mapping; it remains proposed behavior until the coupled RFCs are accepted and implemented:

```incan
# Proposed atomic source-operation shape; not implemented in Hees 0.0.1.
outcome = govern_candidate_output(admitted_package, candidate)
println(f"receipt={outcome.receipt.receipt_id}")

# Public verification checks bytes and schema, not Hees-process authority.
verification = verify_governance_receipt(outcome.receipt.canonical_bytes)
```

Hees 0.0.1's `AdmissionResult` does not carry the complete RFC 005 artifact identity or a logical proposal identifier, so it is not a valid source for `ProposalAdmission`. RFC 009 defines the canonical bounded `proposal_id`, exact admitted package-artifact identity, seven original/repair/clarification/rejection terminal variants, 31 stable reasons, typed support projection, and terminal Content DNA presence required by this receipt kind. This RFC imports that source contract but does not claim the current runtime implements it. Proposal identity must never be derived by hashing visible output, support fields, hidden reasoning, or the complete untrusted request.

A memory receipt is a redacted projection rather than a serialization of the complete `MemoryAdmissionRecord`. A normalized accepted record exports the complete admitted package identity, evaluation time, envelope decision, provider state and typed provider reason, and ordered materialized memory identifiers. It omits the query, caller identifiers, provider binding, result nominations, ranks, and scores. A pre-normalization rejection maps to the minimal safe body and exports none of the malformed input.

Consumers recompute JCS bytes for `body`, hash those bytes, compare the exact `receipt_id`, and validate the closed kind schema. This proves that the exported body is internally self-consistent. Without a separately verified attestation, it does not prove who constructed the envelope.

## Reference-level explanation

### Canonical body and envelope

Receipt contract `0.1` must reuse the exact RFC 005 canonical governance JSON profile: RFC 8259 JSON, RFC 7493 I-JSON constraints, RFC 8785 JCS serialization, strict duplicate-name detection, Unicode preserved as-is, no floating point, exact safe integers, ordered arrays, closed schemas, and UTF-8 output.

`GovernanceReceiptBody` must not contain `receipt_id`, a body digest, a signature, or any self-reference. Hees must serialize the complete body with JCS and compute SHA-256 over those exact body bytes. The receipt identifier must be exactly `sha256:<64 lowercase hexadecimal characters>`.

`GovernanceReceiptEnvelope` must contain exactly two members:

- `body`, one closed `GovernanceReceiptBody`; and
- `receipt_id`, the exact digest identifier of the canonical body bytes.

The exported envelope bytes must themselves be the JCS serialization of that two-member object. Unknown envelope members, duplicate names, alternate digest forms, a body member named `receipt_id`, noncanonical body bytes, or noncanonical envelope bytes must fail verification.

The same complete body value must always produce the same canonical body bytes and receipt identifier. Different internal governed records may intentionally project to the same redacted body; `receipt_id` identifies the exported body, not every private input or internal record field.

### Common body fields

Every receipt body must contain exactly these common members:

- `receipt_contract`, exactly `0.1`;
- `receipt_kind`, one exact kind listed below;
- `terminal`, the closed kind-specific terminal object;
- `reason`, a closed object containing one exact `namespace` and one stable allowlisted `id` from the governing result;
- `admitted_evidence_ids`, an ordered array of canonical identifiers;
- `admitted_memory_ids`, an ordered array of canonical identifiers; and
- `diagnostic_codes`, an ordered array governed by the diagnostic rule below.

A kind may additionally require or permit only the kind-specific members declared below: `package`, `proposal_id`, `content_dna_id`, `evaluation_time_ms`, `constraint_plan`, `constraint_execution`, or `memory_state`. Inapplicable members must be absent rather than `null`. Unknown body members must fail closed.

Identifier fields must use the governing contract's explicit canonical grammar. Arrays must preserve governing-result order and must not contain duplicates. Receipt construction must never sort identifiers unless the governing result itself normatively defines that order.

When present, `content_dna_id` must use RFC 002's exact `sha256:<64 lowercase hexadecimal characters>` syntax and must be copied from the direct Content DNA envelope returned by the same atomic Spectrum operation. Receipt verification can validate its syntax and terminal presence rule, but it cannot prove that the referenced Content DNA body exists or matches a live Spectrum decision without receiving and separately verifying that body.

### Reason namespaces and diagnostics

The `reason.namespace` values for contract `0.1` must be exactly:

- `package_artifact_admission_0_1` for `PackageAdmission`;
- `memory_admission_0_1` for `MemoryAdmission`;
- `constraint_adjudication_0_1` for `ConstraintAdjudication`; and
- `proposal_admission_0_1` for `ProposalAdmission`.

The reason identifier must be one stable public reason defined by the exact governing contract and globally unique within its receipt reason namespace across all source stages and terminal variants. The body does not carry a separate source stage, so reusing one reason identifier for multiple stages or variants would make verification ambiguous and must fail the lifecycle gate. Private receipt projection must reject a free-form, unknown, provider-owned, parser-owned, or implementation-specific reason. Receipt verification confirms allowlist membership and its unique terminal mapping but does not reinterpret the reason.

RFC 005 defines the closed package-admission stage/reason vocabulary and precedence. RFC 003 defines exactly 40 globally unique Hees memory-admission reasons in its `memory_admission_0_1` namespace, RFC 004 defines exactly 27 globally unique Hees adjudication reasons in its `constraint_adjudication_0_1` namespace, and RFC 009 defines exactly 31 globally unique proposal reasons with seven terminal mappings in `proposal_admission_0_1`. Receipt construction and verification normatively import those complete source tables, their order, and their terminal mappings rather than inventing aliases or an independent compatibility vocabulary. A source-contract reason addition, removal, rename, reorder, or terminal remapping therefore requires coordinated receipt-contract review and cannot be accepted as an implementation-local extension.

Diagnostics may contain only stable codes from an exact receipt-safe allowlist owned by the governing contract and bounded there. The package, memory, constraint, and proposal source drafts define no non-primary export-safe diagnostic list, so `diagnostic_codes` must be empty in receipt contract `0.1`. Any non-empty value must fail closed. A future non-empty diagnostic contract requires explicit bounded codes and a new exact receipt contract version.

### Safely known package identity

The optional `package` object has one closed shape across all receipt kinds. When present, it must contain exactly:

- `package_id`;
- `domain_id`;
- `package_revision`; and
- `artifact_digest`, in RFC 005's exact `sha256:<64 lowercase hexadecimal characters>` form.

The object is all-or-absent. A receipt must never use a kind-specific subset, carry raw `package_fingerprint`, or treat package, domain, revision, and artifact digest as independently selectable fields. Under RFC 005, RFC 003/RFC 004 `package_fingerprint` is exactly the 64-lowercase-hexadecimal suffix of `artifact_digest`; receipt projection adds the one required `sha256:` prefix and computes no new hash.

The governing result must carry this complete identity from an RFC 005-admitted package. It must not be copied from an untrusted request, reconstructed from a package identifier alone, or filled with empty strings, hashes of rejected input, or caller-supplied fallback values. RFC 003 `Normalized` records and RFC 004 `Valid` results carry the complete trusted package identifier, domain identifier, package revision, and unprefixed artifact fingerprint from RFC 005 admission. Private projection adds only the fixed `sha256:` prefix. Their identity-free variants deliberately carry none of those fields. RFC 001 Spectrum proposal results carry the complete trusted package identity only under the exact RFC 009 safe-identity table below; the current Hees 0.0.1 proposal result remains outside this new source contract.

Package-object presence is exact:

| Receipt source outcome | `package` rule |
| --- | --- |
| RFC 005 `complete` / `admitted` | Required |
| Any RFC 005 rejection stage or reason | Absent |
| RFC 003 `Normalized` record | Required |
| RFC 003 `PreNormalizationRejected` record | Absent |
| RFC 004 `Valid` adjudication | Required |
| RFC 004 `Invalid` adjudication | Absent |
| RFC 009 `rejected_original_package_unavailable` before safe package identity | Absent |
| RFC 009 raw proposal bounds failure or invalid proposal identity | Required when an accepted evaluated package was supplied; otherwise absent |
| RFC 009 valid proposal identity with a mismatched claimed package reference | Required from the trusted evaluated package |
| Every later RFC 009 original outcome after safe proposal identity | Required |
| Every RFC 009 repair outcome from an authentic pending-repair capability | Required |

For proposal reasons after package validation, the package object identifies the trusted admitted package evaluated by Hees, never the proposal's possibly mismatched package claim. Unknown or partial package members must fail closed.

### Receipt kinds

This Draft defines exactly four kinds. Package, memory, constraint, and proposal mappings now have exact source reason vocabularies and identity rules. No kind enters an executable closed `0.1` verifier allowlist until its governing source contract, fields, and bounds are accepted and implemented.

#### PackageAdmission

`receipt_kind` must be `package_admission`. `terminal` must contain only `decision`, with value `accepted` or `rejected`. `reason.namespace` must be `package_artifact_admission_0_1`. Both admitted identifier arrays must be empty, and `evaluation_time_ms`, `constraint_plan`, `constraint_execution`, and `memory_state` must be absent.

The reason identifier must be one exact RFC 005 public reason and therefore maps to one exact RFC 005 stage. Only atomic `finish` at stage `complete` with reason `admitted` may use terminal `accepted` and carry the complete package object. Every other RFC 005 stage/reason must use terminal `rejected` and omit the package object. In particular, a digest that matches caller-supplied bytes, syntactically valid package fields, or validation that later reaches `manifest_bytes_noncanonical`, `member_bytes_noncanonical`, `member_missing`, or any other RFC 005 rejection does not establish an admitted package identity. Package receipt identity is never partial.

#### MemoryAdmission

`receipt_kind` must be `memory_admission`. `terminal` must contain only `envelope_admission`, with value `accepted` or `rejected`. `reason.namespace` must be `memory_admission_0_1`.

A normalized record must include the complete package object, `evaluation_time_ms`, and `memory_state` from RFC 003's trusted normalized record. `memory_state` must contain exactly `state` and `reason`. Canonical receipt strings are `complete`, `partial`, and `unavailable` for state, and `completed`, `capacity_limited`, `deadline_reached`, `provider_unavailable`, and `index_unavailable` for reason. The only valid pairs are the RFC 003 pairs: `complete` with `completed`; `partial` with `capacity_limited` or `deadline_reached`; and `unavailable` with `provider_unavailable`, `index_unavailable`, or `deadline_reached`.

An accepted `complete` or `partial` record may export exactly the ordered materialized identifiers as `admitted_memory_ids`. Accepted `unavailable` and every rejected record must export an empty memory array. Evidence identifiers must be empty.

An RFC 003 `PreNormalizationRejected` record must use the minimal safe form: rejected terminal decision, stable Hees reason, empty admitted and diagnostic arrays, no package, no evaluation time, and no memory state. It must not export raw or hashed malformed input, query text, caller identifiers, provider data, or a digest of the private in-memory record.

This mapping resolves RFC 003's canonical export ownership question: RFC 006 owns the JCS receipt-body projection, envelope, and identifier; Hees owns construction from `MemoryAdmissionRecord`; consumers own verification only. The exported receipt remains a redacted outcome projection and is not semantic proof for its admitted memory identifiers.

#### ConstraintAdjudication

`receipt_kind` must be `constraint_adjudication`. `terminal` must contain exactly `adjudication_validity` and `action`. Canonical receipt validity strings are `valid` and `invalid`; canonical action strings are `continue`, `revise`, `clarify`, `reject`, and `escalate`. An `invalid` terminal must use action `reject`. `reason.namespace` must be `constraint_adjudication_0_1`.

When adjudication validity is `valid`, the body must include the complete package object, admitted evaluation time, and a closed `constraint_plan` containing exactly `plan_id` and `plan_revision` copied from RFC 004's trusted valid result. It must also contain `constraint_execution`, a closed structural projection with exactly:

- `evaluated_ids`, copied in order from the source result;
- `substituted_ids`, copied in order from the source result;
- `skipped_ids`, copied in order from the source result;
- `conflicting_ids`, copied in order from the source result's conflicting constraint identifiers; and
- optional `primary_constraint_id`, present exactly when the source result has a primary constraint.

All five fields contain only canonical package-owned constraint identifiers, and every array must be duplicate-free. The evaluated, substituted, and skipped arrays must preserve the disjoint RFC 004 partition of the admitted plan. Conflicting identifiers must preserve source-result order and resolve within the effective evaluated-or-substituted identifiers. The optional primary identifier must match the source result exactly and likewise resolve within those effective identifiers. An `invalid` result must omit package, evaluation time, plan, and execution because RFC 004 does not treat its context or provisional execution as authoritative.

This structural subset distinguishes which plan revision ran, which definitions supplied validated findings or fail-closed substitutions, which definitions were skipped, which constraint was primary, and which named constraints conflicted. It intentionally omits complete effective findings and their generic support identifiers: those remain operator-trace or separately typed support data, and different private finding details may map to one receipt when this structural projection and terminal outcome are identical.

RFC 004 currently exposes generic support identifiers rather than export-safe evidence-versus-memory namespaces. Contract `0.1` must therefore export both admitted identifier arrays as empty for this kind. A later governing contract may export typed support only after it defines exact namespaces, admission semantics, order, and bounds.

#### ProposalAdmission

`receipt_kind` must be `proposal_admission`. It is not constructible from Hees 0.0.1 `AdmissionResult`; its sole source is the direct RFC 001 Spectrum terminal result carrying an exact RFC 009 governed visible-response variant. `terminal` must contain exactly `variant`, whose value is one of:

- `admitted_original`;
- `repair_requested_original`;
- `clarification_required_original`;
- `rejected_original`;
- `admitted_repaired`;
- `clarification_required_after_repair`; or
- `rejected_after_repair`.

`reason.namespace` must be `proposal_admission_0_1`. The reason identifier must be copied unchanged from RFC 009's exact 31-reason allowlist and must map to the terminal variant exactly as that source table defines. Receipt construction and verification must not accept the nine Hees 0.0.1 action-only reasons as aliases under this contract.

Package and proposal identity presence must follow this exact projection:

| RFC 009 source outcome | `package` | `proposal_id` |
| --- | --- | --- |
| `rejected_original_package_unavailable` before safe package identity | Absent | Absent |
| `rejected_original_bounds` at the raw proposal ceiling before safe proposal identity | Required when an accepted package was supplied; otherwise absent | Absent |
| `rejected_original_identity` caused by invalid or missing proposal identity | Required when an accepted package was supplied; otherwise absent | Absent |
| Valid proposal identity with a mismatched claimed package reference | Required from the trusted evaluated package | Required |
| Every later original outcome after safe proposal identity | Required | Required |
| Every repair outcome from an authentic pending-repair capability | Required | Required |

When present, `proposal_id` must come unchanged from RFC 009's trusted logical proposal identity. It must never be a digest or transformation of visible output, support mappings, candidate identity, hidden fields, or malformed input. The package object must always identify the trusted RFC 005 package evaluated by Hees, never the proposal's claimed package tuple.

Only `admitted_original` and `admitted_repaired` may export support. For those variants, `admitted_evidence_ids` and `admitted_memory_ids` must exactly equal RFC 009's ordered, duplicate-free, typed first-visible-use projections. Every repair-requested, clarification, and rejected variant must export both arrays as empty even when some identifiers were structurally valid during evaluation.

The admitted and clarification variants must contain `content_dna_id` copied unchanged from the RFC 001 atomic terminal result. Admitted variants reference an RFC 002 `admitted_answer` body; clarification variants reference an RFC 002 `no_answer` body. Repair-requested and rejected variants must omit `content_dna_id`. Receipt construction must not recompute the identifier from receipt fields, accept it from the candidate, or emit it when the corresponding Content DNA envelope was not returned atomically.

Proposal receipts must omit `evaluation_time_ms`, `constraint_plan`, `constraint_execution`, and `memory_state`. They must not contain Content DNA entries or bodies, attempt indexes, visible answer units, support mappings, candidate identifiers or digests, requirements, clarification data, repair data, verifier findings or scores, traces, provider fields, or hidden reasoning. `diagnostic_codes` must be empty.

### Minimal safe failure body

When a governing operation fails before input normalization or safe package identity, Hees must construct the minimal body for the known receipt kind. It contains only the common members, the kind's rejected or invalid terminal object, one Hees-owned stable reason, and empty admitted and diagnostic arrays. Every optional kind-specific member must be absent.

The minimal body must not contain raw malformed input or a hash of that input. It must not contain caller identifiers, package guesses, paths, parser messages, provider fields, environment values, source text, model output, or timestamps. Different unsafe inputs may intentionally map to the same minimal body and therefore the same receipt identifier.

### Evaluation time

`evaluation_time_ms` may appear only when the governing normalized contract already admits a caller-supplied evaluation time: normalized `MemoryAdmission` and valid `ConstraintAdjudication`. It must exactly equal that governed value and remain within the governing safe-integer and temporal rules.

### Rejected outcomes and admitted identifiers

Private receipt projection must copy only identifiers the governing result structurally admitted. It must never copy raw requested, cited, nominated, retrieved, or provider-returned identifiers merely because they were present in input.

Rejected memory and RFC 009 proposal outcomes export no admitted identifiers. RFC 009 repair-requested and clarification outcomes likewise export empty support arrays; only admitted original or repaired outcomes export its exact typed projection. Clarification may still reference a zero-entry RFC 002 no-answer Content DNA value, which is not an admitted support claim. Package receipts have no admitted evidence or memory identifiers. Constraint receipts export neither admitted evidence nor admitted memory identifiers until typed support namespaces exist; their separate structural constraint-execution identifiers do not claim semantic support. Future governing contracts may permit identifiers on another non-admitted terminal outcome only when the result explicitly marks those exact identifiers admitted independently from the terminal action.

### Private atomic receipt emission

A receipt-enabled governing operation must construct and return its terminal result and receipt atomically. Its public input is the operation's governed input, never a caller-constructed terminal result or `GovernanceReceiptBody`. Body projection, canonicalization for authorship, identifier construction, and creation of the in-process authoritative receipt value must remain private to Hees.

Within that private completion path, Hees must:

1. Select the receipt kind from the terminal governed result, never from caller input.
2. Validate that the result is eligible for that kind and exact governing contract version.
3. Project only the closed allowlisted fields, applying minimal-safe-failure rules where required.
4. Validate the body schema, reason namespace and identifier, canonical identifiers, Content DNA presence and identity, order, duplicates, governing bounds, and absence of forbidden fields.
5. Serialize the complete body with the RFC 005 JCS profile.
6. Compute SHA-256 over the exact canonical body bytes and format the exact `receipt_id`.
7. Construct the two-member envelope, serialize it with the same JCS profile, and return it beside the terminal result from the same trusted operation.

There must be no public `receipt_body(result)`, `export_receipt(body)`, or equivalent operation that upgrades caller-constructible data into an authoritative Hees receipt. If the private projection cannot safely map the terminal result, the receipt-enabled operation must fail with the fixed local code `receipt_emission_failed` and expose neither a partial receipt nor a separately returned terminal result through that atomic API. That error must contain no result fields, input echo, parser text, body, or nested cause, and it must not recursively produce another receipt.

### Receipt verification

A consumer must enforce the contract-defined envelope byte ceiling before parsing, then parse with duplicate detection, validate the exact envelope and body schemas, re-canonicalize the body, recompute and compare `receipt_id`, and re-canonicalize and byte-compare the complete envelope. Unknown fields, versions, kinds, reason values, non-empty diagnostics, noncanonical bytes, and digest mismatch must fail closed. Public verification may return validated receipt content and an integrity verdict, but it must not return or claim the in-process authoritative receipt value reserved for direct governing-operation output.

Verification proves internal content integrity only. It does not prove that Hees constructed the body, that the fields came from a real governed operation, or that admitted identifiers semantically support an answer.

### Authority, integrity, and authenticity

- **Content identity and integrity:** JCS body bytes plus matching `receipt_id` identify the exported body and detect body changes.
- **Authority inside Hees processing:** Only the direct atomic return from the trusted governing Hees operation carries authority for that operation in the running process and control flow. External components may not substitute their own fields or decisions.
- **External authenticity:** An unsigned envelope is self-consistent data, not proof of Hees origin. A verifier needs a separately trusted and verified attestation that references the receipt identity.

Signatures and attestations must remain detached from the core `0.1` envelope. No signature, key identifier, certificate, attestation, or issuer field is permitted in the body or envelope. A future attestation contract may reference `receipt_id`, but its trust roots, algorithms, key lifecycle, and verification semantics require separate design.

Receipt schemas, canonical body bytes, envelope bytes, and identifiers remain independently reproducible so consumers can verify them across runtimes. That reproducibility is an integrity property only. Recreating byte-identical data locally never recreates the in-process authority of the original direct operation return.

### No receipt chaining

Contract `0.1` must not contain `parent_receipt_id`, `previous_receipt_id`, child identifiers, chain position, ancestry, or arbitrary related-receipt arrays. Receipt chaining is omitted because bounded acyclicity, missing-parent behavior, redaction, and cross-kind semantics are not established. Adding a chain requires a new exact contract with bounded acyclic semantics.

### Bounds

Every identifier and collection copied into a body must already satisfy its governing contract's accepted bound. Receipt construction must not widen those bounds. Fixed envelope overhead can be calculated once the closed schemas and governing limits are final.

This Draft does not invent an independent receipt-size ceiling. RFC 006 cannot advance to Planned until each receipt kind has a mechanically derived maximum member count and byte size from accepted governing-contract bounds, including RFC 005 artifact identity and RFC 009's typed proposal support projection. Verification must enforce those final values before parsing. No streaming guarantee is implied.

## Design details

### Relationship to RFC 000

RFC 000 distinguishes in-process authority from exportable explanation. This RFC defines the generic receipt boundary that preserves that distinction; canonical verification never upgrades a copied receipt into a live Hees capability.

### Relationship to RFC 001

Spectrum is the governing terminal source operation for proposal outcomes. This RFC privately projects its trusted source record into a redacted receipt and must not let callers assemble a terminal decision from receipt fields.

### Relationship to RFC 002

Content DNA is the dedicated selected-memory provenance artifact, while this RFC is the generic terminal receipt envelope. An admitted proposal receipt references the exact Content DNA identifier but does not duplicate Content DNA entries, source-safe provenance, or answer binding under receipt contract 0.1.

### Relationship to operator traces

A governance receipt is a stable redacted outcome projection. An operator trace may contain richer operational details under a separate privacy and retention boundary, but it must not be embedded in, appended to, or presented as part of the receipt.

Consumers may store, display, index, transmit, or verify a receipt. Reproducing canonical bytes for verification does not grant authority to claim that a locally assembled body came from Hees. External authenticity remains an attestation question.

### Relationship to RFC 009 and issue #11

RFC 009, arising from issue #11, owns the candidate-output input and terminal result contract: visible-answer fields, repair state, clarification state, canonical logical proposal identity, stable terminal variants and reasons, Content DNA presence, and which support identifiers are structurally admitted for each path. RFC 006 owns only the cross-kind redacted projection, canonical body and envelope bytes, receipt identifier, private atomic emission boundary, and generic verification rules.

RFC 009 defines no competing receipt encoding or public receipt-authoring path. RFC 006 does not invent candidate identity, infer terminal state, or decide which support survives projection. Both contracts must be accepted, their numeric bounds finalized, and their implementation completed before `ProposalAdmission` becomes executable.

### Compatibility evidence

JavaScript, Rust, and Incan consumers must share golden bodies, body bytes, receipt identifiers, envelope bytes, and verification outcomes. Golden fixtures must cover every finalized kind, the one all-or-absent package-identity shape, accepted and rejected outcomes, normalized and minimal memory failures, valid constraint execution partitions plus primary/conflict identity, invalid constraint omission, all seven RFC 009 proposal variants, exact proposal/package identity presence, admitted evidence and memory order, required admitted and clarification Content DNA identifiers, forbidden repair and rejection Content DNA identifiers, empty non-admitted support, empty diagnostics, Unicode preservation, and same-body/same-ID behavior. RFC 003, RFC 004, and RFC 009 fixtures must exercise every final globally unique Hees-owned reason and prove the same selected reason when multiple failures apply; verifier fixtures must reject every identifier outside those accepted allowlists.

Negative fixtures must cover duplicate names, unknown fields, unknown kinds and versions, receipt IDs inside bodies, digest mismatch, noncanonical body or envelope bytes, illegal evaluation time, partial or kind-specific package identity, mismatched artifact-digest/fingerprint projection, malformed constraint partitions, unknown or reordered constraint execution identifiers, execution data on an invalid adjudication, a reason reused across terminal variants, invented proposal identity, invented or mismatched Content DNA identity, forbidden Content DNA presence or absence, invented reasons, non-empty diagnostics, arbitrary cited identifiers on rejection, raw or hashed malformed input, provider/model fields, paths, environment values, embedded signatures, and chain members. API tests must prove that caller-constructed results or bodies cannot enter an authoritative receipt-authoring operation and that byte-identical reconstruction or successful public verification does not yield the in-process authority value.

## Alternatives considered

### Define a receipt-specific encoding

Rejected because RFC 005 already establishes the canonical governance JSON profile. A second encoding would create avoidable cross-runtime and security differences.

### Hash the complete envelope

Rejected because the envelope contains `receipt_id`, making whole-envelope self-identity circular. Hashing the complete body before adding the ID is unambiguous.

### Serialize the complete internal result

Rejected because internal records contain fields that are unnecessary or unsafe to export. Receipt bodies are closed redacted projections and may intentionally be many-to-one.

### Add a creation timestamp or nonce

Rejected because it destroys same-body/same-ID determinism and adds a wall-clock or randomness dependency unrelated to the governed decision.

### Embed a signature in contract `0.1`

Rejected because algorithms, keys, trust roots, rotation, revocation, and issuer authority require their own contract. Detached attestation preserves the stable receipt body and identifier.

### Allow arbitrary diagnostics

Rejected because free-form diagnostics can leak source text, paths, environment data, provider output, or hidden reasoning. Current diagnostics are an empty bounded list until an exact safe allowlist exists.

### Include receipt chains now

Rejected because no bounded acyclic cross-kind semantics are established. Core receipts remain independent values.

## Drawbacks

The export projection is deliberately lossy: different private records can produce the same safe body and identifier. Unsigned receipts require external attestation before a remote verifier can trust their origin. Empty diagnostics limit troubleshooting through the receipt itself. Constraint receipts cannot export generic support IDs until their namespaces become typed. Exact per-kind receipt bounds remain a lifecycle gate, and strict closed schemas require new contract versions for additional fields or receipt kinds.

## Layers affected

- **Public contract:** New closed receipt body and envelope schemas, identifier, integrity verification, atomic governed-operation output, and bounded private-emission error behavior.
- **Runtime authority:** Private Hees-owned mapping from terminal governed results to redacted bodies, including minimal safe failures; no public authoritative receipt constructor.
- **Canonicalization and integrity:** Reuse of RFC 005 JCS and SHA-256 for body and envelope verification.
- **Compatibility:** Exact receipt kind, reason, field, version, order, and failure behavior across producers and consumers.
- **Tests and documentation:** Shared JavaScript/Rust/Incan goldens, leak-negative fixtures, and explicit integrity/authority/authenticity guidance.

## Design Decisions

- Receipt contract `0.1` reuses RFC 005 canonical governance JSON and defines no second encoding.
- `receipt_id` is SHA-256 over the complete canonical body bytes; the body excludes its identifier and the envelope contains exactly body plus ID.
- The same body always has the same ID, while multiple private records may intentionally map to one redacted body.
- This Draft defines package admission, memory admission, constraint adjudication, and proposal admission; proposal admission imports RFC 009's exact seven variants, 31 reasons, identity presence, and typed support mapping but cannot become executable until the coupled contracts and bounds are accepted and implemented.
- Proposal receipts require `content_dna_id` for admitted and clarification variants and forbid it for repair-requested and rejected variants; Content DNA bodies and entries remain outside receipt contract `0.1`.
- Every present package object has the same complete package, domain, revision, and RFC 005 artifact-digest shape; raw RFC 003/RFC 004 package fingerprints are only the unprefixed syntax view of that digest.
- Package identity is all-or-absent and exported only after the governing result establishes it; syntax-valid caller claims are insufficient.
- Reason identifiers are globally unique within each receipt namespace, allowing their source stage or terminal mapping to be verified without exporting a separate stage field.
- Valid constraint receipts include the exact plan plus bounded evaluated, substituted, skipped, primary, and conflict identifiers; complete findings and generic support IDs remain outside the receipt.
- Rejected outcomes expose only structurally admitted identifiers, which are empty under the memory and RFC 009 proposal contracts; proposal repair-requested and clarification outcomes are empty as well.
- Pre-normalization failures map to a minimal body with no raw or hashed malformed input.
- Diagnostics are allowlisted and bounded; for contract `0.1` the only valid diagnostic list is empty.
- Evaluation time appears only when RFC 003 or RFC 004 already admits the caller-supplied value; receipts add no time or nonce.
- Receipt projection and identifier construction are private to the governing operation, which returns result plus receipt atomically; no public body exporter grants authority.
- Receipt content integrity, direct-return authority within Hees processing, and external producer authenticity are separate claims; independently reproducible bytes do not confer authority.
- Signatures and attestations are detached and outside core `0.1`; an unsigned receipt does not prove Hees origin.
- Package-authoring tools, providers, control planes, and device applications may consume receipts but do not author authoritative Hees outcomes.
- Receipt chaining is absent from `0.1` until a bounded acyclic semantic is separately specified.
- RFC 006 owns the canonical export projection and identifier for RFC 003 `MemoryAdmissionRecord` without making the receipt semantic proof.

## Unresolved questions

- What exact per-kind member-count and envelope-byte ceilings are mechanically implied by the final accepted bounds of RFC 003, RFC 004, RFC 005, and proposal admission, and what pre-parse ceiling safely covers the largest kind?

<!-- Rename this section to "Design Decisions" once all questions have been resolved.
     An RFC cannot move from Draft to Planned until no unresolved questions remain. -->
