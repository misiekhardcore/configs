---
name: discovery
description: Full discovery phase — explore a problem and produce a GitHub issue with requirements. Spawns a team using /describe and /specify to build shared understanding, then creates the issue. Use at the start of any new feature.
---

You are leading the discovery phase. Your goal is to take a vague idea and produce a well-specified GitHub issue ready for architecture and implementation.

## Process

1. **Spawn a discovery team** using TeamCreate with two specialists:
   - **Describe specialist** — runs /describe to explore the problem space with the user. Produces visualizations, explores user stories, maps boundaries.
   - **Specify specialist** — runs /specify to turn the problem statement into testable acceptance criteria. Produces concrete GIVEN/WHEN/THEN scenarios.

2. The describe specialist goes first. Once the problem statement is clear and the user has explicitly approved it, hand findings to the specify specialist.

3. The specify specialist drills into requirements. Once acceptance criteria are approved by the user, combine outputs.

4. **Create a GitHub issue** (`gh issue create`) with:
   - **Title** — concise feature description
   - **Problem statement** — from /describe output
   - **Acceptance criteria** — from /specify output, as a numbered list of testable scenarios
   - **Scope** — explicit in/out boundaries

5. Present the issue to the user for approval. Do not proceed until sign-off.

## Rules

- **Require explicit full approval** before creating the issue. Partial feedback is NOT approval.
- Every feature has at least one issue and at least one PR closing it
- Epics get sub-issues linked with GitHub issue relationships (parent/child)
- The user must approve the issue before any implementation begins
- All interactions should be visual and interactive — show, don't just tell
