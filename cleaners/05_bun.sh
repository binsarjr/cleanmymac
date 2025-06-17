#!/bin/bash

# Bun Cleaner - Removes Bun cache and node_modules

echo "🟤 Bun Cleanup"
echo "==============="

# Mencari dan menghapus folder node_modules yang menggunakan bun (ada bun.lockb)
FOUND_BUN=false
while IFS= read -r -d '' BUN_LOCK; do
    PROJECT_DIR=$(dirname "$BUN_LOCK")
    if [[ -d "$PROJECT_DIR/node_modules" ]]; then
        FOUND_BUN=true
        safe_delete "$PROJECT_DIR/node_modules" "Bun node_modules"
    fi
done < <(find "$SCAN_DIR" -name "bun.lockb" -print0 2>/dev/null)

if [ "$FOUND_BUN" = false ]; then
    echo "ℹ️  No Bun projects found."
fi

echo ""
