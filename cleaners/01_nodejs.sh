#!/bin/bash

# Node.js Cleaner - Removes node_modules folders

echo "🟢 Node.js Cleanup"
echo "=================="

# Mencari dan menghapus semua folder node_modules
FOUND_MODULES=false
while IFS= read -r -d '' NODE_MODULES_DIR; do
    FOUND_MODULES=true
    safe_delete "$NODE_MODULES_DIR" "node_modules folder"
done < <(find "$SCAN_DIR" -type d -name "node_modules" -prune -print0 2>/dev/null)

if [ "$FOUND_MODULES" = false ]; then
    echo "ℹ️  No node_modules folders found."
fi

echo ""
