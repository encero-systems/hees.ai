# RFC 003: Governed Memory and Retrieval Results

- **Status:** Planned
- **Created:** 2026-07-17
- **Author(s):** Encero Systems
- **Related:**
    - RFC 000 (Foundational Governance Authority)
    - RFC 001 (Spectrum Terminal Adjudication)
    - RFC 002 (Content DNA Answer-Time Provenance)
    - RFC 004 (Composable Governance Constraints)
    - RFC 005 (Canonical Package Artifact Admission)
    - RFC 006 (Export-Safe Governance Receipts)
- **Issue:** https://github.com/encero-systems/hees.ai/issues/4
- **RFC PR:** —
- **Written against:** Hees.ai 0.0.1 / Incan 0.5
- **Shipped in:** —

## Summary

Hees.ai should accept bounded provider-neutral retrieval results as untrusted nominations, validate every nominated logical memory identifier and its provenance against an already admitted package, and materialize only package-owned governed memory atoms for later decisions. Retrieval relevance remains non-authoritative: a provider may nominate an atom, but it cannot create content, establish semantic support, change package authority, or determine a runtime outcome.

## Core model

1. **The package owns memory.** A deployable package defines the logical memory atoms that Hees.ai may expose, their source-safe provenance, review and rights state, applicability, authority, and validity interval.
2. **A provider nominates identifiers.** A retrieval provider returns ranked logical identifiers plus bounded relevance metadata. It never returns text for Hees.ai to trust or place into context.
3. **Hees.ai validates the complete envelope.** Request identity, provider binding, result state, rank, score, freshness, bounds, and every identifier must validate. One malformed item invalidates the whole result.
4. **Hees.ai materializes package data.** Accepted context is assembled by resolving nominated identifiers back to the admitted package. No provider-supplied content survives this boundary.
5. **Later governance remains authoritative.** An accepted memory context proves structural eligibility and provenance binding only. It does not prove that an atom supports a claim or that an answer should be admitted.

## Motivation

The current Hees.ai 0.0.1 runtime can check whether a proposal cites package-owned evidence identifiers, but it deliberately does not retrieve evidence or validate provider results. External callers therefore have no shared contract for separating a provider's relevance judgment from package authority, detecting stale or mismatched indexes, representing partial service, or handing a deterministic set of package-owned atoms to later governance.

Without a common ingress contract, provider adapters can accidentally turn retrieved text or opaque scores into authority. They can also disagree about duplicate identifiers, malformed results, time-dependent validity, and provider failure. Those differences are especially dangerous when the same package must behave consistently across independent runtimes.

## Goals

- Define the package-owned governed memory atom admitted to runtime context.
- Freeze the exact package-relative registry and atom binary member payloads imported by RFC 005, including closed nested shapes, enum spellings, ordering, and absence rules.
- Define provider-neutral requests, approved provider bindings, result states, nominations, deterministic admission records, and accepted context.
- Require exact contract and artifact identity rather than implicit version negotiation.
- Make item, text, identifier, and aggregate context sizes explicit and bounded.
- Define deterministic ordering, fixed-point relevance, caller-supplied evaluation time, and freshness rules.
- Fail closed on malformed, ambiguous, stale, incompatible, unapproved, rights-blocked, or unknown data.
- Preserve the distinction between retrieval relevance, semantic support, and final runtime authority.
- Define synthetic acceptance evidence that independent provider adapters must satisfy.

## Non-Goals

- Defining embeddings, indexes, quantization, reranking, search algorithms, storage engines, transport protocols, or provider selection.
- Ingesting source documents, authoring packages, reviewing content, or determining whether declared source rights are legally correct.
- Accepting provider-returned passages, snippets, summaries, claims, guidance, or other raw text as runtime memory.
- Proving that a selected atom semantically supports a model claim or visible answer.
- Selecting model prompts, context-window layouts, token budgets, or generation behavior.
- Standardizing a domain taxonomy, policy vocabulary, authority scale meaning, or content corpus.
- Re-verifying package artifact bytes or accepting a second independently supplied package digest. RFC 005 establishes the admitted artifact identity; this RFC uses its exact package-fingerprint view.
- Defining RFC 005 member wrappers, sharding, exact binary member bytes, descriptor commitments, sequencing, or package-artifact identity.
- Defining receipt canonicalization, redaction, envelope bytes, identifier construction, verification, or external authenticity. RFC 006 owns that export boundary; this RFC owns the complete in-memory source record from which Hees.ai privately projects a receipt.

## Guide-level explanation

This RFC describes a proposed public contract. Hees.ai 0.0.1 does not implement retrieval or this memory-result admission surface.

A package author declares governed memory atoms and one or more approved provider bindings. Each atom has a package-scoped logical identifier and bounded package-owned content. A provider binding pins the provider adapter, its configuration, the index snapshot, and the corpus snapshot expected by the package.

At runtime, the caller creates a bounded request with an explicit evaluation time and invokes its provider outside Hees.ai. The provider responds with identifiers, ranks, and fixed-point relevance values only. The caller then submits the request and result to Hees.ai. The following illustrative Incan uses the proposed API shape:

```incan
# Proposed API shape; not implemented in Hees.ai 0.0.1.
request = memory_request(
    contract_version="0.1",
    request_id="turn_104",
    package_id="learning_support",
    domain_id="public_learning",
    package_revision="1.0",
    package_semantic_identity=admitted_package.package_semantic_identity,
    package_admission_binding=admitted_package.package_admission_binding,
    query_text="How does a public decision become binding?",
    evaluation_time_ms=1784304000000,
)

result = memory_provider_result(
    contract_version="0.1",
    request_id="turn_104",
    result_id="result_104",
    state=MemoryResultState.Complete,
    reason=MemoryResultReason.Completed,
    binding=approved_binding,
    nominations=[
        memory_nomination(memory_id="decision_process_07", rank=0, relevance_bps=8710),
        memory_nomination(memory_id="public_participation_03", rank=1, relevance_bps=7440),
    ],
)

record = admit_memory_result(admitted_package, request, result)
if record.envelope_admission == MemoryEnvelopeAdmission.Accepted:
    println(f"package_revision={record.evaluated_package.package_revision}")
    println(f"provider_state={record.provider_state}")
    for atom in record.context.atoms:
        println(f"selected={atom.id}")
```

Hees.ai does not copy `query_text` or any provider text into the accepted context. It uses the result only to resolve `decision_process_07` and `public_participation_03` from the admitted package. If either identifier is unknown, duplicated, invalid at the supplied evaluation time, not approved, rights-blocked, outside the aggregate context bound, or tied to a different provider snapshot, the complete result is rejected.

`Complete`, `Partial`, and `Unavailable` describe provider execution, not Hees.ai admission. `Accepted` and `Rejected` independently describe whether Hees.ai admitted the envelope. A structurally valid `Partial` or `Unavailable` envelope is accepted; an accepted `Unavailable` envelope materializes zero atoms while preserving its typed provider state and reason for later governance. A rejected envelope always exposes zero atoms. `Partial` cannot be used to salvage valid-looking items from a malformed envelope.

## Reference-level explanation

### Authority boundary

An admitted package must be the sole source of runtime memory content. A retrieval provider result must contain logical memory identifiers and retrieval metadata only. It must not contain a passage, snippet, title, claim, guidance, applicability text, source text, embedding, generated summary, or arbitrary metadata map.

Hees.ai must treat every request and result as untrusted input. Acceptance must prove only that the result is structurally valid, exactly bound to the admitted package and approved provider snapshot, within declared limits, and resolvable to currently eligible package-owned atoms.

Retrieval relevance must not be interpreted as truth, source authority, semantic entailment, policy precedence, or answer admissibility. A later verifier or constraint may inspect the resolved atoms, but only a later governed Hees.ai decision may authorize an outcome.

### Package identity and serialized governed-memory declarations

The complete trusted package identity used by memory admission is the RFC 005 `AdmittedPackageIdentity`: `package_id`, `domain_id`, `package_revision`, `package_semantic_identity`, `artifact_digest`, and `package_admission_binding`. RFC 011 distinguishes semantic identity from delivered artifact integrity, while `package_admission_binding` identifies the admitted typed pair. This RFC carries the typed admitted value; it must not derive, shorten, or reconstruct one identity from another.

A package-relative serialized governed-memory declaration is carried by the RFC 005 `governed_memory_registry` member followed by one or more `governed_memory_atoms` members. RFC 005 owns each member's common `member_id`, `member_kind`, `member_contract`, and `record_count` fields; exact binary member bytes; descriptor order; sharding; digest and length commitments; sequential admission; profile resource envelopes; and inherited package identity. In both memory member kinds, `member_contract` must be the exact string `0.1` and is the sole serialized memory-contract version. The payload must not add `contract_version`, a nested payload envelope, another wrapper field, `artifact_contract`, `package_id`, `domain_id`, `package_revision`, `package_semantic_identity`, `artifact_digest`, `package_admission_binding`, or an equivalent containing-package identity field.

This RFC owns the payload fields below. They are top-level siblings of the four RFC 005 wrapper fields and are disjoint from them. Every payload and nested record is closed: a field is required unless its table says optional, every unlisted field and alias is invalid, and an absent-value tag is invalid where a field is present. Optional means absent from the record, never a placeholder or an admission-invented default. Field spelling and lowercase enum spelling are exact. Arrays preserve submitted order; Hees.ai must not sort or deduplicate them. RFC 005 owns duplicate-aware parsing, binary field order, byte equality, schema failure classification, and the final package-admission result.

#### Registry member payload

After the common wrapper, a `governed_memory_registry` member must contain exactly:

| Field | Value kind | Presence and meaning |
| --- | --- | --- |
| `provider_bindings` | array of provider-binding objects | Required, non-empty, ordered, and bounded by the RFC 005 profile resource envelope. |
| `authority_class_ids` | array of text identifiers | Required, non-empty, ordered, and bounded by the RFC 005 profile resource envelope. |
| `risk_class_ids` | array of text identifiers | Required, non-empty, ordered, and bounded by the RFC 005 profile resource envelope. |
| `sensitivity_class_ids` | array of text identifiers | Required, non-empty, ordered, and bounded by the RFC 005 profile resource envelope. |

Each classification array must contain values matching `[a-z0-9][a-z0-9_-]*`, with no duplicate inside that typed array. The same spelling may occur in different authority, risk, and sensitivity arrays because atom references are typed by their field. Array order is package semantic identity and must survive admission unchanged.

The RFC 005 profile resource envelope owns registry, nomination, materialized-context, and text ceilings. A registry member cannot carry a second local limit or expand the profile envelope. The RFC 005 descriptor `record_count` must equal `len(provider_bindings) + len(authority_class_ids) + len(risk_class_ids) + len(sensitivity_class_ids)`. The registry member must not contain `items`.

#### Provider-binding object

Every `provider_bindings` entry must contain exactly these six required string fields:

| Key | Meaning |
| --- | --- |
| `provider_id` | Canonical provider identifier. |
| `provider_contract_version` | Exact provider-result contract version. |
| `adapter_version` | Exact adapter version. |
| `configuration_fingerprint` | SHA-256 fingerprint of the governed provider configuration. |
| `index_fingerprint` | SHA-256 fingerprint of the governed index snapshot. |
| `corpus_fingerprint` | SHA-256 fingerprint of the governed corpus snapshot. |

`provider_id` must match the identifier grammar and bound. `provider_contract_version` and `adapter_version` must match `[0-9]+(\.[0-9]+){1,2}` and the version bound. Every fingerprint must be exactly 64 lowercase hexadecimal characters without a `sha256:` prefix. The complete six-field tuple must be unique within the registry; sharing an individual component, including a corpus fingerprint, does not by itself make two bindings duplicates. Provider-binding order is identity-bearing. A binding must not contain package identity, transport location, executable bytes, attestation, free-form metadata, or a second digest syntax.

#### Atom member payload

After the common wrapper, a `governed_memory_atoms` member must contain exactly one required `items` field. `items` must be a non-empty ordered array of atom objects bounded by the RFC 005 profile resource envelope. It must not contain registry fields or package identity. The descriptor `record_count` must equal `len(items)`, and RFC 005 forms the package's logical atom list by concatenating atom-member arrays in descriptor order.

Every atom object must contain exactly these required fields:

| Field | Value kind | Meaning |
| --- | --- | --- |
| `id` | string | Package-scoped logical memory identifier. |
| `corpus_version` | string | Exact governed corpus version. |
| `corpus_fingerprint` | string | Exact governed corpus SHA-256 fingerprint. |
| `claim` | string | Bounded package-owned claim. |
| `guidance` | string | Bounded package-owned guidance. |
| `applicability` | string | Bounded package-owned applicability statement. |
| `source_ref` | string | Bounded source-safe reference. |
| `source_fingerprint` | string | Exact governed source SHA-256 fingerprint. |
| `review_status` | string enum | Exactly `approved`, `pending`, or `rejected`. |
| `runtime_rights` | string enum | Exactly `allowed`, `restricted`, or `denied`. |
| `authority_class_id` | string | Reference into `authority_class_ids`. |
| `risk_class_id` | string | Reference into `risk_class_ids`. |
| `sensitivity_class_id` | string | Reference into `sensitivity_class_ids`. |
| `validity` | validity object | Closed temporal-validity shape defined below. |
| `labels` | array of text identifiers | Ordered package-owned canonical labels. |

`id`, the three classification references, and every label must match the identifier grammar and their field bounds. Atom identifiers are unique across the RFC 005-combined logical atom list. Labels may be empty, must be bounded by the RFC 005 profile resource envelope, and must not contain duplicates; their declared order is identity-bearing. `corpus_version` must match the version grammar. `corpus_fingerprint` and `source_fingerprint` must each be exactly 64 lowercase hexadecimal characters without a prefix. The atom's corpus fingerprint must equal at least one registry provider binding's `corpus_fingerprint`, and each typed classification reference must resolve exactly once in its corresponding registry array.

`claim`, `guidance`, and `applicability` must be non-empty, remain within their UTF-8 byte ceilings, and each contain at least one code point other than tab `U+0009`, line feed `U+000A`, carriage return `U+000D`, or space `U+0020`. A `source_ref` must be non-empty and within its byte ceiling; must not begin or end with that ASCII whitespace; must contain no C0 control code point `U+0000..U+001F`, delete `U+007F`, backslash, `..` substring, `file://` substring, or `:/` substring; and must not begin with `/`. These are shape checks only and do not dereference the reference or establish legal rights.

The closed `validity` object has exactly two permitted shapes:

| `mode` | Required keys | Rules |
| --- | --- | --- |
| `bounded` | `mode`, `valid_from_ms`, `valid_until_ms` | Both times are non-negative exact integers and `valid_until_ms` is strictly greater than `valid_from_ms`. |
| `indefinite` | `mode`, `valid_from_ms` | `valid_from_ms` is a non-negative exact integer and `valid_until_ms` must be absent. |

`mode` is the exact lowercase text value shown in the table. An absent end value, omitting it for `bounded`, supplying it for `indefinite`, numeric sentinels, fractions, exponents, negative values, and unknown fields are invalid package declarations. Successful package admission preserves the declared shape; it does not add an end value to an indefinite atom.

All three recognized review states and all three recognized runtime-rights states are structurally admissible through RFC 005 package admission. RFC 003 runtime nomination eligibility exclusively owns their effect: a nominated atom whose `review_status` is not `approved` reaches `atom_review_not_approved`, and a subsequently eligible atom whose `runtime_rights` is not `allowed` reaches `atom_rights_not_allowed` under the existing atom-stage precedence. Unknown values, aliases, or different casing remain RFC 005 member-schema failures rather than RFC 003 runtime reasons.

The atom declaration must not contain raw source material. `claim`, `guidance`, and `applicability` are reviewed package artifacts, not excerpts supplied by a retrieval provider. Corpus, source, configuration, and index fingerprints plus adapter versions identify separate governed artifacts and therefore remain explicit; none may substitute for or be interpreted as the containing Package artifact digest or package semantic identity.

### Identity-bound admitted atom

After successful RFC 005 package admission, Hees.ai must materialize each admitted runtime atom by binding the declaration to the inherited `AdmittedPackageIdentity`. This binding must not modify, migrate, reserialize, or re-hash the serialized declaration or containing artifact.

The admitted runtime atom must expose the declaration fields plus that inherited package binding. A request or provider result must not overwrite its identity. Package identity becomes trusted only through RFC 005 admission; canonical-looking request fields are still untrusted claims.

Identifiers must match the lowercase ASCII grammar `[a-z0-9][a-z0-9_-]*`. An admitted package must not contain duplicate logical memory identifiers. Fingerprints in contract `0.1` must be SHA-256 values encoded as exactly 64 lowercase hexadecimal characters. Separate corpus, source, configuration, and index fingerprints plus adapter versions must match their corresponding admitted declarations exactly.

The serialized validity mode is exactly lowercase `bounded` or `indefinite` in the closed shape above; a typed runtime API may expose corresponding `Bounded` and `Indefinite` variants after package admission. `bounded` is eligible when `valid_from_ms <= evaluation_time_ms < valid_until_ms`. `indefinite` is eligible when `valid_from_ms <= evaluation_time_ms`. Numeric sentinels must not represent indefinite validity, and a mode/end mismatch must make RFC 005 package admission fail.

The three classification identifiers must match package-declared bounded identifier sets. Hees.ai validates their identity and bounds but must not impose an ordering or infer that one package's classification has the same meaning as another's. Package-owned constraints interpret those classifications.

### Approved provider binding

An admitted package must declare every provider binding it allows. The serialized binding's exact fields are:

- `provider_id`;
- `provider_contract_version`;
- `adapter_version`;
- `configuration_fingerprint`;
- `index_fingerprint`; and
- `corpus_fingerprint`.

A serialized provider-binding declaration is package-relative and must not repeat the containing package identity or digest. Successful RFC 005 admission associates it with the inherited trusted package identity without changing its serialized fields. Provider identifier and versions plus configuration, index, and corpus fingerprints remain explicit because they identify the separate retrieval execution and snapshot boundary.

The submitted result binding must exactly equal one admitted binding. Hees.ai must not negotiate versions, accept compatible-looking prefixes, substitute a newer index, or infer equivalence between fingerprints.

A declared binding establishes identity, not integrity. Hees.ai may compare canonical fingerprint values without claiming that it independently hashed an adapter, configuration, index, corpus, or source artifact.

### Request contract

A memory request must contain the exact memory contract version, a canonical bounded caller-supplied request identifier, package identifier, domain identifier, package revision, `package_semantic_identity`, `package_admission_binding`, bounded query text, and caller-supplied evaluation time. The request must not carry `artifact_digest`: the Package admission binding is the compact declared reference to the admitted semantic-and-artifact pair. The request identifier is not asserted to be globally unique; it is interpreted only as one field of the complete structured admission record.

The evaluation time must be a non-negative integer count of Unix epoch milliseconds. Hees.ai must use this supplied value for every time-dependent check in the admission. It must not read a wall clock, reinterpret local time, or silently replace the value.

The request must use memory contract version `0.1` exactly. Unknown versions must fail closed. Its package, domain, revision, semantic-identity, and admission-binding fields are untrusted claims and must exactly match the trusted identity of the admitted package. Canonical syntax alone must never promote those claims into receipt identity.

### Result contract

A provider result must echo the exact contract version and request identifier, provide a canonical bounded caller-supplied result identifier, include one approved provider binding, declare one `MemoryResultState`, declare one compatible typed `MemoryResultReason`, and contain a bounded ordered list of nominations. The result identifier is not asserted to be globally unique and must not be treated as a receipt identifier.

The provider result must not carry package identity, package revision, `package_semantic_identity`, `package_admission_binding`, or `artifact_digest`. The request supplies untrusted package claims for comparison; the admitted package supplies the only trusted evaluated identity.

Each nomination must contain exactly:

- one package-owned logical memory identifier;
- one zero-based integer rank; and
- one integer `relevance_bps` in the inclusive range `0..10000`.

Ranks must be unique, contiguous, and ordered as `0..len(nominations)-1`. Memory identifiers must be unique within the result. The list order must equal rank order. Floating-point scores, NaN-like values, negative values, values above `10000`, duplicate ranks, gaps, or ties represented by a shared rank must fail validation.

`relevance_bps` is comparable only within one result produced by one exact provider binding. Hees.ai must not compare scores across bindings or use a score as evidence strength. Providers may choose any deterministic scoring method that preserves the declared rank; the algorithm remains outside this contract.

### Result states

The result state and shape must follow these rules:

- `Complete` must use reason `Completed`. It may contain zero or more nominations and asserts that the provider completed the bounded request against the declared binding.
- `Partial` must use one of the bounded incomplete-service reasons defined by the contract and must contain at least one nomination. It asserts incomplete provider coverage, not partially valid data.
- `Unavailable` must use one of the bounded unavailability reasons defined by the contract and must contain zero nominations.

The complete `0.1` reason set is `Completed`, `CapacityLimited`, `DeadlineReached`, `ProviderUnavailable`, and `IndexUnavailable`. `Complete` permits only `Completed`. `Partial` permits only `CapacityLimited` or `DeadlineReached`. `Unavailable` permits only `ProviderUnavailable`, `IndexUnavailable`, or `DeadlineReached`. Unknown state or reason values and incompatible state/reason pairs must fail closed. Free-form provider error text must not cross the admission boundary.

### Bounds and profile resource envelope

The RFC 005 Package profile resource envelope must declare closed exact ceilings for identifiers and revisions, source references, query text, atom claim/guidance/applicability text, atom labels, classification identifiers, provider bindings, nominations, materialized atoms, aggregate materialized context, parser nesting, normalized request/result bytes, retained materialized atom state, and record/receipt-source projection. The envelope must specify the accounting rule for aggregate context bytes: the UTF-8 bytes of every selected atom's `id`, `claim`, `guidance`, `applicability`, `source_ref`, and labels.

Versions and package revisions must match `[0-9]+(\.[0-9]+){1,2}`. `package_semantic_identity` and `package_admission_binding` must be valid registered RFC 011 identity values with their expected domains and contracts. The request cannot select a lower resource limit or override the closed profile envelope. Zero, negative, overflowing, malformed, or above-envelope values must fail validation rather than being clamped.

Implementations must use the declared accounting rule exactly and must reject before allocating an above-limit context.

### Admission, trusted identity, and materialization

Hees.ai must validate memory input in this order without exposing a partially admitted context or promoting untrusted package claims:

1. Enforce profile resource-envelope bounds and validate every field needed for a safe normalized record, including canonical identifiers and versions, structural identity domain/contract syntax, exact-integer representation, non-negative evaluation time, and a known compatible provider state/reason pair.
2. Establish that the package was successfully admitted under RFC 005 and that its governed-memory registry was admitted. Failure before both facts are established produces no trusted package identity.
3. Snapshot the complete trusted package identity from the admitted package separately from the normalized request and result. From this point, every rejection is a `Normalized` record carrying that trusted evaluated identity.
4. Validate the request and result contract linkage, exact request package claims, and result request echo.
5. Validate the approved provider binding and the nomination-count shape required by the already normalized provider state.
6. Validate nomination count, uniqueness, dense rank order, and relevance range.
7. Resolve every nomination and validate corpus binding, review state, runtime rights, and temporal eligibility.
8. Enforce the effective aggregate context-byte limit, materialize atoms from the admitted package in provider rank order, and construct the terminal record.

A `Partial` provider state must not weaken any validation requirement. Envelope admission and provider state remain independent dimensions. Accepted `complete` and `partial` contexts contain package-owned atoms in exact nomination rank order and may retain rank and relevance as non-authoritative annotations. Accepted `unavailable` contains zero atoms. Every rejected record exposes zero atoms, and no context retains provider-returned text.

### Public admission stages and reasons

Every result must contain one stage and one reason from this closed table. Rows are strict stage precedence, and reason order within a row is strict reason precedence. Every reason is globally unique within RFC 006's `memory_admission_0_1` namespace.

| Stage | Reasons in precedence order | Record variant and terminal |
| --- | --- | --- |
| `normalization` | `input_collection_bound_exceeded`, `input_text_bound_exceeded`, `invalid_contract_value`, `invalid_request_identifier`, `invalid_result_identifier`, `invalid_package_claim`, `invalid_provider_binding`, `invalid_nomination_identifier`, `invalid_nomination_number`, `invalid_evaluation_time`, `unsupported_provider_state`, `unsupported_provider_reason`, `provider_state_reason_mismatch` | `PreNormalizationRejected` / `Rejected` |
| `package` | `package_not_admitted`, `memory_registry_not_admitted` | `PreNormalizationRejected` / `Rejected` |
| `request` | `unsupported_memory_contract`, `request_package_id_mismatch`, `request_domain_id_mismatch`, `request_package_revision_mismatch`, `request_package_semantic_identity_mismatch`, `request_package_admission_binding_mismatch`, `result_contract_mismatch`, `result_request_id_mismatch` | `Normalized` / `Rejected` |
| `provider` | `provider_binding_not_admitted`, `provider_state_nomination_mismatch` | `Normalized` / `Rejected` |
| `nominations` | `nomination_count_exceeds_profile`, `duplicate_nomination_id`, `nomination_rank_mismatch`, `nomination_relevance_out_of_range` | `Normalized` / `Rejected` |
| `atoms` | `unknown_memory_id`, `atom_corpus_mismatch`, `atom_review_not_approved`, `atom_rights_not_allowed`, `atom_not_yet_valid`, `atom_expired` | `Normalized` / `Rejected` |
| `context` | `context_bytes_exceeded` | `Normalized` / `Rejected` |
| `complete` | `accepted_complete`, `accepted_partial`, `accepted_unavailable` | `Normalized` / `Accepted` |

These eight stages contain exactly 39 globally unique runtime admission reasons. Serialized package-schema failures remain RFC 005 package-admission reasons and must not add, remove, or shadow a reason in this table.

The normalization reasons have exact scopes. `input_collection_bound_exceeded` means an input collection exceeds its profile resource-envelope ceiling before entries are retained, while `input_text_bound_exceeded` means a text field exceeds its profile UTF-8 byte ceiling before content is retained. `invalid_contract_value` means a contract or version field violates its canonical grammar or byte bound, while a syntactically valid version other than memory contract `0.1` reaches `unsupported_memory_contract`. `invalid_request_identifier` and `invalid_result_identifier` apply independently to malformed or over-bound caller identifiers. `invalid_package_claim` covers malformed package, domain, revision, semantic-identity, or admission-binding syntax; it does not compare those claims with the admitted package. `invalid_provider_binding` covers malformed or over-bound binding fields, while a well-formed binding absent from the admitted registry reaches `provider_binding_not_admitted`. `invalid_nomination_identifier` covers malformed or over-bound logical identifiers, and `invalid_nomination_number` covers a rank or relevance value that is not an exactly representable integer. `invalid_evaluation_time` means the evaluation time is not a non-negative exact integer. `unsupported_provider_state` and `unsupported_provider_reason` apply to unknown typed values; `provider_state_reason_mismatch` applies to a known pair that the state table forbids. These checks occur before a `Normalized` record can be formed, ensuring every normalized record has the receipt-safe typed memory state required by RFC 006.

At the package stage, `package_not_admitted` means no successful RFC 005 admission identity exists. `memory_registry_not_admitted` means the admitted package does not carry an admitted governed-memory declaration. Structurally invalid declarations fail RFC 005 package admission and therefore reach `package_not_admitted`, not a second runtime registry error.

At the request stage, `request_package_id_mismatch`, `request_domain_id_mismatch`, `request_package_revision_mismatch`, `request_package_semantic_identity_mismatch`, and `request_package_admission_binding_mismatch` each compare the named well-formed untrusted request field with the separate trusted package snapshot. `result_contract_mismatch` applies when the well-formed result contract does not exactly equal the request's accepted `0.1` contract, and `result_request_id_mismatch` applies when its request echo differs.

At the provider stage, the state and reason are already a known compatible pair. `provider_state_nomination_mismatch` means `partial` has no nominations or `unavailable` has any nominations; `complete` may contain zero or more. At the nominations stage, `nomination_count_exceeds_profile` means the list exceeds the profile nomination ceiling, `duplicate_nomination_id` means two entries name the same memory identifier, `nomination_rank_mismatch` means any rank differs from its exact zero-based list index, and `nomination_relevance_out_of_range` means an exact integer relevance lies outside inclusive `0..10000`.

At the atom stage, `unknown_memory_id` means a nomination resolves to no admitted atom. `atom_corpus_mismatch` means the atom's corpus fingerprint differs from the selected admitted provider binding. `atom_review_not_approved` and `atom_rights_not_allowed` apply to the named package-owned eligibility state. `atom_not_yet_valid` means evaluation precedes the inclusive validity start, while `atom_expired` means evaluation is at or after a bounded exclusive validity end. Package identity cannot mismatch at this stage because every runtime atom inherited it from the same admitted package; a repeated caller-controlled atom identity is forbidden by the serialized declaration contract.

At the context stage, `context_bytes_exceeded` means the exact aggregate materialized byte sum exceeds the profile context-byte ceiling. Completion reasons map one-to-one to the valid provider states and terminal `Accepted`: `accepted_complete` for `Complete`, `accepted_partial` for `Partial`, and `accepted_unavailable` for `Unavailable`. Every other reason maps to terminal `Rejected`. Provider-state reasons such as `completed` and `deadline_reached` remain a separate typed dimension in the normalized result and RFC 006 `memory_state`; they must never be reused as Hees.ai admission reasons.

Admission stops at the first failing stage. Within a stage, Hees.ai must determine the set of applicable public reason kinds and choose the first reason in the table. It must not select reasons from provider error text, parser wording, hash-map iteration, or the first malformed nomination or atom encountered. Implementations may retain richer bounded local diagnostics, but those diagnostics must not alter the stage/reason pair or contain provider text, package content, source text, hidden model reasoning, or unsafe input echoes.

### Admission record and later handoff

Every submission must produce one deterministic in-memory `MemoryAdmissionRecord` variant:

- `Normalized` must contain `evaluated_package`, the complete trusted `AdmittedPackageIdentity` snapshot from RFC 005 admission; the complete bounded normalized request and provider result as untrusted echoes; valid caller-supplied `evaluation_time_ms`; one valid provider state/reason pair; envelope admission; one stable Hees.ai stage/reason pair; and ordered materialized logical memory identifiers. The nested request retains its untrusted package, domain, revision, semantic-identity, and admission-binding claims, query, evaluation time, and request identifier. The nested result retains its caller identifiers, provider binding, state/reason, and ordered nominations. These nested fields never substitute for `evaluated_package`.
- `PreNormalizationRejected` must contain only envelope admission `Rejected`, one stable Hees.ai stage/reason pair, and optional request and result caller identifiers. Each caller identifier may be copied only when that individual field independently satisfies the canonical grammar and bound. It must contain no package identity, package claim, evaluation time, query, provider binding, provider state or reason, nomination, score, package content, malformed value, or other untrusted input, and it always exposes zero atoms.

A rejected record is `Normalized` exactly when the normalization and package stages both succeeded, so Hees.ai has the complete trusted evaluated package identity and a receipt-safe evaluation time and provider state/reason pair. Request identity mismatch, unapproved binding, malformed nomination semantics, ineligible atoms, and context overflow therefore remain normalized rejections with trusted package identity. Input-normalization failure, absence of RFC 005 package admission, or absence of an admitted memory registry uses `PreNormalizationRejected` and carries no trusted identity even if individual caller fields look canonical.

The complete normative fields of the selected variant form its in-memory identity. A minimal rejection record is deliberately not an injective representation of malformed input: different unsafe envelopes may produce the same safe stage/reason record.

Later governance consumes only an accepted context's typed provider state/reason and ordered package-owned atoms. It may cite only atom identifiers present in an accepted context; accepted `unavailable` supplies absence information but no support citation. A rejected record supplies no context. Neither an admission record nor its exported receipt is semantic verification, and later proposal admission must still validate every cited identifier against package authority.

### Receipt projection ownership

This RFC owns the complete in-memory `MemoryAdmissionRecord` and the trusted-versus-untrusted field distinction. RFC 006 exclusively owns the redacted receipt body, inspection envelope, receipt identifier, private atomic projection, and public integrity verification. There is no second memory-specific canonical encoding or public result-to-receipt authoring API.

For `Normalized`, RFC 006 must take package identity only from `evaluated_package`, copy the admitted package semantic identity, artifact digest, and admission binding only where its receipt projection declares them, copy the admitted evaluation time and valid provider state/reason pair, and export materialized memory identifiers only for accepted `complete` or `partial`. Accepted `unavailable` and every normalized rejection export an empty admitted-memory array. `PreNormalizationRejected` maps to RFC 006's minimal body with no package, evaluation time, memory state, caller identifiers, or input-derived identity.

### Determinism and errors

Given identical RFC 005-admitted package data and identical typed request/result values, conforming implementations must select the same record variant, stage, globally unique reason, trusted identity presence, normative record fields, and accepted context. This in-memory determinism does not make a record an exported receipt; only RFC 006 defines canonical receipt bytes and identity.

## Design details

### Relationship to RFC 000

RFC 000 defines retrieval output as non-authoritative nomination and requires package-owned reviewed memory before a value can participate in governance. This RFC realizes that ingress boundary without allowing relevance, provider identity, or returned text to become terminal authority.

### Relationship to RFC 001

This RFC supplies Spectrum with the direct accepted governed-memory context. Spectrum alone freezes the terminal selected and discarded partition; accepting or materializing an atom here does not make it answer-supporting selected memory.

### Relationship to RFC 002

RFC 002 projects exact source-safe provenance from Spectrum-selected atoms into Content DNA. This RFC owns the package-bound memory, source, review, rights, authority, validity, and provenance facts required by that projection; it does not construct answer-specific Content DNA.

### Relationship to the current evidence contract

The current `EvidenceRecord` remains the implemented 0.0.1 structural citation contract until this RFC and a separate implementation are merged. Governed memory is a richer retrieval-facing package contract. An implementation may represent an evidence record and a governed memory atom with shared internals, but it must not silently treat an existing evidence record as retrieval-ready when the required identity, provenance, bounds, and validity fields are absent.

Adding governed memory is therefore additive at the capability level but opt-in at the package level. Existing packages must not become retrieval-capable merely because a runtime understands memory contract `0.1`.

### Provider neutrality

Hees.ai receives a normalized result envelope after an external caller has invoked its provider. The public contract must not expose an index API, embedding shape, distance metric, transport error, storage identifier, or provider-specific extension map. A future contract version may add a new normalized field only through an exact version change.

### Acceptance obligations

Conformance evidence must include at least two synthetic provider adapters that use different internal retrieval strategies but produce the same normalized request/result behavior. The evidence must demonstrate accepted and rejected envelope admission independently from complete, empty-complete, partial, and unavailable provider states; deterministic ordering and both admission-record variants; no unsafe-content echo after oversized or malformed pre-normalization input; conditional retention of independently canonical caller identifiers; exact version and provider-binding checks; fixed-point score boundaries; bounded and indefinite validity; stale and future atom rejection; duplicate and unknown identifier rejection; item and byte limits; request-package and atom-corpus mismatches; explicit source-fingerprint and classification-identifier validation during RFC 005 package admission; and deterministic handoff into later structural proposal admission.

Shared package goldens must include complete validated models, exact RFC 005 binary member bytes, member digests, descriptor counts, inherited package identity, and RFC 011 structural identities for a registry, a bounded atom, an indefinite atom, multiple atom shards, every recognized review/runtime-rights state, ordered labels, and more than one valid provider binding. JavaScript, Rust, and Incan consumers must agree on every payload field, array order, absence rule, exact byte sequence, structural identity, and RFC 005 package-admission outcome.

Negative package fixtures must independently cover every unknown field; aliases such as `provider_contract`, `contract_version`, `runtime_rights_status`, or a generic `payload`; field and enum case changes; absent values in required fields; missing and extra validity end fields; invalid validity-end representation; unknown validity modes; duplicate provider tuples, classifications, atom identifiers, and labels; malformed fingerprints and versions; registry fields in an atom member; atom fields in a registry member; wrapper fields nested in payload; repeated package identity; and record-count mismatch. Recognized `pending`, `rejected`, `restricted`, and `denied` states must have positive package-admission fixtures followed by RFC 003 runtime fixtures that reach the existing eligibility reasons.

The fixture set must make every reason in the closed admission table reachable in isolation and must include multi-failure cases that prove the exact stage and within-stage precedence. It must prove that `Normalized` is selected if and only if normalization and package admission both succeed, that only `Normalized` carries the complete trusted evaluated package identity, and that canonical-looking request or result fields never supply trusted identity. Package fixtures must cover an RFC 005-admitted package-relative memory declaration, inherited identity binding without mutation or re-hashing, distinction among package semantic identity, artifact digest, and admission binding, and rejection of a declaration that repeats its containing package identity.

RFC 006 projection fixtures must prove that `Normalized` receipts derive their package object only from `evaluated_package`, that every normalized rejection and accepted `unavailable` result exports no admitted-memory identifiers, and that `PreNormalizationRejected` exports the minimal body with no package, evaluation, memory-state, caller-identifier, or input-derived field. The memory admission fixture must not define a competing receipt encoding, identifier, or redaction path.

The acceptance corpus must be fictional and source-safe. It must include a case where the highest relevance score nominates an atom that a later semantic verifier rejects, proving that retrieval relevance alone is not authority.

## Alternatives considered

### Accept provider-returned text

Rejected because it lets a provider create runtime content outside package review, rights, provenance, and validity controls. Resolving logical identifiers back to package-owned atoms preserves the authority boundary.

### Treat scores as evidence strength

Rejected because retrieval scores are provider-specific ranking signals. Fixed-point relevance is retained only for deterministic ordering metadata and remains non-authoritative.

### Salvage valid items from a malformed result

Rejected because caller-dependent salvage would produce inconsistent contexts and make `Partial` ambiguous. Partial service is an explicit provider state; validation remains all-or-nothing.

### Read the local wall clock for freshness

Rejected because repeated evaluation could change without input changes and independent runtimes could disagree. The caller-supplied evaluation time is part of the deterministic input.

### Negotiate compatible versions or provider snapshots

Rejected because implicit compatibility weakens reproducibility. Exact versions and fingerprints fail closed; migration requires an explicit new package or contract version.

### Let each implementation choose its own limits

Rejected because an envelope accepted on one device could fail or allocate dangerously on another. Contract ceilings are fixed, while requests and packages may choose lower values.

## Drawbacks

Logical identifier retrieval requires package builders to compile and version a governed memory declaration before runtime. Exact provider bindings make index or configuration updates explicit package changes. Binding inherited package identity only after RFC 005 admission adds a deliberate distinction between package-relative serialized values and admitted runtime values. All-or-nothing validation can discard otherwise useful nominations after one malformed item. A closed reason vocabulary and strict precedence require a contract revision when a new public failure distinction is needed, and a changed profile resource envelope requires an exact profile contract/version change. The contract also does not solve semantic support; it deliberately leaves that to a later governed verifier and adjudication path.

## Layers affected

- **Public contract:** New versioned memory declaration, identity-bound admitted atom, validity, classification, provider binding, request, result, nomination, context, admission-record, provider-state, reason, and envelope-admission types.
- **Runtime validation:** Deterministic normalization, RFC 005 admission lookup, trusted identity binding, envelope validation, package resolution, bounds enforcement, materialization, and typed fail-closed results.
- **Package compatibility:** Explicit opt-in package-relative memory declaration and approved provider bindings carried through the RFC 005 package boundary, without requiring a monolithic package representation or changing existing 0.0.1 packages implicitly.
- **External integration boundary:** Provider invocation remains external and must normalize results to logical identifiers only.
- **Receipt boundary:** RFC 006 privately projects the admission record into its canonical redacted receipt; this RFC defines no competing export format.
- **Tests and documentation:** Cross-implementation synthetic fixtures, complete reason and precedence coverage, identity-provenance cases, and clear current-versus-proposed API documentation.

## Design Decisions

- Retrieval providers nominate package-owned logical identifiers only; raw provider text never enters Hees.ai memory context.
- Every returned item must validate. `Partial` means incomplete provider coverage, not partial validation or salvage.
- `Unavailable` contains no nominations and always carries a typed reason.
- Ranks are unique, contiguous, zero-based, and represented by list order; relevance is integer basis points and never authority.
- Provider adapter, configuration, index, corpus, package, source, and contract identities are exact and fail closed.
- Time-dependent checks use one caller-supplied Unix epoch millisecond value; the admission path never reads a wall clock.
- Envelope admission and provider state are independent: valid `Partial` and `Unavailable` envelopes are accepted, accepted `Unavailable` materializes zero atoms, and rejected envelopes always expose zero atoms.
- Accepted context is materialized from package-owned atoms, and every `Normalized` admission record preserves the complete bounded normalized inputs, decision, reason, and deterministic rank order; the minimal pre-normalization variant deliberately does not.
- Pre-normalization failure returns a minimal Hees.ai-owned rejection record with no unsafe content; caller identifiers are retained only when each is independently canonical and bounded.
- Bounded validity uses an inclusive start and exclusive end; indefinite validity uses an inclusive start and no end value.
- Authority, risk, and sensitivity are package-owned classification identifiers rather than universal numeric scales.
- Memory admission and proposal admission remain separate; neither retrieval acceptance nor relevance proves semantic support.
- RFC 005's closed profile resource envelope supplies the exact bounds that independent implementations must enforce.
- RFC 005 owns the common member wrapper, exact binary bytes, sharding, descriptors, sequencing, profile resource envelope, and inherited package identity; this RFC owns only the exact closed registry and atom payload schemas imported under `member_contract="0.1"`.
- Atom validity uses one closed lowercase `bounded`/`indefinite` object whose end field is required only for `bounded`.
- All recognized atom review and runtime-rights states survive structural package admission; only RFC 003 runtime nomination eligibility turns non-approved or non-allowed states into admission reasons.
- The package-relative serialized memory declaration is exactly one RFC 005 registry member followed by one or more atom members; successful package admission binds inherited identity without changing or re-hashing any member bytes.
- The complete trusted memory identity is the RFC 005 `AdmittedPackageIdentity`; its semantic identity, artifact digest, and admission binding have distinct governed meanings.
- Normalized request and result fields remain untrusted echoes. Only the separate admitted-package snapshot supplies trusted evaluated identity, and pre-normalization rejection carries none.
- The public admission stage and reason vocabulary is closed, globally unique within its RFC 006 namespace, and selected by strict precedence independently of provider-state reasons.
- RFC 006 exclusively owns receipt canonicalization, redaction, identifiers, envelopes, private projection, and public integrity verification.
