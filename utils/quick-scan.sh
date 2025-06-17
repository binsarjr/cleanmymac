#!/bin/bash

# Quick scan utility to estimate cleanup potential

if [[ -z "$1" ]]; then
    echo "Usage: $0 [directory]"
    echo "Provides a quick estimate of potential cleanup space"
    exit 1
fi

SCAN_DIR="$1"

if [[ ! -d "$SCAN_DIR" ]]; then
    echo "Error: Directory '$SCAN_DIR' does not exist."
    exit 1
fi

echo "🔍 Quick Scan Report for: $SCAN_DIR"
echo "=================================="

total_size=0

# Count node_modules (only with package.json)
node_modules_count=0
node_modules_size=0
while IFS= read -r -d '' node_modules_dir; do
    parent_dir=$(dirname "$node_modules_dir")
    if [[ -f "$parent_dir/package.json" ]]; then
        ((node_modules_count++))
        size=$(du -sk "$node_modules_dir" 2>/dev/null | cut -f1)
        node_modules_size=$((node_modules_size + size))
    fi
done < <(find "$SCAN_DIR" -type d -name "node_modules" -prune -print0 2>/dev/null)

if [[ $node_modules_count -gt 0 ]]; then
    node_modules_size_mb=$((node_modules_size / 1024))
    echo "📦 Node.js: $node_modules_count folders (~${node_modules_size_mb}MB)"
    total_size=$((total_size + node_modules_size))
fi

# Count vendor folders
vendor_count=0
vendor_size=0
while IFS= read -r -d '' vendor_dir; do
    composer_file=$(dirname "$vendor_dir")/composer.json
    if [[ -f "$composer_file" ]]; then
        ((vendor_count++))
        size=$(du -sk "$vendor_dir" 2>/dev/null | cut -f1)
        vendor_size=$((vendor_size + size))
    fi
done < <(find "$SCAN_DIR" -type d -name "vendor" -prune -print0 2>/dev/null)

if [[ $vendor_count -gt 0 ]]; then
    vendor_size_mb=$((vendor_size / 1024))
    echo "🐘 PHP/Composer: $vendor_count folders (~${vendor_size_mb}MB)"
    total_size=$((total_size + vendor_size))
fi

# Count __pycache__
pycache_count=0
pycache_size=0
while IFS= read -r -d '' pycache_dir; do
    ((pycache_count++))
    size=$(du -sk "$pycache_dir" 2>/dev/null | cut -f1)
    pycache_size=$((pycache_size + size))
done < <(find "$SCAN_DIR" -type d -name "__pycache__" -prune -print0 2>/dev/null)

if [[ $pycache_count -gt 0 ]]; then
    pycache_size_mb=$((pycache_size / 1024))
    echo "🐍 Python: $pycache_count folders (~${pycache_size_mb}MB)"
    total_size=$((total_size + pycache_size))
fi

# Count Rust target folders
rust_count=0
rust_size=0
while IFS= read -r -d '' cargo_file; do
    project_dir=$(dirname "$cargo_file")
    if [[ -d "$project_dir/target" ]]; then
        ((rust_count++))
        size=$(du -sk "$project_dir/target" 2>/dev/null | cut -f1)
        rust_size=$((rust_size + size))
    fi
done < <(find "$SCAN_DIR" -name "Cargo.toml" -print0 2>/dev/null)

if [[ $rust_count -gt 0 ]]; then
    rust_size_mb=$((rust_size / 1024))
    echo "🦀 Rust: $rust_count folders (~${rust_size_mb}MB)"
    total_size=$((total_size + rust_size))
fi

# Count cache directories
cache_count=0
cache_size=0

# Build cache directories
while IFS= read -r -d '' cache_dir; do
    ((cache_count++))
    size=$(du -sk "$cache_dir" 2>/dev/null | cut -f1)
    cache_size=$((cache_size + size))
done < <(find "$SCAN_DIR" -type d \( -name ".cache" -o -name "dist" -o -name "build" -o -name ".next" -o -name ".nuxt" \) -prune -print0 2>/dev/null)

# Coverage directories
while IFS= read -r -d '' coverage_dir; do
    ((cache_count++))
    size=$(du -sk "$coverage_dir" 2>/dev/null | cut -f1)
    cache_size=$((cache_size + size))
done < <(find "$SCAN_DIR" -type d \( -name "coverage" -o -name ".nyc_output" \) -prune -print0 2>/dev/null)

if [[ $cache_count -gt 0 ]]; then
    cache_size_mb=$((cache_size / 1024))
    echo "🗂️  Cache/Build: $cache_count folders (~${cache_size_mb}MB)"
    total_size=$((total_size + cache_size))
fi

echo ""
echo "📊 Summary:"
total_size_mb=$((total_size / 1024))
total_size_gb=$((total_size_mb / 1024))

if [[ $total_size_gb -gt 0 ]]; then
    echo "  • Potential cleanup: ~${total_size_gb}GB"
elif [[ $total_size_mb -gt 0 ]]; then
    echo "  • Potential cleanup: ~${total_size_mb}MB"
else
    echo "  • Potential cleanup: Minimal or no cleanup needed"
fi

echo ""
echo "💡 Run 'cleanmymac --dry-run $SCAN_DIR' to see detailed cleanup plan"
echo ""
