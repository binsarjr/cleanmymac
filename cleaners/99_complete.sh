#!/bin/bash

# Cleanup Complete Message

echo "🎉 Cleanup Complete!"
echo "===================="

if [[ "$DRY_RUN" == "true" ]]; then
    echo "Dry run completed - no files were actually deleted."
    echo "Run without --dry-run to perform the actual cleanup."
else
    echo "All specified directories have been cleaned successfully."
    echo "Your Mac is now squeaky clean! 🧽✨"
    echo ""
    echo "📊 Summary:"
    echo "  • Items processed: $TOTAL_DELETED"
    if [[ $TOTAL_DELETED -gt 0 ]]; then
        echo "  • Status: Success - disk space has been freed!"
    else
        echo "  • Status: No cleanup needed - your workspace is already clean!"
    fi
fi

echo ""
