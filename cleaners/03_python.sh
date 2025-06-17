#!/bin/bash

# Python Cleaner - Removes __pycache__ folders

echo "🔵 Python Cleanup"
echo "=================="

# Mencari dan menghapus semua folder __pycache__
FOUND_PYCACHE=false
while IFS= read -r -d '' PYCACHE_DIR; do
    FOUND_PYCACHE=true
    safe_delete "$PYCACHE_DIR" "__pycache__ folder"
done < <(find "$SCAN_DIR" -type d -name "__pycache__" -prune -print0 2>/dev/null)

if [ "$FOUND_PYCACHE" = false ]; then
    echo "ℹ️  No __pycache__ folders found."
fi

echo ""
