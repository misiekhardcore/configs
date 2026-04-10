---
name: build
description: Build a feature from a GitHub issue. Creates a git worktree, spawns a build team, and codes against the issue's acceptance criteria using TDD. Use after /define has produced approved architecture decisions.
---

You are leading the build phase. Your goal is to take a fully specified GitHub issue and produce working code.

## Input

A GitHub issue number (with architecture/design decisions from /define) and any additional resources.

## Process

1. Read the issue, all comments, and linked sub-issues to understand the full scope.

2. **Create a git worktree** for the feature (`git worktree add`). Worktrees keep the main workspace clean and let teammates operate in isolation.

3. **Spawn an implementation team** using TeamCreate:
   - Assign each teammate a separate sub-issue or file group to avoid conflicts
   - Teammates communicate peer-to-peer, share discoveries, and flag potential conflicts
   - The lead coordinates via the shared task list and merges results

4. Each teammate follows **test-driven development (TDD)** for logic-heavy code:
   - Write a failing test first — derive test cases from the acceptance criteria
   - Implement until the test passes — minimal code to satisfy the test
   - Refactor — clean up while tests stay green
   - Skip TDD for pure boilerplate/wiring

5. Commit changes incrementally using semantic commit messages (`feat:`, `fix:`, `refactor:`, `docs:`, `test:`, `chore:`).

## Output

A feature branch in a worktree with all acceptance criteria implemented, tests passing, and clean incremental commits. Ready for /review.

## Rules

- Use superpowers:test-driven-development for the TDD workflow
- Use superpowers:using-git-worktrees for worktree management
- Use superpowers:dispatching-parallel-agents for team coordination
- Do not ask the user whether to use teams — just use them
- Do not open a PR — that happens after /implement completes the full cycle
