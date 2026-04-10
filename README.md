# configs

Shared configuration files for syncing across machines.

## Claude Code

Global [Claude Code](https://claude.ai/code) configuration — workflow rules, permissions, plugin settings, and MCP servers.

### Setup

```bash
bash claude/install.sh               # symlink configs + generate mcp.json from template
```

This symlinks `CLAUDE.md`, `settings.json`, hooks, and skills into `~/.claude/`.
Templated files (like `mcp.json.template`) are generated via `envsubst`.
Existing files are backed up as `.bak`.

### Optional tools

```bash
bash claude/install-tools.sh         # interactive installer for rudel, pi-self-learning
```

### Files

- `claude/CLAUDE.md` — Global instructions loaded in every session (feature workflow, toolchain, project reference)
- `claude/settings.json` — Permissions, enabled plugins, effort level
- `claude/mcp.json.template` — MCP server definitions (supports `${VAR}` placeholders via `envsubst`)
- `claude/install.sh` — Symlink + template installer
- `claude/install-tools.sh` — Optional CLI tools (rudel, pi-self-learning)
- `claude/docs/ai-champion-reference.md` — Curated learning reference from [ai-kit](https://github.com/urbanisierung/ai-kit)

## Renovate

Shared [Renovate](https://docs.renovatebot.com/) preset config.

### Usage

Add to your `renovate.json`:

```json
{
  "extends": ["github>misiekhardcore/configs//renovate/default"]
}
```
