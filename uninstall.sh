#!/bin/bash

# Clean My Mac v2.0 Uninstaller
echo "🗑️  Clean My Mac v2.0 Uninstaller"
echo "=================================="

# Check if Clean My Mac is installed
if [[ ! -d ~/.cleanmymac ]] && [[ ! -f /usr/local/bin/cleanmymac ]]; then
    echo "❌ Clean My Mac is not installed"
    exit 1
fi

echo "This will completely remove Clean My Mac from your system."
echo "Are you sure you want to continue? (y/N): "
read -r response

if [[ ! "$response" =~ ^[Yy]$ ]]; then
    echo "Uninstallation cancelled."
    exit 0
fi

echo ""
echo "🧹 Removing Clean My Mac..."

# Remove global command
if [[ -f /usr/local/bin/cleanmymac ]]; then
    echo "🔗 Removing global command..."
    if sudo rm -f /usr/local/bin/cleanmymac 2>/dev/null; then
        echo "✅ Global command removed"
    else
        echo "⚠️  Could not remove global command (you may need to remove manually)"
    fi
fi

# Remove installation directory
if [[ -d ~/.cleanmymac ]]; then
    echo "📁 Removing installation folder..."
    rm -rf ~/.cleanmymac
    echo "✅ Installation folder removed"
fi

# Check for PATH modifications
if grep -q "cleanmymac" ~/.zshrc 2>/dev/null; then
    echo ""
    echo "⚠️  Found Clean My Mac PATH entries in ~/.zshrc"
    echo "   You may want to remove them manually:"
    echo "   Lines containing: ~/.cleanmymac or cleanmymac"
fi

if grep -q "cleanmymac" ~/.bash_profile 2>/dev/null; then
    echo ""
    echo "⚠️  Found Clean My Mac PATH entries in ~/.bash_profile"
    echo "   You may want to remove them manually:"
    echo "   Lines containing: ~/.cleanmymac or cleanmymac"
fi

echo ""
echo "✅ Clean My Mac has been uninstalled successfully"
echo ""
echo "Thank you for using Clean My Mac! 🧹"
echo ""