#!/bin/bash

# Node.js Cleaner - Removes node_modules folders

echo "🟢 Node.js Cleanup"
echo "=================="

# Mencari dan menghapus folder node_modules yang memiliki package.json di level yang sama
FOUND_MODULES=false
while IFS= read -r -d '' NODE_MODULES_DIR; do
    # Cek apakah ada package.json di parent directory yang sama
    PARENT_DIR=$(dirname "$NODE_MODULES_DIR")
    PACKAGE_JSON="$PARENT_DIR/package.json"
    
    if [[ -f "$PACKAGE_JSON" ]]; then
        FOUND_MODULES=true
        safe_delete "$NODE_MODULES_DIR" "node_modules folder"
    else
        echo "⏭️  Skipping node_modules folder: $NODE_MODULES_DIR (no package.json found)"
    fi
done < <(find "$SCAN_DIR" -type d -name "node_modules" -prune -print0 2>/dev/null)

if [ "$FOUND_MODULES" = false ]; then
    echo "ℹ️  No valid Node.js projects with node_modules found."
fi

echo ""
