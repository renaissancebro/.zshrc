#!/bin/bash

# Git status summary - less overwhelming version
# Shows file changes without huge diffs

while true; do
    clear
    echo "📊 Git Summary ($(date '+%H:%M:%S'))"
    echo "=================================="
    
    # Check if we're in a git repository
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        # Show status summary
        git status --short
        echo
        
        # Show file-by-file change summary instead of full diff
        echo "File Changes:"
        git diff --name-only | while read -r file; do
            if [[ -n "$file" ]]; then
                local stats=$(git diff --numstat "$file" | cut -f1,2)
                local added=$(echo "$stats" | cut -f1)
                local removed=$(echo "$stats" | cut -f2)
                
                if [[ "$added" != "-" && "$removed" != "-" ]]; then
                    echo "  📝 $file (+$added/-$removed)"
                else
                    echo "  📝 $file (binary/renamed)"
                fi
            fi
        done
        
        # Show staged file summary
        if ! git diff --staged --quiet; then
            echo
            echo "Staged Changes:"
            git diff --staged --name-only | while read -r file; do
                if [[ -n "$file" ]]; then
                    local stats=$(git diff --staged --numstat "$file" | cut -f1,2)
                    local added=$(echo "$stats" | cut -f1)
                    local removed=$(echo "$stats" | cut -f2)
                    
                    if [[ "$added" != "-" && "$removed" != "-" ]]; then
                        echo "  ✅ $file (+$added/-$removed)"
                    else
                        echo "  ✅ $file (binary/renamed)"
                    fi
                fi
            done
        fi
        
        # Show total changes
        echo
        local total_files=$(git diff --name-only | wc -l | tr -d ' ')
        local total_staged=$(git diff --staged --name-only | wc -l | tr -d ' ')
        echo "Total: $total_files modified, $total_staged staged"
        
    else
        echo "❌ Not in a Git repository"
    fi
    
    sleep 3
done