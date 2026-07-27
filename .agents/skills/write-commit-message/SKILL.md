---
name: write-commit-message
description: Draft commit messages for Hees.ai changes using the repository convention.
---

# Write Commit Message

1. Inspect the actual diff before selecting a change type.
2. Use `bugfix` for correctness repairs, `feature` for new behavior, and `chore` for maintenance, documentation, or behavior-preserving refactors.
3. Infer issue numbers from the branch and task context. Never invent one.
4. Format the subject exactly as:

   ```text
   <type> - <concrete short description> (#<issue>)
   ```

5. Keep the subject specific, imperative in effect, and without trailing punctuation.
6. Add a body only when it materially explains distinct changes or motivation.
