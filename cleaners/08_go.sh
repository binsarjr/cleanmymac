#!/bin/bash

# Go Cleaner - Removes Go cache and build artifacts

echo "🐹 Go Cleanup"
echo "=============="

# Mencari dan menghapus folder yang berkaitan dengan Go
FOUND_GO=false

# Membersihkan go.mod projects
while IFS= read -r -d '' GO_MOD; do
    PROJECT_DIR=$(dirname "$GO_MOD")
    
    # Hapus vendor folder jika ada
    if [[ -d "$PROJECT_DIR/vendor" ]]; then
        FOUND_GO=true
        safe_delete "$PROJECT_DIR/vendor" "Go vendor folder"
    fi
    
    # Hapus binary yang mungkin ada (file executable)
    find "$PROJECT_DIR" -maxdepth 1 -type f -perm +111 2>/dev/null | while read -r BINARY; do
        if [[ ! "$BINARY" =~ \.(sh|py|rb|js|ts)$ ]] && [[ $(basename "$BINARY") != "Makefile" ]]; then
            FOUND_GO=true
            safe_delete "$BINARY" "Go binary"
        fi
    done
done < <(find "$SCAN_DIR" -name "go.mod" -print0 2>/dev/null)

if [ "$FOUND_GO" = false ]; then
    echo "ℹ️  No Go projects found."
fi

echo ""
