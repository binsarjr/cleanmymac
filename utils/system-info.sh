#!/bin/bash

# System Info Utility for Clean My Mac

echo "🖥️  System Information"
echo "====================="

# macOS Version
echo "OS: $(sw_vers -productName) $(sw_vers -productVersion)"

# Available disk space
echo "Available disk space:"
df -h / | tail -n 1 | awk '{print "  • Root: " $4 " available (" $5 " used)"}'

# Memory usage
echo "Memory:"
vm_stat | grep "Pages free" | awk '{print "  • Free pages: " $3}' | sed 's/\.$//'

# Check if common tools are installed
echo ""
echo "🔧 Development Tools:"

tools=("node" "npm" "yarn" "pnpm" "bun" "composer" "python3" "cargo" "go" "docker")
for tool in "${tools[@]}"; do
    if command -v "$tool" &> /dev/null; then
        version=$($tool --version 2>/dev/null | head -n 1 | cut -d' ' -f1-2)
        echo "  ✅ $tool: $version"
    else
        echo "  ❌ $tool: not installed"
    fi
done

echo ""
