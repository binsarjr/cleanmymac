#!/bin/bash

# Clean My Mac Demo Script
echo "🎯 Clean My Mac v2.0 Demo"
echo "========================="
echo ""

# Show help
echo "1️⃣  Showing help:"
echo "---"
./cleanmymac.sh --help
echo ""
sleep 2

# Show version
echo "2️⃣  Showing version:"
echo "---"
./cleanmymac.sh --version
echo ""
sleep 2

# Show system info
echo "3️⃣  Showing system information:"
echo "---"
./cleanmymac.sh --info
echo ""
sleep 3

# Create demo directory structure
echo "4️⃣  Creating demo project structure..."
echo "---"
mkdir -p demo_workspace/{react_app/node_modules,laravel_app/vendor,django_app/__pycache__,rust_cli/target}
echo '{"name": "demo-react-app"}' > demo_workspace/react_app/package.json
echo '{"name": "demo-laravel-app"}' > demo_workspace/laravel_app/composer.json
echo 'print("Hello Django")' > demo_workspace/django_app/app.py
echo '[package]
name = "demo_cli"' > demo_workspace/rust_cli/Cargo.toml

# Add some dummy files
echo "dummy node module" > demo_workspace/react_app/node_modules/dummy.js
echo "dummy vendor file" > demo_workspace/laravel_app/vendor/dummy.php
echo "dummy cache" > demo_workspace/django_app/__pycache__/dummy.pyc
echo "dummy target" > demo_workspace/rust_cli/target/dummy.o

echo "Created demo workspace with various project types"
echo ""
sleep 2

# Show quick scan
echo "5️⃣  Running quick scan:"
echo "---"
./cleanmymac.sh --scan demo_workspace
echo ""
sleep 3

# Show dry run
echo "6️⃣  Running dry-run cleanup:"
echo "---"
./cleanmymac.sh --dry-run demo_workspace
echo ""
sleep 3

# Show actual cleanup
echo "7️⃣  Running actual cleanup:"
echo "---"
./cleanmymac.sh demo_workspace
echo ""
sleep 2

# Verify cleanup
echo "8️⃣  Verifying cleanup (should show empty or non-existent directories):"
echo "---"
find demo_workspace -name "node_modules" -o -name "vendor" -o -name "__pycache__" -o -name "target" 2>/dev/null || echo "✅ All target directories cleaned!"
echo ""
sleep 2

# Cleanup demo
echo "9️⃣  Cleaning up demo..."
rm -rf demo_workspace
echo "Demo completed! 🎉"
echo ""
sleep 1
echo "Clean My Mac is ready to use. Try:"
echo "  ./cleanmymac.sh --scan ~/Projects"
echo "  ./cleanmymac.sh --dry-run ~/Development"
echo "  ./cleanmymac.sh ~/workspace"
