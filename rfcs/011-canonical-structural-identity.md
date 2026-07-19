# RFC 011: Canonical Structural Identity for Incan Models

- **Status:** Draft
- **Created:** 2026-07-19
- **Author(s):** Encero Systems
- **Related:**
    - RFC 000 (Foundational Governance Authority)
    - RFC 002 (Content DNA Answer-Time Provenance)
    - RFC 003 (Governed Memory and Retrieval Results)
    - RFC 005 (Canonical Package Artifact Admission)
    - RFC 006 (Export-Safe Governance Receipts)
    - RFC 009 (Governed Visible Response Lifecycle)
    - RFC 010 (Hees Console)
- **Issue:** https://github.com/encero-systems/hees.ai/issues/18
- **RFC PR:** —
- **Written against:** Hees 0.0.1 / Incan 0.5.0-dev.14
- **Shipped in:** —

## Summary

Hees should derive authority-bearing semantic identities from successfully validated Hees-owned Incan model values through one closed, versioned canonical structural identity contract. A participating model renders an identity projection into an unambiguous structural byte stream with stable model, field, variant, type, order, absence, length, and domain semantics; Hees computes the model's typed digest from that stream without using JSON, display formatting, storage layout, reflection order, or caller-controlled serialization as the identity substrate. Wire and storage encodings remain replaceable, exact artifact-byte digests remain available for transit and storage integrity, and neither kind of digest independently creates runtime authority, semantic truth, or producer authenticity.

## Core model

1. **Validated models own semantic identity.** Authority-bearing identity begins only after bounded ingress has constructed the exact Hees Incan model and every nominal field has passed its own validation.
2. **Identity projection is explicit.** Each participating model declares the complete closed projection of fields that determine its semantic identity. Operational, presentation, and storage metadata remain outside that projection only when changing them cannot change governed meaning or behavior.
3. **Structural rendering is not display rendering.** The model renders a typed, length-delimited structural stream for hashing. Ordinary `str`, debug, JSON, terminal, and documentation renderings are never canonical identity inputs.
4. **Stable tags replace incidental order.** Stable model, field, enum, and variant tags determine structure. Source declaration order, object iteration, serializer choice, compiler layout, and storage column order do not.
5. **Collection meaning is contract-owned.** Ordered collections preserve their admitted semantic order. A collection that is logically unordered must name one bounded canonical ordering rule before it can participate; generic runtime or locale sorting is not authority.
6. **Nominal distinctions survive hashing.** Distinct nominal types do not become interchangeable merely because their underlying strings or integers match. Validation and type identity precede encoding.
7. **Domain separation prevents cross-purpose reuse.** Package identities, Content DNA, answer bindings, provenance identities, decisions, and receipts use distinct registered identity domains and exact contract versions.
8. **Artifact identity and semantic identity remain distinct.** An artifact digest identifies exact delivered bytes. A structural digest identifies the validated model projection. Equivalent models may have different artifact digests, while one exact artifact must not be treated as semantically admitted until model validation succeeds.
9. **Recursive identity is bounded and composable.** A parent may render a bounded nested model inline or reference a separately defined child structural digest when its owning contract fixes that choice. Incremental and Merkle-style construction must produce the same contract-defined parent identity without requiring a complete textual serialization in memory.
10. **Evolution never silently rewrites history.** Authority-bearing projection changes create a new identity contract version. Older identities remain explicitly verifiable under their original contracts and are never recomputed under a nearby version.

## Motivation

RFC 002, RFC 005, and RFC 006 currently propose RFC 8785 JSON Canonicalization Scheme bodies as the basis for Content DNA, package artifact, answer, provenance, and receipt digests. JCS is materially safer than hashing ordinary JSON because it fixes JSON property order, primitive rendering, whitespace, and UTF-8 output. It nevertheless makes an external data representation part of Hees's semantic identity contract and imports JSON and ECMAScript number and string rules into every authority-bearing model that uses it.

Hees needs a stronger separation. JSON may be convenient for provider exchange, terminal inspection, fixtures, or public verification, while a constrained device may store the same package in an indexed local representation and another integration may use a binary transport. If all three construct the same validated Incan model, they should be able to establish the same semantic identity without first recreating one preferred JSON document. Conversely, matching bytes or a plausible digest must never bypass nominal validation, closed model construction, rights and review checks, or package admission.

Hashing model display output does not solve the problem. Human-readable renderings legitimately evolve through spacing, labels, field order, escaping, localization, or diagnostic improvements. The required operation is a dedicated structural rendering whose only purpose is stable identity and whose grammar is versioned independently from display and wire formats.

The distinction also improves schema evolution. A new UI label, trace annotation, index hint, or storage offset should not change a semantic digest when it cannot affect governed meaning. A new policy field, selected-memory member, rights state, visible unit, or terminal reason must change identity. An explicit model-owned identity projection makes that boundary reviewable and testable rather than inheriting whichever fields a generic serializer happens to emit.

Finally, constrained hardware benefits from incremental structural hashing. Hees should be able to validate one bounded package member or memory atom, feed its canonical structural representation into a digest sink, retain a typed child identity, and release transient bytes. Requiring the complete corpus, complete JSON tree, or complete canonical JSON body to coexist with a resident model would turn identity calculation into avoidable memory pressure.

## Goals

- Define one Hees canonical structural identity contract for participating Incan models.
- Require complete nominal construction, validation, normalization, and bounds enforcement before any authority-bearing semantic digest is returned.
- Define stable model, field, variant, scalar, option, collection, nested-model, and digest-reference semantics.
- Define a self-delimiting structural stream that cannot confuse different types, values, nesting, lengths, absence states, or collection boundaries.
- Define exact domain separation, identity-contract versioning, digest algorithm, output syntax, and legacy verification behavior.
- Distinguish semantic model identity from exact artifact-byte integrity, storage identity, transport identity, runtime authority, and external authenticity.
- Let JSON, NDJSON, binary transports, and storage engines reconstruct and verify the same model identity without making any of those encodings canonical authority.
- Support bounded incremental hashing and explicitly declared Merkle-style composition for constrained runtimes.
- Amend the canonical identity responsibilities proposed by RFC 002, RFC 005, RFC 006, and RFC 009 without changing their separate governance responsibilities.
- Require cross-runtime golden streams, digests, adversarial validation, evolution fixtures, and resource measurements before the contract advances.

## Non-Goals

- Selecting a Console, provider, network, package-transfer, archive, database, vector, or storage format.
- Defining a general structural hashing facility for every Incan model outside Hees.
- Treating automatic model serialization, compiler reflection, source declaration order, debug output, or ordinary JSON as canonical identity.
- Replacing exact artifact-byte checks where a transport or storage boundary must verify the bytes it received.
- Making two models semantically equivalent through inference, field renaming, lossy normalization, default guessing, or provider interpretation.
- Proving factual correctness, semantic support, source rights, policy quality, human approval, or completeness merely because a structural digest verifies.
- Establishing runtime authority, producer authenticity, signing, attestation, non-repudiation, replay protection, federation, or key management.
- Negotiating a nearby identity contract or digest algorithm when the declared one is unknown.
- Defining Content DNA membership, Spectrum decisions, package policy, visible-answer semantics, or receipt redaction; the related RFCs continue to own those contracts.
- Silently reinterpreting or rewriting identities produced by earlier experimental or released profiles.

## Guide-level explanation

A caller may receive model data as JSON, from a local indexed store, or from another supported transport. Hees first applies the transport's byte and nesting bounds, rejects malformed or duplicate input where that transport permits it, constructs the exact closed Incan model, invokes every nominal constructor and validation rule, and establishes any contract-owned normalization. Only the validated model can enter structural identity construction.

The proposed public shape is model-oriented rather than serializer-oriented:

```incan
# Proposed API shape; not implemented in Hees 0.0.1.
atom = admit_memory_atom(candidate_atom)
identity = identify_memory_atom(atom)

println(f"memory={identity.memory_id}")
println(f"digest={identity.semantic_digest}")
```

`identify_memory_atom` does not call a generic JSON or display serializer. It applies the identity projection owned by the admitted-memory contract, feeds stable typed fields to the canonical structural sink, and returns a nominal memory digest only after successful completion. A caller cannot pass a generic dictionary, JSON tree, arbitrary field list, or pre-rendered string into that operation.

Equivalent transport documents may therefore produce one semantic digest:

```json
{"memory_id":"memory-1","language":"zu","body":"Umthetho"}
```

```json
{
  "body": "Umthetho",
  "language": "zu",
  "memory_id": "memory-1"
}
```

Their exact artifact-byte digests differ. After strict parsing into the same validated model, their semantic digest is the same because JSON property order and whitespace are not model values. Changing `body`, changing the nominal `memory_id`, changing an identity-bearing review state, or changing the collection order where order is meaningful changes the structural stream and digest.

The model's structural rendering remains inspectable for compatibility testing, but it is not intended as a general wire format. Tooling may show a decoded explanation such as model domain, contract version, stable field tags, normalized values, and final digest. It must not claim that the terminal JSON projection or a human-readable explanation is itself the hashed preimage.

## Reference-level explanation

### Terminology

- **Authority model:** A closed Hees-owned Incan model value whose construction, nominal values, references, and governing invariants have passed the owning contract's validation boundary.
- **Identity projection:** The exact allowlisted semantic values from one authority model that participate in one named identity domain and contract version.
- **Structural stream:** The versioned self-delimiting bytes rendered from an identity projection under this RFC.
- **Structural digest:** The algorithm identifier and digest bytes computed over the complete structural stream.
- **Artifact digest:** A digest over exact transported or stored bytes, including representation details that may not be semantic model values.
- **Wire projection:** A JSON, NDJSON, binary, terminal, or other external representation used to exchange or inspect model data.
- **Identity domain:** A registered fixed purpose such as a package semantic identity, Content DNA body, answer binding, provenance projection, or governance receipt.
- **Identity contract version:** The exact version that fixes the identity projection and all structural rules for one domain.

`Semantic` in this RFC means representation-independent identity of one exact validated model projection. It does not mean natural-language equivalence, inferred equivalence, semantic truth, or equivalence between different models that happen to render similarly.

### Authority and construction boundary

A structural identity used by a governing operation must be constructed only from an authority model or from a private identity projection created from that model. Public verification may reconstruct the same digest from a separately defined closed verification model, but it returns only a non-authoritative identity and integrity result. No public operation may accept a generic map, arbitrary JSON value, caller-authored field sequence, caller-selected domain, caller-selected field tags, or caller-selected normalization policy and return a nominal Hees identity.

Every transport decoder must enforce its declared byte, depth, collection, and scalar bounds before proportional allocation. It must reject duplicate or unknown fields according to the owning closed wire contract, construct exact nominal field types through their validating constructors, and reject the complete input if any nominal construction or cross-field invariant fails. Generated deserialization must not bypass a nominal type's constructor or `from_underlying` validation path.

A governing operation must not attach a structural identity or authority to malformed, partially decoded, provisionally normalized, or otherwise unadmitted input. A public verifier must return failure rather than a digest for an invalid verification model. A diagnostic subsystem may compute a separately named non-authoritative fingerprint over rejected bytes for bounded correlation only when another contract explicitly permits it; that value must use another nominal type and domain and cannot substitute for a semantic identity.

### Identity projection completeness

Each identity domain must define one closed projection from its authority model. Every field whose value can change the governed meaning, authority, admissibility, selected memory, visible response, policy effect, terminal outcome, provenance claim, or redacted receipt claim must participate directly or through a referenced child identity.

A field may be excluded only when changing it cannot affect the identity domain's governed claim. Examples may include display labels, terminal colour, local cache offsets, storage page numbers, transient provider latency, or non-authoritative trace annotations. Exclusion from one identity domain does not imply exclusion from every other domain.

Adding an excluded non-authority field to an authority model may preserve an existing identity contract only when the projection and all governed behavior remain unchanged. Adding, removing, retyping, renormalizing, or changing the meaning of an identity-bearing field must create a new identity contract version. An implementation must not silently include every serializable field or infer the projection through reflection.

### Structural stream header

Structural identity contract `0.1` proposes the following root preimage shape:

```text
magic || structural_version || identity_domain || identity_contract_version || root_value
```

`magic` must be the eight exact bytes `48 45 45 53 2d 53 49 00`, representing `HEES-SI` followed by NUL. `structural_version` must be the unsigned big-endian 16-bit value `1`. `identity_domain` and `identity_contract_version` must use the canonical text scalar defined below. `root_value` must be one canonical record value for the participating model.

An identity domain must be a fixed lower-ASCII identifier registered by the owning RFC. It must not come from provider, package, caller, environment, storage, or transport input. The identity contract version must be the exact closed version selected by the authority model's owning contract; unknown versions must fail without attempting a nearby version.

### Canonical value grammar

Contract `0.1` uses one-byte value tags followed by exact fixed-width or length-prefixed payloads. Every length and count is an unsigned big-endian 32-bit value and must be checked against the owning contract's smaller semantic bounds before encoding.

| Tag | Value | Canonical payload |
| --- | --- | --- |
| `0x01` | `false` | No payload |
| `0x02` | `true` | No payload |
| `0x10` | signed integer | Exactly eight bytes, signed two's-complement big-endian |
| `0x20` | text | UTF-8 byte length followed by exact UTF-8 bytes |
| `0x21` | bytes | Byte length followed by exact bytes |
| `0x22` | SHA-256 digest | Algorithm byte `0x01` followed by exactly 32 digest bytes |
| `0x30` | absent option | No payload |
| `0x31` | present option | One complete canonical child value |
| `0x40` | record | Stable model tag, field count, then canonical fields in ascending stable field-tag order |
| `0x41` | sequence | Element count followed by complete canonical child values in semantic order |
| `0x42` | variant | Stable enum tag, stable variant tag, then absent or present canonical payload |
| `0x43` | child identity | Canonical child domain, child contract version, and canonical SHA-256 digest value |

A record's stable model tag, every field tag, every enum tag, and every variant tag must be an unsigned big-endian 32-bit value assigned by the owning identity contract. Each record field consists of its four-byte field tag followed by one complete canonical value. Field tags must be unique, appear in strictly ascending numeric order, and never be reused for another meaning within one identity domain lineage.

The grammar deliberately defines no generic null, floating-point, decimal, map, dictionary, object, set, path, timestamp, platform integer, or arbitrary extension value. A participating contract must map its semantics to the closed values above or define a new structural identity version. Time values, when genuinely identity-bearing, must first become one exact bounded signed integer in a contract-owned epoch and unit.

### Scalar semantics

Boolean values must use their dedicated tags and must not encode as integers or text. Integer-bearing identity fields must fit the signed 64-bit range and must additionally satisfy their owning nominal and semantic bounds before encoding. Contract `0.1` must not hash floating-point values; scores or ratios that become authority-bearing must use contract-defined bounded integers such as basis points.

Text values must be valid Unicode encoded as UTF-8. The default text policy is exact admitted Unicode scalar and whitespace preservation. There is no global case folding, trimming, Unicode normalization, newline rewriting, locale transformation, or URI normalization inside the structural sink.

When an owning contract needs normalization, it must define a nominal normalized type and complete normalization before the authority model is established. The structural sink then encodes the resulting validated text exactly. Identifiers should use their existing bounded nominal ASCII forms; source or answer text may deliberately preserve exact code points and whitespace when those values are part of the governed claim.

Raw bytes must be bounded by the owning field contract. A SHA-256 digest field must be decoded from its nominal syntax and encoded as the algorithm tag plus 32 raw bytes; it must not be hashed as a free-form `sha256:` string. Supporting another algorithm requires a new accepted identity-contract or structural-version rule and must not be negotiated from input.

### Nominal types

The structural identity layer must preserve nominal meaning. Two distinct nominal types with the same underlying scalar must not be interchangeable at the model or API boundary. The owning projection may encode their validated underlying scalar under different stable field or model tags, but a caller cannot substitute one nominal value where another is required.

Identity-returning APIs must use domain-specific nominal digest types such as package identity, Content DNA identity, answer digest, provenance digest, decision identity, and receipt identity. A generic digest string may be used in a wire projection only after parsing into the exact expected nominal digest type. Matching syntax or bytes do not permit cross-domain substitution.

### Optionals, defaults, and variants

An absent optional must encode as `0x30`. A present optional must encode as `0x31` followed by the complete canonical value, even when the contained value equals a declared default. `None` and `Some(default)` are therefore distinct model states.

When a wire contract permits an omitted field to receive a default during validated model construction, omitted and explicitly supplied default input become the same model value and must receive the same semantic identity. If omission itself has governed meaning, the model must preserve that state as an option or variant rather than relying on decoder history.

Closed enum variants must use stable enum and variant tags rather than rendered names, source declaration order, discriminant layout, or compiler-generated integer values. Renaming a displayed variant may preserve identity only when its stable tag and governed meaning remain unchanged. Reusing a retired variant tag is forbidden.

### Collections and ordering

A sequence must preserve the exact semantic order established by its owning contract. The structural sink must not sort it. Reordering selected memory, visible units, evidence, policy effects, findings, or any other ordered sequence changes identity even when the same elements remain.

Contract `0.1` defines no generic unordered collection. If a logical set participates in identity, its owning contract must first establish one bounded canonical sequence using an explicit semantic key such as a validated nominal identifier. The ordering rule, duplicate behavior, comparison semantics, and tie impossibility must be part of that contract. Locale order, hash-map order, storage order, object-property order, and caller iteration order are forbidden.

Duplicate elements must fail when the owning contract declares set semantics. A sequence that legitimately permits duplicates retains them in order. Empty sequences remain distinct from absent options because their value tags and payloads differ.

### Nested models and Merkle composition

A nested model may be rendered inline as a canonical record when the parent contract owns its complete structural shape. Alternatively, the parent may render a `0x43` child identity containing the exact registered child domain, child contract version, and child semantic digest. The owning parent contract must choose one method for each field; implementations cannot switch based on payload size, cache state, storage layout, or runtime preference.

Child identity references permit bounded Merkle-style package construction. A package may validate and identify one member or atom, retain its typed child identity, release transient ingress bytes, and later render the package root from the ordered child identities. The root identity changes if any referenced child domain, contract version, digest, membership, or order changes.

An artifact digest must not be substituted for a child semantic identity merely because both use SHA-256. If a parent intentionally binds exact artifact bytes as an event or provenance fact, that field must use the artifact digest's nominal type and stable field tag and its inclusion must be explicit in the parent identity projection.

### Digest construction and syntax

Structural identity contract `0.1` must compute SHA-256 over the complete structural stream beginning with the fixed header. The public syntax remains `sha256:` followed by exactly 64 lowercase hexadecimal characters. Implementations must reject uppercase, alternate prefixes, omitted leading zeroes, embedded whitespace, and unsupported algorithms at a nominal digest boundary.

The structural stream may be fed incrementally to the digest implementation. Chunk boundaries, buffering strategy, platform crypto provider, and storage paging must not affect the final digest. An implementation must check all aggregate length arithmetic and semantic ceilings before overflow and must fail without returning a partial or plausible digest.

The SHA-256 primitive may be supplied through an ordinary platform cryptography boundary, but the identity projection, stable tags, normalization decisions, order, version, domain, and authority checks remain Hees-owned Incan behavior. A provider, storage adapter, or serializer must not construct the authoritative preimage independently and ask Hees merely to bless its digest.

### Artifact integrity versus semantic identity

An artifact digest identifies exact bytes. It may cover a delivered manifest, member, archive, replay, or other closed artifact and may change when whitespace, property order, compression, framing, or another representation detail changes. Verifying that digest establishes only that the expected bytes arrived unchanged.

A semantic structural digest identifies the validated identity projection. Equivalent supported wire encodings may produce different artifact digests and the same structural digest. A byte-identical artifact that fails parsing, nominal construction, reference validation, review state, rights state, or another admission rule must not receive an admitted semantic identity.

RFC 005 should therefore retain byte-level manifest and member commitments where exact delivery integrity is required while introducing a separately typed package semantic identity constructed only after complete package admission. The package contract must state where an artifact digest remains an event or provenance fact and where package semantic identity governs equivalence, caching, child composition, policy binding, and Content DNA.

Storage systems may index either identity and may retain a mapping between them, but storage lookup success cannot establish admission. Cache and deduplication behavior must name whether it is byte-exact or semantically exact and must not substitute one digest type for the other.

### JSON and other wire projections

JSON remains a permitted inspectable wire projection. It need not be canonical merely to reconstruct a semantic model, but its owning wire contract must still be closed, bounded, duplicate-safe, versioned, and fail closed. A JSON verifier parses the projection into the exact public verification model, validates it, renders the canonical structural stream, and compares the resulting nominal digest.

Wire projections should carry the exact identity contract required to interpret their typed fields when that contract cannot be inferred unambiguously from the closed envelope version. They may expose domain-specific digest strings but must not expose a generic public operation that accepts arbitrary JSON and a caller-selected domain and returns an authoritative Hees identity.

JCS may remain useful for exact JSON artifact identity, signed JSON ecosystems, interoperable golden projections, and debugging. It is no longer the permanent semantic identity substrate merely because the wire format is JSON.

### Relationship to Content DNA and answer-time provenance

RFC 002 continues to own Content DNA membership, terminal construction, selected-memory-only coverage, answer binding, source-safe entries, atomicity, redaction, and authority limits. This RFC should own the structural rendering and digest rules for the Content DNA body, answer binding, and provenance projection.

The Content DNA public body may remain a closed JSON projection for inspection and export. `content_dna_id` must derive from the validated Content DNA model's structural identity projection rather than from ordinary or JCS JSON serialization. `answer_digest` must derive from the exact validated ordered visible-unit model, and `provenance_digest` must derive from the exact validated package-bound provenance model.

RFC 002 must decide whether exact package artifact identity is an identity-bearing provenance fact in Content DNA in addition to package semantic identity. If it includes both, two semantically equivalent packages delivered through different artifacts intentionally produce different Content DNA. If it includes only semantic identity, exact artifact provenance must remain available through another receipt or audit projection. That choice cannot be inherited accidentally from a serializer.

### Relationship to package admission

RFC 005 continues to own package topology, member descriptors, exact sequencing, bounds, reference validation, atomic admission, reload integrity, and package authority. Its byte-level manifest and member digests may remain exact artifact commitments. This RFC introduces the separate semantic identity produced from the completely admitted package and its contract-owned ordered child identities.

RFC 005 must not treat a semantic digest as proof that the expected artifact bytes arrived, and it must not treat a matching artifact digest as proof that the decoded package model is valid. A complete accepted package capability may carry both typed identities when downstream contracts require both.

### Relationship to governance receipts

RFC 006 continues to own redacted receipt kinds, safe projection, atomic emission, verification claims, and the distinction between integrity, in-process authority, and external authenticity. Its receipt body becomes a validated Incan verification model whose `receipt_id` derives from this RFC's receipt identity domain.

The receipt's JSON envelope remains an export and inspection format. Reformatting an equivalent accepted projection must not change `receipt_id`; changing an identity-bearing receipt claim must. Public verification reconstructs and validates the exact receipt model before recomputing the structural digest and still cannot recreate the original in-process authority.

### Relationship to visible responses

RFC 009 continues to own visible units, support, response lifecycle, repair, clarification, terminal variants, and proposal identity. This RFC owns only the structural identity mechanics used when RFC 009 requires a digest over an exact validated visible-unit or proposal projection.

Exact answer text, unit identifiers, unit order, and any other RFC 009 identity-bearing values remain unchanged before structural rendering unless RFC 009 explicitly assigns a normalized nominal type. Display wrapping, terminal colour, panel layout, and JSON property order remain outside answer identity.

### Compatibility and schema evolution

Every identity domain must publish its exact contract version, model and field tag registry, enum and variant tags, normalization policy, collection semantics, child identity choices, domain string, structural identity version, algorithm, bounds, golden structural bytes, and golden digest.

An implementation upgrade that preserves all of those values must preserve identities regardless of compiler version, runtime, platform, serializer, storage engine, or internal refactoring. Compiler-generated support may reduce boilerplate but cannot infer or renumber stable tags from source order, names, reflection, memory layout, or hash-map iteration.

An authority-bearing projection change must create a new exact identity contract version. Verifiers may support multiple explicit versions, but they must dispatch by exact version and never retry another version after failure. Existing values remain verifiable under their original contract; migration creates a separately governed mapping or new artifact and does not rewrite the historical identifier.

Earlier profiles that define JCS-based identities remain governed by their exact named profile contracts until explicitly migrated. This RFC must not relabel their existing identifiers as structural identities or imply that identical digest syntax means identical preimages.

### Bounds and constrained-resource behavior

Every participating model must have fixed depth, field-count, sequence-count, scalar-byte, child-count, and aggregate structural-input ceilings derived from its owning contract. The structural sink must check bounds before proportional allocation and use checked arithmetic for every encoded length and count.

Implementations should feed structural bytes incrementally into the digest primitive and should not retain a complete JSON document, generic parsed tree, display rendering, or structural stream when the validated model can be traversed safely. Merkle composition may reduce retained package state only where child identities and order are contract-owned; it must not weaken complete validation or atomic package admission.

Resource failure must not return a digest, reuse a partial digest, omit a field, truncate a scalar, reduce a collection, or fall back to artifact identity. The owning governance operation must fail through its declared fail-closed path.

### Verification and acceptance evidence

Before this RFC advances to Planned, a complete golden corpus must publish canonical structural bytes as hexadecimal or another exact byte projection in addition to final digests. Hash-only fixtures are insufficient because they cannot localize cross-runtime encoding disagreement.

The corpus must cover every value tag; minimum and maximum integers; empty and maximum text and bytes; multilingual Unicode; exact versus nominally normalized strings; absent and present optionals; explicit defaults; every enum variant; empty, singleton, maximum, duplicate, and reordered collections; nested inline models; child identities; every registered domain; and every final model and field tag.

Transport-differential fixtures must prove that multiple valid JSON renderings and at least one non-JSON or direct-model construction produce the same semantic identity, while their exact artifact digests may differ. Negative ingress fixtures must cover malformed UTF-8, duplicate and unknown fields, invalid nominal identifiers, bypassed nominal construction, out-of-range integers, unsupported floating point, unknown tags, unknown versions, unknown algorithms, depth and count overflow, and invalid references.

Mutation fixtures must change every identity-bearing field one at a time and prove that the structural stream changes. They must also change every deliberately excluded field and prove that identity remains stable without changing governed behavior. Ambiguity fixtures must prove that different type, length, nesting, option, variant, and sequence shapes cannot produce the same structural stream through concatenation.

At least one independent verifier and every supported Incan runtime must reproduce the golden streams and digests. Compiler-upgrade fixtures must preserve all accepted contract `0.1` identities. Constrained-device evidence must measure peak additional memory, incremental throughput, maximum-depth behavior, package member release, failure cleanup, and verification while representative resident workloads remain active.

## Design details

### Ownership boundary

Hees owns the identity domains, authority-model projections, stable tags, normalization choices, child composition, bounds, digest types, and fail-closed use of identities. Incan supplies the language and runtime in which those contracts are authored. A reusable Incan library capability may implement the structural sink, but it does not choose which Hees fields carry authority or make a generic model authoritative.

If implementation requires new Incan language syntax, compiler derivation, nominal-deserialization guarantees, standard-library cryptography, or stable schema metadata beyond the released language contract, that capability requires its own Incan issue or RFC. This Hees RFC must remain implementable through explicit Incan-authored projections even if compiler derivation is unavailable.

Transport adapters own bounded decoding into declared wire models. Storage adapters own persistence and retrieval of bytes, models, indexes, and cached identities. Neither adapter owns semantic projection rules or terminal authority.

### Contract registration

The accepted contract should maintain one public registry of identity domains, model tags, field tags, enum tags, variant tags, identity versions, and digest types. Entries are append-only within a version lineage; retired tags remain reserved. The registry is a compatibility artifact, not a runtime extension point.

Owning RFCs should define their projection in model terms and reference the shared structural grammar. They should not duplicate byte grammar or invent local serializer rules. New domains require public review because domain choice determines cross-purpose separation and verification semantics.

### Public inspection

Developer tooling may render an identity explanation containing the domain, identity version, participating model type, ordered stable field tags, child identity references, total structural byte count, algorithm, and final digest. Sensitive field values remain subject to the owning projection's disclosure rules; inspectability does not authorize dumping source text, answer text, private policy, or credentials.

An exact structural-byte export may be available only for fixtures and values whose disclosure is already allowed. Verification APIs should accept typed public models or closed envelopes, not arbitrary field streams, so inspection does not become an authority constructor.

## Alternatives considered

### Continue using RFC 8785 JCS for every semantic identity

Rejected as the permanent semantic identity substrate because it couples Hees model identity to JSON and ECMAScript serialization rules. JCS remains a credible exact JSON artifact format and interoperability tool where a contract intentionally needs canonical JSON bytes.

### Hash raw JSON or another wire payload

Rejected because semantically equivalent model values can differ in whitespace, property order, escaping, framing, compression, or other representation details. Raw byte digests remain useful as artifact identities but cannot replace validated semantic identity.

### Hash ordinary model display output

Rejected because display order, spacing, labels, escaping, localization, and diagnostics are presentation concerns that should evolve without rewriting authority-bearing identities.

### Use generic compiler reflection or declaration order

Rejected because renaming, reordering, compiler upgrades, layout changes, and generated metadata could silently change identity. Stable explicit tags and projections make compatibility a reviewed contract.

### Adopt deterministic CBOR, Protocol Buffers, MessagePack, or another binary encoding as the universal identity format

Rejected for contract `0.1` because choosing another serialization format would still couple semantic identity to a transport schema, unknown-field behavior, versioning rules, and implementation-specific deterministic modes. A future exact format may be useful for artifacts or wire exchange without replacing the model-owned semantic projection.

### Concatenate rendered field values

Rejected because values, lengths, types, nesting, optionals, and collection boundaries can become ambiguous. A typed length-delimited stream is required.

### Hash every model field automatically

Rejected because presentation, storage, cache, and diagnostic fields would become authority-bearing accidentally. Explicit projections cost more review effort but make governed meaning and compatibility visible.

### Use random UUIDs for authority-bearing content identity

Rejected because random identifiers cannot independently reproduce or verify model identity, detect semantic mutation, or support deterministic cross-runtime fixtures. Logical nominal IDs may still use UUIDs under their own contracts; they do not replace content-derived structural identity.

### Let the storage engine define canonical rows

Rejected because storage schemas, page layouts, indexes, compression, and migrations are implementation concerns. The same validated model must retain its semantic identity across supported storage representations.

## Drawbacks

The contract creates another carefully governed schema surface in addition to wire models. Stable tags, explicit projections, normalization rules, digest domains, golden bytes, and legacy verifiers require long-term maintenance and disciplined review.

Explicit projections can omit a field that should have been identity-bearing. Automatic serialization avoids that omission risk but introduces a larger accidental-authority risk. Mutation testing, authority review, and owning-RFC acceptance evidence are therefore mandatory rather than optional polish.

Semantic and artifact identities may confuse consumers when both use SHA-256 syntax. Nominal digest types, domain-specific fields, documentation, and negative substitution tests are required throughout the public API and storage integrations.

Unicode and text normalization remain domain-sensitive. Exact preservation is safe but may treat visually equivalent text as different; normalization can improve equivalence but may erase meaningful distinctions or depend on an unstable library. The owning nominal type must resolve that trade-off before its identity contract advances.

Independent verification becomes more work than invoking a common JSON serializer. Publishing exact byte grammar and golden streams offsets that cost, but a new verifier still needs a complete safe implementation.

Merkle-style composition improves bounded operation but creates more typed child identities and migration edges. A parent contract must freeze whether a child is inline or referenced, so future storage optimization cannot silently change identity shape.

## Implementation architecture

This section is non-normative. A practical implementation may expose a small Incan-authored structural sink with operations for the closed scalar and container grammar. Domain-specific private projection functions traverse validated models and feed the sink in stable tag order. The sink writes directly into an incremental SHA-256 state and may optionally mirror bounded bytes for golden-fixture diagnostics.

The implementation should separate three capabilities: validated authority models, non-authoritative public verification models, and the private identity-construction path used by governing operations. They may share structural projection logic, but only the direct governing path can attach in-process authority to its result.

Package construction may identify bounded admitted members independently, retain typed child identities and compact indexes, and construct the final semantic package identity after cross-member validation completes. Public JSON or another transport can be rendered afterward from the validated model without participating in that digest.

Compiler-generated projection support may be considered only after explicit field tags, exclusions, normalization, and versioning remain visible in source and stable in generated output. Manual Incan projections are preferable to a derivation mechanism that infers authority from incidental model structure.

## Layers affected

- **Public authority contracts:** Shared distinction between artifact identity, semantic identity, integrity, runtime authority, and external authenticity.
- **Nominal types and model construction:** Validating constructors, domain-specific digest types, normalization boundaries, and prevention of deserialization bypass.
- **Structural identity runtime:** Closed tagged grammar, bounded incremental sink, SHA-256 boundary, domain registration, and exact verification.
- **Package admission:** Separate exact manifest and member artifact commitments from final admitted package semantic identity and child composition.
- **Governed memory and Content DNA:** Typed atom, answer, provenance, selected-memory, and Content DNA structural identities.
- **Visible-response and receipt contracts:** Typed proposal, visible-unit, terminal projection, and receipt identity independent of wire rendering.
- **Transport and storage adapters:** Strict reconstruction of validated models plus explicit handling of artifact and semantic digest types without owning identity semantics.
- **Compatibility tooling:** Append-only tag registry, structural-byte inspection, golden corpus, independent verifier, migration fixtures, and compiler-version gates.
- **Documentation:** Exact current-versus-proposed capability, disclosure rules, digest claims, and consumer guidance.
- **Incan language or standard library:** A separate Incan proposal only if reusable derivation, schema metadata, nominal deserialization, or cryptographic support exceeds the released language surface.

## Unresolved questions

- Should stable model and field tags be authored directly in each Hees identity contract, generated from an append-only public registry, or authored in both forms with a mechanical equality check?
- Which initial domains and exact projections must be registered before contract `0.1` can replace the JCS identity clauses in RFC 002, RFC 005, RFC 006, and RFC 009?
- Should exact string preservation remain the universal `0.1` default, with normalization available only through dedicated nominal types, or should any domain mandate Unicode NFC or line-ending normalization?
- Does RFC 002 Content DNA bind both package semantic identity and exact package artifact identity, or should exact artifact provenance remain solely in a separate receipt or audit projection?
- Which RFC 005 values remain byte-exact artifact digests, and what exact model and child identities compose the final admitted package semantic identity?
- Should nested independently governed models always use child identity references, or may each owning contract choose inline versus child identity per field?
- Is SHA-256 the only accepted algorithm for every `0.1` domain, and what explicit version transition would introduce another algorithm without runtime negotiation?
- What public verification model permits independent reconstruction of each identity while preventing arbitrary generic field streams from masquerading as authoritative Hees values?
- Can the complete structural sink and nominal validation path be implemented in Incan 0.5.0-dev.14, or is a separate Incan language or standard-library RFC required?
- What exact peak-memory, input-size, depth, member-count, and compiler-version evidence is required before the contract advances from Draft to Planned?

<!-- Rename this section to "Design Decisions" once all questions have been resolved. An RFC cannot move from Draft to Planned until no unresolved questions remain. -->
