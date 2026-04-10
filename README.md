# configs

Shared configuration files for syncing across machines. Each config is a [git submodule](https://git-scm.com/book/en/v2/Git-Tools-Submodules) that can be used independently.

```bash
git clone --recurse-submodules git@github.com:misiekhardcore/configs.git
```

## Submodules

| Path        | Repo                                                                 | Description                                                         |
| ----------- | -------------------------------------------------------------------- | ------------------------------------------------------------------- |
| `claude/`   | [claude-config](https://github.com/misiekhardcore/claude-config)     | Claude Code global configuration — skills, hooks, plugins, settings |
| `renovate/` | [renovate-config](https://github.com/misiekhardcore/renovate-config) | Shared Renovate preset configuration                                |
| `tmux/`     | [tmux-config](https://github.com/misiekhardcore/tmux-config)         | tmux configuration                                                  |

## Claude Code

See [claude-config](https://github.com/misiekhardcore/claude-config) for full docs.

```bash
bash claude/install.sh               # symlink configs + generate mcp.json from template
```

## Renovate

Add to your `renovate.json`:

```json
{
  "extends": ["github>misiekhardcore/renovate-config//default"]
}
```

## tmux

```bash
bash tmux/install.sh
```
