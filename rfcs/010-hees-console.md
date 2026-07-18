# RFC 010: Hees Console

- **Status:** Draft
- **Created:** 2026-07-18
- **Author(s):** Encero Systems
- **Related:**
    - RFC 000 (Foundational Governance Authority)
    - RFC 001 (Spectrum Terminal Adjudication)
    - RFC 002 (Content DNA Answer-Time Provenance)
    - RFC 003 (Governed Memory and Retrieval Results)
    - RFC 004 (Composable Governance Constraints)
    - RFC 005 (Canonical Package Artifact Admission)
    - RFC 006 (Export-Safe Governance Receipts)
    - RFC 007 (Evidence-Grounded Claim Verification Findings)
    - RFC 008 (Governed Behavior Envelopes)
    - RFC 009 (Governed Visible Response Lifecycle)
- **Issue:** https://github.com/encero-systems/hees.ai/issues/14
- **RFC PR:** —
- **Written against:** Hees 0.0.1 / Incan 0.4.0
- **Shipped in:** —

## Summary

Hees should provide a permanent terminal-first developer product named Hees Console for running and inspecting one governed AI interaction. The Console must load canonical reviewed memory from a fictional package, keep model proposals and evaluator observations visibly untrusted, and execute one bounded versioned `console_profile_0_1` Spectrum operation inside an Incan-authored Hees runner. Hees alone may classify observations under package policy, choose the terminal decision and selected memory, construct experimental `console_content_dna_0_1`, and emit `console_profile_receipt_0_1`. Offline replay must rerun the same operation, optional live GPT-5.6 must remain a narrow provider boundary, and the first release must not claim conformance to the complete Draft contracts in RFC 001–009.

## Core model

1. **The Console is a permanent product.** The first public release is a time-bounded release of Hees Console, not a parallel demonstration architecture or disposable event branch.
2. **GPT-5.6 proposes. Hees decides.** A model may generate visible response candidates and bounded relation and synthesis observations. Optional GPT atom candidates are comparison material only; canonical reviewed atoms already belong to the package. A model cannot return the terminal action, selected memory, provenance, or receipt.
3. **The first profile is deliberately narrow.** `console_profile_0_1` is one deterministic bounded Spectrum operation over a wholly fictional lesson-support package. It is not the complete RFC 001 Spectrum, RFC 002 Content DNA, governed-memory, constraint, package-artifact, receipt, verifier, behavior, or response-lifecycle design.
4. **The presentation host is not an authority.** External code may call providers, run the compiled Hees process, render terminal views, package the application, and manage secrets or hosted sessions. It must not duplicate, repair, reinterpret, or override a Hees decision.
5. **Replay reruns the decision.** Offline replay stores only neutral deterministic fixture values and integrity metadata. Every run resubmits those values to the compiled Incan-authored profile; no replay may contain or reuse a stored terminal result, and no fixture may be described as recorded provider output without separately bound live-canary evidence.
6. **Live use is explicit and optional.** Live mode uses an exact model, API, structured-output schema, and secret surface. Missing credentials or provider failure must remain visible and fail closed rather than silently becoming replay or an invented decision.
7. **Terminal provenance is Hees-owned.** After admission, Hees freezes every and only the terminal selected memory, constructs experimental `console_content_dna_0_1`, and projects the profile-specific `console_profile_receipt_0_1`. Neither artifact may be supplied by a model, fixture, host, or caller.
8. **The judge path is prebuilt.** The released executable must run offline without Incan, Python, a package manager, a source checkout, or an API key. A hosted session must invoke the same frozen product without exposing an unrestricted shell.
9. **Inspection does not become response authority.** The Console may show rejected or untrusted model prose in a clearly marked developer-inspection view, but only admitted units may appear in the trusted answer view or any downstream response surface.
10. **The release boundary is public-safe.** Shipped fixtures are original and fictional. Private content, client material, research artifacts, local paths, credentials, downloaded models, and unrelated product code are forbidden.

## Motivation

Hees 0.0.1 proves a small structural boundary: a caller supplies an in-memory package and an untrusted proposal, and Hees checks package validity, identity, visible output, declared action, and evidence references. That kernel is intentionally not a product experience. A developer cannot yet run a provider, inspect a complete untrusted bundle, compare live and replay behavior, observe non-authoritative findings, or test the compiled decision path without assembling source components.

The broader Draft RFC series defines a stronger target with Spectrum finality, selected governed memory, Content DNA, semantic findings, deterministic behavior, visible-response governance, and export-safe receipts. Presenting all of that as implemented would be false. Conversely, building a host-only demonstration that chooses the result in presentation code would obscure the authority model the Console is meant to expose.

Hees Console therefore needs its own permanent product contract and one honest first profile. The profile can make the central boundary directly judgeable now while retaining exact names, versions, failure reasons, non-claims, and migration rules for later RFC-conforming profiles.

## Goals

- Define Hees Console as a permanent public developer product with a stable authority and packaging boundary.
- Define the exact scope and contract identifiers of `console_profile_0_1`.
- Keep all terminal decisions, selected memory, experimental Console Content DNA, and receipt projection inside the compiled Incan-authored Hees runner.
- Define strict package-memory, untrusted proposal, support-mapping, observation, finding, runner-request, runner-response, replay, trace, Content DNA, and receipt contracts for the first profile.
- Define deterministic admission stages, a closed public reason namespace, and exact failure precedence.
- Make offline replay the zero-credential default while requiring every replay to rerun the real Hees decision path.
- Define optional live GPT-5.6 operation without making the provider or presentation host authoritative.
- Require a self-contained prebuilt executable and a restricted hosted test path that do not require rebuilding Incan.
- Define the required terminal views, keyboard contract, escaping, trust labels, and live-versus-replay disclosure.
- Establish exact non-claims relative to RFC 000–009 and the checked Hees 0.0.1 public API.
- Define public-safety, licensing, provenance, platform, and judge acceptance evidence for release.

## Non-Goals

- Claiming that `console_profile_0_1` implements the complete RFC 001 Spectrum contract or its seven RFC 009 terminal variants.
- Claiming that experimental `console_content_dna_0_1` establishes complete RFC 002 conformance or that `console_profile_receipt_0_1` is compatible or conforming with RFC 006.
- Implementing the complete RFC 003 retrieval, RFC 004 constraint, RFC 005 package-artifact, RFC 007 verification, RFC 008 behavior-selection, or RFC 009 repair and clarification surfaces.
- Building a general source-ingestion, corpus-management, package-authoring, human-review, deployment-management, or model-training product.
- Treating structured model evaluation as model-weight training, human review, legal rights review, unrestricted truth, or calibrated proof.
- Proving source ownership, licensing, factual correctness, universal semantic support, producer authenticity, or remote attestation.
- Shipping a model, embedding index, private package, client content, research benchmark, raw corpus, hidden prompt, chain-of-thought, credential, personal path, or unrestricted source locator.
- Defining a general-purpose provider SDK, terminal framework, subprocess library, container platform, or hosted-shell service.
- Requiring a network, provider credential, or live model call for the default judge experience.
- Silently changing the Hees library version when releasing the separately versioned Console product.

## Guide-level explanation

A developer starts the released `hees-console` executable. With no credential or flags, it opens in visibly labelled replay mode and offers three fictional scenarios: a valid declared-action proposal, an undeclared-action proposal, and a proposal that references unknown evidence or non-admitted memory. Running a scenario verifies the replay envelope and submits its neutral deterministic proposal and observation fixtures to the embedded compiled Hees runner. The replay does not contain a decision, finding classification, selected-memory set, Content DNA, or receipt.

The Console shows the package and source summary, optional untrusted atom candidates beside canonical package-authored atoms, the exact untrusted proposal and identifier-only support mappings, bounded relation and synthesis observations, Hees-classified non-authoritative findings, the limited operation's normalized policy effects, and then a large `ADMITTED` or `REJECTED` result with its reason namespace and reason. An admitted result exposes selected memory, experimental Console Content DNA, and the profile-specific receipt. A separately labelled non-authoritative trace carries build, provider, replay, observation, and finding metadata. A rejected candidate remains available only in an escaped `UNTRUSTED PROPOSAL` inspection view and is never rendered as the trusted answer.

When an operator deliberately selects live mode and supplies `OPENAI_API_KEY`, the host calls the Responses API with explicit `gpt-5.6-sol` structured-output contracts. The same runner validates and decides the resulting bundle. If the provider times out, refuses, returns malformed output, or omits a required observation, the Console shows the exact fail-closed Hees result or a typed pre-decision failure; it must not silently use replay data while retaining a live label.

The first profile is shown as `LIMITED SPECTRUM OPERATION — console_profile_0_1`. That label means the Incan-authored operation is the sole terminal authority for this release. It does not mean the complete RFC 001 Spectrum, RFC 002 Content DNA, RFC 006 receipt, RFC 008 behavior, or RFC 009 response-lifecycle contract is implemented. Serialized JSON values cannot substitute for the direct capabilities created and consumed inside that operation. Later Console releases may adopt the complete contracts only through explicit profile and artifact-version transitions.

## Reference-level explanation

### Product identity, versions, and release line

The public product name must be `Hees Console`, and the installed launch command must be `hees-console`. The Console has its own semantic version independent from the Hees library. The first product release is `Hees Console 0.1.0` and uses release tag `hees-console-v0.1.0`; it must not change the Hees library's checked `0.0.1` version merely because both live in one repository.

The first decision profile identifier is exactly `console_profile_0_1`. The first release contract family uses these exact identifiers:

| Surface | Contract identifier |
| --- | --- |
| Fictional package | `console_package_0_1` |
| Optional atom comparison candidate | `console_atom_candidate_0_1` |
| Model proposal | `console_proposal_0_1` |
| Relation observation | `console_relation_observation_0_1` |
| Synthesis observation | `console_synthesis_observation_0_1` |
| Hees-classified finding | `console_finding_0_1` |
| Runner request | `console_runner_request_0_1` |
| Runner response | `console_runner_response_0_1` |
| Replay envelope | `console_replay_0_1` |
| Non-authoritative execution trace | `console_trace_0_1` |
| Experimental Console Content DNA | `console_content_dna_0_1` |
| Profile-specific Console receipt | `console_profile_receipt_0_1` |
| Terminal reason namespace | `console_admission_0_1` |

An implementation must not accept aliases, nearby versions, missing versions, or unknown extension fields. A material field, state, reason, ordering, canonicalization, or authority change requires a new exact contract or profile identifier.

The release artifact must identify the Console version, profile identifier, Hees source revision, Incan toolchain version, runner digest, schema digests, fixture or live-provider mode, and supported platform. Release assets must carry hashes, build provenance, dependency-license material, and supported-platform instructions.

### Authority and process boundary

The Console is one product with two implementation ownership domains:

| Surface | Owner | Permitted authority |
| --- | --- | --- |
| Fictional sources and package declarations | Shipped Console fixture | Input declarations only; cannot supply a terminal result. |
| Provider calls and normalized response capture | Presentation host | Optional comparison candidates, untrusted proposals, and bounded observations only. |
| Package, admitted memory, proposal, support, manifest, observation, finding, policy, selected-memory, Content DNA, receipt, and terminal contracts | Incan-authored Hees runner | Validation, classification, deterministic policy, and terminal authority. |
| `console_profile_0_1` | Incan-authored Hees runner | Sole admission or rejection authority for the first release. |
| Terminal views, keyboard input, subprocess lifecycle, packaging, secret access, and hosted-session controls | Presentation host | Presentation and platform behavior only. |
| Replay envelope | Shipped Console fixture | Integrity-checked neutral deterministic input only; never a stored Hees result or an unproven provider recording. |

The host must invoke the runner through one bounded request and response protocol. It may reject unsafe bytes before invoking the runner, but it must not convert that host rejection into a fabricated Hees decision. It must not implement a parallel package validator, action policy, evidence or memory policy, observation classifier, finding policy, selected-memory algorithm, Content DNA constructor, receipt constructor, or fallback terminal decision. It must not serialize or reconstruct an opaque Hees capability; direct capabilities are created and consumed only inside one runner invocation.

The runner response is the only source for `ADMITTED` or `REJECTED`. The host may verify response schema and integrity before display, but it may not change the decision, public reason, selected-memory order, Content DNA artifact, or receipt. An invalid runner response is a typed host failure and must not be displayed as a Hees rejection.

### Fictional sources and canonical package atoms

The first profile must operate only over a small original fictional lesson-support fixture. Each source declaration must contain a canonical source reference, source kind, SHA-256 source fingerprint, language identifier, explicit fictional-use rights state, and bounded source text. The release must not infer a legal rights claim from availability or model output.

The package artifact under `console_package_0_1` must contain exactly `contract_version`, `profile_id`, `package_id`, `domain_id`, `package_revision`, `artifact_digest`, `mission`, `sources`, `actions`, `requirements`, `atoms`, and `policy`. `contract_version` must equal `console_package_0_1`, and `profile_id` must equal `console_profile_0_1`. `artifact_digest` must be `sha256:` followed by the lowercase SHA-256 digest of an RFC 8785 JCS artifact projection that removes the top-level `artifact_digest` and each atom's derived `provenance_digest` while preserving every other field and array order. The mission must be a bounded non-empty package-authored string.

Each source must contain exactly `source_id`, `source_ref`, `source_kind`, `source_fingerprint`, `language`, `rights_state`, and `text`. `source_fingerprint` is the lowercase `sha256:` digest of the exact UTF-8 bytes of `text`, and `rights_state` must equal `fictional_use_allowed`. Each action must contain exactly `action_id` and `evidence_required`. Each requirement must contain exactly `requirement_id` and `description`. Source, action, requirement, memory, and evidence identifiers must be safe, ordered, and unique within their typed namespaces.

Each atom must contain exactly `memory_id`, `evidence_id`, `source_id`, `source_ref`, `source_kind`, `source_fingerprint`, `source_span`, `claim`, `guidance`, `language`, `review_state`, `review_revision`, `rights_state`, `authority_class`, `evidence_kind`, and `provenance_digest`. `source_span` must contain exactly `start_utf8_byte` and `end_utf8_byte`, select a non-empty UTF-8-aligned byte range inside the bound source text, and bind the claim to that source range. `source_id`, source identity, fingerprint, and language must match the containing package source. `review_state` is exactly `approved`, `pending`, or `rejected`; `rights_state` is exactly `allowed` or `denied`. Only an atom with approved review, allowed rights, valid source binding, and valid provenance enters the admitted-memory context. The package carries no provider-supplied or precomputed admitted-memory list.

An atom `provenance_digest` must be the lowercase `sha256:` digest of the RFC 8785 JCS object containing `package`, whose exact members are `package_id`, `domain_id`, `package_revision`, and `artifact_digest`, plus `entry`, whose exact members are `memory_id`, `source_ref`, `source_kind`, `source_fingerprint`, `review_state`, `review_revision`, `rights_state`, `authority_class`, and `evidence_kind`. The artifact digest is computed first from the projection that omits derived provenance; atom provenance is computed second and inserted without changing the artifact identity. This package-bound digest is copied unchanged into terminal Content DNA for a selected atom. It is a profile-specific fixture identity, not an RFC 005 admission capability or proof of source ownership.

The fictional package must ship canonical reviewed, rights-allowed atoms independently from every provider call and at least one package-authored pending, rejected, or rights-denied record for fail-closed tests. Each atom must have one distinct `memory_id` and one distinct `evidence_id` plus the exact source, review, rights, authority, evidence-kind, and provenance fields defined above. Package validation is the only way eligible atoms enter the admitted-memory context; an ineligible package record remains addressable for adversarial testing but never becomes admitted memory. A provider cannot add, remove, rewrite, review, license, or admit package memory.

An optional untrusted comparison candidate under `console_atom_candidate_0_1` must contain exactly:

- `contract_version`, exactly `console_atom_candidate_0_1`;
- `profile_id`;
- `package_id`;
- `domain_id`;
- `source_ref`;
- `source_fingerprint`;
- `claim`;
- `guidance`;
- `language`; and
- `candidate_digest`.

The candidate must not contain a trusted memory or evidence identifier, review state, review revision, rights state, authority class, evidence kind, provenance digest, admission state, terminal action, selected-memory state, Content DNA, receipt data, arbitrary metadata, or hidden reasoning. Hees may compare its exact source binding, text fields, language, and digest with a canonical atom and return a non-authoritative match or mismatch record for display. A match does not create memory or strengthen its authority, and a mismatch does not mutate the package or affect terminal selection.

`candidate_digest` must be `sha256:` followed by the lowercase SHA-256 digest of the RFC 8785 JCS candidate object after removing only `candidate_digest`. The digest establishes normalized candidate integrity; it does not establish provider provenance, review, rights, or package membership.

The terminal path therefore never depends on an atom-candidate provider. If an optional candidate is absent, refused, malformed, or mismatched, the Console may show that comparison as unavailable or mismatched, but the canonical package and admitted-memory context remain unchanged.

### Strict model proposal and the sole answer channel

An untrusted proposal under `console_proposal_0_1` must contain exactly:

- `contract_version`, exactly `console_proposal_0_1`;
- `profile_id`;
- `package_id`;
- `domain_id`;
- `request_id`;
- `proposal_id`;
- `action_id`;
- `evidence_ids`;
- `visible_units`; and
- `support_mappings`.

Each visible unit must contain exactly `unit_id`, `text`, and `requirement_ids`. The visible-unit array must be non-empty, every unit identifier must be unique, every unit text must contain a non-whitespace scalar value, and requirement identifiers must resolve in the fixed profile. Evidence identifiers must be ordered and duplicate-free.

Each support mapping must contain exactly `support_claim_id`, `unit_id`, one `memory_id`, and optional typed `evidence_ids`. The first profile requires exactly one mapping per visible unit. Every mapped evidence identifier must occur in the proposal's top-level evidence array, and the mapped memory identifier must resolve in the package-created admitted-memory context. Evidence identifiers and memory identifiers are different typed namespaces and cannot substitute for one another. The support claim text is derived inside Hees as the exact visible-unit text; the provider cannot supply or rewrite it.

The ordered visible-unit texts are the sole model-generated answer channel. The adapter to the checked Hees 0.0.1 `ModelProposal` must derive its one `visible_output` string by joining exact unit texts with one line-feed scalar and must copy the ordered evidence identifiers unchanged. After closed-schema validation, Hees computes `candidate_digest` over the exact RFC 8785 JCS normalized proposal and support-mapping value for verifier binding; a provider cannot supply or override that digest. The model must not supply a second visible-output string, support prose, uncertainty prose, admission field, terminal action, selected-memory list, Content DNA, receipt, policy, free-form rationale, or hidden reasoning.

For every visible unit, the profile derives one atomic support claim whose text is exactly the unit text and whose cited premise is exactly the one admitted memory entry named by its support mapping. A provider cannot independently rewrite, expand, translate, or improve that support claim.

### Verifier manifest, observations, and findings

After package validation creates the admitted-memory context and Hees validates the proposal and support mappings, Hees must derive one complete verifier manifest. The first profile requires:

- one evidence-relation target for each visible unit against the complete ordered admitted-memory union;
- one evidence-relation target for each derived support claim against exactly the one admitted memory entry named by its support mapping;
- one contradiction-cross-check target for the complete ordered visible response against the complete ordered admitted-memory union;
- one synthesis target for the complete ordered visible response against the request; and
- one synthesis target for the complete ordered visible response against each package-declared lesson-support requirement.

The manifest binds each target identifier to the profile, package, domain, request, candidate digest, evaluator role, target role, target digest, and ordered premise-memory identifiers. The host may send those exact targets to separate provider calls, but it may not add, remove, reorder, rewrite, or reinterpret them. Hees must rederive the manifest and require exact identity and complete coverage when observations return.

A provider relation result under `console_relation_observation_0_1` must contain exactly:

- `contract_version`, exactly `console_relation_observation_0_1`;
- `profile_id`;
- `observation_id`;
- `package_id`;
- `domain_id`;
- `request_id`;
- `candidate_digest`;
- `target_id`;
- `evaluator_role`, exactly `evidence_relation` or `contradiction_cross_check`;
- `target_role`, exactly `visible_unit_union`, `support_claim_memory`, or `proposal_union`;
- `support_bps`;
- `contradiction_bps`;
- `unresolved_bps`;
- `model_fingerprint`;
- `prompt_fingerprint`; and
- `configuration_fingerprint`.

The three relation scores must be exact integers from zero through ten thousand and must sum to exactly ten thousand. A provider synthesis result under `console_synthesis_observation_0_1` must contain exactly:

- `contract_version`, exactly `console_synthesis_observation_0_1`;
- `profile_id`;
- `observation_id`;
- `package_id`;
- `domain_id`;
- `request_id`;
- `candidate_digest`;
- `target_id`;
- `evaluator_role`, exactly `synthesis_coverage`;
- `target_role`, exactly `request_coverage` or `requirement_coverage`;
- `covered_bps`;
- `gap_bps`;
- `unresolved_bps`;
- `model_fingerprint`;
- `prompt_fingerprint`; and
- `configuration_fingerprint`.

The three synthesis scores must also be exact integers from zero through ten thousand and sum to exactly ten thousand. Neither observation contract has an authoritative status, action, policy, answer, source text, rationale, selected memory, Content DNA, receipt data, raw response metadata, or hidden reasoning.

The fictional package owns a closed profile policy with exactly `constraint_plan_id`, `constraint_plan_revision`, `response_contract_id`, `response_contract_revision`, `min_support_bps`, `max_contradiction_bps`, `max_relation_unresolved_bps`, `min_coverage_bps`, `max_gap_bps`, and `max_synthesis_unresolved_bps`. For `console_profile_0_1`, the numeric thresholds are frozen respectively at 6500, 3500, 2500, 6500, 3500, and 2500 basis points. Hees classifies a relation observation in this precedence: `contradicted` when `contradiction_bps` exceeds `max_contradiction_bps`; `uncertain` when `unresolved_bps` exceeds `max_relation_unresolved_bps`; `supported` when `support_bps` meets or exceeds `min_support_bps`; otherwise `unsupported`. Hees classifies a synthesis observation in this precedence: `not_covered` when `gap_bps` exceeds `max_gap_bps`; `uncertain` when `unresolved_bps` exceeds `max_synthesis_unresolved_bps`; `covered` when `covered_bps` meets or exceeds `min_coverage_bps`; otherwise `not_covered`.

Hees emits one non-authoritative `console_finding_0_1` for every classified observation. Each finding must contain exactly `contract_version`, equal to `console_finding_0_1`; `profile_id`; `finding_id`; `observation_id`; `package_id`; `domain_id`; `request_id`; `candidate_digest`; `target_id`; `evaluator_role`; `target_role`; `classification`; `constraint_plan_id`; and `constraint_plan_revision`. A relation classification is exactly `supported`, `contradicted`, `uncertain`, or `unsupported`; a synthesis classification is exactly `covered`, `not_covered`, or `uncertain`. A finding cannot choose the terminal result. The bounded Spectrum operation consumes the complete finding set and package policy after classification; no majority vote, provider wording, call order, host code, or provider-supplied enum may choose the terminal result.

Missing, duplicate, unexpected, malformed, identity-mismatched, refused, timed-out, or unavailable required observations must fail closed. The first profile has no model repair, clarification, escalation, or provider fallback path. A later profile may add one only through a new exact contract that coordinates RFC 001 and RFC 009.

### Runner request and terminal response

The host must submit one closed `console_runner_request_0_1` containing the profile identifier, mode, exact package artifact, request identity, normalized proposal-provider result, complete relation and synthesis observations, replay identity when applicable, and build and schema identities required for mismatch detection. Optional atom-comparison material is not part of this request. The request contains raw serializable inputs only; it cannot contain or stand in for an opaque admitted-memory, finding, Spectrum, selected-memory, Content DNA, or receipt capability. It must contain no API key, authorization header, prompt text, provider diagnostic, chain-of-thought, terminal escape sequence, local path, or stored decision.

Inside one runner invocation, Hees must validate the package, create the admitted-memory context, validate the proposal and typed support mappings, derive the verifier manifest, validate and classify observations under package policy, compose non-authoritative findings, invoke the bounded Spectrum operation, freeze terminal selected memory, construct experimental Content DNA, and project the profile-specific receipt. Direct capabilities created by those stages never cross the runner protocol and cannot be reconstructed from JSON.

The runner must enforce raw byte limits before parsing, closed schemas before semantic evaluation, and collection limits before proportional allocation. It must return one closed `console_runner_response_0_1` containing:

- `contract_version` and `profile_id`;
- trusted package, domain, and request identity where safely established;
- `decision`, exactly `admit` or `reject`;
- `reason_namespace`, exactly `console_admission_0_1`;
- one closed public `reason`;
- the checked Hees 0.0.1 structural reason when that stage was reached;
- admitted visible units only when `decision` is `admit`;
- ordered selected memory identifiers only when `decision` is `admit`;
- experimental Console Content DNA only when `decision` is `admit`; and
- the profile receipt when receipt projection succeeded.

A rejected runner response must not contain admitted visible units, selected memory identifiers, or Content DNA. The host already owns the untrusted provider bundle and may show it only in escaped inspection views; the runner must not echo rejected model prose as a trusted response.

### Deterministic stages and public reasons

The profile must choose exactly one public reason from namespace `console_admission_0_1`. All reasons except `admitted` map to `reject`. The fixed stage and within-stage precedence is the table order:

| Stage | Closed reasons in precedence order |
| --- | --- |
| 1. Raw request | `request_too_large`, `invalid_json` |
| 2. Runner request contract | `unsupported_request_contract`, `invalid_request_schema` |
| 3. Package and admitted memory | `package_unavailable`, `invalid_package`, `memory_context_invalid` |
| 4. Trusted identity | `request_id_invalid`, `package_id_mismatch`, `domain_id_mismatch` |
| 5. Proposal provider and contract | `proposal_provider_unavailable`, `unsupported_proposal_contract`, `invalid_proposal_schema`, `proposal_too_large` |
| 6. Visible units | `missing_visible_output`, `invalid_visible_unit` |
| 7. Declared action | `unknown_action` |
| 8. Evidence, support, and memory | `duplicate_evidence_reference`, `evidence_required`, `unknown_evidence`, `support_mapping_invalid`, `duplicate_memory_reference`, `unknown_memory`, `memory_not_admitted` |
| 9. Observation integrity and coverage | `unsupported_observation_contract`, `observation_identity_mismatch`, `observation_coverage_invalid`, `observation_malformed`, `observation_unavailable` |
| 10. Package finding policy | `support_not_established`, `contradiction_detected`, `synthesis_incomplete`, `finding_uncertain` |
| 11. Checked structural admission | `structural_admission_rejected` |
| 12. Terminal memory | `selected_memory_invalid` |
| 13. Experimental Content DNA | `content_dna_construction_failed` |
| 14. Receipt | `receipt_projection_failed` |
| 15. Admission | `admitted` |

The checked 0.0.1 structural admission must still run for every otherwise eligible proposal. The profile must record its exact stable reason separately. An unexpected structural rejection maps to `structural_admission_rejected`; the host must not reinterpret or bypass it. The profile may perform equivalent earlier checks to preserve its richer reason precedence, but the authoritative structural call remains mandatory.

Provider error wording, parser wording, score magnitude, model identity, object-property order, map iteration order, process timing, terminal size, and replay order must not select the public reason. Work skipped after an earlier terminal failure must not change the reason that a complete logical evaluation would select.

### Terminal selected memory and experimental Content DNA

On `admit`, Hees must freeze an ordered duplicate-free selected-memory set containing every and only the admitted memory entries referenced by the admitted support mappings. Every selected entry must remain source-bound, reviewed, rights-allowed, and part of the package-created admitted-memory context. An unreferenced admitted atom is not selected merely because it was available to the verifier; a reference to unknown or non-admitted memory prevents admission.

Experimental `console_content_dna_0_1` must be constructed inside the runner after the bounded Spectrum decision and selected-memory freeze. Its closed RFC 8785 JCS body must contain exactly:

- `contract_version`, exactly `console_content_dna_0_1`;
- `state`, exactly `admitted_answer`;
- `package`, containing exactly `package_id`, `domain_id`, `package_revision`, and `artifact_digest`;
- `proposal_id`;
- `spectrum_decision_id`;
- `terminal`;
- `policy`, containing exactly `constraint_plan_id`, `constraint_plan_revision`, `response_contract_id`, and `response_contract_revision`;
- `entries`;
- `source_digests`; and
- `answer_digest`.

The ordered `entries` array contains every and only terminal selected-memory entries. Each entry must contain exactly `memory_id`, `source_ref`, `source_kind`, `source_fingerprint`, `provenance_digest`, `review_state`, `review_revision`, `rights_state`, `authority_class`, and `evidence_kind`. `provenance_digest` is the lowercase `sha256:` digest of the exact RFC 8785 JCS projection containing those fields other than `provenance_digest` plus the exact containing package object. `source_digests` is the ordered duplicate-free first-use projection of selected source fingerprints. `answer_digest` is the lowercase `sha256:` digest over the canonical bytes of a closed answer-binding object containing the exact ordered visible units, including unit identifiers, text, and requirement identifiers, and no support, finding, provider, or presentation fields. The body contains no source text, claim text, guidance text, prompt text, provider output, evaluator rationale, local path, or credential.

The returned envelope contains exactly `body` and `content_dna_id`. `content_dna_id` must be `sha256:` followed by the lowercase SHA-256 digest of the exact canonical body bytes. `terminal` must contain exactly `decision`, `reason_namespace`, and `reason`, with values equal to the admitted terminal response; `policy` must name the exact package-owned constraint and response identities used by the bounded operation. If entry coverage, ordering, identity, canonicalization, or digest construction fails, the answer must not be admitted or exposed.

The artifact must be labelled `EXPERIMENTAL CONSOLE CONTENT DNA 0.1`. It exercises the complete RFC 002 admitted-answer field shape for this bounded profile, including package, Spectrum decision, policy, selected-memory provenance, source-digest, and answer bindings. It does not establish full RFC 002 conformance: the profile does not implement the complete RFC 001, RFC 005, or RFC 009 source contracts and does not exercise RFC 002's no-answer state because this profile has no clarification outcome. Any conforming adoption requires an explicit profile and artifact transition.

### Profile-specific receipt

The runner may privately construct one `console_profile_receipt_0_1` after the terminal decision only when package, domain, package revision, artifact, request, and proposal identity have been safely established. An earlier failure returns no receipt rather than copying untrusted identity into an authority record. The receipt envelope must contain exactly `body` and `receipt_id`.

Every receipt body must contain exactly `contract_version`, `profile_id`, `package_id`, `domain_id`, `package_revision`, `artifact_digest`, `request_id`, `proposal_id`, `decision`, `reason_namespace`, `reason`, and `structural_reason`, plus the admitted-only members defined below. `contract_version` must equal `console_profile_receipt_0_1`, `profile_id` must equal `console_profile_0_1`, `decision` must equal `admit` or `reject`, and `reason_namespace` must equal `console_admission_0_1`. `reason` is the exact closed public reason. `structural_reason` is the exact checked Hees 0.0.1 reason when that call was reached and is JSON `null` otherwise.

An admitted receipt body must additionally contain exactly `admitted_evidence_ids`, `selected_memory_ids`, and `content_dna_id`. A rejected receipt body must omit all three admitted-only members. The admitted arrays must be ordered and duplicate-free and must equal the terminal evidence and memory projections. The Content DNA identifier must equal the atomically returned admitted artifact.

The receipt identifier must be `sha256:` followed by the lowercase SHA-256 digest of the exact RFC 8785 JCS canonical body bytes. The body must not contain source text, claim or guidance text, visible answer text, prompt content, model or provider identity, build or toolchain identity, replay metadata, observation or finding details, policy-effect diagnostics, raw provider metadata, credential, chain-of-thought, local path, private environment value, wall-clock timestamp, arbitrary diagnostic, or terminal control sequence.

The receipt is a profile-specific terminal-governance record that borrows RFC 006's redaction and least-authority principles. It is not an RFC 006-compatible receipt because this profile lacks the direct RFC 001 and RFC 009 source contracts, and it must not be presented as RFC 006 contract `0.1`. It does not recreate an in-process authority, signature, attestation, or proof of truth. A future RFC 006-conforming Console profile requires a new exact version and must preserve the migration distinction.

If receipt projection fails, the runner must return a rejection with `receipt_projection_failed`; it must not expose an admitted answer first and attach a receipt later. A host-generated receipt is forbidden.

### Non-authoritative Console trace

`console_trace_0_1` is a separately labelled operator artifact. It may contain bounded Console build, Hees source, Incan toolchain, runner, and schema identities; mode and replay-envelope digest; provider, model, prompt, and configuration fingerprints; proposal and observation digests; finding identifiers; and bounded policy-effect codes. It must not contain answer or source prose, credentials, raw provider payloads, unrestricted rationale, or chain-of-thought.

The trace is not a receipt, decision capability, package member, policy input, or authority record. Trace construction occurs after the terminal response is fixed. If trace construction or display fails, the decision, selected memory, Content DNA, and profile receipt remain unchanged and the Console shows `TRACE UNAVAILABLE`; trace failure is not a terminal reason.

### Replay contract

Replay is the default mode of the released executable. A `console_replay_0_1` envelope must contain only its contract and profile identifiers, fictional scenario identity, deterministic normalized proposal output, deterministic normalized relation and synthesis observations, schema digests, and one envelope digest. Replay values are neutral deterministic fixtures; their nested fingerprint fields must use exact profile-reserved fixture identities rather than impersonating a provider, model, or prompt execution. They must not be described as recorded GPT or other provider output unless a separate live canary has produced and cryptographically bound that exact envelope, in which case the nested fingerprints must match that evidence. The envelope must not contain an atom candidate, Hees decision, structural reason, finding classification, selected-memory list, Content DNA, receipt, host screenshot, API credential, raw header, hidden prompt, or chain-of-thought.

An optional atom-comparison fixture is a separate display-only UI input. Its integrity and exact-match result are checked independently from `console_replay_0_1`, and its absence, corruption, mismatch, or provider provenance cannot change whether the replay reaches or passes the runner.

The host and runner must both validate the envelope digest and all nested identities before admission. The runner must recompute the decision, selected memory, Content DNA, and receipt on every invocation. A tampered, incompatible, or identity-mismatched replay must fail before proposal admission with the corresponding earliest public reason.

Replay mode must remain visible in every product view and exported run record. Scripted navigation may drive replay or live mode but must not change or obscure the active mode. A live provider failure must not automatically substitute replay values while the Console remains labelled live.

### Optional live GPT-5.6 mode

The first release's live adapter must use the OpenAI Responses API with explicit model `gpt-5.6-sol`, strict JSON Schema structured output, an explicit bounded reasoning effort, bounded output tokens, timeouts, and no tool access. The optional display-only atom comparison, proposal, relation-observation, and synthesis-observation operations must use separately identified prompts and schemas with deterministic fingerprints. Atom comparison failure cannot affect the terminal path.

The only supported credential surface is `OPENAI_API_KEY` or an equivalent documented hosted secret injection that is never exposed to the runner, fixtures, receipt, logs, screenshots, subprocess arguments, terminal widgets, or exported artifacts. The application must not persist the credential or raw authorization headers.

Live integration is a release claim only after a secret-gated canary proves that exact structured output reaches the same compiled runner used by replay. The default contributor and judge gates must not require a credential. Provider refusal, timeout, rate limit, malformed output, and incomplete result coverage must be typed and fail closed.

### Interaction and presentation contract

The Console must support `interactive`, `scripted`, and `replay` operation. Interactive mode may use live provider calls only when a credential is configured. Scripted mode controls navigation only. Replay mode is the zero-credential execution source.

The product must provide these inspectable views:

- package and fictional source summary;
- optional candidates beside canonical package atoms, with candidates unmistakably untrusted and unable to alter package state;
- `UNTRUSTED PROPOSAL` with exact structured fields;
- typed evidence references and memory-backed support mappings in distinct views;
- provider relation and synthesis observations beside Hees-classified non-authoritative findings;
- `LIMITED SPECTRUM OPERATION — console_profile_0_1` inputs and policy effects;
- `ADMITTED` or `REJECTED` with reason namespace, public reason, and checked structural reason;
- admitted evidence and terminal selected memory in distinct views;
- `EXPERIMENTAL CONSOLE CONTENT DNA 0.1`;
- `CONSOLE PROFILE RECEIPT 0.1`;
- `NON-AUTHORITATIVE CONSOLE TRACE 0.1`; and
- replay identity and integrity state when replay is active.

The first release must implement this keyboard contract:

- `1`: valid declared-action scenario;
- `2`: undeclared-action scenario;
- `3`: unknown evidence or unknown or non-admitted memory scenario;
- `a`: canonical atom, source, and optional comparison-candidate view;
- `p`: untrusted proposal view;
- `f`: observations, findings, and limited-operation view;
- `e`: admitted evidence and selected-memory views;
- `d`: experimental Content DNA view;
- `r`: profile-specific receipt view;
- `space` or `enter`: run the selected interaction; and
- `q`: quit.

Colour may reinforce status but must not carry meaning alone. Text labels and stable ASCII symbols must remain legible in monochrome and narrow terminals. All source, model, provider, error, and fixture text must be escaped before rendering so control sequences, links, markup, or terminal-width tricks cannot alter trusted labels or execute terminal behavior.

Rejected model text may be displayed only inside the escaped untrusted inspection view. It must not appear in the trusted answer region, speech output, clipboard helper, receipt, Content DNA, or default exported response.

### Executable and hosted judge boundary

The release must publish a self-contained prebuilt `hees-console` executable that embeds or safely locates the exact compiled Incan-authored runner, schemas, and fictional replay fixtures. Offline replay must start without an Incan compiler, Python runtime, package manager, source checkout, network connection, or API key.

At least one documented Linux judge artifact must pass the release gate. A macOS artifact may be published only when built and smoke-tested under the same provenance and no-rebuild rules. Unsupported platforms must be stated rather than inferred from source portability.

A hosted browser-terminal or equivalent sandbox must invoke the same frozen executable and expose the Console application directly, not an unrestricted shell. Sessions must be ephemeral, bounded by time and request limits, isolated from one another, non-persistent by default, and unable to read host credentials or unrelated files. Live mode may use server-side secret injection only through the same documented adapter boundary.

The release container must contain the frozen executable rather than define a second source-only path with different decisions. Artifact and container smoke tests must prove the three required scenarios without rebuilding Incan.

### Privacy, security, and publication boundary

Public sources, fixtures, schemas, replay outputs, screenshots, tests, and documentation must use only original fictional lesson-support content. They must not contain or derive from client material, private packages, civic corpora, personal data, unpublished research, downloaded models, private source references, credentials, local filesystem paths, or unrelated product names or code.

The Console must never expose raw provider headers, authorization values, hidden prompts, chain-of-thought, unrestricted evaluator rationale, subprocess command lines containing secrets, local environment dumps, or unrestricted shell access. Logs and failure views must use closed codes and bounded source-safe identity rather than raw provider or parser text.

Dependency, fixture, font, image, music, container-base, and build-tool licenses must be reviewed before release. Release provenance and hashes establish build identity and integrity, not external producer authenticity or factual correctness.

### Bounds and allocation

Every contract in the first profile must define exact global ceilings for raw bytes, nesting, tokens, identifiers, source text, source spans, atom candidates, admitted atoms, visible units, answer bytes, evidence references, requirements, finding targets, provider results, replay envelopes, runner requests and responses, selected memory, Content DNA entries and bytes, receipt fields and bytes, terminal rendering, and retained process state.

The runner must enforce raw byte ceilings before parsing and collection ceilings before proportional allocation. All count and byte arithmetic must use checked exact integers. The host may impose stricter platform limits but must not raise runner limits or truncate a value into a different valid input.

This Draft does not assign unmeasured production numbers. It cannot advance to Planned until clean Linux packaging measurements, supported macOS measurements when that artifact is claimed, maximum fictional fixtures, live and replay provider coexistence, canonicalization, subprocess exchange, terminal rendering, and hosted-session limits establish the exact table. A deadline, host memory observation, or model token budget must not become an undeclared public admission reason.

### Acceptance evidence

The first release is conforming only when the following evidence is public and executable where applicable:

- positive fixtures prove one admitted interaction reaches the checked Hees structural boundary, freezes exact selected memory, and atomically returns experimental Content DNA and a profile-specific receipt;
- adversarial fixtures prove undeclared action, duplicate evidence, missing required evidence, unknown evidence, unknown or non-admitted memory, package mismatch, malformed proposal, missing observation, observation mismatch, unsupported content, contradiction, incomplete synthesis, provider unavailability, and tampered replay fail with exact reasons;
- package fixtures prove canonical reviewed memory exists independently from optional comparison candidates and that candidate absence, mismatch, or provider failure cannot create, mutate, remove, or terminally affect package state;
- verifier fixtures prove Hees derives the exact manifest, requires complete relation and synthesis observation coverage, validates basis-point sums, applies package-owned thresholds, and composes findings before the bounded Spectrum operation;
- authority-negative fixtures prove a model, evaluator, host, replay, caller, copied response, copied Content DNA, or copied receipt cannot create or override a terminal decision;
- schema and canonicalization fixtures prove the host and runner agree on every field, absence rule, order, digest, and unknown-field rejection;
- reason-precedence fixtures make every public reason reachable and include multi-failure cases for every stage boundary;
- escaping and privacy fixtures prove model, source, provider, and error content cannot alter terminal control state or leak forbidden values;
- offline artifact tests prove a clean supported system can run all required scenarios without Incan, Python, a package manager, a source checkout, network access, or an API key;
- hosted tests prove a fresh restricted session can run the same frozen executable without a shell or persistent cross-session state;
- one secret-gated live canary proves explicit `gpt-5.6-sol` structured outputs reach the same runner while keeping the provider non-authoritative;
- documentation identifies supported platforms, install and test steps, live versus replay semantics, architecture, security and privacy boundaries, exact non-claims, known limitations, licenses, hashes, provenance, and how to exercise the product without rebuilding; and
- publication review confirms no forbidden content appears in the checked tree, Git history selected for release, issues, pull requests, workflows, artifacts, container, hosted session, screenshots, or release notes.

## Design details

### Relationship to RFC 000

RFC 000 owns the permanent authority model. Hees Console makes that model observable: providers nominate, the host coordinates, and the Incan-authored profile decides. The Console does not introduce another terminal authority, model-visible answer channel, or provenance author.

### Relationship to RFC 001

`console_profile_0_1` is one bounded versioned Spectrum operation and the sole terminal Hees decision boundary for the first Console release. Direct package, admitted-memory, finding, terminal, and selected-memory capabilities are created and consumed only inside the runner invocation; serialized JSON cannot reconstruct them. The operation does not implement RFC 001's complete capability graph, admitted and discarded memory partition, contradiction model, seven terminal outcomes, repair state, or full decision identity. The UI and documentation must therefore use the exact limited-operation label rather than claim that Spectrum contract `0.1` is implemented.

### Relationship to RFC 002

The profile constructs experimental `console_content_dna_0_1` inside Hees and returns it atomically with an admitted answer. Its admitted-answer body deliberately exercises every RFC 002 field for package identity, proposal identity, Spectrum decision identity, terminal state, policy identity, selected-memory entries, source digests, and answer digest. This is migration evidence, not complete RFC 002 conformance: the profile does not implement the complete upstream RFC 001, RFC 005, or RFC 009 contracts and has no no-answer clarification variant. Adoption as a conforming RFC 002 artifact requires an explicit profile and artifact transition.

### Relationship to RFC 003

The first profile admits only canonical reviewed, rights-allowed atoms already authored in one fixed fictional package. Optional model candidates are exact-match display comparisons and never enter, mutate, or affect that package. The profile does not implement provider-neutral retrieval, temporal validity, retrieval bindings, partial result states, or the complete governed-memory atom, so package validation must not be described as full RFC 003 admission.

### Relationship to RFC 004

The first profile applies one fixed versioned package policy that classifies complete normalized relation and synthesis scores with exact thresholds, composes findings, and maps them to `admit` or `reject`. It does not implement RFC 004's general constraint plan, evaluator capabilities, dependencies, substitutions, conflicts, escalation, or arbitrary package-defined action order. Findings remain non-authoritative despite the smaller policy.

### Relationship to RFC 005

The first profile uses a bounded fictional package with fixed package revision and profile-specific JCS artifact-digest fields so experimental Content DNA can exercise its package binding. It does not claim RFC 005 canonical package-artifact admission, member topology, sequential capability, or reload integrity. The fixture digest is a Console profile identity and must not be labelled an RFC 005-admitted artifact digest.

### Relationship to RFC 006

The first release emits `console_profile_receipt_0_1`, a profile-specific terminal-governance artifact constructed by Hees. It borrows RFC 006 redaction principles but is not RFC 006-compatible because the bounded operation lacks direct RFC 001 and RFC 009 source contracts. It excludes provider, model, build, replay, observation, finding-detail, and policy-effect metadata, does not recreate in-process authority, and cannot be submitted as a live decision capability. A future RFC 006-conforming profile requires an explicit version transition.

### Relationship to RFC 007

The verifier profile rederives exact manifest targets, validates complete coverage, and accepts bounded support, contradiction, unresolved, coverage, and gap basis-point observations without provider-supplied classifications. Hees alone applies package-owned thresholds and emits non-authoritative findings. This exercises a strict RFC 007-shaped subset but does not implement its complete package member, calibration, capability, projection, or unavailable-record contracts.

### Relationship to RFC 008

The first profile permits one package-declared action per proposal and does not implement behavior-envelope states, strategies, multi-candidate comparison, tie rules, or the opaque selected-behavior capability. The runner cannot reconstruct such a capability from JSON, and model output or observation scores cannot select an undeclared behavior.

### Relationship to RFC 009

The first profile narrows the visible-response surface to one original candidate and two completed outcomes, `admit` or `reject`. Its proposal uses visible units as the sole prose channel plus identifier-only support mappings with distinct evidence and memory namespaces; Hees derives support claim text exactly from those units. It has no model repair, package-authored clarification, seven-variant lifecycle, or RFC 009 receipt projection and therefore does not claim full RFC 009 conformance.

### Permanent product and first release

The Build Week submission is the `hees-console-v0.1.0` release of the permanent product. Event copy, screenshots, and video may identify that release context, but the code and contract must not create a separate product name, disposable architecture, or submission-only authority path.

Future releases may add packages, providers, languages, full RFC contracts, repair, clarification, richer developer inspection, or additional platforms. They must preserve the Hees decision boundary and use explicit profile and artifact versions. A provider, UI, packaging, or event change alone must not change terminal semantics.

### Public repository boundary

The Console implementation may live beside the Hees kernel because it is the public reference developer product for exercising the kernel's authority. That exception does not admit private implementation packages, customer applications, general package-authoring systems, research workspaces, model artifacts, or unrelated control planes into the repository.

The checked Hees README and Contracts documentation remain the source of truth for implemented library behavior until the Console implementation and release are actually merged. A Draft RFC, issue, replay fixture, screenshot, or release plan must not be described as shipped functionality.

## Alternatives considered

### Build a disposable event demo

Rejected because it would split product evolution, encourage a host-only authority path, and leave no stable public contract after the submission release.

### Wait for every RFC 001–009 contract to be implemented

Rejected because the central authority boundary can be demonstrated honestly with a smaller named profile. Waiting would not improve the first profile if the missing contracts were merely claimed rather than implemented.

### Let the presentation host decide after validating model JSON

Rejected because strict structured output establishes shape, not package authority, terminal policy, selected memory, provenance, or receipt integrity. The host may coordinate but cannot decide.

### Store complete replay outcomes

Rejected because replaying an admission result would test rendering rather than Hees. Replays store neutral deterministic proposal and observation fixtures only and rerun the compiled decision path. A replay is not called recorded GPT output without separately bound live-canary evidence.

### Require a live API key for judging

Rejected because provider availability and credentials should not gate the zero-credential product experience. Live mode remains separately proven and explicitly selected.

### Call the limited artifacts RFC 001 Spectrum, RFC 002 Content DNA, and RFC 006 receipts

Rejected because shared terminology without contract conformance would overstate implementation and make future migration ambiguous. The first profile uses exact Console-specific identifiers and labels.

### Ship source and ask judges to rebuild

Rejected because it would make toolchain setup part of the product evaluation and would not prove the frozen release artifact. The judge path is a prebuilt self-contained executable and restricted hosted session.

### Bundle a local language model

Rejected for the first release because the product goal is the governance boundary, not model distribution, and downloaded model artifacts do not belong in this public release. Offline replay provides a deterministic zero-credential path without pretending to be live inference.

## Drawbacks

The first release carries profile-specific contracts that will require explicit migration when the full RFC 001–009 contracts are implemented. Maintaining a strict host/runner split adds subprocess, packaging, schema, and cross-boundary tests. Offline replay is reliable but cannot demonstrate live provider behavior by itself, so a separate credential-gated canary remains necessary. A self-contained executable and hosted sandbox add build provenance, platform, dependency-license, extraction, session-isolation, and security work beyond the Hees kernel.

The limited profile also makes narrower claims than the product language may initially suggest. Its provider scores can be wrong, its package-owned thresholds are profile-specific, its fictional package does not establish general corpus ingestion, and its experimental Content DNA and receipt do not establish complete Draft-contract conformance. Those limitations are required for a truthful first release.

## Layers affected

- **Public product contract:** Permanent product identity, release line, profile versions, modes, views, keyboard behavior, and judge experience.
- **Hees runtime:** Incan-authored canonical-memory, proposal, manifest, observation-classification, finding, policy, structural admission, selected-memory, Content DNA, receipt, and runner-response boundaries.
- **Provider host:** Strict structured provider calls, normalized untrusted outputs, timeouts, refusal handling, and secret isolation without terminal authority.
- **Runner protocol:** Closed request and response schemas, raw bounds, identity binding, reason precedence, and host/runner authority-negative behavior.
- **Replay:** Neutral deterministic proposal-and-observation envelope, integrity validation, exact mode disclosure, and rerun semantics.
- **Presentation:** Escaped trust-labelled terminal views, keyboard contract, narrow-terminal and monochrome behavior, and rejected-answer isolation.
- **Distribution:** Self-contained executable, supported-platform artifacts, container, hashes, provenance, dependency licenses, and smoke tests.
- **Hosted testing:** Restricted ephemeral sessions over the same frozen executable, no shell, bounded resources, and optional server-side secret injection.
- **Documentation:** RFC and implementation status truth, installation, testing, architecture, limitations, live/replay semantics, security, privacy, licensing, and exact non-claims.
- **Testing:** Positive, adversarial, schema, precedence, authority-negative, replay-integrity, escaping, privacy, packaging, hosted, and live-canary evidence.

## Design Decisions

- Hees Console is a permanent public product; the Build Week submission is its first release rather than a separate product.
- The first release is independently versioned as `Hees Console 0.1.0`, tagged `hees-console-v0.1.0`, and does not silently bump the Hees library.
- `console_profile_0_1` is the sole Incan-authored terminal authority for the release and is explicitly narrower than RFC 001–009.
- Offline replay is the no-credential default and stores neutral deterministic proposal and observation fixtures only; every replay reruns the compiled Hees path.
- Optional live mode uses explicit `gpt-5.6-sol`, the Responses API, strict structured outputs, bounded calls, no tools, and the documented secret surface.
- The external host owns provider, terminal, subprocess, packaging, hosting, and secret boundaries only.
- Ordered visible units are the sole model answer channel; support claims are derived exactly from those units, and typed evidence and memory identifiers remain distinct.
- The first profile has one original candidate and only `admit` or `reject`; it has no model repair, clarification, or escalation.
- Provider relation and synthesis scores remain non-authoritative, require exact Hees-derived manifest coverage, and are classified only by package-owned thresholds.
- Selected memory, experimental Content DNA, and the profile-specific receipt are constructed inside Hees only after terminal admission.
- Experimental Content DNA exercises the complete RFC 002 admitted-answer field shape without claiming full RFC 002 conformance; the profile receipt borrows RFC 006 redaction principles without claiming RFC 006 compatibility.
- The release fixture is wholly fictional, public-safe, and bounded; no general corpus or package-authoring claim is made.
- The judge experience is a self-contained executable plus restricted hosted access, with at least one verified Linux artifact and no rebuild requirement.
- The public reason namespace and precedence are closed; provider wording, scores, iteration order, and wall-clock timing cannot choose the result.

## Unresolved questions

- What exact raw-byte, item-count, visible-unit, observation, finding, selected-memory, canonical-body, terminal-rendering, and retained-state ceilings do clean supported-platform measurements justify for `console_profile_0_1`?
- Can a verified macOS self-contained artifact meet the same no-rebuild, provenance, dependency-license, extraction, and runner-integrity gates before the first release, or should `0.1.0` document Linux as its only supported local artifact?

<!-- Rename this section to "Design Decisions" once all questions have been resolved.
     An RFC cannot move from Draft to Planned until no unresolved questions remain. -->
