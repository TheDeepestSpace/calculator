#!/usr/bin/bash
set -euo pipefail
WORKSPACE="$1"
git config --global --add safe.directory "$WORKSPACE"
echo "✅ Added $WORKSPACE to git safe directories"
