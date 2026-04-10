# Step 5 — Implementation

Create a git worktree for the feature (`git worktree add`). Worktrees keep the main workspace clean and let teammates operate in isolation. Only fall back to a regular branch (`git checkout -b`) for trivial single-file fixes.

Use **test-driven development (TDD)** for logic-heavy code:

- **Write a failing test first** — derive test cases from the acceptance criteria on the issue
- **Implement until the test passes** — minimal code to satisfy the test
- **Refactor** — clean up while tests stay green
- **Repeat** for each unit of work
- Skip TDD for pure boilerplate/wiring (handler registration, thin adapters, factory methods with no logic)

**Default to agent teams** for implementation — assign each teammate a separate sub-issue or file group to avoid conflicts (teammates don't share file state). Teammates communicate peer-to-peer, share discoveries, and flag potential conflicts. The lead coordinates via the shared task list and merges results. Only fall back to inline (single-agent) implementation for trivial fixes or when the change is a single file with no parallelizable work. Do not ask the user whether to use teams — just use them. Commit changes incrementally using semantic commit messages (`feat:`, `fix:`, `refactor:`, `docs:`, `test:`, `chore:`).
