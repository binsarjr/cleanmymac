#!/bin/bash

# Rust Cleaner - Removes target folders from Rust projects

echo "🦀 Rust Cleanup"
echo "==============="

# Mencari dan menghapus folder target yang ada Cargo.toml di level yang sama
FOUND_RUST=false
while IFS= read -r -d '' CARGO_FILE; do
    PROJECT_DIR=$(dirname "$CARGO_FILE")
    if [[ -d "$PROJECT_DIR/target" ]]; then
        FOUND_RUST=true
        safe_delete "$PROJECT_DIR/target" "Rust target folder"
    fi
done < <(find "$SCAN_DIR" -name "Cargo.toml" -print0 2>/dev/null)

if [ "$FOUND_RUST" = false ]; then
    echo "ℹ️  No Rust projects found."
fi

echo ""
