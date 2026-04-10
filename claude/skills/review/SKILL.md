---
name: review
description: Review an implementation against its issue requirements. Spawns a review team — one for correctness, one for style/standards. Wraps superpowers:requesting-code-review with team-based specialist review.
---

You are leading the review phase. Your goal is to thoroughly review the implementation and produce actionable findings.

## Phase 0 — Scope Assessment

Before starting, classify the review scope:

1. **Lightweight** — small change, single file or tightly scoped fix
   - Single reviewer, quick pass. No team dispatch.
   - Focus on correctness and obvious issues only.
2. **Standard** — typical feature or multi-file change
   - Current behavior: 2-reviewer team (correctness + standards).
3. **Deep** — security-sensitive, performance-critical, cross-cutting, or migration/breaking-change
   - Full team plus additional specialist reviewers.

Decision tree:
1. Is the diff under ~50 lines and touches one module? → Lightweight
2. Does it touch auth/security, database migrations, public APIs, or performance-critical paths? → Deep
3. Otherwise → Standard

## Process

### Lightweight

1. Read the GitHub issue and its acceptance criteria.
2. Run `git diff main...HEAD` to see all changes.
3. Single-pass review: check acceptance criteria, obvious bugs, leftover debug code, forgotten TODOs.
4. Report findings.

### Standard

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

### Deep

1. Read the GitHub issue and its acceptance criteria.

2. **Spawn an extended review team** using TeamCreate with four specialists:
   - **Correctness reviewer** — checks acceptance criteria, edge cases, logical errors
   - **Standards reviewer** — checks code style, naming, patterns, test quality
   - **Security reviewer** — checks for vulnerabilities: injection, auth bypass, data exposure, insecure defaults, OWASP top 10 concerns
   - **Performance/migration reviewer** — checks for N+1 queries, unnecessary allocations, breaking changes, migration safety, backward compatibility

3. All reviewers work in parallel. Each uses `git diff main...HEAD` and reports structured findings.

4. Security and performance reviewers have veto power — their critical findings block the review.

5. Team converges on a unified review via messages.

6. Present findings to the implementation lead. Do **not** fix issues — only report them.

## Output

A structured review report with:
- Pass/fail per acceptance criterion
- Issues found (with file:line references and severity)
- Recommendations

## Rules

- Never fix issues during review — separation of concerns
- Both reviewers must agree before the review is finalized (Standard/Deep)
- Flag any changes outside the stated scope of the issue
