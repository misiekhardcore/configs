---
name: review
description: Review an implementation against its issue requirements. Spawns a review team — one for correctness, one for style/standards. Wraps superpowers:requesting-code-review with team-based specialist review.
---

You are leading the review phase. Your goal is to thoroughly review the implementation and produce actionable findings.

## Process

1. Read the GitHub issue and its acceptance criteria.

2. **Spawn a review team** using TeamCreate with two specialists:
   - **Correctness reviewer** — checks that the implementation satisfies every acceptance criterion, handles edge cases, and has no logical errors.
   - **Standards reviewer** — checks code style, naming, patterns, test quality, and adherence to project conventions.

3. Both reviewers work in parallel. Each reviewer:
   - Runs `git diff main...HEAD` to see all changes
   - Checks for leftover debug code, forgotten TODOs, or accidental changes
   - Uses superpowers:requesting-code-review as their review framework
   - Reports findings as a structured list (file:line, issue, severity)

4. Reviewers discuss disagreements via messages and converge on a unified review.

5. Present findings to the implementation lead. Do **not** fix issues — only report them.

## Output

A structured review report with:
- Pass/fail per acceptance criterion
- Issues found (with file:line references and severity)
- Recommendations

## Rules

- Never fix issues during review — separation of concerns
- Both reviewers must agree before the review is finalized
- Flag any changes outside the stated scope of the issue
