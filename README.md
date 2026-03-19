# configs

Shared configuration files for syncing across machines.

## Claude Code

Global [Claude Code](https://claude.ai/code) configuration — workflow rules, permissions, and plugin settings.

### Setup

```bash
bash claude/install.sh
```

This symlinks `CLAUDE.md` and `settings.json` into `~/.claude/`. Existing files are backed up as `.bak`.

### Files

- `claude/CLAUDE.md` — Global instructions loaded in every session (feature workflow, toolchain, project reference)
- `claude/settings.json` — Permissions, enabled plugins, effort level
- `claude/install.sh` — Symlink installer

## Renovate

Shared [Renovate](https://docs.renovatebot.com/) preset config.

### Usage

Add to your `renovate.json`:

```json
{
  "extends": ["github>misiekhardcore/configs//renovate/default"]
}
```
