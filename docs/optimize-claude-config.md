# Claude Code Config Optimization

This document and the companion `optimize-claude-config.patch` describe a set
of changes to `claude-config` (the submodule mounted at `claude/`) that reduce
input tokens, tighten the auto-loaded context window, and route each
orchestrator skill to an appropriate model + thinking budget.

The changes were authored from a session that does not have push access to
`misiekhardcore/claude-config`, so they are landed here as a patch for manual
replay rather than as a submodule pointer bump.

## How to apply

```sh
cd claude
git checkout -b claude/optimize-claude-usage-ITste
git am ../docs/optimize-claude-config.patch
git push -u origin claude/optimize-claude-usage-ITste
# open a PR in misiekhardcore/claude-config, merge to main, then:
cd ..
git submodule update --remote claude
git add claude
git commit -m "chore: bump claude submodule to optimized config"
```

## Summary of changes

### `settings.json`

| Field | Before | After | Why |
|---|---|---|---|
| `model` | `opus[1m]` | `sonnet` | Sonnet handles ~80% of coding work at a fraction of the cost. Promote to Opus per-session via `/model`. |
| `effortLevel` | `high` | `medium` | Per-skill `effortLevel` still overrides this for the design trio. |
| `env.CLAUDE_CODE_SUBAGENT_MODEL` | — | `haiku` | Routes Task/Explore subagents to Haiku — large win for fan-out. |
| `env.DISABLE_TELEMETRY` | — | `1` | Free. |
| `permissions.allow` | dup `Edit`, phantom `Update` | cleaned | `Update` is not a real Claude Code tool; duplicate `Edit` was a no-op. |
| `enabledPlugins` | 10 enabled | 7 enabled | Disabled `chrome-devtools-mcp`, `claude-code-setup`, `code-simplifier` (overlaps built-in `/simplify`). Each disabled plugin removes its tool/skill metadata from every system prompt. |

`claude-hud` is intentionally kept enabled — the `statusLine` command depends
on `${CLAUDE_CONFIG_DIR}/plugins/cache/claude-hud/...` resolving, and disabling
the plugin would break the status line.

### `CLAUDE.md`

- The "Always use agent teams for non-trivial implementation" rule was
  forcing `TeamCreate` fan-out on tasks that one agent would finish faster.
  Replaced with a default-to-single-agent rule that reserves teams for 3+
  parallelizable units of work.
- Dropped the `@RTK.md` auto-import. RTK is invoked transparently by the
  `rtk-rewrite.sh` PreToolUse hook, so the agent rarely needs to read its
  reference. Replaced with a one-line on-demand pointer.

### Skills

| Skill | Model | Thinking |
|---|---|---|
| `discovery` | `opus` | `effortLevel: high` |
| `define` | `opus` | `effortLevel: high` |
| `architecture` | `opus` | `effortLevel: high` |
| `review` | `sonnet` | `effortLevel: high` |
| `implement` | `sonnet` | (default) |
| `build` | `sonnet` | (default) |

The design trio (`discovery` → `define` → `architecture`) keeps Opus + high
effort because they reason about complex features, run rarely per-feature, and
their output cascades into implementation. The build/implement pair stays on
Sonnet because the work is mechanical and they're invoked far more often.
`review` sits in the middle: Sonnet lead with high effort, with a documented
`/review --deep` escape hatch when reviewers should be promoted to Opus on
risky PRs.

## Verification

After replaying the patch and bumping the submodule:

1. `python3 -m json.tool < claude/settings.json > /dev/null` — JSON is valid.
2. `bash claude/install.sh` — symlinks resolve cleanly.
3. Start a fresh Claude Code session:
   - default model shows `sonnet`
   - `enabledPlugins` count is 7
   - `CLAUDE_CODE_SUBAGENT_MODEL=haiku` is exported
4. Run a trivial fix in a real repo and confirm the session no longer
   auto-spawns a `TeamCreate`.
5. Run `/discovery` against a non-trivial idea and confirm the lead runs on
   Opus (visible in `/cost`).
6. Edit a `.ts` file with an obvious ESLint error in a project with eslint
   configured — confirm the `lint-on-write.sh` hook still reports it.
7. Run `git status` in a fresh session and confirm `rtk gain` reflects the
   call (RTK rewrite hook still firing).
