# Hyperquant retrieval

Hyperquant is Hees's first-party family of bounded vector-retrieval profiles. It answers one narrow question: which package-owned memory identifiers are the strongest candidates for a query?

Hyperquant ranks. Hees decides.

## Authority boundary

A Hyperquant result is a non-authoritative nomination. It contains logical `MemoryId` values, dense zero-based ranks, and bounded relevance metadata.

It does not contain trusted memory payloads and does not establish that nominated material is reviewed, rights-allowed, temporally valid, relevant to the active goal, sufficient to support an answer, or admissible under policy.

The RFC 003 governed-memory boundary must validate the provider binding, package identity, nominated identifiers, review and rights declarations, temporal state, limits, and package-owned materialization before memory can become selected memory. Spectrum and the final Hees decision remain downstream authority.

```text
query vector + versioned Hyperquant index
        |
        v
non-authoritative MemoryId nominations
        |
        v
RFC 003 package-owned memory admission
        |
        v
selected memory
        |
        v
Spectrum + final Hees decision
```

## Exact profile

`exact_cosine_0_1` is the initial product profile. It is both the permanent correctness oracle for later compressed profiles and a legitimate fallback for small corpora.

The profile:

- accepts between 1 and 65,536 uniquely identified entries;
- accepts vectors containing between 1 and 8,192 finite values;
- rejects zero-norm vectors;
- normalizes index and query vectors without mutating caller-owned lists;
- scores every entry using exact cosine similarity;
- retains only the bounded top-k candidate trace while scanning;
- permits `top_k` values from 1 through 64, never exceeding the index size;
- resolves exact score ties by canonical memory identifier;
- projects relevance into the inclusive range 0 through 10,000 basis points;
- fails through a closed typed error vocabulary.

Because the retained set never exceeds `top_k`, candidate memory is O(k) and deterministic ordering work is O(n × k), where `n` is the number of indexed entries and `k` is at most 64.

## Public API

The initial public surface is exported from `pub::hees_ai`:

```incan
from pub::hees_ai import (
    exact_index,
    exact_query,
    hyperquant_entry,
    memory_id,
)

entry_a = hyperquant_entry(memory_id("lesson_step_a"), [1.0, 0.0])?
entry_b = hyperquant_entry(memory_id("lesson_step_b"), [0.0, 1.0])?
index = exact_index([entry_a, entry_b])?
result = exact_query(index, [1.0, 0.0], 1)?
```

The internal source is already organized as `src/hyperquant/`. [Incan issue #947](https://github.com/encero-systems/incan/issues/947) tracks nested public module namespace exports so a future compatible surface can expose `from pub::hees_ai import hyperquant` without creating a separate package.

## Failure behavior

Hyperquant rejects:

- an empty or oversized index;
- empty, oversized, zero-norm, or non-finite vectors;
- mismatched dimensions;
- duplicate memory identifiers;
- a non-positive, oversized, or index-exceeding `top_k`.

Diagnostics use stable error kinds and bounded implementation-owned detail. Caller vectors and caller text are not copied into error messages.

## Profile roadmap

The first compressed product candidates are separately versioned TurboQuant product-style and MSE-oriented profiles. Their [reference contract](hyperquant-turboquant-reference.md) now maps transforms, quantization, residuals, estimators, packing, and query-time behavior to explicit paper evidence and Hees reproducibility decisions.

The reference contract and conformance fixtures are frozen specification evidence. They do not mean the codecs are already implemented or public. The next implementation slice must reproduce those fixtures in Incan before either compressed profile can be selected.

Both profiles will use bounded approximate nomination and an explicitly configured exact-reranking policy. Evaluation against `exact_cosine_0_1` and independent baselines will determine the default; the paper name alone will not.

The current Notulist-derived randomized-Hadamard, scalar-centroid, and residual-sign experiment remains comparison evidence under an identity describing what it actually implements. It is not a TurboQuant profile.

Later slices add canonical packed codecs, corruption detection, multilingual evaluation, RFC 003 admission, paged storage integration, and consumer migration. Related KV-cache compression belongs to the native model runtime and will use a distinct profile identity rather than being conflated with Hyperquant retrieval.
