#!/bin/bash

# Clean My Mac v2.0 Installer
echo "🧹 Clean My Mac v2.0 Installer"
echo "==============================="

# Get installer path
CMM_PATH=$(cd "$(dirname "$0")" && pwd)

# Check if running from correct directory
if [[ ! -f "$CMM_PATH/cleanmymac.sh" ]]; then
    echo "❌ Error: Please run this installer from the cleanmymac directory"
    echo "   Make sure cleanmymac.sh exists in the current directory"
    exit 1
fi

# Check if already installed and ask for confirmation
if [[ -f "/usr/local/bin/cleanmymac" ]] || [[ -d ~/.cleanmymac ]]; then
    echo "⚠️  Clean My Mac is already installed."
    echo "Do you want to reinstall? (y/N): "
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        exit 0
    fi
    echo "🔄 Reinstalling..."
fi

# Create installation directory
echo "📁 Creating installation folder..."
rm -rf ~/.cleanmymac 2>/dev/null || true
mkdir -p ~/.cleanmymac

# Copy files to home directory
echo "📋 Copying files..."
cp -R "${CMM_PATH}/" ~/.cleanmymac/
echo "$CMM_PATH" > ~/.cleanmymac/source_path

# Make scripts executable
echo "🔧 Making scripts executable..."
find ~/.cleanmymac -name "*.sh" -exec chmod +x {} \;

# Create symlink for global access
echo "🔗 Adding cleanmymac command to PATH..."

# Remove existing symlink if it exists
sudo rm -f /usr/local/bin/cleanmymac 2>/dev/null || true

# Try to create /usr/local/bin if it doesn't exist
if [[ ! -d "/usr/local/bin" ]]; then
    echo "📂 Creating /usr/local/bin directory..."
    sudo mkdir -p /usr/local/bin 2>/dev/null || {
        echo "❌ Failed to create /usr/local/bin directory"
        echo "   You'll need to add ~/.cleanmymac to your PATH manually"
        MANUAL_PATH=true
    }
fi

# Create symlink
if [[ "$MANUAL_PATH" != "true" ]]; then
    if sudo ln -sf ~/.cleanmymac/cleanmymac.sh /usr/local/bin/cleanmymac 2>/dev/null; then
        echo "✅ Global command 'cleanmymac' installed successfully"
        
        # Verify installation
        if command -v cleanmymac >/dev/null 2>&1; then
            echo "✅ Binary verification: cleanmymac command is accessible"
        else
            echo "⚠️  Warning: cleanmymac command might not be in your PATH"
            echo "   You may need to restart your terminal or add /usr/local/bin to PATH"
        fi
    else
        echo "❌ Failed to create symlink with sudo"
        MANUAL_PATH=true
    fi
fi

# Provide manual installation instructions if automatic failed
if [[ "$MANUAL_PATH" == "true" ]]; then
    echo ""
    echo "🔧 Manual Installation Required:"
    echo "   Add this line to your ~/.zshrc file:"
    echo "   export PATH=\"\$HOME/.cleanmymac:\$PATH\""
    echo ""
    echo "   Then run: source ~/.zshrc"
    echo "   Or restart your terminal"
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

# Test the installation
if command -v cleanmymac >/dev/null 2>&1; then
    echo "🚀 Ready to use:"
    echo "  cleanmymac --help                 # Show help"
    echo "  cleanmymac --scan ~/Projects      # Preview cleanup"
    echo "  cleanmymac --dry-run ~/Projects   # Test cleanup"
    echo "  cleanmymac ~/Projects             # Clean Projects folder"
    echo ""
    echo "✅ Type 'cleanmymac --help' to get started!"
else
    echo "📋 Manual usage (restart terminal or source ~/.zshrc):"
    echo "  ~/.cleanmymac/cleanmymac.sh --help"
    echo ""
    echo "🔧 To add to PATH permanently, add this to ~/.zshrc:"
    echo "   export PATH=\"\$HOME/.cleanmymac:\$PATH\""
fi

echo ""
echo "🗑️  To uninstall: run ~/.cleanmymac/setup/uninstall.sh"
echo ""