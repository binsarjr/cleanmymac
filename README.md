# Clean My Mac - Advanced Cleanup Tool

inspired https://github.com/aviral2552/cleanmymac

Clean My Mac adalah tool pembersihan canggih yang dirancang khusus untuk sistem macOS modern. Tool ini melakukan maintenance untuk komponen yang paling umum digunakan di sistem operasi dan third-party tools dengan satu perintah terminal.

Clean My Mac menggunakan sistem plugin sederhana dengan semua "cleaners" terletak di direktori `cleaners`. Fungsionalitas dapat ditambah (atau dihapus) dengan menambah (atau menghapus) file di direktori tersebut.

## Fitur

🧹 **Pembersihan Komprehensif**: 
- **Node.js**: Membersihkan folder `node_modules`
- **PHP/Composer**: Membersihkan folder `vendor` (hanya jika ada `composer.json`)
- **Python**: Membersihkan folder `__pycache__`
- **PNPM**: Membersihkan `node_modules` dari proyek PNPM
- **Bun**: Membersihkan `node_modules` dari proyek Bun
- **Yarn**: Membersihkan `node_modules` dari proyek Yarn
- **Rust**: Membersihkan folder `target` dari proyek Rust
- **Go**: Membersihkan folder `vendor` dan binary dari proyek Go
- **macOS**: Membersihkan `.DS_Store`, `Thumbs.db`, dan file log besar

🎯 **Smart Detection**: Mendeteksi jenis proyek berdasarkan file konfigurasi (package.json, composer.json, Cargo.toml, dll.)

⚡ **Fast & Safe**: Animasi loading dan konfirmasi untuk setiap operasi penghapusan

## Pre-requisites

Anda memerlukan:
- macOS system
- Bash atau Zsh shell
- Terminal access

## Installation

### Method 1: Git Clone (Recommended)
```bash
git clone https://github.com/binsarjr/cleanmymac.git
cd cleanmymac
chmod +x cleanmymac.sh
```

### Method 2: Using install.sh (if available)
```bash
./install.sh
```

## Usage

### Basic Usage
```bash
# Membersihkan direktori tertentu
./cleanmymac.sh /path/to/your/workspace

# Contoh: Membersihkan folder Projects
./cleanmymac.sh ~/Projects

# Contoh: Membersihkan direktori saat ini
./cleanmymac.sh .
```

### Advanced Options
```bash
# Preview cleanup tanpa menghapus (dry-run)
./cleanmymac.sh --dry-run ~/Projects

# Verbose output untuk detail lengkap
./cleanmymac.sh --verbose ~/Projects

# Quick scan untuk estimasi cleanup
./cleanmymac.sh --scan ~/Projects

# Kombinasi options
./cleanmymac.sh --dry-run --verbose ~/Projects
```

### Utility Commands
```bash
# Menampilkan help
./cleanmymac.sh --help

# Menampilkan informasi versi
./cleanmymac.sh --version

# Menampilkan informasi sistem
./cleanmymac.sh --info
```

### Demo
```bash
# Jalankan demo lengkap untuk melihat semua fitur
./demo.sh
```

### Output Example
```
Clean My Mac - Advanced Cleanup Tool
====================================
Scanning directory: /Users/username/Projects
================================

Starting cleanup process...
==========================
🟢 Node.js Cleanup
==================
Deleting node_modules folder: /Users/username/Projects/project1/node_modules
✅ Deleted: /Users/username/Projects/project1/node_modules

🟡 Composer/PHP Cleanup
=======================
ℹ️  No vendor folders with composer.json found.

🔵 Python Cleanup
==================
Deleting __pycache__ folder: /Users/username/Projects/project2/__pycache__
✅ Deleted: /Users/username/Projects/project2/__pycache__

🎉 Cleanup Complete!
====================
All specified directories have been cleaned successfully.
Your Mac is now squeaky clean! 🧽✨
```

## Supported Cleaners

| Cleaner | Description | Files Detected | Folders Cleaned |
|---------|-------------|----------------|-----------------|
| 🟢 **Node.js** | Membersihkan dependencies Node.js | `package.json` | `node_modules` |
| 🟡 **Composer/PHP** | Membersihkan dependencies PHP | `composer.json` | `vendor` |
| 🔵 **Python** | Membersihkan cache Python | `*.py` files | `__pycache__` |
| 🟠 **PNPM** | Membersihkan dependencies PNPM | `pnpm-lock.yaml` | `node_modules` |
| 🟤 **Bun** | Membersihkan dependencies Bun | `bun.lockb` | `node_modules` |
| 🔴 **Yarn** | Membersihkan dependencies Yarn | `yarn.lock` | `node_modules` |
| 🦀 **Rust** | Membersihkan build artifacts Rust | `Cargo.toml` | `target` |
| 🐹 **Go** | Membersihkan dependencies & binaries Go | `go.mod` | `vendor`, binaries |
| 🐳 **Docker** | Membersihkan Docker artifacts | Docker daemon | containers, images, networks, volumes |
| 🗂️ **Cache** | Membersihkan build cache | Various | `.cache`, `dist`, `build`, `.next`, `.nuxt`, coverage |
| 🍎 **macOS** | Membersihkan cache macOS | - | `.DS_Store`, `Thumbs.db`, large `.log` files |

## Utilities

Clean My Mac juga dilengkapi dengan utilities tambahan:

### Quick Scan (`--scan`)
Melakukan scan cepat untuk estimasi potensi cleanup tanpa melakukan penghapusan:
```bash
./cleanmymac.sh --scan ~/Projects
```

### System Info (`--info`) 
Menampilkan informasi sistem dan tools development yang terinstal:
```bash
./cleanmymac.sh --info
```

### Dry Run (`--dry-run`)
Preview apa yang akan dihapus tanpa benar-benar menghapus:
```bash
./cleanmymac.sh --dry-run ~/Projects
```

### Verbose Mode (`--verbose`)
Menampilkan output detail dengan informasi path lengkap:
```bash
./cleanmymac.sh --verbose ~/Projects
```

## Customization

### Menambah Cleaner Baru
1. Buat file baru di folder `cleaners/` dengan format `XX_nama.sh`
2. Gunakan template berikut:
```bash
#!/bin/bash

echo "🎯 Custom Cleanup"
echo "================="

# Your cleanup logic here
FOUND_ITEMS=false
while IFS= read -r -d '' ITEM; do
    FOUND_ITEMS=true
    echo "Deleting: $ITEM"
    rm -rf "$ITEM" &
    loading_animation $!
    wait
    echo "✅ Deleted: $ITEM"
done < <(find "$SCAN_DIR" -name "pattern" -print0 2>/dev/null)

if [ "$FOUND_ITEMS" = false ]; then
    echo "ℹ️  No items found."
fi

echo ""
```

### Menonaktifkan Cleaner
Hapus atau rename file cleaner di folder `cleaners/` dengan menambah ekstensi `.disabled`:
```bash
mv cleaners/01_nodejs.sh cleaners/01_nodejs.sh.disabled
```

## Safety Features

- ✅ **Selective Deletion**: Hanya menghapus folder yang benar-benar terkait dengan project (contoh: `vendor` hanya dihapus jika ada `composer.json`)
- ✅ **Confirmation**: Menampilkan path lengkap sebelum menghapus
- ✅ **Error Handling**: Graceful handling untuk permission errors
- ✅ **Dry Run**: Bisa dimodifikasi untuk preview mode

## Troubleshooting

### Permission Denied
```bash
chmod +x cleanmymac.sh
chmod +x cleaners/*.sh
```

### Script Not Found
Pastikan Anda menjalankan script dari direktori yang benar:
```bash
cd /path/to/cleanmymac
./cleanmymac.sh [directory]
```

### No Items Found
Ini normal jika direktori sudah bersih atau tidak mengandung jenis project yang didukung.

## Contributing

1. Fork repository ini
2. Buat branch untuk feature baru (`git checkout -b feature/amazing-feature`)
3. Commit perubahan (`git commit -m 'Add amazing feature'`)
4. Push ke branch (`git push origin feature/amazing-feature`)
5. Buat Pull Request

## License

Project ini menggunakan MIT License. Lihat file `LICENSE` untuk detail.

## Disclaimer

⚠️ **PENTING**: Tool ini menghapus file dan folder secara permanen. Pastikan Anda memahami apa yang akan dihapus sebelum menjalankan script. Selalu backup data penting Anda.

Penggunaan tool ini sepenuhnya risiko Anda sendiri. Developer tidak bertanggung jawab atas kehilangan data.

Note: Uninstallation is not required for updates. You can run `$ cleanmymac update` to perform auto-update.

## How do cleaners work

Cleaners are located under `~/.cleanmymac/cleaners` directory. You may remove the cleaners that are not applicable on your system.

## How do I contribute

Feel free to fork the project and submit a pull request for new or updated cleaner scripts.
