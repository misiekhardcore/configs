# Claude Code Config Optimization

`optimize-claude-config.patch` carries a two-commit series against the
`claude-config` submodule mounted at `claude/`. It cuts auto-loaded context,
externalizes reference material, and routes each orchestrator skill to an
appropriate model + thinking budget.

The patch is landed here (instead of as a submodule pointer bump) because the
session that authored it does not have push access to
`misiekhardcore/claude-config`.

## How to apply

```sh
cd claude
git checkout -b claude/optimize-claude-usage-ITste
git am ../docs/optimize-claude-config.patch
git push -u origin claude/optimize-claude-usage-ITste
# open + merge a PR in misiekhardcore/claude-config, then in the parent:
cd ..
git submodule update --remote claude
git add claude
git commit -m "chore: bump claude submodule to optimized config"
```

The patch is two commits — the second is the context-engineering pass on
top of the first. `git am` will apply both in order.

## What changes

### Iteration 1 — model routing, plugin pruning, rule fix

**`settings.json`**

| Field | Before | After | Why |
|---|---|---|---|
| `model` | `opus[1m]` | `sonnet` | Promote per-session via `/model`. |
| `effortLevel` | `high` | `medium` | Per-skill `effortLevel` overrides for the design trio. |
| `env.CLAUDE_CODE_SUBAGENT_MODEL` | — | `haiku` | Routes Task/Explore subagents to Haiku. |
| `env.DISABLE_TELEMETRY` | — | `1` | — |
| `permissions.allow` | dup `Edit`, phantom `Update` | cleaned | `Update` is not a real tool; duplicate `Edit` was a no-op. |
| `enabledPlugins` | 10 enabled | 7 enabled | Disabled `chrome-devtools-mcp`, `claude-code-setup`, `code-simplifier`. |

`claude-hud` stays enabled — the `statusLine` command depends on its plugin
cache directory.

**`CLAUDE.md`**

- Replaced "Always use agent teams" with a default-to-single-agent rule
  (teams reserved for 3+ parallelizable units of work).
- Dropped the `@RTK.md` auto-import; RTK is invoked transparently by the
  `rtk-rewrite.sh` hook.

**Skills**

| Skill | Model | Thinking |
|---|---|---|
| `discovery`, `define`, `architecture` | `opus` | `effortLevel: high` |
| `review` | `sonnet` | `effortLevel: high` |
| `build`, `implement` | `sonnet` | default |

The design trio keeps Opus + high effort — they run rarely per-feature and
their output cascades into implementation. Build/implement stay on Sonnet
because the work is mechanical and they're invoked much more often.

### Iteration 2 — context engineering

Informed by Anthropic's [*Effective context engineering for AI agents*](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents):
*find the smallest set of high-signal tokens; prefer just-in-time over
preloading; canonical examples over exhaustive rules.*

**`CLAUDE.md` (55 → 29 lines)**

- Dropped the "Building-block skills" table — every skill already carries its
  own description in the system prompt, so the table was duplicate metadata.
- Dropped the "Feature Workflow" table; replaced with one canonical worked
  example (medium feature: discovery → implement).
- Moved "Maintenance" + "Scripts CLI" to a new `REFERENCE.md` that is **not**
  auto-imported. CLAUDE.md only mentions it as an on-demand path.
- Added an explicit *just-in-time over preloading* rule that points at
  `REFERENCE.md`, `RTK.md`, and `plugins-reference.md` as on-demand reads.
- Added a *externalize state on long sessions* rule that asks the agent to
  write progress notes to `.claude/notes/<feature>.md` instead of carrying
  them in conversation (the "structured note-taking" lever from the article).

**`REFERENCE.md` (new, ~34 lines)**

On-demand reference. Holds Maintenance, Scripts CLI, RTK meta commands, and
the notes convention. Not auto-loaded.

**`settings.json`**

- `claude-md-management` plugin disabled — overlaps the built-in `update-config`
  skill that's already loaded by the harness. Plugin count is now 6.

**Skill body trims** (no behavior change, denser prose)

| Skill | Change |
|---|---|
| `discovery` | Collapsed the redundant Decision Tree (the bullets above already describe the same triage). |
| `architecture` | Tightened the Auto-deepen paragraph. |
| `define` | Tightened the research-team / gate-rule paragraph. |
| `build` | Replaced the inline 5-question verification check with a pointer to `superpowers:verification-before-completion` — the canonical version is already in the superpowers plugin. |

## Verification

After `git am` and `git submodule update --remote claude`:

1. `python3 -m json.tool < claude/settings.json > /dev/null` — JSON parses.
2. `bash claude/install.sh` — symlinks resolve.
3. Fresh Claude Code session:
   - default model is `sonnet`
   - `enabledPlugins` count is 6 (was 10)
   - `CLAUDE_CODE_SUBAGENT_MODEL=haiku` is exported
   - `~/.claude/REFERENCE.md` exists and is **not** referenced by CLAUDE.md
4. Trivial fix in a real repo no longer auto-spawns `TeamCreate`.
5. `/discovery` against a non-trivial idea runs the lead on Opus.
6. `/build` against a small issue calls `superpowers:verification-before-completion`
   instead of inlining the 5-question check.
7. `lint-on-write.sh` still fires on Edit/Write.
8. `rtk gain` reflects shell calls (RTK rewrite hook still firing).

## What this patch deliberately does **not** do

These came up in the audit but were judged out-of-scope for a single iteration:

- **Aggressive plugin pruning by tool count.** Without runtime measurements
  of how many tool schemas each remaining plugin contributes, blanket cuts
  risk breaking workflows. The `claude-md-management` cut (iteration 2) is
  deliberate because the built-in `update-config` covers it.
- **Shrinking `compound/` and `find-skills/` (the 143-line custom skills).**
  These are the largest custom skills and likely have plugin equivalents
  (`superpowers:compounding-engineering`, `skill-creator`'s discovery), but
  verifying parity needs a careful per-feature audit.
- **Restructuring `/build` and `/implement` around the notes convention.**
  Iteration 2 introduces the convention but does not yet rewrite the skills
  to read/write `.claude/notes/`. Worth a follow-up.
