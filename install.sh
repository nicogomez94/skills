#!/usr/bin/env bash
set -euo pipefail
umask 077

REPO_URL="${SKILLS_REPO:-https://github.com/nicogomez94/skills.git}"
BRANCH="${SKILLS_BRANCH:-main}"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
SKILLS_DIR="${CODEX_SKILLS_DIR:-$CODEX_HOME/skills}"
ALLOW_REMOTE_CHANGE="${SKILLS_ALLOW_REMOTE_CHANGE:-0}"
ALLOW_DIRTY="${SKILLS_ALLOW_DIRTY:-0}"

die() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

info() {
  printf '%s\n' "$*"
}

mkdir -p "$CODEX_HOME"
mkdir -p "$SKILLS_DIR"

if command -v flock >/dev/null 2>&1; then
  exec 9>"$SKILLS_DIR/.install.lock"
  flock -n 9 || die "another skills install/update is already running in $SKILLS_DIR"
fi

if [ -d "$SKILLS_DIR/.git" ]; then
  current_origin="$(git -C "$SKILLS_DIR" remote get-url origin 2>/dev/null || true)"
  if [ -z "$current_origin" ]; then
    git -C "$SKILLS_DIR" remote add origin "$REPO_URL"
    current_origin="$REPO_URL"
  fi

  if [ "$current_origin" != "$REPO_URL" ]; then
    if [ "$ALLOW_REMOTE_CHANGE" != "1" ]; then
      die "origin is '$current_origin' but expected '$REPO_URL'. Set SKILLS_ALLOW_REMOTE_CHANGE=1 to update it explicitly."
    fi
    git -C "$SKILLS_DIR" remote set-url origin "$REPO_URL"
  fi

  if [ -n "$(git -C "$SKILLS_DIR" status --porcelain)" ] && [ "$ALLOW_DIRTY" != "1" ]; then
    die "local changes exist in $SKILLS_DIR. Commit, stash, or clean them first, or set SKILLS_ALLOW_DIRTY=1 if you intentionally want to proceed."
  fi

  git -C "$SKILLS_DIR" fetch --prune origin "$BRANCH"

  if git -C "$SKILLS_DIR" show-ref --verify --quiet "refs/heads/$BRANCH"; then
    git -C "$SKILLS_DIR" checkout "$BRANCH"
  else
    git -C "$SKILLS_DIR" checkout -B "$BRANCH" "origin/$BRANCH"
  fi

  git -C "$SKILLS_DIR" pull --ff-only origin "$BRANCH"
else
  existing_item="$(find "$SKILLS_DIR" -mindepth 1 -maxdepth 1 ! -name ".system" | head -n 1 || true)"

  if [ -n "$existing_item" ]; then
    die "cannot install over $SKILLS_DIR because it already contains non-.system files. Move them out, or initialize the repo manually first."
  fi

  git -C "$SKILLS_DIR" init
  git -C "$SKILLS_DIR" remote add origin "$REPO_URL"
  git -C "$SKILLS_DIR" fetch --prune origin "$BRANCH"
  git -C "$SKILLS_DIR" checkout -B "$BRANCH" "origin/$BRANCH"
fi

info "Skills installed/updated in $SKILLS_DIR"
git -C "$SKILLS_DIR" status --short --branch || true
info "Restart Codex to pick up new skills."
