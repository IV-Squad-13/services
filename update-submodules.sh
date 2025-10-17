#!/usr/bin/env bash
set -e

echo "🔄 Updating all submodules to latest 'main' branch..."

git submodule update --init --recursive

git submodule foreach --recursive '
  echo "📦 Updating submodule: $name"
  git fetch origin main
  git checkout main || echo "⚠️ Could not checkout main (might not exist)"
  git pull origin main || echo "⚠️ Could not pull from main"
'

git add $(git submodule --quiet foreach 'echo $path')

if git diff --cached --quiet; then
  echo "✅ All submodules already up to date."
else
  git commit -m "Update submodules to latest main"
  echo "✅ Submodule references updated and committed."
fi