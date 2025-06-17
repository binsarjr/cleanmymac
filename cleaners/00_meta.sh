#!/bin/bash

# Meta file dengan fungsi umum dan argument handling

# Fungsi untuk mencetak pesan bantuan
function usage() {
    echo "Usage: cleanmymac [options] [directory]"
    echo "  directory: directory to scan for node_modules, vendor, and __pycache__ folders."
    echo ""
    echo "Options:"
    echo "  -h, --help      Show this help message"
    echo "  -d, --dry-run   Show what would be deleted without actually deleting"
    echo "  -v, --verbose   Show detailed output"
    echo "  -s, --scan      Quick scan to estimate cleanup potential"
    echo "  -i, --info      Show system information"
    echo "  --version       Show version information"
    echo ""
    echo "Examples:"
    echo "  cleanmymac ~/Projects"
    echo "  cleanmymac --dry-run /path/to/your/workspace"
    echo "  cleanmymac --verbose ~/Development"
    echo "  cleanmymac --scan ~/Projects"
}

# Fungsi untuk menampilkan animasi loading
function loading_animation() {
    local pid=$1
    local delay=0.1
    local spinner=("|" "/" "-" "\\")
    while kill -0 $pid 2>/dev/null; do
        for i in "${spinner[@]}"; do
            echo -ne "\rProcessing $i"
            sleep $delay
        done
    done
    echo -ne "\r"
}

# Parse command line arguments
DRY_RUN=false
VERBOSE=false
SCAN_ONLY=false
SHOW_INFO=false
SHOW_VERSION=false
SCAN_DIR=""

# Get script directory for utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)"

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            exit 0
            ;;
        -d|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -s|--scan)
            SCAN_ONLY=true
            shift
            ;;
        -i|--info)
            SHOW_INFO=true
            shift
            ;;
        --version)
            SHOW_VERSION=true
            shift
            ;;
        -*)
            echo "Error: Unknown option $1"
            echo ""
            usage
            exit 1
            ;;
        *)
            if [[ -z "$SCAN_DIR" ]]; then
                SCAN_DIR="$1"
            else
                echo "Error: Multiple directories specified"
                echo ""
                usage
                exit 1
            fi
            shift
            ;;
    esac
done

# Handle special modes that don't require directory
if [[ "$SHOW_VERSION" == "true" ]]; then
    source "$SCRIPT_DIR/version.sh"
    exit 0
fi

if [[ "$SHOW_INFO" == "true" ]]; then
    chmod +x "$SCRIPT_DIR/utils/system-info.sh" 2>/dev/null
    "$SCRIPT_DIR/utils/system-info.sh"
    exit 0
fi

if [[ "$SCAN_ONLY" == "true" ]]; then
    if [[ -z "$SCAN_DIR" ]]; then
        echo "Error: Directory is required for scan mode."
        echo ""
        usage
        exit 1
    fi
    chmod +x "$SCRIPT_DIR/utils/quick-scan.sh" 2>/dev/null
    "$SCRIPT_DIR/utils/quick-scan.sh" "$SCAN_DIR"
    exit 0
fi

# Memastikan argumen directory diisi
if [[ -z "$SCAN_DIR" ]]; then
    echo "Error: Directory is required."
    echo ""
    usage
    exit 1
fi

# Memastikan direktori yang diberikan valid
if [[ ! -d "$SCAN_DIR" ]]; then
    echo "Error: Directory '$SCAN_DIR' does not exist."
    exit 1
fi

# Menampilkan direktori yang akan dipindai
echo "Scanning directory: $SCAN_DIR"
echo "================================"

# Export fungsi dan variabel untuk digunakan oleh cleaner lainnya
export SCAN_DIR
export DRY_RUN
export VERBOSE
export -f loading_animation

# Statistics tracking
TOTAL_DELETED=0
TOTAL_SIZE_SAVED=0

# Custom delete function that respects dry-run mode
function safe_delete() {
    local target="$1"
    local description="${2:-item}"
    
    # Calculate size before deletion
    if [[ -e "$target" ]]; then
        local size=$(du -sh "$target" 2>/dev/null | cut -f1)
        
        if [[ "$DRY_RUN" == "true" ]]; then
            echo "🔍 Would delete $description ($size): $target"
        else
            if [[ "$VERBOSE" == "true" ]]; then
                echo "🗑️  Deleting $description ($size): $target"
                echo "   📍 Full path: $(realpath "$target" 2>/dev/null || echo "$target")"
            else
                echo "Deleting $description ($size): $target"
            fi
            rm -rf "$target" &
            loading_animation $!
            wait
            echo "✅ Deleted: $target"
            ((TOTAL_DELETED++))
        fi
    fi
}

function track_stats() {
    ((TOTAL_DELETED++))
}

export -f safe_delete
export -f track_stats
export TOTAL_DELETED
