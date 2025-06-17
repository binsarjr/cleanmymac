#!/bin/bash

# Clean My Mac - Advanced Cleanup Tool
# =====================================

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLEANERS="$SCRIPT_DIR/cleaners"
METAMODULE="$CLEANERS/00_meta.sh"

if [ -z "$1" ]; then
    echo "Clean My Mac - Advanced Cleanup Tool"
    echo "====================================="
    echo "Error: Directory argument is required."
    echo ""
    echo "Usage: $0 [options] [directory]"
    echo "Example: $0 ~/Projects"
    echo "Example: $0 --dry-run ~/Projects"
    echo ""
    echo "Use -h or --help for more information."
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