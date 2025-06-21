#!/bin/bash

# Cache Cleaner - Removes various cache directories

echo "🗂️  Cache Cleanup"
echo "=================="

FOUND_CACHE=false

# Clean npm cache in projects
FOUND_CACHE=false
while IFS= read -r -d '' PACKAGE_JSON; do
    PROJECT_DIR=$(dirname "$PACKAGE_JSON")
    if [[ -d "$PROJECT_DIR/.npm" ]]; then
        FOUND_CACHE=true
        safe_delete "$PROJECT_DIR/.npm" "npm cache"
    fi
done < <(find "$SCAN_DIR" -name "package.json" -print0 2>/dev/null)

# Clean yarn cache in projects
while IFS= read -r -d '' YARN_LOCK; do
    PROJECT_DIR=$(dirname "$YARN_LOCK")
    if [[ -d "$PROJECT_DIR/.yarn/cache" ]]; then
        FOUND_CACHE=true
        safe_delete "$PROJECT_DIR/.yarn/cache" "yarn cache"
    fi
done < <(find "$SCAN_DIR" -name "yarn.lock" -print0 2>/dev/null)

# Clean build cache directories (khusus cache framework, bukan dist/build output)
BUILD_CACHE_FOUND=$(find "$SCAN_DIR" -type d \( -name ".cache" -o -name ".next" -o -name ".nuxt" -o -name ".svelte-kit" -o -name ".vite" \) -prune -print 2>/dev/null | head -1)
if [[ -n "$BUILD_CACHE_FOUND" ]]; then
    FOUND_CACHE=true
    while IFS= read -r -d '' BUILD_DIR; do
        safe_delete "$BUILD_DIR" "framework cache"
    done < <(find "$SCAN_DIR" -type d \( -name ".cache" -o -name ".next" -o -name ".nuxt" -o -name ".svelte-kit" -o -name ".vite" \) -prune -print0 2>/dev/null)
fi

# Clean coverage directories  
COVERAGE_FOUND=$(find "$SCAN_DIR" -type d \( -name "coverage" -o -name ".nyc_output" \) -prune -print 2>/dev/null | head -1)
if [[ -n "$COVERAGE_FOUND" ]]; then
    FOUND_CACHE=true
    while IFS= read -r -d '' COVERAGE_DIR; do
        safe_delete "$COVERAGE_DIR" "coverage directory"
    done < <(find "$SCAN_DIR" -type d \( -name "coverage" -o -name ".nyc_output" \) -prune -print0 2>/dev/null)
fi

if [ "$FOUND_CACHE" = false ]; then
    echo "ℹ️  No cache directories found."
fi

echo ""
