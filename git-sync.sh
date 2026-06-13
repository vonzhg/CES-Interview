#!/usr/bin/env bash
#
# git-sync.sh - portable Git setup for a OneDrive-synced working tree.
#
# Stores the full repo history as a single .git-bundle file that OneDrive
# can safely sync. On any Mac, running this script will either:
#   (a) export a fresh bundle   - if a working Git repo is already configured, or
#   (b) rebuild Git from bundle - if Git is not yet set up on this machine.
#
# Usage:
#   ./git-sync.sh            # auto-detect: export or rebuild
#   ./git-sync.sh export     # force export (update the bundle)
#   ./git-sync.sh rebuild    # force rebuild from bundle
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BUNDLE_FILE="$SCRIPT_DIR/.git-bundle"
GIT_POINTER="$SCRIPT_DIR/.git"
EXTERNAL_GIT_DIR="$HOME/.codex/memories/gitdirs/CES-Interview.git"
REMOTE_URL="https://github.com/vonzhg/CES-Interview.git"

git_is_working() {
    git -C "$SCRIPT_DIR" rev-parse --git-dir >/dev/null 2>&1
}

bundle_exists() {
    [[ -f "$BUNDLE_FILE" ]]
}

print_header() {
    printf '\n\033[1;36m▸ %s\033[0m\n' "$1"
}

print_ok() {
    printf '  \033[0;32m%s %s\033[0m\n' "OK" "$1"
}

print_warn() {
    printf '  \033[0;33m%s %s\033[0m\n' "WARN" "$1"
}

print_err() {
    printf '  \033[0;31m%s %s\033[0m\n' "ERR" "$1"
}

do_export() {
    print_header "Exporting Git history to .git-bundle"

    if ! git_is_working; then
        print_err "Git is not set up in this working tree. Cannot export."
        print_warn "Run: ./git-sync.sh rebuild"
        exit 1
    fi

    git -C "$SCRIPT_DIR" bundle create "$BUNDLE_FILE" --all
    local size
    size=$(du -h "$BUNDLE_FILE" | cut -f1)
    print_ok "Bundle written: .git-bundle ($size)"
    print_ok "OneDrive will sync this file to your other Macs."
}

do_rebuild() {
    print_header "Rebuilding Git from .git-bundle"

    if ! bundle_exists; then
        print_err "No .git-bundle found. Nothing to rebuild from."
        print_warn "Either run this on the Mac that has the repo, or clone from GitHub first."
        exit 1
    fi

    local verify_ok=false
    if git_is_working; then
        git -C "$SCRIPT_DIR" bundle verify "$BUNDLE_FILE" >/dev/null 2>&1 && verify_ok=true
    else
        local verify_dir
        verify_dir=$(mktemp -d)
        git init --bare "$verify_dir/verify.git" >/dev/null 2>&1
        git --git-dir="$verify_dir/verify.git" bundle verify "$BUNDLE_FILE" >/dev/null 2>&1 && verify_ok=true
        rm -rf "$verify_dir"
    fi

    if ! "$verify_ok"; then
        print_err "Bundle verification failed. The file may be corrupted or still syncing."
        print_warn "Wait for OneDrive to finish downloading, then retry."
        exit 1
    fi

    mkdir -p "$(dirname "$EXTERNAL_GIT_DIR")"

    if [[ -d "$EXTERNAL_GIT_DIR" ]]; then
        print_warn "External git dir already exists: $EXTERNAL_GIT_DIR"
        printf '  Overwrite it? [y/N] '
        read -r answer
        if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
            echo "  Aborted."
            exit 0
        fi
        rm -rf "$EXTERNAL_GIT_DIR"
    fi

    local tmpdir
    tmpdir=$(mktemp -d)
    git clone --bare "$BUNDLE_FILE" "$tmpdir/repo.git"

    git -C "$tmpdir/repo.git" config core.bare false
    git -C "$tmpdir/repo.git" config core.worktree "$SCRIPT_DIR"

    mv "$tmpdir/repo.git" "$EXTERNAL_GIT_DIR"
    rm -rf "$tmpdir"

    git --git-dir="$EXTERNAL_GIT_DIR" remote set-url origin "$REMOTE_URL"
    git --git-dir="$EXTERNAL_GIT_DIR" config core.hooksPath .githooks

    echo "gitdir: $EXTERNAL_GIT_DIR" > "$GIT_POINTER"

    git -C "$SCRIPT_DIR" reset HEAD -- . >/dev/null 2>&1 || true

    print_ok "External git dir: $EXTERNAL_GIT_DIR"
    print_ok "Pointer file: .git -> $EXTERNAL_GIT_DIR"
    print_ok "Remote origin: $REMOTE_URL"

    echo ""
    print_header "Verify"
    echo "  git -C \"$SCRIPT_DIR\" status --short --branch"
    git -C "$SCRIPT_DIR" status --short --branch 2>&1 | head -5 | sed 's/^/  /'

    echo ""
    print_ok "Done. You can now use Git normally in this folder."
    print_warn "Run 'git pull' to fetch any commits pushed after the bundle was created."
}

main() {
    local action="${1:-auto}"

    case "$action" in
        export)
            do_export
            ;;
        rebuild)
            do_rebuild
            ;;
        auto)
            if git_is_working; then
                print_header "Git is already configured on this Mac."
                printf '  Git dir: %s\n' "$(git -C "$SCRIPT_DIR" rev-parse --git-dir)"
                echo ""
                do_export
            elif bundle_exists; then
                print_warn "Git is NOT configured, but .git-bundle found."
                echo ""
                do_rebuild
            else
                print_err "Git is not configured and no .git-bundle exists."
                print_warn "On your primary Mac, run: ./git-sync.sh export"
                print_warn "Or clone from GitHub: see ONEDRIVE_GIT_SETUP.md"
                exit 1
            fi
            ;;
        -h|--help|help)
            echo "Usage: ./git-sync.sh [export|rebuild|auto]"
            echo ""
            echo "  export   - Save repo history to .git-bundle"
            echo "  rebuild  - Recreate local Git setup from .git-bundle"
            echo "  auto     - Detect which action is needed (default)"
            exit 0
            ;;
        *)
            print_err "Unknown action: $action"
            echo "Usage: ./git-sync.sh [export|rebuild|auto]"
            exit 1
            ;;
    esac
}

main "$@"
