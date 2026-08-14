# RFC 005: Canonical Package Artifact Admission

- **Status:** Planned
- **Created:** 2026-07-17
- **Author(s):** Encero Systems
- **Related:**
    - RFC 000 (Foundational Governance Authority)
    - RFC 001 (Spectrum Terminal Adjudication)
    - RFC 002 (Content DNA Answer-Time Provenance)
    - RFC 003 (Governed Memory and Retrieval Results)
    - RFC 004 (Composable Governance Constraints)
    - RFC 006 (Export-Safe Governance Receipts)
    - RFC 007 (Evidence-Grounded Claim Verification Findings)
    - RFC 008 (Governed Behavior Envelopes)
    - RFC 009 (Governed Visible Response Lifecycle)
    - RFC 011 (Canonical Structural Identity for Incan Models)
    - RFC 012 (Governed Effect Capabilities and Execution Receipts)
- **Issue:** https://github.com/encero-systems/hees.ai/issues/6
- **RFC PR:** —
- **Written against:** Hees.ai 0.0.1 / Incan 0.5.0-dev.14
- **Shipped in:** —

## Summary

Hees.ai must admit a complete governed Package through a closed, profile-registered binary artifact contract that validates exact delivered bytes, reconstructs bounded typed member models, validates their complete cross-member graph, and atomically yields one authoritative `AdmittedPackage`. The contract deliberately separates the exact-byte `artifact_digest` used for installation and delivery integrity from the typed `package_semantic_identity` defined by RFC 011 and used to bind governed runtime behavior, Content DNA, and receipts.

## Core model

1. **A Package is an authority unit, not a document.** A Package binds one domain, revision, declared profile, governance graph, experience graph, supporting material references, and eligible runtime behavior. Its admitted form is the only Package form that may supply trusted runtime authority.
2. **Artifact integrity and semantic identity are different claims.** `artifact_digest` identifies the exact complete delivered byte stream. `package_semantic_identity` identifies the fully validated Package meaning. `package_admission_binding` derives from their exact typed pair and provides one compact reference to that admission event without replacing either claim. None proves producer authenticity, factual correctness, source rights, or policy quality by itself.
3. **The binary artifact is closed and self-delimiting.** `hees_package_wire_0_1` defines a byte preamble, a closed binary manifest, and an ordered series of bounded binary members. JSON, text exports, archives, and storage pages may carry or reconstruct the Package, but they are not its authority-bearing wire substrate.
4. **A declared profile owns topology.** Each registered Package profile declares the permitted member kinds, their exact order and multiplicity, cross-member references, resource bounds, runtime eligibility rules, and semantic-identity projection. Unknown profiles, members, fields, aliases, extension maps, or compatibility guesses must fail closed.
5. **Admission is sequential and atomic.** Hees.ai validates the manifest, accepts exactly the next declared member bytes, validates each member against its descriptor and profile, then performs complete graph validation. No partial state is an admitted Package; any failure discards the provisional branch.
6. **Package-relative declarations stay package-relative.** Members declare content, behavior, material, and policy without repeating the containing Package identity. Successful admission binds one trusted `AdmittedPackageIdentity` to every imported runtime object without mutation, reserialization, or caller substitution.
7. **Cross-package confusion is rejected.** A proposal, retrieval result, behavior selection, activity binding, supporting-material reference, Content DNA body, receipt, or effect request must match the exact trusted Package semantic identity required by its governing operation. Matching a package identifier or revision alone is never enough.
8. **Profiles enable breadth without generic authority.** A public registry may add profiles for governed learning, agents, operational workflows, or other domains, but each profile remains closed and independently reviewable. A Package cannot smuggle new behavior into an existing profile through metadata or an unrecognized member.

## Motivation

Hees.ai currently admits in-memory governance models and validates a descriptor that points toward a Package. It does not yet establish a portable, byte-verified, typed Package artifact whose authority survives installation, reload, or transport. That leaves a gap between a reviewed package candidate and the runtime object which is actually allowed to govern a model proposal, select evidence, present material, maintain a learning or task goal, or execute a declared effect.

Canonical JSON is useful for external exchange and inspection, but it is not the correct permanent internal authority substrate. JSON makes formatter, escaping, number, duplicate-property, and serializer choices part of an identity contract that must work across constrained devices, native runtimes, indexed storage, and future package profiles. A Package should instead enter Hees.ai as one explicit closed binary contract, become validated typed Incan models, and derive semantic identity from those models under RFC 011.

The separation of exact bytes from admitted meaning is intentional. An installer must be able to prove that the byte stream it received is exactly the byte stream the publisher intended to distribute. A runtime must also be able to prove which fully validated Package governs a decision even where an equivalent Package has been delivered through another approved encoding, transport, storage layout, or compression layer. Conflating those claims would make harmless delivery changes look like authority changes, or worse, let a matching file hash bypass semantic validation.

The Package is also the bridge between authoring and runtime without transferring authority to an authoring surface. An external tool may compose a candidate, review supporting material, define lessons or other journeys, bind activities, configure goals and time rules, and release a byte artifact. Hees.ai admits only the closed artifact and remains the final authority for runtime eligibility and behavior. The same model supports rich governed learning experiences without turning runtime admission into a generic content-management interface.

## Goals

- Define a storage-neutral, binary, closed Package artifact contract with an exact complete-byte digest.
- Define profile-registered Package topology for governance primitives, experience structures, supporting materials, activity bindings, temporal and goal rules, localization, assessment, and declared effects where a profile permits them.
- Define typed package semantic identity after complete validation under RFC 011.
- Define an opaque sequential admission state machine with exact terminal behavior for malformed, missing, extra, reordered, replayed, over-limit, mismatched, and cross-package input.
- Keep retained admission state bounded while permitting large Packages to be admitted member by member.
- Require complete cross-member reference, identifier, dependency, rights-state, profile, and package-identity validation before a Package becomes authoritative.
- Define immutable binding of Package identity to runtime models, Content DNA, receipts, effect receipts, and future governed-session state.
- Preserve public inspection and import/export paths without making a serializer, database, archive, or network protocol the semantic authority.
- Define golden artifacts, independent verification, failure precedence, constrained-resource evidence, and compatibility expectations for every registered profile.

## Non-Goals

- Authoring, reviewing, signing, publishing, locating, fetching, selecting, or promoting Package candidates inside Hees.ai.
- Defining an archive, compression, encryption, object-store, filesystem, database, memory-map, transport, synchronization, or key-management protocol.
- Authenticating a publisher, proving a source right, assessing factual correctness, proving pedagogical quality, or replacing human review.
- Accepting arbitrary key/value metadata, arbitrary member types, dynamic capabilities, runtime-selected profile rules, or extension maps inside an admitted Package.
- Treating a matching artifact digest, profile name, package identifier, or revision as partial admission.
- Defining activity implementation internals, media rendering engines, model-provider protocols, or presentation UI. A Package may bind reviewed identities for such artifacts only where its profile declares the binding.
- Allowing a runtime interaction, retrieval outcome, or learner observation to mutate reviewed Package content, semantic identity, Content DNA, or release state automatically.
- Replacing the separate ownership of Content DNA, memory admission, constraints, claim verification, behavior envelopes, visible responses, receipts, and effect execution in their respective RFCs.

## Guide-level explanation

A Package is delivered as one exact binary stream. The caller supplies that stream and its expected artifact digest. Hees.ai first proves the exact stream identity, then validates its manifest and members in profile-defined order. No caller-supplied path, member label, member digest, package identity, or profile fallback can redirect the admission path.

```incan
# Proposed API shape; not implemented in Hees.ai 0.0.1.
artifact = read_installed_package_bytes()
expected_artifact = ArtifactDigest.parse("sha256:63d96c8cf4af9c207646a8e72617e450778a5dc52b45998f85218fa4142b8970")?
admission = admit_package_artifact(artifact, expected_artifact)

match admission:
    case Ok(package):
        println(f"package={package.identity().package_id()}")
        println(f"semantic={package.identity().package_semantic_identity()}")
        println(f"artifact={package.identity().artifact_digest()}")
    case Err(error):
        println(f"package admission rejected: {error.reason()}")
```

Successful admission produces a typed value whose identity contains both primary claims and a derived binding:

```text
AdmittedPackageIdentity
  package_id: sleep_foundations
  domain_id: governed_learning
  package_revision: 2.3.0
  package_semantic_identity:
    domain: hees.package
    contract: 0.1
    digest: sha256:5bfe…
  artifact_digest: sha256:63d9…
  package_admission_binding:
    domain: hees.package_admission
    contract: 0.1
    digest: sha256:2e61…
```

The semantic identity is the runtime binding. For example, a memory result must match the admitted Package semantic identity, and a Content DNA body carries that semantic identity as the Package that governed answer-time selection. The artifact digest remains available for installation audit, delivery debugging, and receipts that must prove the exact delivered bytes. The Package Admission Binding is useful when an operator needs one reference to the exact admitted pairing, but it does not grant authority when presented alone.

The byte stream is not a generic object encoding. It is an exact Package wire contract:

```text
preamble | manifest-length | binary-manifest | declared-member-bytes...
```

The manifest declares the profile and the exact ordered descriptors. A descriptor commits to one member’s identifier, kind, member contract, byte length, exact byte digest, logical record count, and semantic child identity. A profile defines which descriptors are legal together. A governed-learning profile, for example, may require governance and evidence members while declaring optional instructional graph, supporting-material, activity-binding, localization, temporal-goal, and assessment members. Another profile may use a different closed topology. Neither profile can accept a member that it did not declare.

## Reference-level explanation

### Terms

- **Package artifact:** The complete `hees_package_wire_0_1` byte stream submitted for admission.
- **Artifact digest:** A nominal SHA-256 digest over the exact complete Package artifact bytes.
- **Package profile:** A public, closed contract that owns a Package topology, member schemas, bounds, reference rules, and semantic-identity projection.
- **Member descriptor:** The manifest record that commits to one expected member before its bytes are decoded.
- **Admitted Package:** The opaque authoritative runtime value returned only after full artifact, member, graph, and profile validation succeeds.
- **Package semantic identity:** The RFC 011 structural identity of one fully validated Package profile projection.
- **Child semantic identity:** The RFC 011 identity of a validated member or independently governed nested artifact used by the Package semantic projection.
- **Package Admission Binding:** The RFC 011 structural identity of the exact pair of an admitted Package semantic identity and its verified artifact digest.

### Exact artifact wire

`hees_package_wire_0_1` must use the following fixed preamble and framing:

```text
offset  size  value
0       8     ASCII bytes "HEESPKG\0"
8       2     unsigned big-endian wire-contract number: 1
10      4     unsigned big-endian manifest byte length
14      N     complete binary manifest bytes
14 + N  …     member byte sequences in manifest descriptor order
```

The complete artifact digest must be `sha256:<64 lowercase hexadecimal characters>` over every byte in the preamble, length field, manifest, and member sequence. Hees.ai must compare it with the expected `ArtifactDigest` before returning an admitted Package. It must not trim, normalize, decompress, reserialize, or hash a decoded model in place of the submitted bytes.

The framing has no trailing bytes. The sum of manifest and declared member lengths must equal the total submitted length using checked arithmetic. A byte sequence with a valid prefix and missing tail, extra tail, integer overflow, invalid magic, unknown wire contract, or manifest length beyond the profile-independent pre-parse ceiling must reject before a proportional allocation.

### Closed binary values

The manifest and members use one self-delimiting closed binary value grammar. Values must be encoded with these tags and no aliases:

```text
0x01  false
0x02  true
0x10  signed integer: exactly eight two's-complement big-endian bytes
0x11  unsigned integer: exactly eight big-endian bytes
0x20  UTF-8 text: unsigned big-endian u32 byte length followed by exact UTF-8 bytes
0x21  byte string: unsigned big-endian u32 byte length followed by exact bytes
0x22  SHA-256 digest: exactly thirty-two raw bytes
0x30  absent optional
0x31  present optional followed by one value
0x40  record: u16 type tag, u16 field count, then ascending u16 field tag and value pairs
0x41  sequence: u32 element count followed by values in declared order
0x42  variant: u16 variant tag followed by one declared variant payload
0x43  semantic child identity: closed `StructuralIdentity` record defined by RFC 011
```

All lengths and counts must be checked before allocation. Text must be valid UTF-8 without a byte-order mark. Integer values are exact and have no alternate width, sign, floating-point, decimal, or textual-number representation. A record must contain exactly the required field tags for its declared type, in strict ascending tag order, and must not contain an unknown, duplicate, omitted, or reordered field. Sequences preserve declared semantic order and are never sorted or deduplicated by admission. The binary grammar is reversible and independently decodable; it is not RFC 011’s structural identity stream.

### Stable schema registry

Hees.ai must maintain a public append-only Package wire registry containing type tags, field tags, variant tags, profile identifiers, member-kind identifiers, member-contract versions, and every closed profile topology. A registry entry must state the owner, bounds, semantic role, reference targets, and compatibility lineage. Tags are never inferred from source order, field names, compiler reflection, storage layout, or map iteration. Retired tags remain reserved.

Every Package profile must identify one exact profile contract. Profile registration must define all of the following:

- the legal ordered member grammar, including required, optional, singleton, repeating, and mutually dependent members;
- every member’s closed wrapper and payload contract;
- identifier namespaces, cross-member references, uniqueness rules, and failure precedence;
- pre-parse, per-member, aggregate, graph, and retained-state bounds;
- permitted governed runtime capabilities, material types, activity bindings, temporal and goal semantics, localization rules, and effect declarations where applicable;
- the complete RFC 011 Package semantic-identity projection and each required child identity; and
- conformance corpus and independent-verifier obligations.

No profile may inherit unknown members, use a generic payload, accept a generic map, or reinterpret another profile’s descriptor as compatible. A profile extension is a new registered contract, not a runtime negotiation.

### Manifest and descriptors

The manifest must be a closed binary record with exactly these fields:

- `wire_contract`, exactly `0.1`;
- `package_id`, one bounded canonical package identifier;
- `domain_id`, one bounded canonical domain identifier;
- `package_revision`, one bounded exact revision value;
- `profile_id` and `profile_contract`, which resolve to one registered profile;
- `mission`, bounded non-empty text describing the Package’s declared purpose; and
- `members`, one bounded non-empty ordered descriptor sequence.

The manifest must not carry a self digest, Package semantic identity, locator, path, URL, storage key, transport hint, compression flag, encryption detail, arbitrary metadata, caller capability, or an extension map. Its exact artifact commitment is external and non-circular.

Every descriptor must contain exactly `member_id`, `member_kind`, `member_contract`, `byte_length`, `member_artifact_digest`, `record_count`, and `semantic_identity`. Descriptor identifiers and exact member artifact digests must be unique within a Package. `byte_length` must be positive unless the declared profile explicitly permits a zero-byte member, and `record_count` must have the profile-defined meaning. `semantic_identity` is a declared expected child identity; admission must recompute it after the member model is valid and compare it exactly. The member must not repeat a containing Package identity or its own byte digest.

### Member topology and scope

The registry must define one closed member topology per profile. A profile may compose members in these broad categories when it declares their exact contracts:

- governance declarations, including actions, evidence, memory, constraints, claim verification, behavior, visible-response, and effects;
- experience declarations, including module and lesson structure, learner journeys, activity bindings, assessment, supporting materials, accessibility and localization variants;
- session declarations, including goals, temporal conditions, return behavior, progress states, and bounded observation rules; and
- independently governed material references, including media, interactive artifacts, simulations, and packages whose own identities and eligibility are explicitly bound.

These categories do not authorize a member by name. A profile contract must name each permitted member kind and its exact order. A member which does not belong to the profile rejects even if its bytes, digest, or locally valid schema would otherwise be acceptable.

Members are Package-relative. A member may reference another member only through a declared identifier and expected semantic identity in the profile-defined namespace. An action, evidence item, memory atom, activity binding, supporting material, lesson, goal, translation, or effect declaration must not resolve across Packages without an explicitly declared and admitted cross-Package contract. A package identifier string, revision string, or artifact digest alone must never authorize a cross-Package reference.

### Sequential admission and atomic completion

`begin_package_admission` must validate the artifact preamble, expected artifact digest syntax, manifest length, manifest digest contribution, binary manifest shape, profile resolution, descriptor uniqueness, topology, and aggregate declared bounds before returning an opaque provisional state. It must not return a partial Package or expose a trusted Package identity.

`admit_next_package_member` must accept only raw bytes for the next descriptor. It must reject a missing member, bytes beyond the declared length, byte-digest mismatch, malformed binary value, wrapper mismatch, schema violation, invalid child semantic identity, record-count mismatch, duplicate logical identifier, invalid reference, or profile-bound failure. It must not accept a caller-supplied member identifier, kind, profile, expected digest, path, or locator.

`finish_package_admission` must reject until every descriptor has succeeded and every full graph invariant has been checked. It must then calculate the typed Package semantic identity from the profile’s complete RFC 011 projection, compare all required child identities, bind one `AdmittedPackageIdentity`, and atomically return the opaque Package. A terminal failure invalidates the provisional branch. Retaining an immutable predecessor state may create an independent branch, but only a successful finish may expose authority.

### Admitted identity and downstream binding

An `AdmittedPackageIdentity` must contain `package_id`, `domain_id`, `package_revision`, `package_semantic_identity`, `artifact_digest`, and `package_admission_binding`. The semantic identity is a typed RFC 011 identity in domain `hees.package`; the artifact digest is a typed `ArtifactDigest`; and the binding is a typed RFC 011 identity in domain `hees.package_admission`. They are never aliases and must not be accepted through one generic string parameter.

`package_admission_binding` must be calculated only after the Package semantic identity and artifact digest have both verified. Its structural projection must contain exactly the semantic identity’s complete typed record and the complete artifact digest typed value, in that order. It must not contain display text, a caller-selected short hash, a package identifier, a revision, a timestamp, or a third-party claim. The binding is therefore sensitive to a change in either primary claim while leaving their distinct authority meanings intact.

For human transcription and comparison, tooling may render the binding as an exact textual reference with ISO/IEC 7064 MOD 97-10 check digits over the normalized display body. A check-digit failure must reject that human input before lookup. A successful check-digit comparison proves only that the text was likely copied accurately; it must never be presented as a cryptographic check, a semantic identity, exact artifact verification, authenticity, or runtime authority. An operation that consumes the reference must resolve the full typed binding and independently validate both primary identities.

Runtime admission compares the semantic identity named by the governing contract. A trusted package snapshot therefore cannot be manufactured from request echoes, a model proposal, a reloaded descriptor, or a matching package identifier. Exact artifact identity may additionally be required by an installation, deployment, receipt, or audit contract, but it must not substitute for semantic identity.

Content DNA must bind the exact `package_semantic_identity` that governed selected-memory and answer-time behavior. A Content DNA body may carry an exact artifact digest only when its own contract expressly describes delivery provenance; the presence or absence of that audit fact must not silently redefine Content DNA. Governance receipts must carry the Package semantic identity and may carry the exact artifact digest as a distinct delivery-provenance field. A receipt verifier must validate each field by its declared type and must not derive one from the other.

### Reload, storage, and transport

Storage and transport adapters may retain raw artifact bytes, decoded member models, profile indexes, child identities, compact compiled projections, and Package Admission Bindings. Before using a cached or reloaded Package as authority, Hees.ai must establish that the cache entry corresponds to an admitted Package identity and that every required profile invariant remains satisfied. A cache hit must not skip a required artifact-integrity, semantic-identity, binding, or runtime-compatibility check.

An external JSON, Protocol Buffers, columnar, archive, or human-readable form may serve import, export, inspection, synchronization, or storage needs. Such a form must decode into the declared closed model and pass ordinary admission. It cannot be treated as the canonical authority format merely because it is deterministic or has a hash.

### Bounds, errors, and observability

The wire contract must impose global pre-parse ceilings for total bytes, manifest bytes, member count, nesting depth, scalar bytes, and aggregate declared bytes. Every registered profile must impose additional bounds for its members, references, identities, material payloads, activity state, temporal rules, and retained runtime state. A missing bound means the profile is not admissible.

Admission reasons must be public, globally unique, and selected by documented precedence. They must distinguish wire framing, artifact digest, manifest, profile, descriptor, member, child identity, cross-member graph, semantic identity, resource, and completion failures without exposing private source content. Diagnostics may report safe identifiers and positions only after those identifiers have passed their own bounds and grammar checks.

Conforming implementations must provide bounded counters and receipt-safe traces for declared versus observed bytes, member index, profile, accepted member count, retained-state estimate, terminal reason, artifact identity when verified, and semantic identity only after successful admission. These observations are diagnostic facts, not an alternate authority path.

### Verification and acceptance evidence

Every registered profile must publish positive and fail-closed artifacts, decoded model fixtures, exact binary member bytes, artifact digests, child semantic identities, final Package semantic identities, and expected receipt-safe reasons. Goldens must cover reordered descriptors, reordered records, duplicate identifiers, missing and extra members, malformed wire values, unknown tags, wire and profile mismatch, all optional topology combinations, cross-member references, cross-Package substitution, semantic-child mismatch, artifact-digest mismatch, version mismatch, overflow, nested bounds, reload, and repeat admission.

At least one independent verifier must reproduce the complete wire parse, profile validation, artifact digest, child identities, Package semantic identity, and expected failure reason without depending on a Package authoring implementation. Cross-runtime fixtures must prove that a validated Package has the same semantic identity regardless of the supported storage or import representation that produced it. Constrained-resource evidence must measure peak additional memory, retained provisional state, sequential member release, failure cleanup, cold reload, and verification while representative resident workloads remain active.

## Design details

### Authority boundary

Hees.ai owns Package wire validation, profile registry resolution, complete semantic validation, identity binding, and the fail-closed decision that an artifact is admitted. Package-producing tools own candidate creation and release. Storage, transport, model-provider, renderer, activity, and effect adapters own only their declared boundary behavior. None of those adapters may claim Package admission or manufacture an `AdmittedPackage` from a convenient representation.

### Identity reconciliation

This RFC and RFC 011 replace the earlier Draft assumption that an artifact hash or JSON canonicalization is the complete trusted Package identity. Existing related RFCs retain their governance responsibilities but must use `AdmittedPackageIdentity`: semantic identity for runtime authority and Content DNA, artifact digest for exact delivered-byte provenance. A package fingerprint that is merely the suffix of an artifact digest is not an authority identity under this contract.

### Profile breadth

The Package profile registry is intentionally broader than one governed experience. It can represent evidence-grounded learning, guides, activities, materials, agent behavior, operational actions, accessibility variants, local context, goals, time-aware session rules, and other governed domains while retaining a closed contract for every admitted Package. Breadth comes from registered profiles and explicit typed contracts, not permissive fields.

## Alternatives considered

### Retain canonical JSON as the Package authority wire

Rejected because JSON parsing and canonicalization rules would remain the central Package authority substrate across runtimes, storage systems, and constrained devices. JSON remains valuable for inspection and exchange but is not the internal authority format.

### Use Protocol Buffers, deterministic CBOR, Parquet, or another general format as the canonical wire

Rejected as the authority contract because each format imports its own schema evolution, unknown-field, ordering, and implementation rules. These formats may be useful behind explicit import, export, or storage adapters, but they cannot define what a validated Hees.ai Package means.

### Use a single artifact digest as Package identity

Rejected because a byte hash proves delivery integrity but cannot prove that those bytes decoded into one complete valid governed Package. It also turns representation or delivery changes into semantic changes.

### Use semantic identity without exact artifact integrity

Rejected because package installation, storage, transport, and audit need a byte-exact integrity claim. A valid semantic model does not prove which original bytes arrived.

### Permit arbitrary profile extensions

Rejected because a generic extension map would let an unreviewed field silently affect runtime behavior or create cross-runtime disagreement. New governed capability requires explicit profile registration.

### Make an authoring surface the Package admission authority

Rejected because authoring, review, and release workflows can propose or approve a candidate but must not replace runtime validation. Hees.ai is the final admission boundary.

## Drawbacks

The contract adds a public binary grammar, a schema registry, typed identities, goldens, and independent verification obligations. Package producers and consumers must maintain exact compatibility rather than relying on a permissive serializer. Profile registration requires more design discipline than a document with arbitrary metadata.

That cost is deliberate. A governed Package becomes a portable authority artifact only when its complete topology, identity, bounds, and cross-member behavior are visible and reproducible. The contract therefore rejects convenient but ambiguous representations and requires explicit evolution when a new governed capability is introduced.

## Implementation architecture

Hees.ai should expose an Incan-authored Package admission surface with nominal artifact and semantic identity types, an opaque provisional admission state, profile-owned model constructors, and profile-owned identity projections. Reusable binary decoding, incremental hashing, and bounded indexing should remain generic capability layers; the decision that a field, member, or reference is authority-bearing must remain in the profile contract.

An implementation may stream member bytes from any supported source, verify them incrementally, decode bounded typed models, retain only profile-required indexes and child identities, and release transient bytes. It may cache a successfully admitted compiled projection only where cache integrity and package identity checks preserve the same public contract.

## Layers affected

- **Package authority contract:** The public distinction between a candidate artifact, an admitted Package, exact artifact integrity, semantic identity, and authenticity.
- **Profile registry:** Closed topology, schema, bounds, reference, identity, and capability registration for every governed Package domain.
- **Runtime admission:** Trusted package binding, cross-package rejection, and eligibility checks for proposals, retrieval, material presentation, goals, activities, and effects.
- **Content DNA and receipts:** Semantic Package identity for authority provenance, distinct artifact provenance where a receipt or audit contract requires it, and a derived Package Admission Binding for safe exact-pair reference.
- **Storage and transport adapters:** Exact-byte verification, safe reconstruction of closed models, cache validation, and explicit non-authoritative import/export behavior.
- **Compatibility tooling:** Public tag registry, golden artifacts, independent verifier, binary diagnostics, resource evidence, and contract-version fixtures.
- **Incan language and libraries:** Incan-authored contracts and typed models; any demonstrated missing language or library primitive requires a tracked Incan proposal before a narrow foreign boundary is introduced.

## Design Decisions

- `hees_package_wire_0_1` is a closed binary artifact contract. JSON is an external edge representation, never the Package authority substrate.
- Artifact integrity and semantic identity are separate nominal values. The complete artifact digest spans the complete byte stream; the Package semantic identity is produced only after full typed admission under RFC 011.
- Package Admission Binding derives from the exact semantic-identity and artifact-digest pair. Its human rendering uses check digits to detect transcription mistakes, but it never replaces either primary identity or their separate validation.
- A public append-only registry owns wire tags, profile identifiers, member kinds, and profile contracts. Source declaration order, reflection, serializers, and storage layouts have no authority role.
- Package topology is profile-registered and closed. Governance, learning, activities, supporting materials, temporal goals, localization, assessment, agent behavior, and effects are accommodated by explicit profiles rather than generic fields.
- Content DNA binds Package semantic identity. Receipts expose semantic identity and may expose artifact digest as distinct delivery provenance when their contract requires it.
- Every runtime-facing reference is Package-identity-bound. Matching a package identifier, revision, descriptor, or artifact digest alone is insufficient for runtime authority.
