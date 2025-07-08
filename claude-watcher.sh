#!/bin/bash

FILE=~/.claude/recently_edited.txt

echo "🧠 Watching for Claude-edited files..."

LAST=""

while true; do
    if [ -s "$FILE" ]; then
        CURRENT=$(cat "$FILE")
        if [ "$CURRENT" != "$LAST" ]; then
            echo "📂 Claude edited: $CURRENT"
            nvim +"e $CURRENT"
            LAST="$CURRENT"
        fi
    fi
    sleep 1
done
