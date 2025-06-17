#!/bin/bash

# Yarn Cleaner - Removes Yarn cache and node_modules

echo "🔴 Yarn Cleanup"
echo "==============="

# Mencari dan menghapus folder node_modules yang menggunakan yarn
YARN_COUNT=0
find "$SCAN_DIR" -name "yarn.lock" | while read -r YARN_LOCK; do
    PROJECT_DIR=$(dirname "$YARN_LOCK")
    if [[ -d "$PROJECT_DIR/node_modules" ]]; then
        echo "Deleting Yarn node_modules: $PROJECT_DIR/node_modules"
        (rm -rf "$PROJECT_DIR/node_modules" & loading_animation $!)
        echo "✅ Deleted: $PROJECT_DIR/node_modules"
        ((YARN_COUNT++))
    fi
done

if [ $YARN_COUNT -eq 0 ]; then
    echo "ℹ️  No Yarn projects found."
fi

echo ""
