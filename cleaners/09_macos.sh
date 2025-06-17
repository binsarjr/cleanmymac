#!/bin/bash

# macOS Core Cleanup - Removes common cache and temporary files

echo "🍎 macOS Core Cleanup"
echo "====================="

MACOS_COUNT=0

# Mencari dan menghapus .DS_Store files
find "$SCAN_DIR" -name ".DS_Store" -type f | while read -r DS_STORE; do
    echo "Deleting .DS_Store: $DS_STORE"
    rm -f "$DS_STORE"
    echo "✅ Deleted: $DS_STORE"
    ((MACOS_COUNT++))
done

# Mencari dan menghapus Thumbs.db files (Windows compatibility)
find "$SCAN_DIR" -name "Thumbs.db" -type f | while read -r THUMBS; do
    echo "Deleting Thumbs.db: $THUMBS"
    rm -f "$THUMBS"
    echo "✅ Deleted: $THUMBS"
    ((MACOS_COUNT++))
done

# Mencari dan menghapus .log files yang mungkin besar
find "$SCAN_DIR" -name "*.log" -type f -size +10M | while read -r LOG_FILE; do
    echo "Deleting large log file: $LOG_FILE"
    rm -f "$LOG_FILE"
    echo "✅ Deleted: $LOG_FILE"
    ((MACOS_COUNT++))
done

if [ $MACOS_COUNT -eq 0 ]; then
    echo "ℹ️  No macOS cache files found."
fi

echo ""
