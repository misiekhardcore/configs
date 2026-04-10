# Step 6 — Verification

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
