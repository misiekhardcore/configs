# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Feature Workflow

When working on any feature or task, always follow this loop:

1. **Branch** — Create a feature branch off main (`git checkout -b feat/short-description`)
2. **Plan** — Thoroughly plan the architecture before writing code. Use plan mode. Read existing code patterns first to stay consistent. Consider whether existing code needs refactoring for a cleaner solution — prefer refactoring over bolting on. Get alignment before proceeding
3. **Implement** — Write the code. Commit changes incrementally along the way with meaningful messages
4. **Test** — Run the full verification chain:
   - Type-check: `tsc --noEmit`
   - Lint: `yarn lint` / `npm run lint`
   - Unit tests: `yarn test` / `npm test` — write new tests for new behavior
   - Build: `yarn build` / `npm run build`
   - **Next.js projects:** Use Playwright (via MCP) to test changes in the browser — start the dev server, navigate to affected pages, verify the UI works as expected
   - **VSCode extension projects:** Run `npm run test:e2e` to launch the extension in a debug session and verify behavior end-to-end
   - **Cypress projects:** Run `yarn e2e` for end-to-end browser tests
5. **Repeat steps 3-4** until everything passes and the implementation is complete
6. **Self-review** — Check `git diff main...HEAD` for leftover debug code, forgotten TODOs, or accidental changes
7. **Draft PR** — Push the branch and open a draft PR (`gh pr create --draft`)

Do this for every feature, bug fix, or significant change — no exceptions.

## Environment

- **User:** Michal Konopski
- **OS:** Ubuntu Linux
- **Node:** v25.x (managed via nvm)
- **Git default branch:** main

## Shared Toolchain

Most projects in `~/Projects/` are TypeScript and share this stack:

| Tool | Version | Notes |
|------|---------|-------|
| Package manager | Yarn 4.x (Berry) | `nodeLinker: node-modules` in `.yarnrc.yml`. Exception: VSCode extensions use npm |
| TypeScript | 5.x | Strict mode |
| ESLint | 9.x | **Flat config** (`eslint.config.mjs`), not legacy `.eslintrc` |
| Prettier | 3.x | Integrated via `eslint-plugin-prettier`. `singleQuote: true`, `tabWidth: 2` |
| Testing | Jest + ts-jest | Next.js projects use `next/jest`. Some projects also have Cypress for e2e |
| Git hooks | Husky 9.x + lint-staged 16.x | Pre-commit: tsc --noEmit, eslint --fix, prettier --write |

## Common Commands (Yarn-based Projects)

```bash
yarn dev                # Next.js dev server (Turbopack)
yarn build              # lint + build
yarn test               # jest
yarn test:watch         # jest --watch
yarn lint               # eslint --cache
yarn lint-fix           # eslint --fix
yarn e2e                # cypress run --browser chrome (where available)
```

## Scripts CLI

The `scripts` command is globally available (linked from `~/Projects/scripts`). It provides cross-repo utilities for dependencies, file search, git operations, and GitHub label migration. Most commands accept `--all` to operate on all repos in `~/Projects/`.

Run `scripts --help` or `scripts <command> --help` for details on available commands and options.

## Projects Quick Reference

### Next.js Web Apps (Yarn)
- **konopskiwebdev** — Full-stack: Drizzle ORM, PostgreSQL, next-auth, Docker Compose
- **nextjs-lms** — Learning management system
- **color-scale-generator** — Color tool

### Other TypeScript (Yarn)
- **scripts** — CLI utilities (inquirer, yargs, chalk)
- **configs** — Shared Renovate config + Claude Code global config

### VSCode Extensions (npm)
- **vscode-gcode-extension** — LSP extension for G-code. Has its own AGENTS.md with architecture rules
- **stl-previewer** — STL file previewer
