#!/usr/bin/env bash
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

BOOKMARKS_FILE="$HOME/.config/bookmarks.txt"

# Check if the file exists before proceeding
if [ ! -f "$BOOKMARKS_FILE" ]; then
    osascript -e 'display notification "Bookmarks file not found at ~/.config/bookmarks.txt" with title "Bookmark Opener"'
    exit 1
fi

# Pass the contents of the file to choose
SELECTED=$(choose -p "Open Bookmark:" < "$BOOKMARKS_FILE")

if [ -n "$SELECTED" ]; then
    # Extract the URL portion after the pipe separator
    URL=$(echo "$SELECTED" | awk -F ' \\| ' '{print $2}')

    if [ -n "$URL" ]; then
        open "$URL"
    fi
fi
