# Step 8 — PR

Push the branch and open a draft PR (`gh pr create --draft`). Link to the issue:

- `Closes #<issue>` — if this is the only PR or the final PR that completes the issue
- `Related to #<issue>` — if this is a partial implementation (one of multiple PRs for the issue)

PR description must include a **"Manual testing"** section with concrete steps to verify the change (not a checklist of TODOs, but actual repro steps someone can follow).

Delete the plan file if one was created during architecture.
