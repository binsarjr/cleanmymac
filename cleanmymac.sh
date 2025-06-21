#!/bin/bash

# Clean My Mac - Advanced Cleanup Tool
# =====================================

# Get the directory where this script is located
# Handle both direct execution and symlink execution
SCRIPT_PATH="${BASH_SOURCE[0]}"

# Resolve symlinks to get the actual script location
while [[ -L "$SCRIPT_PATH" ]]; do
    SCRIPT_DIR="$(cd -P "$(dirname "$SCRIPT_PATH")" && pwd)"
    SCRIPT_PATH="$(readlink "$SCRIPT_PATH")"
    # Handle relative symlinks
    [[ $SCRIPT_PATH != /* ]] && SCRIPT_PATH="$SCRIPT_DIR/$SCRIPT_PATH"
done

SCRIPT_DIR="$(cd -P "$(dirname "$SCRIPT_PATH")" && pwd)"
CLEANERS="$SCRIPT_DIR/cleaners"
METAMODULE="$CLEANERS/00_meta.sh"

if [ -z "$1" ]; then
    echo "Clean My Mac - Advanced Cleanup Tool for Developers"
    echo "============================================================="
    echo "Bersihkan proyek-proyekmu dari file dan folder sampah yang tersembunyi!"
    echo ""
    echo "Tool ini membantu menghapus cache, dependensi, dan file build yang tidak diperlukan dari berbagai ekosistem (Node.js, Python, Go, Rust, Docker, dsb)."
    echo ""
    echo "Fitur utama:"
    echo "  • Pembersihan otomatis node_modules, vendor, __pycache__, cache, dsb."
    echo "  • Mode dry-run untuk simulasi tanpa menghapus apapun."
    echo "  • Statistik penghematan ruang dan jumlah file yang dihapus."
    echo "  • Scan cepat untuk estimasi potensi pembersihan."
    echo "  • Info sistem dan versi."
    echo ""
    echo "Penggunaan: $0 [opsi] [direktori]"
    echo "Contoh: $0 --dry-run ~/Projects"
    echo ""
    echo "Opsi:"
    echo "  -h, --help      Tampilkan bantuan ini"
    echo "  -d, --dry-run   Simulasi tanpa menghapus file"
    echo "  -v, --verbose   Tampilkan detail proses"
    echo "  -s, --scan      Scan cepat estimasi pembersihan"
    echo "  -i, --info      Info sistem"
    echo "  --version       Info versi"
    echo ""
    echo "Jadikan workspace-mu lebih bersih, ringan, dan bebas sampah! 🚀"
    echo "============================================================="
    exit 1
else
    # Run the meta module first to handle arguments and setup
    source "$METAMODULE" "$@"
    
    # If meta module succeeds, run all other cleaners
    if [ $? -eq 0 ]; then
        echo ""
        if [[ "$DRY_RUN" == "true" ]]; then
            echo "🔍 DRY RUN MODE - No files will be deleted"
            echo "=========================================="
        else
            echo "Starting cleanup process..."
            echo "=========================="
        fi
        
        # Run all cleaner modules in order
        for file in $(ls "$CLEANERS" | grep -v "00_meta.sh" | sort); do
            if [ -f "$CLEANERS/$file" ] && [ -x "$CLEANERS/$file" ]; then
                source "$CLEANERS/$file"
            fi
        done
    fi
fi