# TurboQuant reference contract

This document freezes the reproducibility contract for Hees's first faithful TurboQuant retrieval profiles. It tells an implementer what comes directly from the published algorithm, what the paper leaves unspecified, and which deterministic decisions Hees makes so two implementations can produce the same result.

The profiles described here are **specified, not yet implemented**. The current public Hyperquant implementation remains `exact_cosine_0_1`. Codec implementation and public compressed-profile constructors belong to the next slice and must pass the fixtures frozen here before they can be called TurboQuant.

## Why a separate reference contract exists

The TurboQuant paper defines the important mathematics: random rotation, scalar MSE quantization, residual construction, one-bit QJL correction, reconstruction, and estimator guarantees. It does not define a portable random byte stream, a seed representation, the sign convention of QR decomposition, behavior at exactly zero, bit order, tail padding, a binary envelope, or a stable profile identity.

Those omissions are normal in a research paper, but they matter for a replayable product. If Hees silently selected different answers on different platforms, old index identities and retrieval receipts could stop reproducing even though every implementation claimed to use TurboQuant.

This contract therefore has two kinds of normative statement:

- **Paper mapping:** behavior required by Algorithms 1–2, Equation 4, or Theorems 1–2 of the paper.
- **Hees decision:** a deterministic product choice where the paper permits more than one valid implementation.

## Source ledger

The normative research source is:

- Amir Zandieh, Majid Daliri, Majid Hadian, and Vahab Mirrokni, [TurboQuant: Online Vector Quantization with Near-optimal Distortion Rate](https://arxiv.org/pdf/2504.19874), arXiv:2504.19874v1, 28 April 2025.
- Frozen PDF SHA-256: `431eb13926e10491f5fbd0bebd0813c51bd6c1e884426a1500c5db640b2997ab`.

The [Google Research overview](https://research.google/blog/turboquant-redefining-ai-efficiency-with-extreme-compression/) is useful explanatory context, but the paper is normative where their levels of detail differ.

No third-party reproduction is normative. Independent implementations may be used later as comparison evidence, but they cannot silently fill gaps in this contract.

## Reserved profile identities

The contract reserves two behavioral identities:

| Profile | Paper mapping | Purpose |
|---|---|---|
| `turboquant_mse_0_1` | Algorithm 1 | Reconstruct a unit vector with low mean-squared error. |
| `turboquant_product_0_1` | Algorithm 2 | Combine an MSE code with one-bit QJL residual correction for unbiased inner-product estimation in expectation. |

These identities name mathematical behavior. They do not identify an implementation build, an embedding model, a corpus, an index page, or the eventual IncQL-DB storage representation.

The fixture schema identity is `hees_hyperquant_turboquant_fixture_0_1`. The reference-contract identity is `hees_hyperquant_turboquant_reference_0_1`. A future codec implementation version and physical index format must remain separately identifiable.

## Shared vector contract

Both profiles operate on vectors normalized to the unit sphere, as assumed by the paper. A Hyperquant cosine-retrieval provider must:

1. Accept only finite, non-empty vectors within the public Hyperquant dimension bound.
2. Reject a zero-norm vector.
3. Normalize each indexed vector before encoding.
4. Normalize each query before scoring.
5. Require the query and every indexed code to have the configured dimension.
6. Preserve exact full-precision vectors separately when the selected profile requires exact reranking.

The compressed code does not own a `MemoryId`. Index storage binds a code position to a logical memory identifier. Hyperquant nomination still returns identifiers only, and RFC 003 admission still determines whether those identifiers can materialize package-owned memory.

## Deterministic random stream

Algorithms 1–2 require random Gaussian matrices. The paper does not prescribe a portable generator. Hees decision `TQ-RNG-001` defines one.

### Counter blocks

Every random stream is identified by an ASCII domain, one unsigned 64-bit seed, and an unsigned 64-bit block counter.

The source text for block `counter` is:

```text
domain + ":" + seed_hex + ":" + counter_hex
```

`seed_hex` and `counter_hex` are lowercase, zero-padded, 16-character hexadecimal values. The source contains ASCII bytes only and no terminator. Its SHA-256 digest is read as four consecutive unsigned 64-bit big-endian words.

The profile domains are:

```text
hees.hyperquant.turboquant.rotation.0_1
hees.hyperquant.turboquant.qjl.0_1
```

### Uniform and Gaussian samples

For each 64-bit word `word`, discard its lowest 11 bits and call the remaining 53-bit integer `mantissa`. Convert it to an open-interval uniform sample:

```text
u = (mantissa + 0.5) / 2^53
```

Consume uniform samples in order. Convert pairs `(u1, u2)` to standard Gaussian samples using Box–Muller:

```text
radius = sqrt(-2 * ln(u1))
angle = 2 * pi * u2
z0 = radius * cos(angle)
z1 = radius * sin(angle)
```

Emit `z0`, then `z1`. No value may be cached across domain, seed, profile, or dimension boundaries.

## Rotation matrix

Algorithm 1 line 2 requires a random rotation and states that it can be generated by QR decomposition of a matrix with independent normal entries. Hees decision `TQ-QR-001` makes this reproducible.

1. Fill a `d × d` matrix `A` row by row from the rotation Gaussian stream.
2. Compute Householder QR in increasing column order using binary64 arithmetic.
3. If `R[j,j]` is negative, negate column `j` of `Q` and row `j` of `R`.
4. Reject a non-finite intermediate or a diagonal whose absolute value is at most `1e-15`.
5. Use the resulting `Q` as the paper's rotation matrix `Π`.

The positive-diagonal normalization removes the otherwise implementation-dependent sign of each QR column. The dense reference transform is intentionally faithful rather than optimized. A future structured or faster transform must use a different profile identity unless equivalence to this contract is proven.

## Scalar codebooks

Algorithm 1 and Equation 4 define an optimal scalar codebook for the rotated-coordinate distribution. The paper explicitly proposes solving the one-dimensional optimization once and storing the result.

Hees decision `TQ-CODEBOOK-001` follows that model:

- A profile configuration carries its ordered binary64 centroids.
- `turboquant_mse_0_1` with bit width `b` requires exactly `2^b` centroids.
- `turboquant_product_0_1` with total bit width `b` uses an MSE stage of `max(0, b - 1)` bits and requires `2^max(0, b - 1)` centroids.
- Centroids must be finite, strictly increasing when more than one is present, contained in `[-1, 1]`, and symmetric about zero within the declared tolerance.
- The profile configuration identifies the dimension for which the codebook was solved.
- A decoder never derives or changes centroids from corpus data.

This makes the runtime online and data-oblivious while keeping numerical codebook construction outside decoding. Shipping codebooks for production dimensions remains implementation work. A codebook is not faithful merely because it has the correct number of centroids; it must be evidence-mapped to Equation 4 and bound into configuration identity.

The dimension-four, one-bit fixture has the exact symmetric centroids `±4/(3π)`, because the positive conditional mean of the dimension-four coordinate density is `4/(3π)`.

## MSE profile

`turboquant_mse_0_1` follows Algorithm 1.

### Encode

1. Validate and normalize the source vector `x`.
2. Compute `y = Πx`.
3. For each coordinate `y[j]`, select the nearest centroid and store its zero-based index.
4. If two centroids are equally near, select the lower index.
5. Pack indices using `TQ-PACK-001`.

### Reconstruct

1. Replace each index with its configured centroid, producing `y_tilde`.
2. Compute `x_tilde = Πᵀy_tilde`.

The squared reconstruction error is `||x - x_tilde||²`. The paper's expected distortion guarantees describe the random procedure over transforms; they are not per-vector acceptance thresholds.

## Product profile

`turboquant_product_0_1` follows Algorithm 2.

### Encode

1. Encode and reconstruct `x` through the configured MSE stage.
2. Compute the residual `r = x - x_tilde_mse`.
3. Compute `gamma = ||r||₂`.
4. Fill a `d × d` projection matrix `S` row by row from the QJL Gaussian stream.
5. Compute `qjl = sign(Sr)`.
6. Pack MSE indices and QJL signs using `TQ-PACK-001`.
7. Store `gamma` as finite, non-negative IEEE-754 binary64.

Hees decision `TQ-SIGN-001` defines:

```text
sign(value) = +1 when value >= 0
sign(value) = -1 when value < 0
```

### Reconstruct and estimate

Compute:

```text
x_tilde_qjl = sqrt(pi / 2) / d * gamma * S_transpose * qjl
x_tilde_product = x_tilde_mse + x_tilde_qjl
```

For a normalized query `q`, the reference inner-product estimate is:

```text
estimate = dot(q, x_tilde_product)
```

An optimized implementation may score directly from packed codes and transformed queries, but it must reproduce the reference estimate within the configured numerical tolerance.

The paper proves unbiasedness in expectation over the random procedure. One fixture estimate is not expected to equal the exact inner product.

## Canonical bit packing

Hees decision `TQ-PACK-001` defines a language-neutral packed representation:

1. Coordinates appear in logical order.
2. An unsigned index is emitted most-significant bit first using exactly its declared width.
3. A QJL sign emits `1` for `+1` and `0` for `-1`.
4. The first emitted bit occupies bit 7 of the first byte.
5. Subsequent bits fill toward bit 0 before continuing at bit 7 of the next byte.
6. An incomplete final byte is padded with zero bits.
7. A decoder rejects a non-zero padding bit, a truncated payload, an overlong payload, or a value outside the configured codebook.

For example, five three-bit indices `[0, 1, 2, 3, 4]` produce hexadecimal `0538`. Five sign bits `[1, 0, 1, 1, 0]` produce hexadecimal `b0`.

## Canonical standalone code envelope

Slice 3 must implement a standalone binary envelope with the following field order. Multi-byte integers and IEEE-754 values are big-endian.

| Field | Size | Contract |
|---|---:|---|
| Magic | 8 bytes | ASCII `HQTQCODE` |
| Format major | `u8` | `0` |
| Format minor | `u8` | `1` |
| Profile kind | `u8` | `1` for MSE, `2` for product |
| Total bit width | `u8` | MSE `1..8`, product `1..8` |
| Dimensions | `u32` | `1..8192` and equal to configuration |
| Configuration digest | 32 bytes | Raw SHA-256 of canonical configuration bytes |
| MSE indices | variable | Exactly `ceil(d × mse_bits / 8)` bytes |
| QJL signs | variable | Product profile only; exactly `ceil(d / 8)` bytes |
| Residual norm | 8 bytes | Product profile only; finite non-negative binary64 |
| Envelope digest | 32 bytes | SHA-256 of every preceding envelope byte |

For an MSE profile, `mse_bits` equals total bit width. For a product profile, `mse_bits = max(0, total bit width - 1)`; a zero-bit MSE stage contains no index bytes and uses its sole configured centroid for every coordinate.

The standalone digest is appropriate for fixtures, transport, and isolated verification. A later paged index may amortize integrity metadata at the page level, but it must preserve the same code-body semantics and use a distinct physical-format identity.

## Canonical configuration bytes

Configuration identity is SHA-256 over this exact byte sequence:

| Field | Size | Contract |
|---|---:|---|
| Magic | 8 bytes | ASCII `HQTQCFG0` |
| Contract major | `u8` | `0` |
| Contract minor | `u8` | `1` |
| Profile kind | `u8` | `1` for MSE, `2` for product |
| Total bit width | `u8` | Same value used by the code envelope |
| Dimensions | `u32` | Configured vector dimension |
| Seed | `u64` | Seed used by both domain-separated streams |
| Centroid count | `u16` | Exact number of following centroids |
| Centroids | variable | Ordered IEEE-754 binary64 values |

The domain strings and generation decisions are fixed by the behavioral profile version and are therefore not repeated in every configuration. Changing either domain, the random conversion, QR convention, sign convention, packing order, or reconstruction formula requires a new behavioral profile identity.

Configuration identity is not derived from JSON and is not Content DNA. It binds only the numerical retrieval configuration.

## Numerical behavior

Reference calculations use IEEE-754 binary64 and the operation order described above. Fixture comparisons use combined tolerance:

```text
abs(actual - expected) <= absolute_tolerance + relative_tolerance * abs(expected)
```

The initial fixtures set `absolute_tolerance = 1e-12` and `relative_tolerance = 1e-12`. Integer values, signs, indices, bytes, identifiers, and SHA-256 digests require exact equality.

An implementation must reject non-finite input, configuration, decoded scalar, or intermediate output. It must not convert NaN into an ordering decision.

## Frozen fixtures

The language-neutral fixture set lives under `tests/fixtures/hyperquant/turboquant_0_1/`.

| Fixture | Covers |
|---|---|
| `generation.json` | SHA-256 counter stream, Box–Muller samples, seeded rotation, and QJL projection. |
| `mse.json` | Dimension-four one-bit rotation, centroid selection, packing, reconstruction, and squared error. |
| `product.json` | Residual, QJL signs, product reconstruction, and query estimates. |
| `packing.json` | Non-byte-aligned integer and sign packing with zero tail padding. |
| `manifest.json` | Paper identity, Hees decisions, fixture identities, and exact fixture digests. |

The fixtures are JSON for accessibility to independent implementers. Their exact file digests are fixture-integrity evidence only; JSON is not the canonical compressed-code or configuration encoding.

## Fail-closed requirements

A future implementation must reject:

- unknown contract, profile, implementation, or physical-format versions;
- unsupported dimensions or bit widths;
- empty, non-finite, zero-norm, or dimension-mismatched vectors;
- malformed, unsorted, asymmetric, or dimension-mismatched codebooks;
- rank-deficient or non-finite seeded transforms;
- truncated, overlong, or non-canonical packed sections;
- non-zero tail padding;
- invalid sign or centroid indices;
- negative or non-finite residual norms;
- configuration digest mismatch;
- envelope or index integrity failure.

Decoding failure returns a closed Hyperquant error. It must not allocate from an unvalidated length, return a partial code, or fall back to a different profile.

## What this contract does not claim

This contract does not claim that:

- the compressed profiles are implemented or exported today;
- the dimension-four fixture predicts retrieval quality at production dimensions;
- one seed proves unbiasedness, distortion, recall, latency, or memory behavior;
- TurboQuant scores establish relevance, evidence support, rights, review, or authority;
- the dense reference transform will be the performance default;
- vector-search profiles can be reused as KV-cache format identities.

Slice 3 implements the reference codecs in Incan. Slice 4 adds bounded approximate nomination and exact reranking. Slice 5 supplies the multi-domain, multilingual, and constrained-device evidence needed to select defaults.
