---
name: create-pr-description
description: Draft or update a Hees.ai pull request description from the final diff and repository template.
---

# Create PR Description

1. Identify the base and head branches, then inspect the complete diff and commit
   log between them.
2. Use `.github/pull_request_template.md` as the required structure. Do not
   replace repository-specific sections with a generic template.
3. State the public product behavior, architectural boundaries, and verification
   evidence precisely. Distinguish implemented behavior from residual work.
4. When an RFC is touched, describe the RFC's lifecycle state without using the
   RFC as a progress log or claiming that draft scope is fully implemented.
5. Preserve public/private boundaries: do not disclose client material,
   proprietary systems, research artifacts, secrets, personal paths, or local
   model assets.
6. Include exact test counts and toolchain provenance when they matter to the
   demonstrated path. Commit hashes identify tested source and artifacts; they do
   not prescribe merge-history shape.
7. Retain all template checkboxes and mark only checks supported by evidence.
8. Reference the associated issue using the repository's expected closing or
   tracking language. Do not invent an issue.
