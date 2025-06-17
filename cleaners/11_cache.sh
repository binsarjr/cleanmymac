#!/bin/bash

# Cache Cleaner - Removes various cache directories

echo "🗂️  Cache Cleanup"
echo "=================="

FOUND_CACHE=false

# Clean npm cache in projects
while IFS= read -r -d '' PACKAGE_JSON; do
    PROJECT_DIR=$(dirname "$PACKAGE_JSON")
    if [[ -d "$PROJECT_DIR/.npm" ]]; then
        FOUND_CACHE=true
        echo "Deleting npm cache: $PROJECT_DIR/.npm"
        rm -rf "$PROJECT_DIR/.npm" &
        loading_animation $!
        wait
        echo "✅ Deleted: $PROJECT_DIR/.npm"
    fi
done < <(find "$SCAN_DIR" -name "package.json" -print0 2>/dev/null)

# Clean yarn cache in projects
while IFS= read -r -d '' YARN_LOCK; do
    PROJECT_DIR=$(dirname "$YARN_LOCK")
    if [[ -d "$PROJECT_DIR/.yarn/cache" ]]; then
        FOUND_CACHE=true
        echo "Deleting yarn cache: $PROJECT_DIR/.yarn/cache"
        rm -rf "$PROJECT_DIR/.yarn/cache" &
        loading_animation $!
        wait
        echo "✅ Deleted: $PROJECT_DIR/.yarn/cache"
    fi
done < <(find "$SCAN_DIR" -name "yarn.lock" -print0 2>/dev/null)

# Clean build cache directories
while IFS= read -r -d '' BUILD_DIR; do
    FOUND_CACHE=true
    echo "Deleting build cache: $BUILD_DIR"
    rm -rf "$BUILD_DIR" &
    loading_animation $!
    wait
    echo "✅ Deleted: $BUILD_DIR"
done < <(find "$SCAN_DIR" -type d -name ".cache" -o -name "dist" -o -name "build" -o -name ".next" -o -name ".nuxt" | head -20 | tr '\n' '\0')

# Clean coverage directories
while IFS= read -r -d '' COVERAGE_DIR; do
    FOUND_CACHE=true
    echo "Deleting coverage: $COVERAGE_DIR"
    rm -rf "$COVERAGE_DIR" &
    loading_animation $!
    wait
    echo "✅ Deleted: $COVERAGE_DIR"
done < <(find "$SCAN_DIR" -type d -name "coverage" -o -name ".nyc_output" | head -10 | tr '\n' '\0')

if [ "$FOUND_CACHE" = false ]; then
    echo "ℹ️  No cache directories found."
fi

echo ""
