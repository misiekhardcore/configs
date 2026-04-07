# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Feature Workflow

The workflow below describes the **maximum** process. The main conversation decides which phases to engage based on task complexity:

- **Trivial fix** (obvious problem + solution) → skip to step 5, implement + PR
- **Medium feature** → steps 1-2, then 5-8
- **Large feature / epic** → full workflow 1-8

### 1. Discovery

Use /grill-me skill to understand the problem, requirements, edge cases, and constraints. Explore the codebase, ask hard questions, and resolve ambiguity before specifying anything.

### 2. Specification

Create a GitHub issue from the discovery output (`gh issue create`). The issue must have:

- **Problem statement** — clear description of what and why
- **Acceptance criteria** — as concrete, testable scenarios (these drive TDD later)
- **Scope** — well-defined boundaries; one issue = one cohesive unit of work
- All of the above with the rigor of a senior principal software engineer

The user must approve the issue before proceeding. Do not start coding until sign-off.

**Issue management rules:**

- Every feature has at least one issue and at least one PR closing it
- Epics get sub-issues linked with GitHub issue relationships (parent/child)
- Related issues linked with GitHub relationships
- Issue bodies kept up to date throughout the lifecycle

### 3. Architecture

Dispatch a **team** to research in parallel — each teammate analyzes a different area (codebase structure, external APIs/protocols, prior art) and shares findings via peer-to-peer messages. Synthesize findings into architecture decisions:

- **Update the issue body** with architecture decisions and approach
- **Create sub-issues** with GitHub relationships if the work can be decomposed
- **Add comments** under the issue for secondary decisions and trade-offs that don't belong in the description
- **Define the dependency graph** between sub-tasks and identify what can be parallelized
- For complex tasks, dispatch a second team to critique the plan — teammates challenge assumptions and debate trade-offs before finalizing
- Optionally create a plan file for tactical execution steps — **must be deleted after implementation is complete**

### 4. Design (optional — visual/UI tasks only)

When the task has visual aspects (webview, frontend pages, components):

- Design agent proposes **2-3 visual approaches** as code prototypes with screenshots
- User picks one (or asks for iterations)
- The chosen design becomes a constraint for implementationso

Skip for non-visual work (parsers, services, CLI, etc.).

### 5. Implementation

Create a feature branch off main (`git checkout -b feat/short-description`).

Use **test-driven development (TDD)** for logic-heavy code:

- **Write a failing test first** — derive test cases from the acceptance criteria on the issue
- **Implement until the test passes** — minimal code to satisfy the test
- **Refactor** — clean up while tests stay green
- **Repeat** for each unit of work
- Skip TDD for pure boilerplate/wiring (handler registration, thin adapters, factory methods with no logic)

Use **agent teams** when sub-issues are independent — assign each teammate a separate sub-issue on different files to avoid conflicts (teammates don't share file state). Teammates communicate peer-to-peer, share discoveries, and flag potential conflicts. The lead coordinates via the shared task list and merges results. Commit changes incrementally using semantic commit messages (`feat:`, `fix:`, `refactor:`, `docs:`, `test:`, `chore:`).

### 6. Verification

Dispatch a **QA team** to check **every acceptance criterion** from the issue — teammates split criteria across themselves, cross-verify each other's findings via messages, and discuss edge cases:

- Run the code and verify the feature works end-to-end
- Report pass/fail per criterion with evidence (test output, screenshots)
- Do **not** fix issues — only report findings

Loop: engineer fixes findings → QA team re-checks → repeat until the team agrees the implementation is good enough.

Run the full verification chain:

- Type-check: `tsc --noEmit`
- Lint: `yarn lint` / `npm run lint`
- Unit tests: `yarn test` / `npm test`
- Build: `yarn build` / `npm run build`
- **Frontend projects:** Use browser automation (Playwright via MCP, Cypress, etc.) to test UI changes end-to-end
- **VSCode extension projects:** Run `npm run test:e2e` for Extension Host tests
- Run any additional e2e or integration test suites defined in the project

### 7. Review

Dispatch a **review team** — one teammate focuses on correctness, another on style/standards. Check `git diff main...HEAD` for leftover debug code, forgotten TODOs, or accidental changes. Teammates discuss disagreements via messages and converge on a unified review.

### 8. PR

Push the branch and open a draft PR (`gh pr create --draft`). Link to the issue:

- `Closes #<issue>` — if this is the only PR or the final PR that completes the issue
- `Related to #<issue>` — if this is a partial implementation (one of multiple PRs for the issue)

PR description must include a **"Manual testing"** section with concrete steps to verify the change (not a checklist of TODOs, but actual repro steps someone can follow).

Delete the plan file if one was created during architecture.

## Scripts CLI

The `scripts` command is globally available (linked from `~/Projects/scripts`). It provides cross-repo utilities for dependencies, file search, git operations, and GitHub label migration. Most commands accept `--all` to operate on all repos in `~/Projects/`.

Run `scripts --help` or `scripts <command> --help` for details on available commands and options.

@RTK.md
