#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${SKILLS_REPO:-https://github.com/nicogomez94/skills.git}"
BRANCH="${SKILLS_BRANCH:-main}"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
SKILLS_DIR="${CODEX_SKILLS_DIR:-$CODEX_HOME/skills}"

mkdir -p "$SKILLS_DIR"

if [ -d "$SKILLS_DIR/.git" ]; then
  if ! git -C "$SKILLS_DIR" remote get-url origin >/dev/null 2>&1; then
    git -C "$SKILLS_DIR" remote add origin "$REPO_URL"
  fi

  git -C "$SKILLS_DIR" remote set-url origin "$REPO_URL"
  git -C "$SKILLS_DIR" fetch origin "$BRANCH"

  if git -C "$SKILLS_DIR" show-ref --verify --quiet "refs/heads/$BRANCH"; then
    git -C "$SKILLS_DIR" checkout "$BRANCH"
  else
    git -C "$SKILLS_DIR" checkout -B "$BRANCH" "origin/$BRANCH"
  fi

  git -C "$SKILLS_DIR" pull --ff-only origin "$BRANCH"
else
  existing_item="$(find "$SKILLS_DIR" -mindepth 1 -maxdepth 1 ! -name ".system" | head -n 1 || true)"

  if [ -n "$existing_item" ]; then
    echo "No puedo instalar sobre $SKILLS_DIR porque ya tiene archivos que no son .system:"
    echo "$existing_item"
    echo "Movelos, o converti esa carpeta en repo manualmente antes de volver a correr este instalador."
    exit 1
  fi

  git -C "$SKILLS_DIR" init
  git -C "$SKILLS_DIR" remote add origin "$REPO_URL"
  git -C "$SKILLS_DIR" fetch origin "$BRANCH"
  git -C "$SKILLS_DIR" checkout -B "$BRANCH" "origin/$BRANCH"
fi

echo "Skills instaladas/actualizadas en $SKILLS_DIR"
echo "Reinicia Codex para que tome los cambios."
