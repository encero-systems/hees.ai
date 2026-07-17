# RFC 003: Canonical Package Artifact Admission

- **Status:** Draft
- **Created:** 2026-07-17
- **Author(s):** Encero Systems
- **Related:**
    - RFC 001 (Governed Memory and Retrieval Results)
    - RFC 002 (Composable Governance Constraints)
    - RFC 004 (Export-Safe Governance Receipts)
    - RFC 005 (Evidence-Grounded Claim Verification Findings)
    - RFC 006 (Governed Behavior Envelopes)
    - RFC 007 (Governed Visible Response Lifecycle)
- **Issue:** https://github.com/encero-systems/hees.ai/issues/1
- **RFC PR:** https://github.com/encero-systems/hees.ai/pull/10
- **Written against:** Hees 0.0.1 / Incan 0.4.0
- **Shipped in:** —

## Summary

Hees should admit a governed package through one canonical RFC 8785 JCS root manifest that carries package identity and an ordered closed descriptor array, then validate each independently canonical bounded JCS member in that exact order before atomically producing an accepted package. The external SHA-256 digest of the manifest is the package artifact identity and transitively commits to every member digest, descriptor, and cross-shard order; no package identity, accepted package, or receipt becomes authoritative while admission remains incomplete.

## Core model

1. **The manifest owns package identity.** One bounded canonical JCS manifest contains package, domain, revision, mission, and ordered member descriptors. Its externally supplied SHA-256 digest is `artifact_digest`; the manifest never contains its own digest.
2. **Descriptors commit to members.** Every descriptor names one closed member kind and contract, exact member digest, byte length, and kind-specific record count. Descriptor order is identity-bearing and defines order across shards.
3. **Members remain package-relative.** Each member is an independently bounded canonical JCS object. It repeats only its non-circular descriptor identity fields, contains closed kind-specific content, and omits the containing package identity and digest.
4. **Admission is sequential and atomic.** After manifest verification, an opaque state accepts exactly the next member's raw bytes. Missing, extra, reordered, replayed, malformed, or mismatched members terminally reject that branch and discard its provisional state.
5. **Retained admission state is compact.** Between members, Hees retains bounded descriptors, logical-identifier and reference indexes, and small admitted scalars, not prior raw member bytes or parsed JSON trees.
6. **Identity is not authenticity.** Matching canonical bytes and SHA-256 commitments prove deterministic content identity and integrity, not who produced the package or whether its policy and source claims are true.

## Motivation

Hees 0.0.1 accepts an in-memory `GovernedPackage` and separately validates the shape of a `PackageLoaderDescriptor`. It does not parse canonical package bytes, verify digests, sequence multiple package members, or establish a portable artifact identity. Independent package producers and runtimes therefore need one exact contract for byte identity, member topology, parser behavior, cross-member references, resource handling, reload integrity, and fail-closed completion.

Ordinary JSON is not sufficient for digest identity. Equivalent values can use different whitespace, escaping, number spellings, and property order, while duplicate property names can be interpreted inconsistently. RFC 8785 already defines a deterministic JSON representation on the RFC 7493 I-JSON profile and preserves array order, making it suitable for both the root manifest and each member.

A single large canonical object is also the wrong admission boundary for constrained devices. It couples package size to one parse and canonicalization high-water mark and encourages retention of the complete parsed tree. Bounded member-at-a-time admission is the proposed constrained-device direction, but the design alone does not prove final ceilings, final retained runtime memory, real-device behavior, or behavior on the representative production corpus. This RFC therefore settles the manifest/member contract while leaving the exact numeric resource table as an explicit Draft measurement gate.

## Goals

- Define the root manifest as the sole package artifact identity and map its external digest exactly to RFC 001/002 package fingerprints.
- Define a closed ordered descriptor schema with exact member identity, contract, digest, length, record-count, presence, dependency, and order rules.
- Define independently canonical package-relative members for actions, evidence, governed-memory registry data, governed-memory atom shards, constraints, claim verification, behavior envelopes, and visible-response contracts.
- Preserve one logical ordered evidence list and one logical ordered governed-memory atom list across member shards.
- Define an opaque sequential admission state machine with atomic success, branch-local terminal failure, and exact missing, extra, reorder, and replay behavior.
- Enforce manifest, member, total-package, parser, record, nested-collection, and retained-state bounds before proportional allocation.
- Define deterministic globally unique public reason identifiers and strict precedence across manifest, member, cross-member, and completion failures.
- Bound retained inter-member state without claiming that member sharding alone proves total runtime memory suitability.
- Define storage-neutral runtime reload integrity against the accepted manifest descriptors.
- Define migration, member reuse, digest identity, and authenticity boundaries without mutating admitted bytes.
- Require cross-runtime golden, parser-differential, sequencing, reload, and constrained-device compatibility evidence.

## Non-Goals

- Authoring, editing, reviewing, signing, publishing, locating, fetching, storing, selecting, or migrating package content inside Hees.
- Defining filesystem paths, URLs, object-store keys, archives, compression, decompression, encryption, multipart transport, memory mapping, or storage policy in either manifest or member schemas.
- Promising streaming parsing, incremental JCS canonicalization, or sub-member paging within one member.
- Verifying source rights, policy quality, semantic correctness, producer identity, organizational approval, or executable provenance.
- Defining arbitrary member kinds, extension maps, custom metadata, caller-selected capability namespaces, or implementation-private payloads.
- Negotiating digest algorithms, contract versions, member versions, or compatible-looking aliases.
- Treating manifest verification, one accepted member, or a valid `PackageLoaderDescriptor` as partial package admission.
- Choosing final numeric ceilings before representative constrained-device and real-corpus measurements justify them.

## Guide-level explanation

This RFC describes a proposed public contract. Hees 0.0.1 does not implement manifest/member admission or serialized package reload.

A package producer first creates each closed member value, serializes it independently with RFC 8785 JCS, and computes SHA-256 over those exact member bytes. The producer then creates the root manifest with one descriptor per member in the required order. Each descriptor commits to the member's identifier, kind, contract, digest, exact byte length, and semantic record count. Finally, the producer serializes the manifest with JCS and computes the external manifest digest.

Admission begins with only the manifest bytes and external expected manifest digest. After the manifest passes, the caller supplies raw member bytes one at a time; it does not submit a path, descriptor, claimed member identifier, claimed length, or independent expected member digest. The opaque state already knows the sole expected descriptor. The proposed Incan call shape is:

```incan
# Proposed API shape; not implemented in Hees 0.0.1.
mut state = begin_package_artifact_admission(
    manifest_bytes=canonical_manifest_bytes,
    expected_manifest_digest="sha256:63d96c8cf4af9c207646a8e72617e450778a5dc52b45998f85218fa4142b8970",
)
state = admit_next_package_member(state, canonical_actions_member_bytes)
state = admit_next_package_member(state, canonical_evidence_member_bytes)
admission = finish_package_artifact_admission(state)

if admission.accepted:
    println(f"package={admission.package_id} revision={admission.package_revision}")
    println(f"artifact={admission.artifact_digest}")
```

The following formatted JSON illustrates a minimal logical manifest. Display whitespace has been added, and the descriptor commitments are illustrative rather than golden fixture values:

```json
{
  "artifact_contract": "0.1",
  "domain_id": "public_learning",
  "members": [
    {
      "byte_length": 241,
      "member_contract": "0.1",
      "member_digest": "sha256:1111111111111111111111111111111111111111111111111111111111111111",
      "member_id": "actions_core",
      "member_kind": "actions",
      "record_count": 1
    },
    {
      "byte_length": 132,
      "member_contract": "0.1",
      "member_digest": "sha256:2222222222222222222222222222222222222222222222222222222222222222",
      "member_id": "evidence_core",
      "member_kind": "evidence",
      "record_count": 0
    }
  ],
  "mission": "Provide bounded public-learning guidance.",
  "package_id": "learning_support",
  "package_revision": "1.0"
}
```

The matching logical actions member repeats its non-circular self-description and contains the closed action content. It does not repeat the package, domain, revision, manifest digest, member digest, byte length, path, or locator:

```json
{
  "items": [
    {
      "evidence_required": true,
      "id": "explain"
    }
  ],
  "member_contract": "0.1",
  "member_id": "actions_core",
  "member_kind": "actions",
  "record_count": 1
}
```

Every package has exactly one non-empty actions member and at least one evidence member. Evidence may be split across multiple members, with one logical list formed by concatenating their item arrays in descriptor order. Governed memory, when present, uses one registry member followed immediately by one or more non-empty atom members; the atom arrays likewise concatenate in descriptor order. Constraints, claim verification, a behavior envelope, and a response contract are optional singletons in that order. Claim verification requires both governed memory and constraints. A response contract requires a behavior envelope.

No intermediate state exposes an accepted package. Calling `finish_package_artifact_admission` before every descriptor succeeds rejects with a missing-member reason. Supplying a later member early, replaying a member already admitted in the current branch, or supplying bytes after the descriptor list ends also terminally rejects that branch. Retaining or cloning a predecessor value creates an independent bounded branch from the same verified manifest commitments; every branch that reaches successful `finish` necessarily establishes the same package identity. Only successful `finish` atomically establishes that identity and makes an accepted RFC 004 package receipt possible.

## Reference-level explanation

### Normative format basis

Artifact contract `0.1` must use:

- [RFC 8259, The JavaScript Object Notation Data Interchange Format](https://www.rfc-editor.org/rfc/rfc8259) for JSON syntax;
- [RFC 7493, The I-JSON Message Format](https://www.rfc-editor.org/rfc/rfc7493) for interoperable UTF-8, Unicode, number, and duplicate-name constraints;
- [RFC 8785, JSON Canonicalization Scheme](https://www.rfc-editor.org/rfc/rfc8785) for canonical primitive serialization, recursive object-property sorting, preserved array order, and final UTF-8 bytes; and
- [FIPS 180-4, Secure Hash Standard](https://csrc.nist.gov/pubs/fips/180-4/upd1/final) for SHA-256.

Where this RFC narrows those standards, the narrower package contract must apply. It must not weaken a JCS or I-JSON requirement. The manifest and every member must be separate complete RFC 8259 JSON objects, each encoded as strict UTF-8 without a byte-order mark and each independently equal to its RFC 8785 JCS serialization.

### Manifest submission and package artifact identity

The initial package-artifact submission must contain exactly two caller inputs:

- `manifest_bytes`, the raw uncompressed bytes claimed to be the complete canonical root manifest; and
- `expected_manifest_digest`, a bounded ASCII string supplied outside `manifest_bytes`.

The expected manifest digest must use exactly `sha256:<64 lowercase hexadecimal characters>`. Contract `0.1` must reject uppercase hexadecimal, missing or extra characters, whitespace, alternate prefixes, bare hexadecimal, or another algorithm. Hees must hash the exact submitted manifest byte sequence without trimming, decoding, normalizing, decompressing, or reserializing first.

The verified expected manifest digest is the canonical external `artifact_digest` for the complete package. RFC 001 and RFC 002 use an unprefixed `package_fingerprint` view of that same value:

```text
artifact_digest == "sha256:" + package_fingerprint
package_fingerprint == artifact_digest after removing the one required "sha256:" prefix
```

The root manifest must not contain `digest`, `artifact_digest`, `package_fingerprint`, `self_digest`, or any equivalent self-identity member. Its identity is external and non-circular. Because the manifest contains the ordered exact descriptors and every descriptor contains one exact member digest, changing any descriptor or committed member necessarily changes canonical manifest bytes and therefore the package artifact digest.

After manifest verification, each state transition must accept exactly one caller input: the next member's raw uncompressed bytes. It must not accept an independently supplied member identifier, kind, contract, digest, length, record count, path, or locator. Every expected member value comes only from the already verified manifest held inside the opaque admission state.

### JSON, Unicode, and number profile

Every parser used for admission must detect duplicate property names before mapping an object into a representation that could discard duplicates. Two names are duplicates when their decoded Unicode strings are identical, including names written through different JSON escape forms. A duplicate at any nesting level must reject the current manifest or member.

All string values and property names must be valid Unicode permitted by I-JSON. JCS string values must be preserved as-is. Hees must not apply NFC, NFD, case folding, locale transformation, whitespace folding, line-ending conversion, or any other Unicode normalization. Visually equivalent but byte-distinct Unicode sequences remain distinct content and therefore produce distinct canonical bytes and digests.

Contract `0.1` must reject every JSON number containing a fraction or exponent. It must reject negative zero and values outside the inclusive exact-integer range `-9007199254740991..9007199254740991`. A future field requiring a larger integer must use an explicit field-specific canonical decimal-string grammar and byte ceiling under a new exact contract; no generic numeric-string escape hatch is permitted.

Objects must be serialized exactly as JCS specifies. Arrays must preserve submitted semantic order; Hees must not sort or deduplicate them. Reordering the manifest descriptor array, a member item array, or any identity-bearing nested array changes canonical bytes and digest identity.

### Canonical identifiers and versions

Package, domain, member, action, evidence, memory, constraint, provider, reason, label, and capability identifiers must match `[a-z0-9][a-z0-9_-]*` and their field-specific byte ceilings. Versions and package revisions must match `[0-9]+(\.[0-9]+){1,2}` and compare exactly. Hees must not normalize or infer compatibility from either form.

Every manifest member identifier must be unique. Every descriptor member digest must also be unique within one manifest so a bounded digest lookup can classify a member consumed in the current branch as replayed and a future member as out of order without ambiguity. Logical identifiers must satisfy the kind-specific and combined-namespace uniqueness rules below.

### Closed root manifest schema

The root manifest must contain exactly:

- `artifact_contract`, exactly `0.1`;
- `package_id`;
- `domain_id`;
- `package_revision`;
- bounded non-empty `mission`; and
- `members`, one bounded non-empty ordered descriptor array.

Unknown root members must reject the manifest. The root must not contain `capabilities`, generic `metadata`, `extensions`, `custom`, storage information, or arbitrary key/value content. For contract `0.1`, `artifact_contract` is also the admitted package schema version inherited by RFC 001 runtime atoms and RFC 002 runtime plans. The manifest must not contain a second package schema version.

Every descriptor must contain exactly:

- `member_id`, one canonical manifest-unique member identifier;
- `member_kind`, exactly one closed kind defined below;
- `member_contract`, the exact supported capability/member contract for that kind;
- `member_digest`, exactly `sha256:<64 lowercase hexadecimal characters>` and unique within the manifest;
- `byte_length`, one positive exact integer equal to the complete member byte length; and
- `record_count`, one non-negative exact integer with the kind-specific meaning below.

A descriptor must not contain a path, locator, media type, compression flag, archive member, fetch hint, mutable generation, timestamp, arbitrary metadata, or alternate digest. `byte_length` and `record_count` must fit the cross-language exact-integer range and their contract ceilings. Their checked aggregate calculations must reject overflow rather than wrap, saturate, clamp, or allocate.

The only `member_kind` values in artifact contract `0.1` are `actions`, `evidence`, `governed_memory_registry`, `governed_memory_atoms`, `constraints`, `claim_verification`, `behavior_envelope`, and `response_contract`. Each uses `member_contract` version `0.1` exactly. A new kind, a changed member wrapper, or a changed capability contract requires a new exact artifact or member contract rather than an ignored extension.

### Member topology, presence, and combined order

The descriptor array must satisfy this exact kind grammar:

```text
actions evidence+ (governed_memory_registry governed_memory_atoms+)? constraints? claim_verification? behavior_envelope? response_contract?
```

This grammar means:

- descriptor zero is the sole `actions` member, and its action list is non-empty;
- one or more contiguous `evidence` members follow;
- governed memory is absent entirely or consists of exactly one registry member immediately followed by one or more atom members;
- `constraints`, `claim_verification`, `behavior_envelope`, and `response_contract` are optional singletons and may appear only in that order;
- `claim_verification` is legal only when the complete governed-memory group and `constraints` are present;
- `response_contract` is legal only when `behavior_envelope` is present; and
- no other multiplicity, interleaving, or order is valid.

These rules produce exactly 15 legal optional-member topologies. The number is a compatibility assertion derived from the grammar and dependency rules, not an additional permissive interpretation of them.

The logical evidence list is the stable concatenation of every evidence member's `items` array in descriptor order. If that combined list is empty, there must be exactly one evidence member and it must have `record_count=0`; otherwise every evidence member must be non-empty. The logical governed-memory atom list is the stable concatenation of every atom member's non-empty `items` array in descriptor order. Record order within one member and member order across shards are both package identity.

The descriptor `record_count` must equal this exact kind-specific count:

| Member kind | Exact `record_count` meaning |
| --- | --- |
| `actions` | Number of action `items`; greater than zero. |
| `evidence` | Number of evidence `items`; zero only for the sole empty evidence member. |
| `governed_memory_registry` | Sum of provider bindings plus authority, risk, and sensitivity classification identifiers. |
| `governed_memory_atoms` | Number of atom `items`; greater than zero for every shard. |
| `constraints` | Sum of constraint definitions plus evaluator capability declarations; both collections are non-empty. |
| `claim_verification` | Number of verifier provider bindings plus one policy. |
| `behavior_envelope` | Sum of phase identifiers, four class-identifier arrays, states, strategies, and selection criteria. |
| `response_contract` | Sum of synthesis requirements, clarification definitions, and failure-policy rules. |

Descriptor counts must satisfy per-member and combined capability ceilings before any member bytes are requested. Parsing a member must reproduce the same count exactly. A declared count is a resource commitment and consistency check, not proof that the unseen member content is valid.

### Common member shape and inherited identity

Every member must be a closed object containing exactly the common non-circular self-description fields `member_id`, `member_kind`, `member_contract`, and `record_count`, plus the fields permitted by its kind-specific schema. Those four values are untrusted self-description until they exactly match the current descriptor. The descriptor's `member_digest` and `byte_length` must not appear inside the member because they commit to the complete member bytes and repeating the digest would create another self-digest cycle.

A member must not contain the containing `artifact_contract`, `package_id`, `domain_id`, `package_revision`, `package_fingerprint`, `artifact_digest`, or equivalent package identity. It must not contain a path, locator, storage key, compression field, archive field, generic metadata, or extension map. Fingerprints for separately governed corpus, source, provider configuration, or index artifacts and exact adapter versions remain explicit only where RFC 001 requires them; they do not identify the containing package.

An individually valid member remains provisional and package-relative. Only after every descriptor succeeds and `finish` completes may Hees bind member declarations to the manifest's trusted package, domain, artifact contract, revision, and artifact digest. That derived binding must not modify, migrate, reserialize, or re-hash manifest or member bytes. RFC 001 atoms receive the exact unprefixed package-fingerprint view, and RFC 002 plans receive the same complete inherited package identity.

### Kind-specific member schemas

An `actions` member must contain the four common fields plus `items`. Each item must contain exactly canonical action `id` and Boolean `evidence_required`. The array must be non-empty. An action item contains no evidence identifier; `evidence_required` says only whether a later proposal for that action must nominate at least one admitted evidence identifier.

An `evidence` member must contain the four common fields plus `items`. Each evidence item must contain exactly canonical package-scoped `id`, bounded non-empty `claim`, bounded non-empty `guidance`, bounded non-empty source-safe `source_ref`, `rights_status`, and `review_status`. The recognized rights values are `allowed`, `restricted`, and `denied`; the recognized review values are `approved`, `pending`, and `rejected`. A deployable admitted package requires `allowed` and `approved`, while recognized non-deployable values retain distinct public rejection reasons.

For actions and evidence, ASCII whitespace is exactly tab `U+0009`, line feed `U+000A`, carriage return `U+000D`, and space `U+0020`. `mission`, evidence `claim`, and evidence `guidance` must each contain at least one code point outside that set. A `source_ref` must be non-empty; must not begin or end with ASCII whitespace; and must contain no C0 control code point `U+0000..U+001F`, delete `U+007F`, backslash, `..` substring, `file://` substring, or `:/` substring. Its first code point must not be `/`. These checks establish a source-safe reference shape; they do not dereference it or establish rights.

A `governed_memory_registry` member must contain the four common fields plus the complete package-relative RFC 001 registry payload. Its semantic collections are non-empty ordered provider bindings, non-empty ordered authority/risk/sensitivity classification identifiers, and optional lower positive item and context-byte ceilings. Provider bindings carry the provider, provider-contract, adapter-version, configuration-fingerprint, index-fingerprint, and corpus-fingerprint identity defined by RFC 001. The member must not contain atoms.

A `governed_memory_atoms` member must contain the four common fields plus one non-empty `items` array. Every item uses the complete package-relative RFC 001 atom payload: logical identifier, corpus version and fingerprint, bounded claim/guidance/applicability, source-safe reference and source fingerprint, review and runtime-rights states, authority/risk/sensitivity identifiers, typed validity data, and ordered labels. It must not repeat registry fields or package identity. RFC 003 validates recognized review and runtime-rights enum values structurally but does not require an atom to be currently approved or allowed; RFC 001 exclusively owns that eligibility decision when a runtime memory result nominates the admitted atom.

A `constraints` member must contain the four common fields plus the complete package-relative RFC 002 plan payload. Its semantic fields are plan identifier and revision, positive evaluation budget, non-empty ordered evaluator capabilities, and non-empty ordered definitions. Every definition includes its ordered dependencies, allowed evaluator action/reason pairs, action ceiling, and fail-closed action/reason pair. For this kind, `member_contract` is the serialized RFC 002 constraint contract version required by RFC 002, not a wrapper-only version; it must be `0.1`, and no nested second constraint version or package identity is permitted.

A `claim_verification` member must contain the four common fields plus the complete package-relative RFC 005 payload. Its semantic fields are a non-empty ordered provider-binding array and exactly one policy. Its constraint reference must resolve to an admitted RFC 002 definition with the required evaluator kind and version, and every policy mapping must satisfy that definition's admitted action/reason and action-strength rules. RFC 005 exclusively owns the payload keys, binding identity, threshold semantics, policy mapping, and runtime finding contract.

A `behavior_envelope` member must contain the four common fields plus the complete package-relative RFC 006 payload. Its semantic fields are envelope identity, phase and class declarations, states, strategies, and selection policy. Every package-action reference must resolve in the preceding actions member, while every state, strategy, class, transition, priority, and selection-policy reference must satisfy RFC 006. RFC 006 exclusively owns behavior selection and the opaque selected-candidate capability; package admission does not inspect response prose or select a behavior candidate.

A `response_contract` member must contain the four common fields plus the complete package-relative RFC 007 payload. Its semantic fields are response-contract identity, lower package limits, synthesis requirements, package-authored clarifications, and failure policy. Strategy references must resolve in the preceding behavior envelope and action references in the actions member. RFC 007 exclusively owns visible-unit, support, repair, clarification, proposal-terminal, and receipt-source semantics; no candidate or response content belongs in the package member.

RFC 003 owns the exact common wrapper, member partition, canonical bytes, digest commitments, sequence, and cross-member composition. Imported payload fields are top-level siblings of the four common fields, not members of a generic `payload` envelope, and the imported field sets must be disjoint from all four common names. RFC 001 exclusively owns every JSON key, nested object shape, type, enum spelling, optional-field omission rule, and semantic validation rule inside its registry and atom payloads; RFC 002 owns the same details inside its plan payload; and RFCs 005, 006, and 007 respectively own the same details inside claim-verification, behavior-envelope, and response-contract payloads. Artifact contract `0.1` imports those frozen serialized `0.1` schemas without aliases, compatibility normalization, duplicate contract fields, or locally invented defaults. The semantic summaries above are not substitutes for those byte-level schemas. Lifecycle advancement remains coupled to all imported source RFCs, and shared golden members must prove that all runtimes import the same shapes.

Every kind-specific object is closed. Unknown fields, unrecognized enums, unsupported versions, arbitrary metadata, and incompatible optional-field combinations must fail closed.

### Logical namespaces and references

Action identifiers must be unique in the sole actions member. Evidence identifiers must be unique across the combined evidence list. Governed-memory atom identifiers must be unique across all atom members. Provider binding tuples and classification identifiers must be unique within their RFC 001 registry namespaces. Constraint identifiers, orders, and evaluator capability tuples must be unique within the constraints member. Claim-verification binding and policy identifiers, behavior-envelope declarations, and response-contract requirement and clarification identifiers must satisfy the uniqueness rules of RFCs 005, 006, and 007 respectively.

Because RFC 002 contract `0.1` uses generic package-owned support identifiers rather than typed evidence and memory namespaces, evidence identifiers and governed-memory atom identifiers must be mutually disjoint in artifact contract `0.1`. A collision uses the dedicated cross-member support-namespace reason rather than becoming an ambiguous runtime reference.

Every governed-memory atom classification identifier must resolve exactly once in the preceding registry member. Every atom corpus fingerprint must equal at least one admitted registry provider binding's corpus fingerprint. Constraint dependencies and evaluator kind/version references must resolve exactly once within the constraints member and obey RFC 002's dense order and earlier-only dependency rules. No member may create an undeclared forward reference, and a string that merely resembles an identifier creates no reference.

Claim-verification references may resolve only to the preceding constraints member and its own provider-binding declarations. Behavior-envelope action references may resolve only to the preceding actions member and its local declarations. Response-contract strategy references may resolve only to the preceding behavior envelope, and its action references may resolve only to the actions member. Package admission must validate those exact backwards references without importing candidate, selected-memory, selected-evidence, proposal, verifier-result, or runtime-context identifiers into retained package state.

### Opaque sequential admission state

Manifest admission must return either a terminal rejection or one opaque pending state value. The pending value may contain only the verified manifest scalar fields and digest, the bounded descriptor table, the next descriptor index, compact current-branch consumed/future digest identity, bounded logical-identifier and reference indexes, checked aggregate counters, and small scalars required by admitted contracts. It must expose no trusted package identity, package content, accepted capability, or receipt-authoring surface.

Each pending value represents one branch at one exact descriptor index. Applying a successful nonterminal member transition returns that branch's successor; rejection or successful finish returns no successor for that branch. Because public Incan values are cloneable, retaining or explicitly cloning a predecessor creates an independent bounded branch with the same verified manifest and descriptor commitments. A terminal result cannot be resumed, repaired, or appended to, but it does not poison a separately retained predecessor or sibling branch. Replay and out-of-order classification use only the branch value supplied to the transition. No hidden native handle, process-global session registry, or cross-branch invalidation authority is part of this contract.

Branching cannot change admitted authority: every successful branch must validate the same exact descriptor-committed member bytes and therefore produce the same accepted package identity and trusted lookup. An abandoned or rejected branch produces no accepted package. Cloning may duplicate that branch's bounded compact value in caller-owned memory, but Hees retains no global branch registry; each branch must independently satisfy the same retained-state ceiling.

### Manifest verification order

Hees must verify a manifest in this order:

1. Enforce the exact manifest byte ceiling before hashing, UTF-8 decoding, parsing, or allocation proportional to declared content.
2. Validate the external expected manifest digest syntax.
3. Compute SHA-256 over the exact manifest bytes and compare the complete lowercase digest value.
4. Decode strict UTF-8 and scan one complete I-JSON object with bounded nesting, token, property, string, and descriptor counts; reject trailing data, duplicate decoded property names, and disallowed numbers in the fixed parse precedence below.
5. Validate the closed manifest and descriptor schemas, exact contracts, identifiers, fields, multiplicity, order, dependencies, record counts, and checked total declared package bytes.
6. Regenerate RFC 8785 JCS bytes from the validated value and require byte-for-byte equality with `manifest_bytes`.
7. Create the opaque pending state without exposing an accepted package, then release the manifest raw bytes, parsed JSON tree, and JCS regeneration buffer.

The canonical byte comparison remains required after digest verification. The digest proves the bytes match the caller's expected manifest identity; JCS regeneration proves those bytes are the one permitted representation of the parsed manifest.

### Next-member verification order

For the descriptor at the state's exact next index, Hees must verify one submitted member in this order:

1. Reject immediately if no descriptor remains; do not inspect or hash extra bytes.
2. Enforce the exact absolute and kind-specific member byte ceilings before hashing, parsing, or proportional allocation.
3. Compute SHA-256 over the exact member bytes. If it matches a descriptor digest already consumed in the current branch, reject as replayed; if it matches a later descriptor digest, reject as out of order.
4. Compare actual byte length with the current descriptor, then compare the computed digest with the current descriptor. Expected length and digest come only from the verified manifest.
5. Decode strict UTF-8 and scan one complete bounded I-JSON object using the same fixed parse classification as the manifest.
6. Validate the closed common and kind-specific schemas, exact self-description tuple, exact record count, local identifiers, local references, rights, review state, and field bounds.
7. Validate combined namespace uniqueness, support-namespace separation, registry references, and other cross-member rules against compact provisional state.
8. Regenerate RFC 8785 JCS bytes and require byte-for-byte equality with the submitted member bytes.
9. Commit only compact descriptor, identifier, reference, ordinal, and small scalar state; advance the next index; then release the member's raw bytes, parsed JSON tree, and JCS regeneration buffer before accepting another member.

Hees must not promise streaming within a member. A conforming implementation may need the complete bounded member value for duplicate-aware parsing, schema checks, and JCS regeneration. The low-memory guarantee is member-at-a-time admission plus bounded compact inter-member retention, not sub-member streaming.

### Completion and atomic authority

`finish_package_artifact_admission` must succeed only when the next descriptor index equals the descriptor count and every combined invariant remains satisfied. Calling it earlier terminally rejects as missing a member. Supplying any member when no descriptor remains terminally rejects as unexpected.

Successful finish must atomically produce the accepted package identity, trusted descriptor and lookup state, and the terminal result eligible for RFC 004 private receipt projection. No earlier manifest or member transition may return a public accepted package, imported member authority, or RFC 004 receipt. A terminal failure discards all provisional package state for that branch and may produce only the minimal rejected result eligible for RFC 004's rejection mapping.

### Public admission stages and reasons

Every terminal result must contain exactly one stage and one reason from this closed table. Rows are strict global stage precedence, and reason order within a row is strict reason precedence. The member rows repeat for each descriptor in manifest order; the earliest descriptor index at which admission cannot continue determines the member failure.

| Stage | Reasons in precedence order |
| --- | --- |
| `manifest_input` | `manifest_bytes_exceeded` |
| `manifest_expected_digest` | `manifest_expected_digest_invalid` |
| `manifest_digest` | `manifest_digest_mismatch` |
| `manifest_parse` | `manifest_utf8_invalid`, `manifest_parse_limit_exceeded`, `manifest_json_invalid`, `manifest_duplicate_property_name`, `manifest_number_invalid` |
| `manifest_schema` | `manifest_contract_unsupported`, `manifest_required_field_missing`, `manifest_unknown_field`, `manifest_identifier_invalid`, `manifest_revision_invalid`, `manifest_field_invalid`, `manifest_field_limit_exceeded`, `manifest_member_count_invalid`, `manifest_member_digest_invalid`, `manifest_member_length_invalid`, `manifest_record_count_invalid`, `manifest_member_id_duplicate`, `manifest_member_digest_duplicate`, `manifest_member_kind_unsupported`, `manifest_member_contract_unsupported`, `manifest_member_dependency_invalid`, `manifest_member_order_invalid`, `manifest_total_bytes_overflow`, `manifest_total_bytes_exceeded` |
| `manifest_canonical` | `manifest_bytes_noncanonical` |
| `member_sequence` | `member_unexpected` |
| `member_input` | `member_bytes_exceeded` |
| `member_integrity` | `member_replayed`, `member_out_of_order`, `member_length_mismatch`, `member_digest_mismatch` |
| `member_parse` | `member_utf8_invalid`, `member_parse_limit_exceeded`, `member_json_invalid`, `member_duplicate_property_name`, `member_number_invalid` |
| `member_schema` | `member_required_field_missing`, `member_unknown_field`, `member_identity_mismatch`, `member_record_count_mismatch`, `member_identifier_invalid`, `member_enum_invalid`, `member_field_invalid`, `member_field_limit_exceeded`, `member_duplicate_declaration`, `member_broken_reference`, `member_evidence_rights_not_allowed`, `member_evidence_not_approved` |
| `cross_member` | `cross_member_duplicate_identifier`, `cross_member_broken_reference`, `cross_member_support_namespace_collision`, `cross_member_retained_limit_exceeded` |
| `member_canonical` | `member_bytes_noncanonical` |
| `complete` | `member_missing`, `admitted` |

The manifest input, expected-digest, and digest reasons have singular meanings: `manifest_bytes_exceeded` means the raw manifest exceeds its pre-hash ceiling; `manifest_expected_digest_invalid` means the external digest violates exact syntax; and `manifest_digest_mismatch` means the computed digest differs from that well-formed expected value.

Manifest parse classification is exact. `manifest_utf8_invalid` applies first to invalid UTF-8 or a byte-order mark. `manifest_parse_limit_exceeded` covers nesting, token, property, descriptor, or string scanner ceilings before object allocation. `manifest_json_invalid` covers incomplete grammar or trailing data. `manifest_duplicate_property_name` covers equal decoded names after grammar is known valid. `manifest_number_invalid` covers fractions, exponents, negative zero, or values outside the exact-integer profile.

Manifest schema reasons also have exact scopes. `manifest_contract_unsupported` applies to a well-formed artifact contract other than `0.1`; malformed contract syntax uses `manifest_field_invalid`. `manifest_required_field_missing` and `manifest_unknown_field` apply to absent required or extra root/descriptor fields. `manifest_identifier_invalid` covers malformed or over-bound package, domain, or member identifiers; `manifest_revision_invalid` covers package revision syntax or bounds; `manifest_field_invalid` covers a wrong type or invalid scalar combination except for descriptor `member_digest`, `byte_length`, and `record_count`, which use their dedicated reasons; and `manifest_field_limit_exceeded` covers bounded mission or other non-parser field limits.

`manifest_member_count_invalid` covers a missing or duplicate actions member, absence of every evidence member, more than one registry, constraints, claim-verification, behavior-envelope, or response-contract member, or the cross-descriptor evidence emptiness rule after the absolute descriptor scanner ceiling has passed; it deliberately does not classify optional-member dependencies or relative order. Once every relevant descriptor `record_count` is individually valid, it also covers a checked combined actions, evidence, or governed-memory-atoms descriptor sum that would exceed `9007199254740991` or its lower capability ceiling. The evidence emptiness rule likewise applies only after every evidence `record_count` is individually valid: it requires exactly one zero-count evidence descriptor when their declared combined count is zero and otherwise requires every evidence descriptor count to be positive. `manifest_member_digest_invalid` covers the descriptor digest type and exact syntax. `manifest_member_length_invalid` covers the descriptor length type, exact-integer range, positivity, and ceiling. `manifest_record_count_invalid` covers the descriptor count type, exact-integer range, ceiling, and the kind-local lower bounds `actions >= 1`, `governed_memory_registry >= 4`, `governed_memory_atoms >= 1`, `constraints >= 2`, `claim_verification >= 2`, `behavior_envelope >= 8`, and `response_contract >= 7`; it is strictly per descriptor, while cross-descriptor emptiness and aggregate sums use only `manifest_member_count_invalid`. `manifest_member_id_duplicate` and `manifest_member_digest_duplicate` cover duplicate values in those complete descriptor fields. `manifest_member_kind_unsupported` covers an unknown closed kind, and `manifest_member_contract_unsupported` covers a known kind with a well-formed version other than its exact supported contract. After multiplicities and manifest-time combined counts pass, `manifest_member_dependency_invalid` covers registry without atoms, atoms without a registry, claim verification without the complete governed-memory group and constraints, or a response contract without a behavior envelope. After multiplicity, count, and dependency checks pass, `manifest_member_order_invalid` covers every remaining sequence that differs from the exact kind grammar, including noncontiguous evidence or atom shards, a registry not immediately before its atoms, or any optional singleton outside constraints, claim verification, behavior envelope, then response contract order. `manifest_total_bytes_overflow` means the exact non-negative sum of manifest byte length and every declared member byte length would exceed `9007199254740991`; `manifest_total_bytes_exceeded` means that representable sum exceeds the lower contract ceiling. `manifest_bytes_noncanonical` means the fully valid manifest does not byte-equal its JCS regeneration.

At the member boundary, `member_unexpected` means bytes were submitted when no descriptor remained. `member_bytes_exceeded` means the raw current member exceeds the absolute or current-kind ceiling. After bounded hashing, `member_replayed` means the digest equals one descriptor already consumed in the current branch, and `member_out_of_order` means it equals a later descriptor. `member_length_mismatch` then compares actual length with the current descriptor; `member_digest_mismatch` applies only after the length matches and the digest is neither consumed in that branch, future, nor current.

Member parse reasons mirror the manifest without sharing identifiers: `member_utf8_invalid`, `member_parse_limit_exceeded`, `member_json_invalid`, `member_duplicate_property_name`, and `member_number_invalid` apply in that exact order to the current member and use the same narrowed conditions.

Member schema classification is also closed. `member_required_field_missing` and `member_unknown_field` apply to the common or current kind-specific object. `member_identity_mismatch` means `member_id`, `member_kind`, or `member_contract` differs from the current descriptor; `member_record_count_mismatch` means the member field or content-derived count differs from the descriptor. `member_identifier_invalid` covers malformed or over-bound logical content identifiers after the common self-description has matched. `member_enum_invalid`, `member_field_invalid`, and `member_field_limit_exceeded` cover unknown enum values, wrong types or invalid field combinations, and non-parser field/collection ceilings, respectively. `member_duplicate_declaration` covers duplicate logical identifiers, provider-binding tuples, classification identifiers, constraint orders, evaluator capability tuples, verification bindings, behavior declarations, response requirements, clarifications, or other kind-declared unique values inside the current member. `member_broken_reference` covers a reference that must resolve inside the same member. `member_evidence_rights_not_allowed` and `member_evidence_not_approved` distinguish recognized non-deployable evidence rights and review states. Unknown evidence or RFC 001 atom rights/review values use `member_enum_invalid`; recognized RFC 001 atom states remain admissible package declarations and are evaluated only under RFC 001 runtime memory admission.

Cross-member reasons apply after current-member schema validation. `cross_member_duplicate_identifier` means an evidence or atom identifier duplicates one from an earlier shard. `cross_member_broken_reference` means a memory atom classification or corpus reference does not resolve in the preceding registry state, a claim-verification policy does not resolve to its required constraint definition and permitted mappings, a behavior strategy does not resolve to an admitted action, or a response requirement does not resolve to its admitted behavior strategy and actions. `cross_member_support_namespace_collision` means an evidence identifier and memory atom identifier collide in the contract `0.1` generic support namespace. `cross_member_retained_limit_exceeded` means committing the current valid member would make one of the representation-independent cumulative logical-index or reference-index counters defined below exceed its exact contract domain or ceiling. `member_bytes_noncanonical` then applies when the fully schema-, reference-, and retained-limit-valid member does not byte-equal its JCS regeneration.

At the `complete` stage, `member_missing` means `finish` was called before every descriptor succeeded. `admitted` is the sole successful reason and is reachable only after all descriptors and combined invariants pass.

Every reason identifier is globally unique within RFC 004's `package_artifact_admission_0_1` namespace, so a receipt verifier can derive the source stage without exporting a separate stage field. At any schema or cross-member stage, Hees must determine the complete set of applicable public reason kinds for the current bounded value and choose the first reason in the table. It must not select reasons from parser wording, hash-map iteration, object property order, record traversal order, storage errors, or arbitrary caller text. Richer diagnostics may remain private but must not alter the public result or echo package content.

Any failure is terminal for that transition branch, exposes no parsed or partially admitted package identity, and releases that branch's provisional raw bytes, JSON trees, and indexes. It returns no successor. A caller may begin again from the manifest or form a separate branch from a predecessor value retained before the failed transition; it cannot continue from the terminal result.

### Resource and retained-state boundary

Artifact contract `0.1` requires one exact shared ceiling table across all conforming runtimes. The following compatibility dimensions are normative even though their numeric values remain a Draft measurement gate:

| Ceiling dimension | Required enforcement point |
| --- | --- |
| Manifest UTF-8 bytes | Before manifest hashing or decoding. |
| Member UTF-8 bytes, including a kind-specific ceiling | Before member hashing or decoding. |
| Total declared package bytes | After bounded manifest validation, before any member is accepted. |
| Descriptor/member count | During bounded manifest scanning and again during schema validation. |
| Parse nesting, token, property, and string size | During the lossless manifest/member scan before ordinary object mapping. |
| Identifier, version, mission, text, source-reference, and fingerprint sizes | During closed schema validation. |
| Per-member `record_count` by kind | From manifest descriptors before member intake, then against parsed content. |
| Combined actions, evidence, and memory atoms | From checked descriptor sums before member intake, then against cumulative counters while members are admitted. |
| Provider bindings, classification identifiers, constraint definitions, and evaluator capabilities | From their member's bounded lossless scan before ordinary object mapping, then against content-derived counters before retention. |
| Nested labels, dependencies, allowed action/reason pairs, and support/reference collections | Before allocating or retaining each declared collection. |
| Claim-verification bindings, policies, target rules, and runtime request/result values | From bounded member scanning and RFC 005 validation before package retention or verifier invocation. |
| Behavior phases, classes, states, transitions, strategies, criteria, candidates, traces, and opaque selected state | From bounded member or candidate-set scanning and RFC 006 validation before proportional allocation or retention. |
| Response requirements, clarifications, failure rules, candidates, visible units, support mappings, findings, repair state, results, and receipt-source projection | From bounded member, proposal, provider-result, or repair scanning and RFC 007 validation before proportional allocation or retention. |
| Manifest-state text, logical-index entries/text, and reference-index entries/text | From the representation-independent accounting vector below before committing inter-member or accepted-package state. |

All byte lengths, counts, and aggregate calculations use the mathematical exact-integer domain `0..9007199254740991` independent of host integer width. Member `byte_length`, required non-empty counts, and positive package limits must also be greater than zero where their schemas require it. Every addition and multiplication must be checked before proportional allocation and must never wrap, saturate, clamp, or depend on a runtime's native integer representation.

The manifest total is the exact manifest byte length plus every descriptor `byte_length`. A domain overflow uses `manifest_total_bytes_overflow`; a representable value above the lower contract ceiling uses `manifest_total_bytes_exceeded`. During manifest schema validation, a descriptor/member-count or retained manifest-state-text limit uses `manifest_member_count_invalid` or `manifest_field_limit_exceeded`, respectively. Within one parsed member, a scanner counter or field/collection counter exceeding either the exact-integer domain or its lower contract ceiling uses `member_parse_limit_exceeded` or `member_field_limit_exceeded` according to whether the lossless scan or the closed field schema owns that counter. Committing a valid member that would overflow or exceed a cumulative logical/reference index dimension uses only `cross_member_retained_limit_exceeded`.

The retained logical accounting vector is representation-independent and contains exactly:

- `descriptor_entry_count`, equal to `len(members)`;
- `manifest_state_text_bytes`, the sum of the UTF-8 byte lengths of `artifact_contract`, `package_id`, `domain_id`, `package_revision`, `mission`, external `artifact_digest`, and every descriptor's `member_id`, `member_kind`, `member_contract`, and `member_digest`;
- `logical_index_entry_count` and `logical_index_text_bytes`, with one entry for each admitted action, evidence record, memory atom, constraint plan, constraint definition, claim-verification policy, behavior envelope, behavior state, behavior strategy, response contract, synthesis requirement, and clarification and with text bytes equal to the UTF-8 byte length of that entry's canonical logical identifier; and
- `reference_index_entry_count` and `reference_index_text_bytes`, with one entry for each RFC 001 provider-binding tuple using its six canonical string fields, authority/risk/sensitivity classification identifier, RFC 002 evaluator-capability tuple using kind and version, RFC 005 provider binding using its binding identifier plus six-field execution tuple, and RFC 006 phase/intent/risk/authority/outcome declaration. Text bytes equal the sum of the UTF-8 byte lengths of every named canonical string component in that entry.

An occurrence in two distinct retained entries is counted twice even when its string value is equal. Descriptor numeric fields, record ordinals, the next descriptor index, fixed per-kind aggregate counters, and Boolean presence flags are exact non-negative scalar values whose number is structurally derived from the bounded entries above; they are not assigned an implementation-dependent byte weight. Prior raw bytes, parsed trees, JCS buffers, member content text, allocator capacity, hash-table slack, object headers, and duplicate implementation caches are never part of this logical vector.

The numeric ceiling set must be fixed before this RFC advances to Planned. An implementation must not treat a Draft gate as unbounded, publish private defaults as contract `0.1`, or claim conformance before the values are accepted. Smaller caller or package-declared limits may narrow an accepted capability only where RFC 001 or RFC 002 explicitly permits them.

Between members, one branch must not retain a prior member's raw bytes, source text, complete parsed JSON tree, or JCS regeneration buffer. It may retain only the bounded compact state named above. An explicitly cloned branch duplicates only that bounded compact state in caller-owned memory; the number of concurrent caller branches is not hidden Hees state. This contract reduces one branch's parse high-water mark from a whole-package tree to at most one bounded manifest or member tree plus compact state.

Physical heap bytes, RSS, allocator behavior, index representation cost, model coexistence, reload latency, thermal behavior, and total caller-created branch memory are deployment measurements, not public admission criteria. A conforming runtime must handle every package inside the accepted contract's semantic ceilings and must not introduce a device-local memory rejection reason. Representative real-corpus and real-device evidence remains required before claiming a deployment envelope.

Hees accepts raw manifest and member bytes only. Compression, archives, decompression, decryption, remote fetching, storage lookup, and multipart assembly must finish outside the admission boundary. No streaming guarantee is implied within a member.

### Runtime member reload integrity

An accepted package must retain trusted manifest identity, the ordered closed descriptor table, and a bounded lookup that maps admitted logical identities to descriptor and record ordinals. It must not trust a mutable external store to preserve those bytes.

When later resolution requires member content, the caller may supply raw bytes for the descriptor selected from the accepted package's trusted lookup. Before exposing any content, Hees must re-enforce the member byte ceiling, exact admitted byte length and digest, duplicate-aware I-JSON parse, closed kind schema, self-description match, record-count match, JCS byte equality, and requested record ordinal/identifier match. Expected identity must come only from the accepted descriptor; a caller-supplied replacement descriptor, digest, path, or metadata cannot override it.

Cross-member invariants need not be recomputed after exact reload because the bytes must match a descriptor already validated under the accepted manifest and the accepted compact lookup preserves the admitted identity relationships. A mismatch must fail closed without mutating the accepted package or replacing its descriptor. Where bytes are stored, whether they are cached, and whether an application uses files, a database, memory mapping, or another source remain outside Hees.

### Descriptor separation

The current `PackageLoaderDescriptor` and `PackageLoaderValidation` remain Hees 0.0.1 descriptor-shape surfaces and are not manifest member descriptors. Their validation checks declared loader metadata only. It must never imply that manifest or member bytes exist, a digest matches, schemas parse, references resolve, members are ordered, or a package is admitted.

A loader may locate bytes outside Hees, but artifact admission starts from raw manifest bytes plus external expected manifest digest and continues with raw next-member bytes only. No loader descriptor, path, or transport record may substitute for the trusted manifest descriptor table.

### Migration and member reuse

Hees must never mutate or migrate submitted or admitted bytes. Any changed member bytes, member digest, descriptor field, descriptor order, manifest field, capability content, identifier, version, Unicode sequence, or package revision creates new canonical manifest bytes and a new manifest digest. A package producer replacing a package revision must assign a new canonical package revision whenever any such governed content changes.

Unchanged package-relative members may be reused byte-for-byte by exact member digest in another manifest. Reuse does not carry package identity with the member; the new manifest independently commits to its descriptor, order, and inherited package identity. A changed package revision alone changes the manifest bytes and digest even when every member is reused.

Contract and digest agility require new exact versions. Hees must not negotiate algorithms, accept multiple digest syntaxes under contract `0.1`, silently migrate member schemas, or reinterpret admitted bytes.

### Identity, integrity, and authenticity

The verified manifest digest establishes deterministic identity for the exact canonical manifest and transitively committed member set, descriptors, and order. Per-member digests detect member substitution relative to that manifest. Runtime reload checks preserve that identity against mutable storage.

These digests do not authenticate the caller, producer, author, reviewer, publisher, storage system, or transport. They do not prove source rights, semantic correctness, policy suitability, or executable provenance. Authenticity requires a separately verified signature or attestation contract over the manifest artifact identity and remains outside core package admission.

## Design details

### Admission result and receipt boundary

While admission is pending, there is no public package-admission result. A terminal rejection contains only rejection terminal state plus one Hees-owned stage/reason pair and no manifest identity, descriptor, member identifier, input hash, path, parser text, or provisional index. A terminal acceptance contains the complete trusted `package_id`, `domain_id`, `package_revision`, `artifact_digest`, ordered descriptors, and bounded lookup identity established at atomic finish.

RFC 004 exclusively owns the private redacted receipt-body projection, canonical envelope, receipt identifier, and public integrity verification. Pending state cannot be projected. Successful finish may atomically return the accepted result and accepted package receipt. A terminal failure may atomically return the minimal rejected result and corresponding minimal rejection receipt, but no partial result or receipt exists before that terminal transition.

### Compatibility evidence

JavaScript, Rust, and Incan paths must consume common golden manifest/member fixtures and agree on manifest bytes, manifest digest, descriptor order, member bytes, member digests, combined logical order, inherited package identity, compact lookup identity, and the exact public reason.

Golden package fixtures must cover the minimal actions-plus-empty-evidence package; multiple evidence shards; governed-memory registry plus multiple atom shards; constraints with and without governed memory; claim verification with its required memory and constraint dependencies; behavior envelopes with and without a response contract; every one of the 15 legal optional-member topologies; descriptor and item order changes; package-fingerprint mapping; unchanged member reuse in a changed manifest; and atomic RFC 004 eligibility only after finish. Fixtures must use fictional source-safe content.

Negative sequencing fixtures must cover early finish, extra bytes, repeated bytes before completion, a later member supplied early, arbitrary digest mismatch, length mismatch, duplicate member digest, invalid topology, registry without atoms, atoms without registry, claim verification without governed memory or constraints, response without behavior, every optional singleton out of order, and empty non-sole evidence shards. Branch fixtures must cover a retained predecessor used after a sibling fails, replay and out-of-order detection within each branch, bounded compact-state cloning, and multiple successful branches producing identical package identity without a native session registry. Isolated manifest fixtures must separately reach descriptor multiplicity, evidence emptiness, combined descriptor-count overflow and lower-ceiling breach, each optional-member dependency, and otherwise-valid dependency/order failures. Runtime reload fixtures must replace, truncate, reorder, and mutate externally stored member bytes and prove that accepted identity remains unchanged and no content resolves from a mismatch.

Parser-differential fixtures must cover manifest and member duplicate names before object mapping, escaped duplicate names, invalid UTF-8, byte-order marks, lone surrogates, Unicode normalization pairs, noncanonical escaping, object-property order, preserved array order, trailing data, fractions, exponents, negative zero, safe-integer boundaries, unknown fields, unsupported kinds and contracts, malformed digests and lengths, count mismatches, broken local and cross-member references, support-namespace collisions, evidence rights/review failures, recognized ineligible RFC 001 atom states that remain structurally admitted, unknown atom state enums, duplicate identity-bearing declarations, cumulative retained-limit failures, and JCS mismatches.

Every public reason must have one isolated reachable fixture, and multi-failure fixtures must prove stage, within-stage, descriptor-index, and parser-subclassification precedence. Rejection fixtures must prove all-or-nothing identity: no manifest field, member field, provisional logical identifier, or input-derived hash enters a rejected result or RFC 004 receipt.

Constrained-device evidence must separately report peak manifest parse memory, peak per-kind member parse memory, compact inter-member state growth, accepted lookup state, reload high-water mark, and total runtime coexistence with representative consumers. Evidence that member-at-a-time parsing lowers parse high-water mark is directional support for this design, not proof of final numeric ceilings or production-corpus retained memory.

## Alternatives considered

### Keep one monolithic canonical package object

Rejected because the complete package must then be parsed and re-canonicalized as one value, coupling package growth and memory sharding to a whole-package high-water mark. An ordered canonical manifest preserves one package identity while allowing independently bounded member admission and reload.

### Allow arbitrary member kinds or arbitrary shard order

Rejected because runtimes could disagree about combined list order, presence dependencies, reference timing, and what an older runtime may ignore. The initial contract uses one closed topology and exact kind grammar.

### Put paths or locators in manifest descriptors

Rejected because location is mutable transport state, not package identity, and would couple Hees to filesystem, URL, storage, and traversal policy. Callers locate bytes outside Hees and submit raw bytes against trusted descriptors.

### Put the manifest or member digest inside the bytes it hashes

Rejected because whole-value self-digests are circular. The manifest digest remains external, while member digests and lengths live only in the parent manifest descriptor.

### Define a Hees-specific binary encoding

Rejected because RFC 8785 already supplies deterministic canonical JSON on an interoperable I-JSON base. A custom encoding would add parser, tooling, and cross-language risk without improving the authority boundary.

### Hash a parsed or normalized value

Rejected because parser and normalization choices can differ. Contract `0.1` hashes exact bounded bytes, then separately proves those bytes are valid canonical representations.

### Accept compressed, archived, or encrypted members

Rejected because decompression, archive traversal, and decryption create separate resource, ambiguity, and key-management boundaries. Transport must produce raw member bytes before Hees admission.

### Promise streaming within a member

Rejected because duplicate-aware parsing, closed-schema checks, cross-reference validation, and JCS regeneration do not yet have a portable bounded streaming contract. Members are independently bounded, but one member may require a complete parsed value.

### Retain every accepted member tree or byte sequence

Rejected because that would surrender the admission-memory benefit and make mutable storage integrity implicit. The accepted package retains compact trusted identity and revalidates bounded member bytes on resolution.

### Choose conservative numeric ceilings without measurements

Rejected because arbitrary values could reject legitimate mobile packages or allow avoidable allocation pressure. The compatibility dimensions are fixed now; their exact shared values remain an explicit Draft gate backed by representative measurement.

## Drawbacks

The manifest/member contract adds one digest and canonicalization operation per member, more sequencing states, and more golden fixtures than a monolith. Producers must compute exact lengths and counts before manifest construction, and callers must supply members in one strict order. Runtime reload trades retained content memory for repeated bounded digest, parse, schema, and JCS work. Compact descriptor and logical-index state still grows with package structure, so sharding alone cannot guarantee small retained memory. One large member can still create a high parse peak because this RFC makes no within-member streaming promise. Strict schemas and reason vocabularies require new contract versions for extensions, and lifecycle advancement remains blocked until exact ceilings and representative real-corpus retained-memory behavior are established.

## Layers affected

- **Public contract:** Root-manifest submission, opaque pending state, next-member transition, atomic finish, terminal result, trusted descriptor, reload, stage, and reason types.
- **Package schema:** Closed manifest descriptors, member topology, common member self-description, and actions/evidence/memory/constraints/verification/behavior/response member schemas.
- **Runtime validation:** Bounded exact-byte hashing, duplicate-aware parsing, schema/reference checks, JCS regeneration, branch-local sequential transitions, compact provisional state, and all-or-nothing completion.
- **Runtime resolution:** Trusted descriptor lookup and storage-neutral revalidation before member content is exposed.
- **Compatibility:** Exact package/member contracts, combined shard order, migration, reuse, reason precedence, and failure behavior across runtimes.
- **Tests and documentation:** Shared golden packages, parser differentials, sequencing and replay cases, mutable-store reload cases, and constrained-device memory evidence.

## Design Decisions

- RFC 8785 JCS over RFC 7493 I-JSON and RFC 8259 JSON is the only canonical representation for the manifest and every member in contract `0.1`.
- The root manifest is the package artifact. Its external SHA-256 digest is `artifact_digest`, and RFC 001/002 package fingerprints are exactly its unprefixed suffix.
- The manifest transitively commits to a closed ordered member set through exact unique descriptors and never contains its own digest.
- Descriptors contain member identifier, kind, contract, digest, byte length, and semantic record count only; they contain no path, locator, compression, archive, fetch, or metadata field.
- Members repeat only the descriptor's non-circular self-description fields, omit digest/length and containing package identity, and inherit package identity only after atomic completion.
- The exact kind grammar is `actions evidence+ (governed_memory_registry governed_memory_atoms+)? constraints? claim_verification? behavior_envelope? response_contract?`, with claim verification dependent on governed memory plus constraints and response dependent on behavior; these rules admit exactly 15 optional-member topologies.
- Evidence and governed-memory atom shards form logical lists by stable concatenation in descriptor order; item and descriptor order are both identity-bearing.
- Evidence and governed-memory identifiers are disjoint in contract `0.1` because RFC 002's support identifiers are not yet typed by namespace.
- RFC 003 imports RFC 001/002/005/006/007 payload schemas without redefining them: those RFCs own exact nested key, type, enum, omission, and runtime semantics, while RFC 003 owns wrappers, sharding, canonicalization, sequencing, and composition.
- Recognized RFC 001 atom review and runtime-rights states survive structural package admission; RFC 001 owns runtime nomination eligibility, while RFC 003 continues to own evidence deployability.
- Admission is an opaque branch-safe sequential value contract. A terminal result has no successor, retaining or cloning a predecessor creates an independently bounded sibling branch, and only successful finish creates an accepted package.
- Missing, extra, replayed, and out-of-order members have exact fail-closed behavior and stable public reasons.
- Between members, Hees retains bounded compact descriptors, indexes, counters, and small scalars, never prior raw member bytes or parsed member trees.
- Member-at-a-time validation bounds parse high-water direction but does not prove total retained runtime memory, final ceilings, or production device suitability.
- Accepted package resolution rechecks caller-supplied bytes against the trusted descriptor and never lets mutable storage replace admitted identity.
- Compression, archives, fetching, storage layout, memory mapping, and transport remain outside Hees; no within-member streaming guarantee is made.
- Changed governed content requires a new package revision and manifest digest, while unchanged package-relative members may be reused by exact digest.
- Public reasons are closed, globally unique within the package receipt namespace, and selected by fixed stage, within-stage, descriptor-index, and parser precedence.
- The three new optional members join artifact contract `0.1` while every coupled RFC remains Draft; no accepted artifact contract is reinterpreted and adding another kind later requires a new exact contract version.
- Manifest and member digests establish deterministic identity and integrity, not producer authenticity, policy quality, source rights, or executable provenance.

## Unresolved questions

- What exact shared numeric values should contract `0.1` assign to every manifest, per-kind member, total-package, parser, record, nested-collection, identifier/text, and compact retained-state ceiling after representative constrained-device measurement?
- Do representative real packages confirm that compact descriptor/index retention and descriptor-verified member reload keep total retained runtime memory and reload high-water marks within the intended device envelope when the package coexists with its consumers?

<!-- Rename this section to "Design Decisions" once all questions have been resolved.
     An RFC cannot move from Draft to Planned until no unresolved questions remain. -->
