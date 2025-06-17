#!/bin/bash

# Clean My Mac v2.0 Installer
echo "🧹 Clean My Mac v2.0 Installer"
echo "==============================="

# Get installer path
CMM_PATH=$(pwd)

# Check if running from correct directory
if [[ ! -f "$CMM_PATH/cleanmymac.sh" ]]; then
    echo "❌ Error: Please run this installer from the cleanmymac directory"
    echo "   Make sure cleanmymac.sh exists in the current directory"
    exit 1
fi

# Create installation directory
echo "📁 Creating installation folder..."
mkdir -p ~/.cleanmymac

# Copy files to home directory
echo "📋 Copying files..."
echo "$CMM_PATH" > ~/.cleanmymac/source_path
cp -R "${CMM_PATH}/" ~/.cleanmymac

# Make scripts executable
echo "🔧 Making scripts executable..."
find ~/.cleanmymac -name "*.sh" -exec chmod +x {} \;

# Create symlink for global access
echo "🔗 Adding cleanmymac command to PATH..."
if [[ -w "/usr/local/bin" ]]; then
    ln -sf ~/.cleanmymac/cleanmymac.sh /usr/local/bin/cleanmymac
    echo "✅ Global command 'cleanmymac' installed successfully"
else
    echo "⚠️  Could not install global command (permission denied)"
    echo "   You can still use: ~/.cleanmymac/cleanmymac.sh"
    echo "   Or add ~/.cleanmymac to your PATH manually"
fi

# Setup directories
echo "📂 Setting up directories..."
cd ~/.cleanmymac
mkdir -p "setup"
cp "$CMM_PATH/install.sh" ~/.cleanmymac/setup/install.sh
cp "$CMM_PATH/uninstall.sh" ~/.cleanmymac/setup/uninstall.sh

# Remove extended attributes (macOS security)
echo "🔒 Removing extended attributes..."
xattr -rc ~/.cleanmymac/ 2>/dev/null || true

echo ""
echo "🎉 Installation Complete!"
echo "========================="
echo "✅ Clean My Mac v2.0 has been installed successfully"
echo ""
echo "Usage:"
echo "  cleanmymac [options] [directory]"
echo "  cleanmymac --help                 # Show help"
echo "  cleanmymac --dry-run ~/Projects   # Preview cleanup"
echo "  cleanmymac ~/Projects             # Clean Projects folder"
echo ""
echo "For more information, visit the project repository or run 'cleanmymac --help'"
echo ""