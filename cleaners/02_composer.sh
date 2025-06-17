#!/bin/bash

# Composer/PHP Cleaner - Removes vendor folders (only if composer.json exists)

echo "🟡 Composer/PHP Cleanup"
echo "======================="

# Mencari dan menghapus semua folder vendor dengan syarat ada composer.json di level yang sama
FOUND_VENDOR=false
while IFS= read -r -d '' VENDOR_DIR; do
    COMPOSER_FILE=$(dirname "$VENDOR_DIR")/composer.json
    if [[ -f "$COMPOSER_FILE" ]]; then
        FOUND_VENDOR=true
        safe_delete "$VENDOR_DIR" "vendor folder"
    else
        echo "⏭️  Skipping vendor folder: $VENDOR_DIR (no composer.json found)"
    fi
done < <(find "$SCAN_DIR" -type d -name "vendor" -prune -print0 2>/dev/null)

if [ "$FOUND_VENDOR" = false ]; then
    echo "ℹ️  No vendor folders with composer.json found."
fi

echo ""
