#!/bin/bash

# Claude Activity Summary
# Shows structured view of what Claude is doing

LOG_FILE="$HOME/.claude/bash-command-log.txt"
EDIT_FILE="$HOME/.claude/recently_edited.txt"
ACTIVITY_LOG="$HOME/.claude/activity_summary.log"

# Function to log activity with timestamp
log_activity() {
    echo "$(date '+%H:%M:%S') - $1" >> "$ACTIVITY_LOG"
}

# Function to get file change summary
get_file_summary() {
    local file="$1"
    if [[ -f "$file" ]]; then
        local lines_added=$(git diff --numstat "$file" 2>/dev/null | cut -f1)
        local lines_removed=$(git diff --numstat "$file" 2>/dev/null | cut -f2)
        
        if [[ "$lines_added" != "-" && "$lines_removed" != "-" ]]; then
            echo "+$lines_added/-$lines_removed lines"
        else
            echo "modified"
        fi
    else
        echo "new file"
    fi
}

# Monitor mode
monitor_mode() {
    echo "🧠 Claude Activity Monitor (Ctrl+C to stop)"
    echo "=========================================="
    
    # Clear previous activity log
    > "$ACTIVITY_LOG"
    
    local last_edit=""
    local last_command=""
    local display_buffer=""
    
    while true; do
        local updated=false
        
        # Check for new file edits
        if [[ -s "$EDIT_FILE" ]]; then
            local current_edit=$(cat "$EDIT_FILE")
            if [[ "$current_edit" != "$last_edit" ]]; then
                local summary=$(get_file_summary "$current_edit")
                log_activity "📝 Edited: $(basename "$current_edit") ($summary)"
                last_edit="$current_edit"
                updated=true
            fi
        fi
        
        # Check for new commands
        if [[ -s "$LOG_FILE" ]]; then
            local current_command=$(tail -1 "$LOG_FILE")
            if [[ "$current_command" != "$last_command" ]]; then
                log_activity "⚡ Command: $current_command"
                last_command="$current_command"
                updated=true
            fi
        fi
        
        # Only update display if there's new content or every 5 seconds
        local current_content=""
        if [[ -s "$ACTIVITY_LOG" ]]; then
            current_content=$(tail -10 "$ACTIVITY_LOG")
        else
            current_content="No activity yet..."
        fi
        
        # Update display if content changed or every 5 cycles
        if [[ "$current_content" != "$display_buffer" ]] || [[ $((SECONDS % 10)) -eq 0 ]]; then
            printf '\033[2J\033[H'  # Clear screen more smoothly
            echo "🧠 Claude Activity Monitor ($(date '+%H:%M:%S'))"
            echo "=========================================="
            echo
            echo "$current_content"
            display_buffer="$current_content"
        fi
        
        sleep 1  # Faster polling for smoother updates
    done
}

# Summary mode - just show what files were changed
summary_mode() {
    echo "📊 Claude Session Summary"
    echo "========================"
    
    # Show unique files that were edited
    echo "Files modified:"
    if [[ -s "$ACTIVITY_LOG" ]]; then
        grep "📝 Edited:" "$ACTIVITY_LOG" | sort | uniq -c | sort -nr
    else
        echo "No files modified"
    fi
    
    echo
    echo "Commands run:"
    if [[ -s "$ACTIVITY_LOG" ]]; then
        grep "⚡ Command:" "$ACTIVITY_LOG" | wc -l | tr -d ' '
    else
        echo "0"
    fi
}

# Main script
case "$1" in
    "monitor"|"")
        monitor_mode
        ;;
    "summary")
        summary_mode
        ;;
    "clear")
        > "$ACTIVITY_LOG"
        echo "Activity log cleared"
        ;;
    *)
        echo "Usage: $0 [monitor|summary|clear]"
        echo "  monitor  - Live activity monitoring (default)"
        echo "  summary  - Show session summary"
        echo "  clear    - Clear activity log"
        ;;
esac