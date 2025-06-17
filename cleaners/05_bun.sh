#!/bin/bash

# Bun Cleaner - Removes Bun cache and node_modules

echo "🟤 Bun Cleanup"
echo "==============="

# Mencari dan menghapus folder node_modules yang menggunakan bun
BUN_COUNT=0
find "$SCAN_DIR" -name "bun.lockb" | while read -r BUN_LOCK; do
    PROJECT_DIR=$(dirname "$BUN_LOCK")
    if [[ -d "$PROJECT_DIR/node_modules" ]]; then
        echo "Deleting Bun node_modules: $PROJECT_DIR/node_modules"
        (rm -rf "$PROJECT_DIR/node_modules" & loading_animation $!)
        echo "✅ Deleted: $PROJECT_DIR/node_modules"
        ((BUN_COUNT++))
    fi
done

if [ $BUN_COUNT -eq 0 ]; then
    echo "ℹ️  No Bun projects found."
fi

echo ""
