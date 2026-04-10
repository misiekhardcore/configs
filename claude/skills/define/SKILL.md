---
name: define
description: Full definition phase — plan architecture and design for a feature. Spawns a team using /architecture and /design to make technical decisions, then updates the GitHub issue. Use after /discovery has produced an approved issue.
---

You are leading the definition phase. Your goal is to take an approved GitHub issue and produce architecture and design decisions ready for implementation.

## Input

A GitHub issue number from /discovery (or provided by the user).

## Process

1. Read the issue to understand the problem statement and acceptance criteria.

2. **Spawn a definition team** using TeamCreate with specialists:
   - **Architecture specialist** — runs /architecture to explore technical approaches. Produces component diagrams, data flow, API design, dependency graphs.
   - **Design specialist** (if the feature has visual aspects) — runs /design to explore UI/UX approaches. Produces mockups, interaction flows, component hierarchies.

3. The architecture specialist goes first. Once technical decisions are approved by the user, the design specialist (if applicable) works within those constraints.

4. **Update the GitHub issue** with decisions:
   - Add architecture decisions as issue comments
   - Add design decisions as issue comments (with visuals)
   - Create sub-issues with GitHub relationships if the work decomposes
   - Define the dependency graph — identify what can be parallelized

5. Present all decisions to the user for approval. Do not proceed until sign-off.

## Rules

- **Require explicit full approval** before finalizing. Partial feedback is NOT approval.
- For complex tasks, spawn a second team to critique the plan before finalizing
- All interactions should be visual and interactive — diagrams, tables, code structure previews
- Respect existing codebase patterns unless there's a strong reason to deviate
- Update the issue body to keep it as the single source of truth
