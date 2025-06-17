# Changelog

## Version 2.0.0 (2025-06-17)

### 🎉 Major Rewrite
- **Complete restructure**: Modular cleaner system with separate files for each tool
- **New Architecture**: Plugin-based system for easy extensibility

### ✨ New Features
- **Dry Run Mode**: `--dry-run` flag to preview what would be deleted
- **Verbose Mode**: `--verbose` flag for detailed output
- **Smart Detection**: Automatically detects project types based on configuration files
- **Statistics**: Shows summary of cleaned items and disk space saved
- **Loading Animation**: Visual feedback during operations

### 🧹 New Cleaners
- **Node.js**: Removes `node_modules` directories
- **PHP/Composer**: Removes `vendor` directories (only with composer.json)
- **Python**: Removes `__pycache__` directories
- **PNPM**: Removes PNPM-specific node_modules
- **Bun**: Removes Bun-specific node_modules  
- **Yarn**: Removes Yarn-specific node_modules
- **Rust**: Removes `target` directories from Rust projects
- **Go**: Removes `vendor` directories and binaries from Go projects
- **Docker**: Cleans Docker containers, images, networks, and volumes
- **Cache**: Removes various cache directories (.cache, dist, build, .next, .nuxt)
- **macOS**: Removes .DS_Store, Thumbs.db, and large log files

### 🔧 Improvements
- **Better Error Handling**: Graceful handling of permission errors
- **Safety Features**: Only deletes directories that belong to specific projects
- **Modern UI**: Emojis and colored output for better user experience
- **Comprehensive Documentation**: Updated README with examples and troubleshooting

### 🐛 Bug Fixes
- Fixed variable counting issues in subshells
- Improved cross-shell compatibility
- Better argument parsing and validation

### 💥 Breaking Changes
- Changed command line interface - now requires directory argument
- Removed dependency on ~/.cleanmymac/path configuration
- Updated installation process

---

## Version 1.x (Legacy)
- Original version with basic cleanup functionality
- Used centralized configuration in ~/.cleanmymac/
- Limited to predefined cleaners
