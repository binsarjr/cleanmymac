#!/bin/bash

# PNPM Cleaner - Removes pnpm cache and node_modules

echo "🟠 PNPM Cleanup"
echo "==============="

# Mencari dan menghapus folder node_modules yang menggunakan pnpm
FOUND_PNPM=false
while IFS= read -r -d '' PNPM_LOCK; do
    PROJECT_DIR=$(dirname "$PNPM_LOCK")
    if [[ -d "$PROJECT_DIR/node_modules" ]]; then
        FOUND_PNPM=true
        echo "Deleting PNPM node_modules: $PROJECT_DIR/node_modules"
        rm -rf "$PROJECT_DIR/node_modules" &
        loading_animation $!
        wait
        echo "✅ Deleted: $PROJECT_DIR/node_modules"
    fi
done < <(find "$SCAN_DIR" -name "pnpm-lock.yaml" -print0 2>/dev/null)

if [ "$FOUND_PNPM" = false ]; then
    echo "ℹ️  No PNPM projects found."
fi

echo ""
