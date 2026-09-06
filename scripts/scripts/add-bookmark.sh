#!/bin/bash

# Display macOS native input dialog using osascript.
# Automatically populates the input field with clipboard content if available,
# and configures 'cancel button "Cancel"' so pressing Escape dismisses the prompt cleanly.

INPUT=$(osascript -e '
tell application "System Events"
    activate

    -- Check clipboard for a default URL
    try
        set clipText to (the clipboard as text)
    on error
        set clipText to ""
    end try
    if clipText does not start with "http" then set clipText to ""

    -- Step 1: Get Title
    set titleDialog to display dialog "Enter Bookmark Title:" default answer "" with title "Add Bookmark - Step 1 of 2" buttons {"Cancel", "Next"} default button "Next" cancel button "Cancel"
    set bookmarkTitle to text returned of titleDialog

    -- Step 2: Get URL
    set urlDialog to display dialog "Enter Bookmark URL:" default answer clipText with title "Add Bookmark - Step 2 of 2" buttons {"Cancel", "Add Bookmark"} default button "Add Bookmark" cancel button "Cancel"
    set bookmarkURL to text returned of urlDialog

    -- Combine Title and URL
    return bookmarkTitle & " | " & bookmarkURL
end tell' 2>/dev/null)

#
# Exit cleanly if user clicked Cancel, pressed Escape, or submitted empty input
if [ -z "$INPUT" ]; then
    exit 0
fi

# Parse Title and URL using '|' delimiter
if [[ "$INPUT" == *"|"* ]]; then
    TITLE="${INPUT%%|*}"
    RAW_URL="${INPUT#*|}"
else
    TITLE="No Title"
    RAW_URL="$INPUT"
fi

# Trim leading/trailing whitespace
TITLE=$(echo "$TITLE" | xargs)
RAW_URL=$(echo "$RAW_URL" | xargs)

# Ensure HTTPS scheme if omitted
if [[ "$RAW_URL" != http* ]]; then
    FETCH_URL="https://$RAW_URL"
else
    FETCH_URL="$RAW_URL"
fi

# Ensure target directory exists and append bookmark
mkdir -p "$HOME/.config"
echo "$TITLE | $FETCH_URL" >> "$HOME/.config/bookmarks.txt"

# Send a native macOS desktop notification
osascript -e "display notification \"Saved: $TITLE\" with title \"Bookmark Added\""

