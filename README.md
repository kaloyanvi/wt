# wt - Git Worktree Helper

A shell plugin for managing git worktrees with Cursor IDE integration.

**Supports:** zsh, bash

## Features

- Create new worktrees in a dedicated sibling directory (`<project>-worktrees/`)
- Always creates from the main repository, even when run from another worktree
- Interactive picker for switching between worktrees
- Optional Cursor IDE integration

## Installation

### One-liner

```bash
curl -fsSL https://raw.githubusercontent.com/kaloyanvi/wt/main/install.sh | bash
```

The installer automatically detects your shell (zsh or bash) and configures it.

### Manual

```bash
git clone https://github.com/kaloyanvi/wt.git ~/.wt

# For zsh - add to ~/.zshrc:
source "${HOME}/.wt/shell/wt.zsh"

# For bash - add to ~/.bashrc:
source "${HOME}/.wt/shell/wt.bash"
```

Then restart your shell or source your config file.

## Usage

### Create a new worktree

```bash
wt create feature-name       # Create worktree and cd into it
wt create feature-name -c    # Same, but also open in Cursor
```

This creates:
- A new branch named `feature-name`
- A new worktree at `../<project>-worktrees/feature-name`

### Switch to an existing worktree

```bash
wt co
```

Shows an interactive menu to pick a worktree. On selection:
- Opens the worktree in a new Cursor window
- Changes the current terminal directory to the worktree

### Update to latest version

```bash
wt update
```

Pulls the latest version from GitHub.

## Uninstall

```bash
wt uninstall
```

## License

MIT
