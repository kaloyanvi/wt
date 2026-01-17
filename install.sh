#!/usr/bin/env bash
# wt installer - https://github.com/kaloyanvidelov/wt

set -e

WT_DIR="${HOME}/.wt"
REPO_URL="https://github.com/kaloyanvi/wt.git"

echo "Installing wt..."

# -----------------------------------------------------------------------------
# Clone or update the repo
# -----------------------------------------------------------------------------

if [[ -d "$WT_DIR" ]]; then
    echo "Updating existing installation..."
    git -C "$WT_DIR" pull --ff-only
else
    echo "Cloning wt to ${WT_DIR}..."
    git clone "$REPO_URL" "$WT_DIR"
fi

# Make the core script executable.
chmod +x "${WT_DIR}/bin/wt-core"

# -----------------------------------------------------------------------------
# Detect shell and configure
# -----------------------------------------------------------------------------

detect_shell() {
    # Check the current shell or fall back to SHELL env var.
    if [[ -n "${ZSH_VERSION:-}" ]]; then
        echo "zsh"
    elif [[ -n "${BASH_VERSION:-}" ]]; then
        echo "bash"
    elif [[ "$SHELL" == *"zsh"* ]]; then
        echo "zsh"
    elif [[ "$SHELL" == *"bash"* ]]; then
        echo "bash"
    else
        echo "unknown"
    fi
}

DETECTED_SHELL="$(detect_shell)"

case "$DETECTED_SHELL" in
    zsh)
        SHELL_CONFIG="${HOME}/.zshrc"
        SOURCE_LINE='source "${HOME}/.wt/shell/wt.zsh"'
        WRAPPER_FILE="shell/wt.zsh"
        ;;
    bash)
        SHELL_CONFIG="${HOME}/.bashrc"
        SOURCE_LINE='source "${HOME}/.wt/shell/wt.bash"'
        WRAPPER_FILE="shell/wt.bash"
        ;;
    *)
        echo ""
        echo "Warning: Could not detect your shell (zsh or bash)."
        echo "Please manually add one of the following to your shell config:"
        echo ""
        echo "  For zsh (~/.zshrc):"
        echo '    source "${HOME}/.wt/shell/wt.zsh"'
        echo ""
        echo "  For bash (~/.bashrc):"
        echo '    source "${HOME}/.wt/shell/wt.bash"'
        echo ""
        exit 0
        ;;
esac

# Add source line to shell config if not already present.
if [[ -f "$SHELL_CONFIG" ]] && grep -qF "$WRAPPER_FILE" "$SHELL_CONFIG" 2>/dev/null; then
    echo "wt already configured in ${SHELL_CONFIG}"
else
    echo "" >> "$SHELL_CONFIG"
    echo "# wt - Git Worktree Helper" >> "$SHELL_CONFIG"
    echo "$SOURCE_LINE" >> "$SHELL_CONFIG"
    echo "Added wt to ${SHELL_CONFIG}"
fi

echo ""
echo "Done! Restart your shell or run:"
echo "  source ${SHELL_CONFIG}"
