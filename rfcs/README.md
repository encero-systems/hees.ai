# Hees RFCs

Hees uses RFCs for new runtime capabilities, material public-contract changes,
and decisions that affect ownership or compatibility across implementations.

## Lifecycle

1. Open an **RFC proposal** issue that states the desired outcome, public
   boundary, non-goals, acceptance evidence, and unresolved risks.
2. Discuss whether the capability belongs in Hees and whether its scope is
   coherent enough for an RFC.
3. If accepted for design, submit a focused RFC document by pull request. The
   RFC should define behavior and compatibility without committing unrelated
   implementation work.
4. Merge implementation separately, with executable positive and fail-closed
   evidence. An accepted RFC does not by itself make a capability implemented.

Proposal issues and RFCs describe public outcomes. They must not contain
private package contents, client material, raw corpora, credentials, local
paths, model artifacts, or unpublished research results.

Until an RFC and its implementation are both merged, the repository's README
and checked public API remain the source of truth for what Hees implements.
