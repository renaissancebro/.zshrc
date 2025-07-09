#!/bin/bash

# Claude Code Safety Hooks
# Collection of safety functions for Claude Code hooks

# Check for dangerous bash commands
check_dangerous_commands() {
    local command="$1"
    
    # List of dangerous patterns
    local dangerous_patterns=(
        "rm -rf"
        "sudo rm"
        "format"
        "mkfs"
        "dd if="
        "chmod -R 777"
        "chown -R"
        "> /dev/"
        "killall"
        "pkill -9"
        "shutdown"
        "reboot"
        "halt"
    )
    
    for pattern in "${dangerous_patterns[@]}"; do
        if echo "$command" | grep -q "$pattern"; then
            echo "❌ BLOCKED: Dangerous command detected: $pattern" >&2
            echo "Command: $command" >&2
            exit 1
        fi
    done
}

# Backup file before editing
backup_before_edit() {
    local file_path="$1"
    
    if [ -f "$file_path" ]; then
        local backup_dir="$HOME/.claude/backups"
        mkdir -p "$backup_dir"
        
        local timestamp=$(date +%Y%m%d_%H%M%S)
        local backup_name="$(basename "$file_path").backup.$timestamp"
        
        cp "$file_path" "$backup_dir/$backup_name"
        echo "📁 Backup created: $backup_dir/$backup_name" >> ~/.claude/safety.log
    fi
}

# Check file size limits
check_file_size() {
    local file_path="$1"
    local max_size_mb=10
    local max_size_bytes=$((max_size_mb * 1024 * 1024))
    
    if [ -f "$file_path" ]; then
        local file_size=$(wc -c < "$file_path")
        if [ "$file_size" -gt "$max_size_bytes" ]; then
            echo "❌ BLOCKED: File too large ($(($file_size / 1024 / 1024))MB > ${max_size_mb}MB)" >&2
            echo "File: $file_path" >&2
            exit 1
        fi
    fi
}

# Log safety events
log_safety_event() {
    local event="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $event" >> ~/.claude/safety.log
}

# Auto-commit after changes (optional)
auto_commit_changes() {
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        if ! git diff --quiet || ! git diff --staged --quiet; then
            git add -A
            git commit -m "Auto-commit: Claude changes at $(date '+%Y-%m-%d %H:%M:%S')" --quiet
            log_safety_event "Auto-committed changes"
        fi
    fi
}

# Check for sensitive files
check_sensitive_files() {
    local file_path="$1"
    
    # List of sensitive file patterns
    local sensitive_patterns=(
        ".env"
        ".secret"
        "id_rsa"
        "private.key"
        ".pem"
        "password"
        "credentials"
        ".aws/credentials"
        ".ssh/config"
    )
    
    for pattern in "${sensitive_patterns[@]}"; do
        if echo "$file_path" | grep -q "$pattern"; then
            echo "⚠️  WARNING: Editing sensitive file: $file_path" >&2
            log_safety_event "WARNING: Sensitive file edited: $file_path"
            # Don't block, just warn
        fi
    done
}

# Main safety check function
main() {
    local action="$1"
    shift
    
    case "$action" in
        "check-command")
            check_dangerous_commands "$1"
            ;;
        "backup-file")
            backup_before_edit "$1"
            ;;
        "check-size")
            check_file_size "$1"
            ;;
        "check-sensitive")
            check_sensitive_files "$1"
            ;;
        "auto-commit")
            auto_commit_changes
            ;;
        *)
            echo "Usage: $0 {check-command|backup-file|check-size|check-sensitive|auto-commit} [args...]"
            exit 1
            ;;
    esac
}

# Run main function if script is executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi