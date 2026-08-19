# RFC 011: Canonical Structural Identity for Incan Models

- **Status:** Planned
- **Created:** 2026-07-19
- **Author(s):** Encero Systems
- **Related:**
    - RFC 000 (Foundational Governance Authority)
    - RFC 002 (Content DNA Answer-Time Provenance)
    - RFC 003 (Governed Memory and Retrieval Results)
    - RFC 005 (Canonical Package Artifact Admission)
    - RFC 006 (Export-Safe Governance Receipts)
    - RFC 009 (Governed Visible Response Lifecycle)
    - RFC 010 (hees.ai console)
    - RFC 012 (Governed Effect Capabilities and Execution Receipts)
- **Issue:** https://github.com/encero-systems/hees.ai/issues/18
- **RFC PR:** —
- **Written against:** Hees.ai 0.0.1 / Incan 0.5
- **Shipped in:** —

## Summary

Hees.ai must derive authority-bearing semantic identities from successfully validated Hees.ai-owned Incan model values through one closed, versioned structural identity contract. Each participating contract explicitly declares its identity projection, stable model and field tags, normalization, collection semantics, child composition, and bounds; Hees.ai renders that validated projection into a typed structural byte stream and computes a domain-separated digest without depending on JSON, display formatting, storage layout, reflection order, or caller-controlled serialization.

## Core model

1. **Identity begins after admission.** A structural identity may be created only from a fully constructed, bounded, nominally valid model whose owning contract has completed its required validation. Raw JSON, binary values, database rows, provider payloads, display strings, and generic dictionaries cannot directly create authority identity.
2. **Every identity has a named domain and contract.** `StructuralIdentity` contains an exact domain, identity-contract version, algorithm, and digest. Package, Package Admission Binding, member, memory, Content DNA, answer, provenance, material, activity, goal, decision, effect, and receipt identities are nominally distinct even when they use the same digest algorithm.
3. **Projection is explicit and complete.** An owning contract must enumerate every identity-bearing field and must explain every excluded field. Changing governed meaning, behavior, evidence binding, package scope, support material, learner-state rule, or terminal result must change the relevant identity.
4. **Stable tags replace incidental order.** Model, field, variant, and enum tags come from a public append-only registry. Source declaration order, property order, compiler layout, reflection, storage columns, and map iteration are not identity inputs.
5. **The structural stream is typed and self-delimiting.** Exact tags, lengths, type distinctions, absence, nesting, variants, collections, and child references prevent two different valid model values from producing an ambiguous preimage.
6. **Collection meaning is contract-owned.** Ordered collections preserve the validated semantic order. A logically unordered collection must declare one bounded canonical order before it can participate. The runtime must not impose a locale, hash, or incidental storage order.
7. **Normalization is nominal and deliberate.** Text and bytes are exact by default. An owning nominal type may define a specific normalization before validation and identity construction, but no generic Unicode, case, whitespace, or line-ending normalization is allowed.
8. **Artifact integrity remains different.** A digest over exact delivered bytes proves an artifact claim. A structural identity proves the identity of one validated model projection. Neither proves producer authenticity, semantic truth, rights, or complete policy correctness.
9. **Recursive composition remains bounded.** An owning contract must declare whether a nested model is rendered inline or represented by a child structural identity. The choice is identity-bearing and cannot change silently for storage or performance convenience.
10. **Evolution never rewrites history.** A projection, tag, normalization, ordering, child-composition, or algorithm change requires a new identity contract. Older identities remain verifiable under their declared contract and must never be recomputed under a nearby contract.

## Motivation

Hees.ai needs durable identities for Package authority, governed memory, selected evidence, Content DNA, visible responses, supporting materials, activity bindings, time and goal state, terminal decisions, effects, and receipts. These identities must remain stable when a governed value is loaded from an installed binary Package, a compact local store, a public JSON inspection document, or another supported representation.

JSON canonicalization is safer than hashing ordinary JSON, but it still makes a transport serializer and its primitive rules the semantic identity substrate. Display output has the same problem in a different form: labels, whitespace, localization, diagnostics, and rendering improvements must remain free to evolve. The required identity is not a serialized document; it is a deliberate projection of validated authority-bearing meaning.

This distinction is essential to governance. A matching artifact hash must not grant runtime authority before model validation. Conversely, a semantically identical Package delivered with a different approved storage layout should not lose its governing identity merely because an archive, serializer, or database page changed. Stable structural identities allow a runtime to bind evidence, memory, Content DNA, activity state, goals, and receipts to what was actually admitted rather than to an incidental representation.

The contract also gives future tools an inspectable, durable vocabulary for change. A source update can make a memory identity stale; a changed Package semantic identity can invalidate a prior release decision; an observation can remain clearly separate from an approved curriculum fact; and a hot local memory can activate a colder, separately identified body of governed knowledge without conflating the two. None of that requires a generic database or a model provider to become the source of truth.

## Goals

- Define one canonical structural identity grammar for participating Hees.ai-owned Incan models.
- Define typed, domain-separated semantic identities independent of wire, storage, display, and provider formats.
- Require complete model admission, nominal validation, bounds checking, and contract-owned normalization before identity construction.
- Define stable tag registration, exact scalar and collection encoding, optional and variant semantics, child composition, and incremental hashing.
- Define package semantic identity in coordination with RFC 005 while preserving artifact integrity as a separate exact-byte claim.
- Define identity roles for Package members, governed memory, Content DNA, answers, provenance, supporting materials, activity bindings, temporal and goal state, decisions, effects, and receipts where their owning contracts register them.
- Preserve cross-runtime verification through public golden structural bytes, identity values, and independent verification models.
- Make compatibility and historic verification explicit rather than silently migrating identifiers during a compiler, storage, schema, or application update.

## Non-Goals

- Selecting a Package archive, transport, database, vector index, cache, console, provider, renderer, or external serialization format.
- Creating a generic public operation that hashes arbitrary values, arbitrary JSON, arbitrary field streams, or caller-selected domains into authoritative identities.
- Replacing exact artifact-byte integrity where installation, transport, storage, or audit requires it.
- Proving producer identity, signatures, attestation, source ownership, factual correctness, policy quality, learner competence, or runtime authority solely by verifying a digest.
- Inferring identity fields from compiler reflection, source order, type display strings, database schemas, object properties, or model-provider output.
- Applying implicit text normalization, sorting, default insertion, alias resolution, field migration, or compatibility fallback.
- Defining the semantic contents of Content DNA, Package profiles, memory admission, behavior selection, visible responses, or receipts. Their owning RFCs define those semantics and register their identities through this contract.

## Guide-level explanation

A model may arrive through different representations and still have one semantic identity. Hees.ai first applies representation bounds, constructs the exact closed Incan model, runs every nominal constructor and owning validation rule, then renders the model’s declared identity projection. The identity operation never accepts a generic dictionary or precomputed digest from the caller.

```incan
# Proposed API shape; not implemented in Hees.ai 0.0.1.
atom = admit_memory_atom(candidate_atom)?
identity = identify_memory_atom(atom)

println(f"domain={identity.domain()}")
println(f"contract={identity.contract()}")
println(f"digest={identity.digest()}")
```

Two JSON documents can therefore lead to one memory identity after they construct the same validated model:

```json
{"memory_id":"sleep_pressure","language":"en","body":"Sleep pressure builds while you are awake."}
```

```json
{
  "body": "Sleep pressure builds while you are awake.",
  "language": "en",
  "memory_id": "sleep_pressure"
}
```

Their artifact-byte digests differ because their bytes differ. Their `hees.memory_atom` structural identity is the same only if the same closed model validates with the same nominal values. Changing the atom body, source binding, review state, language, validity range, or another identity-bearing field changes the structural stream and identity. Changing a display color or storage offset does not.

Package identity illustrates the separate claims together. RFC 005 validates the full delivered Package bytes and calculates an `artifact_digest`. It then validates the profile’s complete graph and calculates `package_semantic_identity` through this RFC. Finally, it derives `package_admission_binding` from that exact typed pair. A governed response and its Content DNA are bound to the semantic Package identity; a receipt may additionally show the exact artifact digest and the derived binding that were admitted.

## Reference-level explanation

### Terminology

- **Authority model:** A closed Hees.ai-owned Incan value that has passed the owning contract’s model, nominal-type, reference, and bound validation.
- **Identity projection:** The complete ordered set of values which an owning contract declares identity-bearing for one named domain and contract version.
- **Structural stream:** The exact self-delimiting bytes rendered from one validated identity projection.
- **Structural identity:** A typed record containing an identity domain, identity-contract version, algorithm, and digest over a complete structural stream.
- **Artifact digest:** A nominal digest over exact input, transport, or stored bytes.
- **Child identity:** A structural identity included in a parent projection instead of an inline nested model where the owner declares that composition.

### Normative digest and external JSON basis

Contract `0.1` uses SHA-256 as defined by [FIPS 180-4, Secure Hash Standard](https://csrc.nist.gov/pubs/fips/180-4/upd1/final). A structural identity implementation must not substitute a locally named digest, truncate a digest, or interpret another algorithm as `sha256`.

Structural identity has no JSON dependency. Where a public inspection, import, export, or verification envelope is JSON, its boundary contract follows [RFC 8259, The JavaScript Object Notation Data Interchange Format](https://www.rfc-editor.org/rfc/rfc8259) and [RFC 7493, The I-JSON Message Format](https://www.rfc-editor.org/rfc/rfc7493). A boundary that additionally requires canonical JSON bytes may declare [RFC 8785, JSON Canonicalization Scheme](https://www.rfc-editor.org/rfc/rfc8785), but those bytes may identify only that declared edge artifact. They must never become a structural identity preimage or bypass closed-model validation.

### Structural identity record

Every structural identity must be a closed typed record:

```text
StructuralIdentity
  domain: registered lowercase ASCII domain identifier
  contract: exact identity contract version
  algorithm: sha256
  digest: exactly thirty-two digest bytes
```

For public text and inspection, a structural identity must render as `hees-si:<domain>:<contract>:sha256:<64 lowercase hexadecimal characters>`. The textual rendering is a presentation of the typed record; an owning model or operation must retain nominal identity types and must not accept this text through an untyped string field.

Identity domains use the grammar `[a-z0-9][a-z0-9_-]*(\.[a-z0-9][a-z0-9_-]*)+`. Hees.ai-owned domains use the `hees.` prefix, such as `hees.package`, `hees.memory_atom`, and `hees.receipt`. This domain grammar is distinct from the underscore-delimited identifiers used where a contract name cannot contain a dot.

Contract `0.1` permits only `sha256`. A future algorithm, digest size, or rendering change requires a new identity contract and an explicit verifier route; a verifier must not negotiate, guess, or retry an alternate algorithm after failure.

### Structural stream framing

Every stream begins with this exact header:

```text
ASCII bytes "HEES-SI\0"
unsigned big-endian structural-wire number: 1
registered domain text value
identity-contract text value
root value
```

The root value must be one declared identity-projection record. The domain and contract in the header must match the typed `StructuralIdentity` returned by the operation. A stream must not contain its final digest, display text, artifact digest, caller-provided identity, or a generic metadata field unless the owning projection declares one of those values identity-bearing under its own type.

### Typed value grammar

Structural rendering must use these exact tags and no aliases:

```text
0x01  false
0x02  true
0x10  signed integer: exactly eight two's-complement big-endian bytes
0x11  unsigned integer: exactly eight big-endian bytes
0x20  text: unsigned big-endian u32 byte length and exact UTF-8 bytes
0x21  bytes: unsigned big-endian u32 byte length and exact bytes
0x22  artifact digest: registered digest algorithm and exact digest bytes
0x30  absent optional
0x31  present optional followed by one typed value
0x40  record: u16 model tag, u16 field count, ascending u16 field tag and typed value pairs
0x41  sequence: u32 element count followed by typed values in semantic order
0x42  variant: u16 variant tag followed by one declared payload
0x43  child structural identity: complete closed `StructuralIdentity` record
```

All tags, lengths, counts, integer values, nested depth, and aggregate byte calculations must be checked before proportional allocation. A record must contain exactly the model’s declared identity-bearing field tags in ascending order. Unknown, duplicate, omitted, or reordered field tags must reject identity construction. The grammar distinguishes an absent optional from a present default-valued optional, a text string from bytes, a direct nested record from a child identity, and a sequence from a variant.

### Stable tag and identity registry

Hees.ai must maintain one public append-only identity registry. It must contain every identity domain, identity contract, model tag, field tag, enum tag, variant tag, child-composition rule, normalization rule, collection-order rule, bound, semantic role, and golden-fixture identifier needed to verify a registered projection.

The registry is the sole authority for tag allocation. A tag is never inferred from a model name, source declaration order, reflection output, field position, storage schema, compiler release, or map iteration. Entries remain reserved after retirement. An owning RFC may add a new domain or new contract only through explicit public review and must provide a complete projection and compatibility record.

The registry must support domains for Package semantic identity, Package Admission Binding, Package members, governed memory, evidence selection, Content DNA, visible answers, provenance, supporting materials, activity bindings, temporal and goal state, terminal decisions, effects, and receipts. A domain may be registered only when its owner declares its exact identity role; a broad category name does not create a usable identity by itself.

### Projection, nominal validation, and normalization

An owning contract must identify every included field, its nominal type, whether it is rendered directly or through a child identity, and why its omission is safe. A field must be included when changing it can alter governed behavior, authority, evidence support, rights eligibility, review state, Package scope, material selection, activity meaning, temporal condition, goal continuity, localization semantics, terminal outcome, or receipt claim.

Text and bytes must be exact by default. A nominal type may declare a deterministic normalization before validation and identity construction, such as a particular Unicode or line-ending rule, only when the owning contract states the rule, version, and semantic rationale. Generic NFC, NFD, case folding, locale transformation, whitespace folding, and automatic default insertion are forbidden. Two visually similar values remain distinct unless their nominal type explicitly defines them as equivalent.

### Collections, nesting, and composition

An ordered collection must render in its validated semantic order. An unordered collection must define one bounded ordering key made entirely from validated identity-bearing values, and must reject a collision where that key cannot produce one strict order. The runtime must not substitute database order, locale collation, hash order, or a display order.

Every nested model must be declared inline or child-identified by its owning contract. Inline rendering is appropriate where the nested data has no independent governed lifecycle. A child structural identity is appropriate where a value is independently admitted, versioned, cached, retained, disclosed, or referenced. The same parent contract must make the same choice across all implementations. A child identity does not waive validation: its parent must validate its required domain, contract, and relationship before accepting it.

Merkle-style composition is permitted only through declared child identities and declared ordered references. The parent stream remains complete because it contains its domain, contract, tags, and every child identity in its required position. An implementation may calculate the child identities incrementally, but it must not omit a child, reorder children, replace a child with raw bytes, or choose a different inline form for memory convenience.

### Package semantic identity and artifact integrity

RFC 005 owns exact Package artifact framing, profile topology, member sequence, byte digests, typed member admission, and complete graph validation. After those checks succeed, the profile renders its Package semantic-identity projection into the `hees.package` domain. The projection must include the Package, domain, revision, profile, declared mission, required topology, and ordered validated member child identities defined by the profile.

`artifact_digest` identifies the exact complete Package byte stream. `package_semantic_identity` identifies the validated Package profile projection. `package_admission_binding` identifies the exact typed pair and is rendered only after both primary values verify. The Package semantic identity must not be calculated from an artifact digest, and a matching artifact digest must not be treated as semantic admission. A receipt, installation audit, or deployment policy may require all three typed values and must label them separately.

A human-facing binding reference may add ISO/IEC 7064 MOD 97-10 check digits to its textual rendering. Those check digits are a transcription check, not an identity algorithm. They remain outside the structural identity preimage and must never be treated as a replacement for semantic, artifact, or binding verification.

### Content DNA, answers, provenance, and receipts

RFC 002 owns Content DNA membership, selected-memory coverage, answer binding, source-safe projections, atomicity, redaction, and authority limits. This RFC owns the structural-identity mechanics used by the Content DNA body, its answer binding, and its Package provenance binding. Content DNA must bind the exact `hees.package` semantic identity of the Package that governed the answer. Its owning contract may carry an artifact digest as an explicitly named delivery-provenance fact, but an artifact change must not silently change Content DNA identity merely because a serializer or storage layout changed.

RFC 006 owns safe receipt projection and public verification. A receipt body must be reconstructed as a validated closed model, and its `receipt_id` must be a `hees.receipt` structural identity. Its inspection envelope may be JSON or another approved external encoding. Reformatting the same accepted receipt model must not change its receipt identity. A receipt verifier proves the identity of the public projection, not the authority or authenticity of the original process.

RFC 009 owns visible-unit, response, repair, clarification, and terminal-result semantics. Exact visible text, unit identifiers, unit order, support bindings, and identity-bearing terminal facts must enter its declared structural projections. Terminal colors, panel geometry, display wrapping, localization of an inspection label, and JSON property order are not answer identity inputs unless the owning response contract explicitly governs them.

### Public verification and disclosure

An independent verifier must reconstruct only a registered closed public verification model, validate it, render the registered structural stream, and compare the expected `StructuralIdentity`. It must not expose a generic endpoint that accepts caller-specified fields and returns an authoritative identity. A verification result must make clear whether it proved valid public-model identity, exact artifact bytes, both, or neither.

Developer tooling may explain a structural identity through its domain, contract, participating model tag, ordered field tags, child identities, byte count, and final digest. It must follow the owning contract’s disclosure rules. Inspectability does not authorize exposing private source text, credentials, sensitive learner state, internal reasoning, or hidden policy.

### Compatibility, bounds, and failure behavior

Every registered identity projection must define maximum depth, field count, sequence count, scalar bytes, child count, and aggregate structural bytes. Identity construction must use checked arithmetic and fail closed on every bound, tag, type, reference, normalization, or digest error. It must not return a partial identity, truncate input, omit a field, reuse a partial digest, fall back to artifact identity, or select a neighboring contract.

An implementation change preserves identity only when it preserves the exact registered domain, contract, tags, projection, normalization, collection semantics, child choices, structural grammar, and algorithm. A changed identity rule creates a new contract. Historic values remain verifiable only under their stated contract; migration creates a separately governed new value or mapping and does not rewrite the original identity.

### Verification and acceptance evidence

Every registered domain must publish golden structural bytes in an exact portable representation as well as final identities. Hash-only fixtures are insufficient because they cannot localize a cross-runtime encoding disagreement. The corpus must cover every scalar and container tag, boundary lengths and values, multilingual text, explicit normalization cases, absent and present optionals, every variant, maximum nesting, duplicate and reordered collections, inline models, child identities, every registered domain, and every identity-bearing field mutation.

Transport-differential fixtures must prove that multiple valid external representations and direct typed construction produce one semantic identity when they produce the same validated model. Artifact fixtures must prove that differing bytes can have distinct artifact digests while reconstructing the same semantic model. Negative fixtures must cover invalid UTF-8, malformed bounds, unknown tags, unknown contracts, duplicate fields, invalid nominal values, attempted validation bypass, incorrect child domain, child contract, or child identity, and cross-domain substitution.

At least one independent verifier and every supported Hees.ai runtime must reproduce the registered goldens. Constrained-resource evidence must measure incremental hashing, peak additional memory, bounded nested behavior, release of transient package-member data, failure cleanup, and verification while representative resident workloads remain active.

## Design details

### Ownership boundary

Hees.ai owns identity domains, projections, tags, normalization choices, collection rules, child composition, digest types, and authority use. Incan provides the language and runtime in which those contracts are authored. Transport and storage adapters own bounded reconstruction and persistence, not semantic identity. A provider, renderer, activity, or external verification adapter may consume a verified identity but cannot determine which fields carry authority.

### Incan authoring requirement

Identity projections and their governing model validation must be authored in Incan. A reusable Incan library may provide a bounded incremental structural sink and SHA-256 capability, but it must not infer an authority projection from reflection or serialization. If a required primitive is genuinely absent from the released Incan surface, the gap must be reduced to a minimal reproducible case and tracked in the Incan backlog before a narrow foreign boundary is introduced.

### Full-scope identity continuity

The contract is designed for an entire governed system rather than only one response path. It supports versioned Package graphs, approved memory, support material, activities, learner journeys, temporal goal keeping, observations, policy and effect execution, terminal decisions, and audit artifacts. Each area remains separately owned, typed, bounded, and registered; structural identity provides continuity across them without collapsing them into one generic document.

## Alternatives considered

### Continue using JSON canonicalization for semantic identity

Rejected because it couples semantic authority to JSON and its serializer rules. Canonical JSON remains credible for an exact JSON artifact or external inspection format but is not the permanent semantic identity substrate.

### Hash raw wire or storage bytes

Rejected because semantically equivalent validated models can differ in framing, escaping, ordering, compression, indexing, or storage layout. Exact-byte hashes remain artifact identities and do not replace semantic identity.

### Hash ordinary model display output

Rejected because display output legitimately changes with labels, spacing, localization, diagnostics, and user-interface improvements.

### Use compiler reflection or source declaration order

Rejected because model names, source order, layout, compiler upgrades, and generated metadata are incidental. Explicit registry tags and projections make compatibility a reviewed contract.

### Use a universal deterministic binary serialization as the identity format

Rejected because a universal serialization still imports transport schema, unknown-field, evolution, and implementation behavior into identity. A binary storage or transport may be useful, but the identity remains a model-owned typed structural projection.

### Generate random identifiers for authority-bearing content

Rejected because random identifiers cannot independently reproduce semantic identity, detect governed mutation, or support cross-runtime verification. Logical identifiers may use other grammars under their own contracts but do not replace content-derived structural identity.

## Drawbacks

The contract adds a stable registry, typed digest values, explicit projections, golden structural bytes, historic verifiers, and cross-runtime compatibility duties. It requires more deliberate design than delegating identity to a serializer or database. Excluded-field mistakes are possible, while including too much can make harmless presentation or storage changes look semantic.

Those costs are preferable to accidental authority. Explicit projections, mutation fixtures, owner review, and independent verification make it possible to explain exactly why a value has an identity and when it must change.

## Implementation architecture

Hees.ai should provide an Incan-authored structural identity surface that accepts only validated domain models or closed public verification models. It should render typed values incrementally into a SHA-256 state, produce nominal structural identities, and make an optional bounded structural explanation available only where disclosure is permitted. Domain-specific model projections must remain in their owning contracts rather than in a generic serializer.

An implementation may calculate registered child identities independently, retain compact typed identities, and release original bytes after validation. It may cache the resulting identity only under an explicit cache-integrity policy. It must preserve the public grammar, tag registry, nominal types, and fail-closed behavior regardless of runtime, platform, or storage representation.

## Layers affected

- **Public authority contracts:** Distinct semantic identity, artifact integrity, runtime authority, and producer-authenticity claims.
- **Nominal models:** Validating constructors, explicit normalization, field inclusion, domain-specific identity types, and prevention of untrusted deserialization bypass.
- **Structural identity runtime:** Closed tagged grammar, incremental hashing, registry resolution, child composition, exact verification, and failure behavior.
- **Package admission:** Typed Package semantic identity after full profile admission, distinct complete artifact-byte integrity, and a derived Package Admission Binding for their exact pairing.
- **Governed memory and Content DNA:** Identity continuity for atoms, selected-memory results, supporting material, answer bindings, provenance, and Content DNA.
- **Experience and session contracts:** Typed identity for activities, media bindings, learner journeys, temporal goals, observations, assessments, and governed state transitions where their owning contracts register them.
- **Response, effect, and receipt contracts:** Exact identity over visible units, terminal outcomes, effect declarations and receipts, and safe public receipt projections.
- **Transport and storage adapters:** Bounded closed-model reconstruction, explicit artifact checks, cache safety, and no ownership of semantic identity.
- **Compatibility tooling:** Public registry, golden streams, independent verifier, migration fixtures, compiler-version gates, and constrained-resource evidence.
- **Incan language and libraries:** Incan-authored projections and reusable primitives, with separately tracked language or library gaps where needed.

## Design Decisions

- Structural identity is derived from validated typed Incan models, never from JSON, display output, storage layout, reflection, or caller-controlled serialization.
- The public structural identity registry is append-only and authoritative for domains, tags, projection rules, normalization, collection semantics, child composition, bounds, and golden fixtures.
- Text and bytes are exact by default. Only an explicitly named nominal type may normalize them before identity construction.
- Each owning contract chooses and freezes inline versus child identity composition for every nested governed value.
- `sha256` is the sole identity algorithm for contract `0.1`; any algorithm change requires a new exact identity contract and verifier route.
- Package semantic identity is distinct from artifact digest. Content DNA binds Package semantic identity; receipts may additionally carry exact artifact provenance as a different typed field.
- Package Admission Binding is a separate structural identity over the exact semantic-identity and artifact-digest pair. Optional human check digits detect transcription errors only and are not an authority or cryptographic substitute.
- Public verification accepts only registered closed verification models or envelopes. It must not expose a generic arbitrary-value identity constructor.
- Identity projections and validation are Incan-authored. A verified Incan capability gap must be tracked before a narrow foreign capability boundary is introduced.
