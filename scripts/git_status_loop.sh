#!/bin/bash

# Git diff viewer for claude-repl
# Shows actual changes with syntax highlighting

while true; do
    clear
    echo "🔄 Git Changes ($(date '+%H:%M:%S'))"
    echo "=================================="
    
    # Check if we're in a git repository
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        # Show status summary
        git status --short
        echo
        
        # Show actual diff with colors and context
        if command -v delta >/dev/null 2>&1; then
            git diff --color=always | delta --paging=never --line-numbers
        elif command -v bat >/dev/null 2>&1; then
            git diff --color=always | bat --style=numbers,changes --language=diff --paging=never
        else
            git diff --color=always --unified=3
        fi
        
        # Show staged changes if any
        if ! git diff --staged --quiet; then
            echo
            echo "--- STAGED CHANGES ---"
            if command -v delta >/dev/null 2>&1; then
                git diff --staged --color=always | delta --paging=never --line-numbers
            elif command -v bat >/dev/null 2>&1; then
                git diff --staged --color=always | bat --style=numbers,changes --language=diff --paging=never
            else
                git diff --staged --color=always --unified=3
            fi
        fi
    else
        echo "❌ Not in a Git repository"
    fi
    
    sleep 3
done