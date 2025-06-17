#!/bin/bash

# macOS Core Cleanup - Removes common cache and temporary files

echo "🍎 macOS Core Cleanup"
echo "====================="

FOUND_MACOS=false

# Mencari dan menghapus .DS_Store files
while IFS= read -r -d '' DS_STORE; do
    FOUND_MACOS=true
    safe_delete "$DS_STORE" ".DS_Store file"
done < <(find "$SCAN_DIR" -name ".DS_Store" -type f -print0 2>/dev/null)

# Mencari dan menghapus Thumbs.db files (Windows compatibility)
while IFS= read -r -d '' THUMBS; do
    FOUND_MACOS=true
    safe_delete "$THUMBS" "Thumbs.db file"
done < <(find "$SCAN_DIR" -name "Thumbs.db" -type f -print0 2>/dev/null)

# Mencari dan menghapus .log files yang mungkin besar
while IFS= read -r -d '' LOG_FILE; do
    FOUND_MACOS=true
    safe_delete "$LOG_FILE" "large log file"
done < <(find "$SCAN_DIR" -name "*.log" -type f -size +10M -print0 2>/dev/null)

if [ "$FOUND_MACOS" = false ]; then
    echo "ℹ️  No macOS cache files found."
fi

echo ""
