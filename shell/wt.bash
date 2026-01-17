# wt - Git Worktree Helper (bash wrapper)
# https://github.com/kaloyanvi/wt
#
# Source this file in your .bashrc

# Resolve the installation directory.
# Note: BASH_SOURCE[0] gives the path to this script.
_wt_get_install_dir() {
    local source="${BASH_SOURCE[0]}"
    # Resolve symlinks.
    while [[ -L "$source" ]]; do
        local dir="$(cd -P "$(dirname "$source")" && pwd)"
        source="$(readlink "$source")"
        [[ "$source" != /* ]] && source="$dir/$source"
    done
    local dir="$(cd -P "$(dirname "$source")" && pwd)"
    echo "$(dirname "$dir")"
}

export WT_INSTALL_DIR="$(_wt_get_install_dir)"

# Detect editor if not explicitly set.
_wt_detect_editor() {
    # User override takes precedence.
    [[ -n "${WT_EDITOR:-}" ]] && { echo "$WT_EDITOR"; return; }

    # Check for common editors in order of preference.
    local editors=(cursor code zed subl idea webstorm atom)
    local editor
    for editor in "${editors[@]}"; do
        command -v "$editor" >/dev/null 2>&1 && { echo "$editor"; return; }
    done

    # No editor found.
    echo ""
}

wt() {
    local output
    local exit_code=0
    local cd_path=""
    local cursor_path=""

    # Run the core script and capture output.
    output="$("${WT_INSTALL_DIR}/bin/wt-core" "$@")"

    # Process each line of output.
    local line
    while IFS= read -r line; do
        case "$line" in
            __WT_CD__:*)
                cd_path="${line#__WT_CD__:}"
                ;;
            __WT_CURSOR__:*)
                cursor_path="${line#__WT_CURSOR__:}"
                ;;
            __WT_EXIT__:*)
                exit_code="${line#__WT_EXIT__:}"
                ;;
            *)
                echo "$line"
                ;;
        esac
    done <<< "$output"

    # Execute directives.
    if [[ -n "$cursor_path" ]]; then
        local editor
        editor="$(_wt_detect_editor)"
        if [[ -n "$editor" ]]; then
            "$editor" -n "$cursor_path" 2>/dev/null || "$editor" "$cursor_path" 2>/dev/null || true
        fi
    fi

    if [[ -n "$cd_path" ]]; then
        cd "$cd_path" || return 1
        pwd
    fi

    return "$exit_code"
}
