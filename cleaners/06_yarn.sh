#!/bin/bash

# Yarn Cleaner - Removes Yarn cache and node_modules

echo "🔴 Yarn Cleanup"
echo "==============="

# Mencari dan menghapus folder node_modules yang menggunakan yarn (ada yarn.lock)
FOUND_YARN=false
while IFS= read -r -d '' YARN_LOCK; do
    PROJECT_DIR=$(dirname "$YARN_LOCK")
    if [[ -d "$PROJECT_DIR/node_modules" ]]; then
        FOUND_YARN=true
        safe_delete "$PROJECT_DIR/node_modules" "Yarn node_modules"
    fi
done < <(find "$SCAN_DIR" -name "yarn.lock" -print0 2>/dev/null)

if [ "$FOUND_YARN" = false ]; then
    echo "ℹ️  No Yarn projects found."
fi

echo ""
