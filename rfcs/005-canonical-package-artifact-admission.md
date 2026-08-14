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
- **Written against:** Hees.ai 0.0.1 / Incan 0.5
- **Shipped in:** —

## Summary

Hees.ai must admit a complete governed Package through a closed, profile-registered binary artifact contract that validates exact delivered bytes, reconstructs bounded typed member models, validates their complete cross-member graph, and atomically yields one authoritative `AdmittedPackage`. The contract deliberately separates the exact-byte `artifact_digest` used for installation and delivery integrity from the typed `package_semantic_identity` defined by RFC 011 and used to bind governed runtime behavior, Content DNA, and receipts.

`hees_ai_package_wire_0_1` is the proposed normative identifier for the authority-bearing Package wire defined by this RFC. It is not an example name, an existing file format, or an implemented API in Hees.ai 0.0.1. The underscore is an identifier delimiter, not a product spelling: public prose, wire magic, and identity namespaces use Hees.ai. If this Planned RFC is implemented, its exact spelling, framing, and rules become the public contract for wire version `0.1`; until then, it names the proposed contract only.

## Core model

1. **A Package is an authority unit, not a document.** A Package binds one domain, revision, declared profile, governance graph, experience graph, supporting material references, and eligible runtime behavior. Its admitted form is the only Package form that may supply trusted runtime authority.
2. **Artifact integrity and semantic identity are different claims.** `artifact_digest` identifies the exact complete delivered byte stream. `package_semantic_identity` identifies the fully validated Package meaning. `package_admission_binding` derives from their exact typed pair and provides one compact reference to that admission event without replacing either claim. None proves producer authenticity, factual correctness, source rights, or policy quality by itself.
3. **The binary artifact is closed and self-delimiting.** `hees_ai_package_wire_0_1` defines a byte preamble, a closed binary manifest, and an ordered series of bounded binary members. JSON, text exports, archives, and storage pages may carry or reconstruct the Package, but they are not its authority-bearing wire substrate.
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

A Package is delivered as one exact binary stream. The caller supplies that stream and its expected artifact digest. Hees.ai validates framing and the manifest, incrementally hashes the exact submitted bytes while it admits members in profile-defined order, then proves the complete stream digest only at atomic finish. No caller-supplied path, member label, member digest, Package identity, or profile fallback can redirect the admission path.

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
    domain: hees.ai.package
    contract: 0.1
    digest: sha256:5bfe…
  artifact_digest: sha256:63d9…
  package_admission_binding:
    domain: hees.ai.package_admission
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

- **Package artifact:** The complete `hees_ai_package_wire_0_1` byte stream submitted for admission.
- **Artifact digest:** A nominal SHA-256 digest over the exact complete Package artifact bytes.
- **Package profile:** A public, closed contract that owns a Package topology, member schemas, bounds, reference rules, and semantic-identity projection.
- **Member descriptor:** The manifest record that commits to one expected member before its bytes are decoded.
- **Admitted Package:** The opaque authoritative runtime value returned only after full artifact, member, graph, and profile validation succeeds.
- **Package semantic identity:** The RFC 011 structural identity of one fully validated Package profile projection.
- **Child semantic identity:** The RFC 011 identity of a validated member or independently governed nested artifact used by the Package semantic projection.
- **Package Admission Binding:** The RFC 011 structural identity of the exact pair of an admitted Package semantic identity and its verified artifact digest.

### Normative format basis and external JSON boundary

`hees_ai_package_wire_0_1` is the authority-bearing Package wire described by this RFC. It is a proposed normative identifier, not illustrative placeholder text. Its SHA-256 artifact and member digests use [FIPS 180-4, Secure Hash Standard](https://csrc.nist.gov/pubs/fips/180-4/upd1/final). An implementation must not substitute a locally named digest, a truncated digest, or a different hash algorithm under the same wire or profile contract.

JSON remains a supported edge representation, not an ungoverned convenience format. Every registered JSON import, export, inspection, synchronization, or public-receipt envelope must declare its own exact contract and use [RFC 8259, The JavaScript Object Notation Data Interchange Format](https://www.rfc-editor.org/rfc/rfc8259) together with [RFC 7493, The I-JSON Message Format](https://www.rfc-editor.org/rfc/rfc7493). Its decoder must reject duplicate decoded property names, invalid UTF-8, a byte-order mark, unsupported numeric values, and trailing data before it constructs a closed model.

Where an external JSON contract needs a canonical byte representation for an export, signature envelope, public comparison, or exact JSON-artifact digest, that contract may additionally require [RFC 8785, JSON Canonicalization Scheme](https://www.rfc-editor.org/rfc/rfc8785). RFC 8785 applies only to that declared JSON edge artifact. Its bytes and digest must not be accepted as a Package semantic identity, Package Admission Binding, or substitute for admission of the binary Package artifact.

### Exact artifact wire

`hees_ai_package_wire_0_1` must use the following fixed preamble and framing:

```text
offset  size  value
0       8     ASCII bytes "HEES.AI\0"
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

Package, domain, profile, member, action, evidence, memory, constraint, provider, reason, label, capability, and logical-content identifiers must use the profile-independent grammar `[a-z0-9][a-z0-9_-]*` and their registered byte ceilings. Package revisions and profile contracts must use exact dotted numeric values in the form `[0-9]+(\.[0-9]+){1,2}`. Hees.ai must not case-fold, trim, normalize, coerce, or infer compatibility from any identifier or version.

The manifest and descriptor models are closed. A missing required field, unknown field tag, duplicated field tag, unknown member kind, unsupported member contract, unsupported profile, mismatched profile contract, invalid scalar, overflow, or incompatible optional-field combination rejects admission. The descriptor’s byte length, record count, and member digest are commitments established before member intake, not caller hints that a member may replace.

### Common member wrapper and inherited Package identity

Every member must be a closed binary record containing exactly the common non-circular fields `member_id`, `member_kind`, `member_contract`, and `record_count`, followed by only the registry-declared fields for that member kind. Those self-description fields are untrusted until they exactly match the current descriptor. A member must not repeat its expected byte digest or byte length because the descriptor commits to its complete bytes; it must not repeat the containing wire contract, package, domain, revision, Package semantic identity, artifact digest, binding, path, locator, storage key, compression detail, archive detail, generic metadata, or extension map.

An individually valid member remains provisional and Package-relative. Only successful `finish_package_admission` may bind its declarations to the trusted `AdmittedPackageIdentity`. That derived binding must not mutate, migrate, reserialize, or re-hash manifest or member bytes. A profile-owned runtime projection may expose only the identity and declarations that the profile explicitly allows; it must not convert a member wrapper into a caller-selectable authority capability.

### Member topology and scope

The registry must define one closed member topology per profile. A profile may compose members in these broad categories when it declares their exact contracts:

- governance declarations, including actions, evidence, memory, constraints, claim verification, behavior, visible-response, and effects;
- experience declarations, including module and lesson structure, learner journeys, activity bindings, assessment, supporting materials, accessibility and localization variants;
- session declarations, including goals, temporal conditions, return behavior, progress states, and bounded observation rules; and
- independently governed material references, including media, interactive artifacts, simulations, and packages whose own identities and eligibility are explicitly bound.

These categories do not authorize a member by name. A profile contract must name each permitted member kind and its exact order. A member which does not belong to the profile rejects even if its bytes, digest, or locally valid schema would otherwise be acceptable.

Members are Package-relative. A member may reference another member only through a declared identifier and expected semantic identity in the profile-defined namespace. An action, evidence item, memory atom, activity binding, supporting material, lesson, goal, translation, or effect declaration must not resolve across Packages without an explicitly declared and admitted cross-Package contract. A package identifier string, revision string, or artifact digest alone must never authorize a cross-Package reference.

### Baseline governed-core profile

The registry must retain one named baseline governed-core profile for the existing public governance contracts. Its exact profile contract is `0.1`, and its member grammar is:

```text
actions evidence+ (governed_memory_registry governed_memory_atoms+)? constraints? claim_verification? behavior_envelope? response_contract?
```

The grammar requires exactly one non-empty `actions` member first and at least one contiguous `evidence` member. Governed memory is absent entirely or consists of exactly one `governed_memory_registry` member immediately followed by one or more non-empty `governed_memory_atoms` members. `constraints`, `claim_verification`, `behavior_envelope`, and `response_contract` are optional singletons and may occur only in that order. Claim verification requires both the complete governed-memory group and constraints. A response contract requires a behavior envelope. No other multiplicity, interleaving, or order is legal.

This grammar has exactly fifteen legal optional-member topologies. That number is a compatibility assertion, not a permissive interpretation. The logical evidence list is the stable concatenation of evidence records in descriptor order. The logical atom list is the stable concatenation of atom records in descriptor order. Record order within a member and descriptor order across members are governed Package meaning and therefore enter the registered Package semantic-identity projection.

For this profile, `record_count` has the following exact meaning:

| Member kind | Exact `record_count` meaning |
| --- | --- |
| `actions` | Number of action records; greater than zero. |
| `evidence` | Number of evidence records; zero only when there is exactly one evidence member. |
| `governed_memory_registry` | Provider bindings plus authority, risk, and sensitivity classifications. |
| `governed_memory_atoms` | Number of atom records; greater than zero for every shard. |
| `constraints` | Constraint definitions plus evaluator capabilities; both collections are non-empty. |
| `claim_verification` | Verifier provider bindings plus one policy. |
| `behavior_envelope` | Declared phases, classes, states, strategies, and selection criteria. |
| `response_contract` | Synthesis requirements, clarifications, and failure-policy rules. |

The registered lower bounds are `actions >= 1`, `governed_memory_registry >= 4`, `governed_memory_atoms >= 1`, `constraints >= 2`, `claim_verification >= 2`, `behavior_envelope >= 8`, and `response_contract >= 7`. The combined evidence count may be zero only when exactly one evidence descriptor declares zero records; otherwise every evidence descriptor must be non-empty. Every declared count is a resource commitment checked before member intake and reproduced from the validated member model before state is committed.

The exact field tags and binary payload shape of each member are registry-owned. An `actions` member has the common wrapper plus a non-empty ordered item sequence; each item has exactly a canonical action identifier and an `evidence_required` Boolean. An action item does not nominate evidence: the Boolean only determines whether a later runtime proposal for that action must nominate admitted evidence. An `evidence` member has the common wrapper plus an ordered item sequence; each item has exactly a canonical identifier, non-empty claim, non-empty guidance, source-safe reference, rights state, and review state.

A `governed_memory_registry` member has the common wrapper plus the complete package-relative RFC 003 registry payload: non-empty ordered provider bindings, non-empty ordered authority, risk, and sensitivity classifications, and any declared lower positive item or context-byte ceilings. Provider bindings include the provider, provider contract, adapter version, configuration identity, index identity, and corpus identity defined by RFC 003. A `governed_memory_atoms` member has the common wrapper plus a non-empty ordered atom sequence. Every atom uses the complete package-relative RFC 003 payload: logical identifier, corpus version and identity, bounded claim, guidance, and applicability, source-safe reference and source identity, review and runtime-rights state, classifications, typed validity data, and ordered labels. Atom members must not repeat registry fields or Package identity; RFC 003 exclusively owns runtime atom-nomination eligibility.

A `constraints` member has the common wrapper plus the complete package-relative RFC 004 plan: plan identifier and revision, positive evaluation budget, non-empty ordered evaluator capabilities, and non-empty ordered definitions. A `claim_verification` member has the common wrapper plus the complete package-relative RFC 007 provider-binding sequence and exactly one policy; its constraint reference must resolve to an admitted RFC 004 definition with the required evaluator kind and version. A `behavior_envelope` member has the common wrapper plus the complete package-relative RFC 008 envelope, including its identity, phase and class declarations, states, strategies, and selection policy. Every action reference must resolve in the admitted actions member. A `response_contract` member has the common wrapper plus the complete package-relative RFC 009 contract, including its identity, lower Package limits, synthesis requirements, Package-authored clarifications, and failure policy. Its strategy references must resolve in the preceding behavior envelope and its action references in the actions member.

RFC 005 owns the exact common wrapper, member partition, binary grammar, descriptor commitments, sequence, and cross-member composition. RFCs 003, 004, 007, 008, and 009 respectively own every imported payload’s nested field shape, nominal types, enum values, omission rules, and runtime semantics. Artifact contract `0.1` imports those registered `0.1` payload contracts without aliases, compatibility normalization, duplicate contract fields, generic payload envelopes, or locally invented defaults. A member must contain its own non-circular `member_id`, `member_kind`, `member_contract`, and `record_count`, all of which must exactly match the current descriptor. It must not repeat a containing Package identity, member byte digest, path, locator, storage key, compression field, generic metadata, or extension map.

Evidence source references must be non-empty, must not begin or end with ASCII whitespace, and must not contain a C0 control character, delete, backslash, `..`, `file://`, `:/`, or a leading slash. Those constraints establish a safe reference shape; they neither dereference a source nor establish rights. Recognized evidence rights are `allowed`, `restricted`, and `denied`; recognized review states are `approved`, `pending`, and `rejected`. A deployable baseline Package requires `allowed` and `approved`, while recognized non-deployable values retain distinct rejection reasons. RFC 003 atom eligibility remains owned by RFC 003 rather than being silently upgraded by Package admission.

### Logical namespaces and references

Action identifiers must be unique in the sole actions member. Evidence identifiers must be unique across the complete logical evidence list, and governed-memory atom identifiers must be unique across every atom shard. Provider-binding tuples and classifications must be unique in their RFC 003 namespaces. Constraint definitions, evaluator capabilities, verification bindings, behavior declarations, strategy identifiers, response requirements, and clarifications must satisfy their owning RFC’s exact uniqueness rules.

In the baseline governed-core profile, evidence identifiers and memory-atom identifiers must be mutually disjoint because the imported constraint contract uses one package-owned support namespace. A collision is a cross-member support-namespace failure, not an ambiguous runtime reference. Every atom classification and corpus reference must resolve exactly once in the preceding registry. Claim-verification policy references must resolve to the required imported constraint definition and permitted mapping. Behavior action references must resolve to admitted actions, and response requirements must resolve to the declared behavior strategy and action. A string that resembles an identifier creates no reference unless its field is registered as one.

### Sequential admission and atomic completion

`begin_package_admission` must return either one terminal rejection or one opaque provisional state. A provisional state may retain only validated manifest scalars, expected and observed artifact-digest state, the bounded descriptor table, the next descriptor index, compact consumed and future member-digest identity, bounded logical and reference indexes, checked aggregate counters, and profile-required small scalars. It must not expose trusted Package content, Package identity, imported authority, an accepted capability, or a receipt-authoring surface.

Each provisional state represents one branch at one exact descriptor index. A successful member transition returns that branch’s successor. A rejection and successful finish return no successor. An immutable predecessor may be retained or cloned to create an independent caller-owned branch with the same verified commitments, but Hees.ai must retain no hidden branch registry, native session handle, process-global state, or cross-branch invalidation authority. A rejected branch never poisons an independently retained predecessor or sibling branch.

`begin_package_admission` must verify an artifact in this exact order:

1. Enforce the global artifact and manifest pre-parse byte ceilings before hashing, decoding, or proportional allocation.
2. Validate the expected artifact-digest nominal type and exact SHA-256 syntax.
3. Validate the preamble, wire-contract number, manifest length, checked declared-length arithmetic, and manifest boundary.
4. Initialize the FIPS 180-4 SHA-256 state and feed it the preamble, manifest-length field, and exact manifest bytes. The implementation may receive a complete artifact or a bounded sequential source, but it must not alter the byte sequence or retain it as a hidden whole-artifact buffer.
5. Decode one bounded binary manifest, rejecting invalid UTF-8 text, malformed values, unknown tags, duplicate or reordered fields, invalid field widths, and decode-depth or scalar limits.
6. Validate the closed manifest and descriptor models, identifier and revision grammar, profile resolution, descriptor uniqueness, profile topology, dependencies, record-count commitments, and aggregate declared bounds.
7. Create the opaque provisional state, then release transient manifest bytes and decoded manifest structures not required by the bounded state.

The final artifact digest cannot verify until every declared member has contributed its exact bytes. A one-shot `admit_package_artifact` API must execute the same ordered state machine internally; it must not choose a different digest-versus-schema precedence merely because the caller supplied one contiguous buffer.

`admit_next_package_member` must accept only raw bytes for the current descriptor. It must verify one member in this exact order:

1. Reject immediately when no descriptor remains; it must not inspect or hash an extra member.
2. Enforce global and profile-defined member byte ceilings before hashing, decoding, or proportional allocation.
3. Compute SHA-256 over the exact member bytes. A digest matching a consumed descriptor is a replay; one matching a later descriptor is out of order.
4. Compare actual member length and computed digest against the current descriptor. The caller may not provide an alternative member identifier, kind, profile, expected digest, path, or locator.
5. Feed the exact member bytes into the provisional artifact-digest state.
6. Decode the bounded binary member using the same closed grammar and limits as the manifest.
7. Validate the member wrapper, kind-specific model, exact self-description tuple, record count, local identifiers, local references, rights and review states, declared field bounds, and recomputed child semantic identity.
8. Validate cross-member namespaces, references, dependencies, and retained-state bounds against the compact provisional state.
9. Commit only the required compact descriptor, identifier, reference, ordinal, child-identity, digest state, and scalar state; advance the descriptor index; and release transient member bytes and decoded structures.

Admission does not promise sub-member streaming. A conforming implementation may require one complete bounded member for closed-model validation and child-identity construction. The resource guarantee is sequential member admission plus bounded inter-member retention, not arbitrary large-member acceptance.

`finish_package_admission` must reject until every descriptor has succeeded and every full graph invariant has been checked. It must then verify that the source has no missing or trailing bytes, finalize the incremental SHA-256 state, compare the exact artifact digest with the expected nominal digest, calculate the typed Package semantic identity from the profile’s complete RFC 011 projection, compare all required child identities, calculate the Package Admission Binding, and atomically return the opaque Package. No earlier transition may return an admitted Package, trusted imported member, or RFC 006 receipt. A terminal failure invalidates only that provisional branch and may yield only the minimal receipt-safe rejection result.

### Admitted identity and downstream binding

An `AdmittedPackageIdentity` must contain `package_id`, `domain_id`, `package_revision`, `package_semantic_identity`, `artifact_digest`, and `package_admission_binding`. The semantic identity is a typed RFC 011 identity in domain `hees.ai.package`; the artifact digest is a typed `ArtifactDigest`; and the binding is a typed RFC 011 identity in domain `hees.ai.package_admission`. They are never aliases and must not be accepted through one generic string parameter.

`package_admission_binding` must be calculated only after the Package semantic identity and artifact digest have both verified. Its structural projection must contain exactly the semantic identity’s complete typed record and the complete artifact digest typed value, in that order. It must not contain display text, a caller-selected short hash, a package identifier, a revision, a timestamp, or a third-party claim. The binding is therefore sensitive to a change in either primary claim while leaving their distinct authority meanings intact.

For human transcription and comparison, tooling may render the binding as an exact textual reference with ISO/IEC 7064 MOD 97-10 check digits over the normalized display body. A check-digit failure must reject that human input before lookup. A successful check-digit comparison proves only that the text was likely copied accurately; it must never be presented as a cryptographic check, a semantic identity, exact artifact verification, authenticity, or runtime authority. An operation that consumes the reference must resolve the full typed binding and independently validate both primary identities.

Runtime admission compares the semantic identity named by the governing contract. A trusted package snapshot therefore cannot be manufactured from request echoes, a model proposal, a reloaded descriptor, or a matching package identifier. Exact artifact identity may additionally be required by an installation, deployment, receipt, or audit contract, but it must not substitute for semantic identity.

Content DNA must bind the exact `package_semantic_identity` that governed selected-memory and answer-time behavior. A Content DNA body may carry an exact artifact digest only when its own contract expressly describes delivery provenance; the presence or absence of that audit fact must not silently redefine Content DNA. Governance receipts must carry the Package semantic identity and may carry the exact artifact digest as a distinct delivery-provenance field. A receipt verifier must validate each field by its declared type and must not derive one from the other.

### Reload, storage, and transport

Storage and transport adapters may retain raw artifact bytes, decoded member models, profile indexes, child identities, compact compiled projections, and Package Admission Bindings. Before using a cached or reloaded Package as authority, Hees.ai must establish that the cache entry corresponds to an admitted Package identity and that every required profile invariant remains satisfied. A cache hit must not skip a required artifact-integrity, semantic-identity, binding, or runtime-compatibility check.

An adapter may physically reuse a member only when the receiving Package profile permits the same member contract and the receiving descriptor independently validates the exact bytes, member digest, child semantic identity, namespace bindings, and Package-level graph relationship. A member is never imported by path, locator, storage key, informal “same version” assertion, or a hash from a different Package. Reuse does not inherit admission from an older Package.

When a later runtime operation needs member content, it may request only a member selected through the admitted Package’s trusted descriptor and logical lookup. Before exposing that content, Hees.ai must re-enforce the declared byte ceiling, exact descriptor length and digest, closed binary grammar, member wrapper, child semantic identity, and requested logical identifier or record ordinal. A caller-supplied replacement descriptor, digest, path, metadata record, or nominal package tuple must not alter that verification. Exact previously admitted member bytes need not repeat full cross-member graph validation because the trusted compact lookup retains the admitted relationship, but a reload mismatch must fail closed without mutating or replacing the admitted Package.

Migration creates a new registered wire or profile contract, a new Package semantic identity, or an explicit governed mapping. It must not rewrite historic bytes, reinterpret an old tag as a new one, silently normalize identifiers, or claim that a receipt, Content DNA body, or Package reference now names the migrated value. Historic artifacts and identities remain verifiable under their original contracts.

An external JSON, Protocol Buffers, columnar, archive, or human-readable form may serve import, export, inspection, synchronization, or storage needs. Such a form must decode into the declared closed model and pass ordinary admission. A JSON form must follow the scoped RFC 8259, RFC 7493, and, where declared, RFC 8785 rules above. None can be treated as the canonical authority format merely because it is deterministic or has a hash.

### Bounds, errors, and observability

The wire contract must impose global pre-parse ceilings for total bytes, manifest bytes, member count, nesting depth, scalar bytes, and aggregate declared bytes. Every registered profile must impose exact additional bounds for members, identifiers, references, identities, material payloads, activity state, temporal rules, nested collections, and retained runtime state. A profile with a missing bound is not admissible. Values and aggregate arithmetic use the exact integer domain `0..9007199254740991`, independent of host integer width; every addition and multiplication must be checked before proportional allocation and must never wrap, saturate, clamp, or depend on host integer representation.

The retained-state accounting contract is representation-independent. It must account for descriptor entries and their trusted identifiers, manifest-state text, logical-index entries and identifier text, reference-index entries and reference text, required child identities, descriptor ordinals, next-member index, aggregate counters, and declared presence flags. It must not count prior raw bytes, decoded member trees, allocator capacity, map slack, object headers, duplicate caches, or process-global state as a hidden substitute for a profile bound. Between members, a branch must not retain prior member bytes, source text, complete decoded member models, or a decode buffer unless the profile explicitly accounts for that retained model as a bounded runtime projection.

Every terminal result must contain exactly one public stage and one globally unique reason. Rows below define strict global precedence; profile-specific reasons may refine only their declared stage and must be registered without changing its order.

| Stage | Reasons in precedence order |
| --- | --- |
| `artifact_input` | `artifact_bytes_exceeded` |
| `artifact_expected_digest` | `artifact_expected_digest_invalid` |
| `artifact_framing` | `artifact_magic_invalid`, `artifact_wire_contract_unsupported`, `artifact_manifest_length_invalid`, `artifact_total_length_overflow`, `artifact_total_length_invalid`, `artifact_trailing_bytes` |
| `manifest_decode` | `manifest_decode_limit_exceeded`, `manifest_binary_invalid`, `manifest_utf8_invalid`, `manifest_unknown_tag`, `manifest_duplicate_field`, `manifest_field_order_invalid` |
| `manifest_schema` | `manifest_required_field_missing`, `manifest_unknown_field`, `manifest_identifier_invalid`, `manifest_revision_invalid`, `manifest_field_invalid`, `manifest_field_limit_exceeded` |
| `profile` | `profile_unknown`, `profile_contract_unsupported`, `profile_member_kind_unsupported`, `profile_member_contract_unsupported`, `profile_dependency_invalid`, `profile_member_order_invalid`, `profile_total_bounds_exceeded` |
| `member_sequence` | `member_missing`, `member_unexpected` |
| `member_input` | `member_bytes_exceeded` |
| `member_integrity` | `member_replayed`, `member_out_of_order`, `member_length_mismatch`, `member_digest_mismatch` |
| `member_decode` | `member_decode_limit_exceeded`, `member_binary_invalid`, `member_utf8_invalid`, `member_unknown_tag`, `member_duplicate_field`, `member_field_order_invalid` |
| `member_schema` | `member_required_field_missing`, `member_unknown_field`, `member_identity_mismatch`, `member_record_count_mismatch`, `member_identifier_invalid`, `member_enum_invalid`, `member_field_invalid`, `member_field_limit_exceeded`, `member_duplicate_declaration`, `member_broken_reference`, `member_evidence_rights_not_allowed`, `member_evidence_not_approved` |
| `member_identity` | `member_semantic_identity_mismatch` |
| `cross_member` | `cross_member_duplicate_identifier`, `cross_member_broken_reference`, `cross_member_support_namespace_collision`, `cross_member_retained_limit_exceeded`, `cross_package_reference_not_admitted` |
| `artifact_digest` | `artifact_digest_mismatch` |
| `complete` | `package_semantic_identity_mismatch`, `package_admission_binding_invalid`, `admitted` |

Reasons must be selected from the complete applicable public reason set for the bounded value and according to this table, never from parser wording, map iteration, field traversal order, storage failures, or caller text. Diagnostics may report safe identifiers and positions only after their own grammar and bounds validation. Any failure releases that branch’s provisional state and exposes no partial admitted identity.

Conforming implementations must provide bounded counters and receipt-safe traces for declared versus observed bytes, member index, profile, accepted member count, retained-state estimate, terminal reason, artifact identity when verified, and semantic identity only after successful admission. These observations are diagnostic facts, not an alternate authority path.

### Verification and acceptance evidence

Every registered profile must publish positive and fail-closed artifacts, decoded model fixtures, exact binary member bytes, artifact digests, child semantic identities, final Package semantic identities, and expected receipt-safe reasons. Goldens must cover reordered descriptors, reordered records, duplicate identifiers, missing and extra members, malformed wire values, unknown tags, wire and profile mismatch, all optional topology combinations, cross-member references, cross-Package substitution, semantic-child mismatch, artifact-digest mismatch, version mismatch, overflow, nested bounds, reload, and repeat admission.

The baseline governed-core corpus must cover a minimal actions-plus-empty-evidence Package, multiple evidence members, one registry plus multiple atom shards, constraints with and without governed memory, claim verification with every required dependency, behavior with and without response rules, all fifteen legal topologies, unchanged-member reuse in a changed Package, and atomic receipt eligibility only after finish. Negative sequencing fixtures must cover early finish, trailing bytes, repeated current-member bytes, a later member supplied early, arbitrary digest mismatch, duplicate descriptor digest, invalid topology, registry without atoms, atoms without registry, claim verification without governed memory or constraints, response rules without behavior, out-of-order optional singletons, and empty non-sole evidence members. Branch fixtures must cover a retained predecessor used after a sibling fails, replay and out-of-order classification per branch, bounded state cloning, and identical successful identity across independent valid branches.

Parser and import-differential fixtures must cover invalid UTF-8, byte-order marks, duplicate field tags, unknown tags, malformed lengths, malformed digests, exact integer boundaries, invalid identifier and revision values, unsupported contracts, nested-depth limits, duplicate identity-bearing declarations, and every public reason. Declared external JSON fixtures must additionally cover duplicate decoded names before model construction, escaped duplicate names, object-property order, preserved array order, trailing data, fractions, exponents, negative zero, unsupported numbers, invalid Unicode, and RFC 8785 edge bytes where that specific external contract declares canonical JSON. These edge fixtures prove external interoperability; they must not be reused as semantic-identity goldens.

At least one independent verifier must reproduce the complete wire parse, profile validation, artifact digest, child identities, Package semantic identity, and expected failure reason without depending on a Package authoring implementation. Cross-runtime fixtures must prove that a validated Package has the same semantic identity regardless of the supported storage or import representation that produced it. Constrained-resource evidence must measure peak manifest and per-member parse memory, retained provisional state, sequential member release, failure cleanup, cold reload, accepted lookup state, and verification while representative resident workloads remain active.

## Design details

### Authority boundary

Hees.ai owns Package wire validation, profile registry resolution, complete semantic validation, identity binding, and the fail-closed decision that an artifact is admitted. Package-producing tools own candidate creation and release. Storage, transport, model-provider, renderer, activity, and effect adapters own only their declared boundary behavior. None of those adapters may claim Package admission or manufacture an `AdmittedPackage` from a convenient representation.

### Relationship to governance, Content DNA, and receipts

RFC 000 permits Package declarations to carry governed authority only after exact Hees.ai admission. Spectrum consumes the direct admitted Package and Package-bound capabilities; it must not reconstruct authority from an artifact digest, descriptor copy, or loose Package tuple. RFC 005 owns the Package artifact, profile, and member identity relationships preserved through a Spectrum decision, while RFC 001 retains terminal adjudication ownership.

RFC 002 owns Content DNA membership, selected-memory coverage, answer binding, source-safe projections, redaction, and authority limits. RFC 005 requires Content DNA to name the exact Package semantic identity that governed answer-time selection; it rejects answer-specific Content DNA, live selection results, or terminal Spectrum values embedded in a Package artifact. RFC 006 exclusively owns receipt projection and public verification. Pending admission state is never receipt-projectable. Successful finish may atomically return an admitted Package and any applicable acceptance receipt; terminal rejection may expose only the minimal rejection result and any separately permitted minimal receipt.

### Identity reconciliation

This RFC and RFC 011 replace the earlier Draft assumption that an artifact hash or JSON canonicalization is the complete trusted Package identity. Existing related RFCs retain their governance responsibilities but must use `AdmittedPackageIdentity`: semantic identity for runtime authority and Content DNA, artifact digest for exact delivered-byte provenance. A package fingerprint that is merely the suffix of an artifact digest is not an authority identity under this contract.

### Profile breadth

The Package profile registry is intentionally broader than one governed experience. It can represent evidence-grounded learning, guides, activities, materials, agent behavior, operational actions, accessibility variants, local context, goals, time-aware session rules, and other governed domains while retaining a closed contract for every admitted Package. Breadth comes from registered profiles and explicit typed contracts, not permissive fields.

### Compatibility evidence

Incan, Rust, and every supported inspection or verification implementation must consume shared wire fixtures and agree on artifact bytes, artifact digest, descriptor order, member bytes, member digests, combined logical order, child identities, Package semantic identity, Package Admission Binding, trusted lookup identity, and public reason. A changed runtime implementation may improve allocation strategy or storage representation only when it preserves those observables exactly under the registered contract.

Each public reason must have an isolated reachable fixture. Multi-failure fixtures must prove global stage precedence, within-stage precedence, descriptor-index precedence, and parser-subclassification precedence. Rejection fixtures must prove all-or-nothing identity: no manifest field, member field, provisional logical identifier, unverified digest, or input-derived identifier enters a rejected result or receipt. Representative device evidence may inform future declared ceilings, but deployment measurements must not create a device-specific admission reason outside the registered contract.

## Alternatives considered

### Retain canonical JSON as the Package authority wire

Rejected because JSON parsing and canonicalization rules would remain the central Package authority substrate across runtimes, storage systems, and constrained devices. JSON remains valuable for inspection and exchange but is not the internal authority format.

### Keep one monolithic Package object

Rejected because a complete Package would have to parse and retain one whole authority tree, coupling Package growth to a single high-water mark. The ordered manifest and member stream retain one exact artifact claim while allowing independently bounded member admission and later descriptor-verified resolution.

### Allow arbitrary member kinds or arbitrary shard order

Rejected because runtimes could disagree about logical list order, dependency timing, reference scope, and what an older implementation may ignore. Registered profiles define a closed kind grammar and semantic order instead.

### Put paths, locators, or transport hints in descriptors

Rejected because location is mutable transport state, not Package meaning. Such values would couple Hees.ai admission to filesystem, URL, object-store, and traversal behavior. Callers locate bytes outside Hees.ai and submit only the declared byte sequence.

### Put an artifact or member digest inside bytes it hashes

Rejected because a self-digest creates a circular commitment. The complete artifact digest remains an external expected value; member digests and lengths appear only in the preceding manifest descriptor.

### Use Protocol Buffers, deterministic CBOR, Parquet, or another general format as the canonical wire

Rejected as the authority contract because each format imports its own schema evolution, unknown-field, ordering, and implementation rules. These formats may be useful behind explicit import, export, or storage adapters, but they cannot define what a validated Hees.ai Package means.

### Accept compressed, archived, or encrypted member bytes directly

Rejected because decompression, archive traversal, decryption, and key handling create separate resource and security boundaries. Those adapters must produce the exact raw Package wire before admission; their own contracts remain distinct from Package authority.

### Promise arbitrary streaming inside a member

Rejected because closed-model validation, child identity construction, and cross-reference checks require a separately specified bounded sub-member contract. This RFC requires sequential member admission and bounded inter-member retention, not an unsupported promise that every member can be processed byte by byte.

### Retain every accepted member tree or byte sequence

Rejected because retained raw content would erase the memory discipline of member-at-a-time admission and hide mutable-storage integrity assumptions. An admitted Package retains only its declared compact lookup and required projections; later member content is revalidated against the trusted descriptor.

### Choose resource ceilings without evidence

Rejected because arbitrary values can either exclude legitimate constrained deployments or permit avoidable allocation pressure. Every profile must declare exact bounds, and their values must be backed by the profile’s conformance and constrained-resource evidence before that profile can claim support.

### Use a single artifact digest as Package identity

Rejected because a byte hash proves delivery integrity but cannot prove that those bytes decoded into one complete valid governed Package. It also turns representation or delivery changes into semantic changes.

### Use semantic identity without exact artifact integrity

Rejected because package installation, storage, transport, and audit need a byte-exact integrity claim. A valid semantic model does not prove which original bytes arrived.

### Permit arbitrary profile extensions

Rejected because a generic extension map would let an unreviewed field silently affect runtime behavior or create cross-runtime disagreement. New governed capability requires explicit profile registration.

### Make an authoring surface the Package admission authority

Rejected because authoring, review, and release workflows can propose or approve a candidate but must not replace runtime validation. Hees.ai is the final admission boundary.

## Drawbacks

The contract adds a public binary grammar, a schema registry, typed identities, sequential states, goldens, and independent verification obligations. Package producers must compute exact descriptor commitments before assembling the manifest, and consumers must maintain exact compatibility rather than relying on a permissive serializer. Runtime reload trades retained content memory for repeat bounded digest, decode, schema, and child-identity work. Profile registration requires more design discipline than a document with arbitrary metadata.

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

- `hees_ai_package_wire_0_1` is a proposed normative, closed binary artifact contract. JSON is an external edge representation, never the Package authority substrate.
- SHA-256 uses FIPS 180-4. RFC 8259 and RFC 7493 govern declared JSON edges, and RFC 8785 may govern a declared canonical JSON edge artifact; none of those JSON bytes becomes Package semantic identity or admission authority.
- Artifact integrity and semantic identity are separate nominal values. The complete artifact digest spans the complete byte stream; the Package semantic identity is produced only after full typed admission under RFC 011.
- Package Admission Binding derives from the exact semantic-identity and artifact-digest pair. Its human rendering uses check digits to detect transcription mistakes, but it never replaces either primary identity or their separate validation.
- A public append-only registry owns wire tags, profile identifiers, member kinds, and profile contracts. Source declaration order, reflection, serializers, and storage layouts have no authority role.
- The baseline governed-core profile preserves the existing closed actions, evidence, memory, constraint, verification, behavior, and response topology, including its fifteen legal optional-member combinations, while future profiles define their own registered breadth.
- Package topology is profile-registered and closed. Governance, learning, activities, supporting materials, temporal goals, localization, assessment, agent behavior, and effects are accommodated by explicit profiles rather than generic fields.
- Content DNA binds Package semantic identity. Receipts expose semantic identity and may expose artifact digest as distinct delivery provenance when their contract requires it.
- Every runtime-facing reference is Package-identity-bound. Matching a package identifier, revision, descriptor, or artifact digest alone is insufficient for runtime authority.
