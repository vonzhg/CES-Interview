# Git + Cloud Setup Guide for CES-Interview

This project lives inside OneDrive while keeping the real Git database outside
OneDrive to avoid repository corruption.

## Canonical layout

Working tree in OneDrive:

`/Users/zfeng/Library/CloudStorage/OneDrive-Personal/Professional-works/CES/CES-Interviews-经邦论策`

Real Git database on local disk:

`$HOME/.codex/memories/gitdirs/CES-Interview.git`

GitHub remote:

`https://github.com/vonzhg/CES-Interview.git`

## Why this setup exists

OneDrive should sync manuscripts, transcripts, outlines, and CVs, but not a live
`.git` directory. Git internals are not safe under per-file cloud sync. This repo
uses:

- a `.git` pointer file inside the OneDrive folder
- a real gitdir on local disk under `~/.codex/memories/gitdirs/`
- a `.git-bundle` file in the OneDrive folder for cross-Mac repo recovery
- `.githooks/` to block files larger than 10 MB and refresh the bundle after commits

Audio/video recordings (`.mp4`, `.m4a`, etc.) are excluded from Git entirely via
`.gitignore`.

## First-time setup on a new Mac

From the OneDrive project folder:

```bash
./git-sync.sh
git pull origin main
```

`git-sync.sh` rebuilds the local gitdir from `.git-bundle`, rewrites the `.git`
pointer file for the current Mac, restores the remote URL, and enables hooks.

## Daily use

```bash
git add ...
git commit -m "..."
git push origin main
```

After each commit, `.githooks/post-commit` refreshes `.git-bundle` so OneDrive can
sync the repository history to the other Mac.

## Recovery

If Git stops working in the OneDrive folder:

```bash
cat .git
./git-sync.sh rebuild
git status
```

If both the pointer and bundle are unusable, re-clone from GitHub using a
separate gitdir and then re-enable hooks:

```bash
git clone \
  --separate-git-dir="$HOME/.codex/memories/gitdirs/CES-Interview.git" \
  https://github.com/vonzhg/CES-Interview.git \
  "/Users/zfeng/Library/CloudStorage/OneDrive-Personal/Professional-works/CES/CES-Interviews-经邦论策"

git config core.hooksPath .githooks
```
