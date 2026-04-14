---
problem_type: bug
module: claude-config
component: install.sh
symptoms:
  - New file added to submodule but ~/.claude/<file> symlink missing after install
  - CLAUDE.md references a file (e.g. ~/.claude/REFERENCE.md) that doesn't exist
root_cause: install.sh's files=() array was not updated when a new file was added to the repo
tags:
  - install
  - symlink
  - dotfiles
severity: low
date: 2026-04-14
---

# install.sh Missing New File in Symlink List

## Problem

A new file (`REFERENCE.md`) was added to the submodule but `~/.claude/REFERENCE.md` was never created after running `install.sh`, causing a broken reference in `CLAUDE.md`.

## Symptoms

- `CLAUDE.md` references `~/.claude/REFERENCE.md` but the file doesn't exist
- Running `install.sh` does not create the expected symlink
- Manual `ln -s` needed as a workaround

## Solution

Add the filename to the `files=()` array in `install.sh`:

```bash
# install.sh
files=(CLAUDE.md settings.json RTK.md REFERENCE.md)
#                                      ^^^^^^^^^^^^ add here
```

Commit both the new file and the install.sh update together.

## Why It Works

`install.sh` iterates `files=()` and creates a symlink for each entry at `~/.claude/<file>`. Files not in the array are silently skipped.

## Prevention

When adding any file to the submodule that should be available at `~/.claude/<file>`, update `files=()` in the same commit. The pattern to check: does `CLAUDE.md` or any skill reference `~/.claude/<new-file>`? If yes, it needs to be in `files=()`.
