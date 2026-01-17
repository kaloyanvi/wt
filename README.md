# wt - Git Worktree Helper

A shell plugin for managing git worktrees with editor integration.

**Supports:** zsh, bash

## Features

- Create new worktrees in a dedicated sibling directory (`<project>-worktrees/`)
- Always creates from the main repository, even when run from another worktree
- Interactive picker for switching between worktrees
- Optional editor integration (Cursor, VS Code, etc.)

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
wt co           # Pick worktree and cd into it
wt co -c        # Same, but also open in Cursor
```

Shows an interactive picker (use arrow keys to navigate, Enter to select, q to cancel).

### List all worktrees

```bash
wt list
```

Displays all worktrees with their paths, marking `(main)` and `(current)`.

### Remove a worktree

```bash
wt remove
```

Interactively select and remove a worktree. If you're currently inside the worktree being removed, you'll be moved to the main repository first.

### Update to latest version

```bash
wt update
```

Pulls the latest version from GitHub.

## Uninstall

```bash
wt uninstall
```

## Configuration

### Editor

The `-c` flag automatically detects your editor. It checks for these in order:

1. `cursor` (Cursor)
2. `code` (VS Code)
3. `zed` (Zed)
4. `subl` (Sublime Text)
5. `idea` (IntelliJ IDEA)
6. `webstorm` (WebStorm)
7. `atom` (Atom)

To override the auto-detection:

```bash
# Add to your .zshrc or .bashrc
export WT_EDITOR="code"
```

## License

MIT
