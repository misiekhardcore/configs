# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Implementation Rules

- **Always use agent teams** for non-trivial implementation. Use `TeamCreate` to spawn teammates — assign each a separate sub-issue or file group to avoid conflicts. Only fall back to single-agent for trivial single-file fixes. When dispatching subagents, explicitly instruct them to use teams.
- Respond concisely; no filler, no preamble

## Feature Workflow

The workflow below describes the **maximum** process. The main conversation decides which phases to engage based on task complexity:

- **Trivial fix** (obvious problem + solution) → skip to step 5, implement + PR
- **Medium feature** → steps 1-2, then 5-8
- **Large feature / epic** → full workflow 1-8

| Step | Phase             | Key action                                                                    |
| ---- | ----------------- | ----------------------------------------------------------------------------- |
| 1    | Discovery         | /grill-me — explore problem, require explicit full approval before proceeding |
| 2    | Specification     | `gh issue create` with problem statement, acceptance criteria, scope          |
| 3    | Architecture      | Dispatch research team, update issue with decisions, create sub-issues        |
| 4    | Design (optional) | 2-3 visual approaches for UI; diagrams for complex logic                      |
| 5    | Implementation    | Git worktree, TDD for logic, agent teams per sub-issue/file group             |
| 6    | Verification      | QA team checks every acceptance criterion; full lint/test/build chain         |
| 7    | Review            | Review team (correctness + style); check diff for debug code/TODOs            |
| 8    | PR                | `gh pr create --draft`, link issue, include manual testing steps              |

Detailed instructions per step:
@docs/workflow-1-discovery.md
@docs/workflow-2-specification.md
@docs/workflow-3-architecture.md
@docs/workflow-4-design.md
@docs/workflow-5-implementation.md
@docs/workflow-6-verification.md
@docs/workflow-7-review.md
@docs/workflow-8-pr.md

## Scripts CLI

The `scripts` command is globally available (linked from `~/Projects/scripts`). It provides cross-repo utilities for dependencies, file search, git operations, and GitHub label migration. Most commands accept `--all` to operate on all repos in `~/Projects/`.

Run `scripts --help` or `scripts <command> --help` for details on available commands and options.

@RTK.md
