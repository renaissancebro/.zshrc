#!/bin/bash

# Monitoring Dashboard Setup Script
# Creates a comprehensive tmux monitoring layout

SESSION_NAME="monitoring_dashboard"
SCRIPT_DIR="$HOME/scripts"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to check if required scripts exist
check_dependencies() {
    local missing=0
    
    echo -e "${BLUE}🔍 Checking monitoring dependencies...${NC}"
    
    # Check for TUI watcher
    if [ ! -f "$HOME/tui_watcher.py" ]; then
        echo -e "${RED}❌ tui_watcher.py not found in home directory${NC}"
        missing=1
    else
        echo -e "${GREEN}✅ tui_watcher.py found${NC}"
    fi
    
    # Check for git status scripts
    if [ ! -f "$SCRIPT_DIR/git_status_summary.sh" ]; then
        echo -e "${RED}❌ git_status_summary.sh not found${NC}"
        missing=1
    else
        echo -e "${GREEN}✅ git_status_summary.sh found${NC}"
    fi
    
    # Check for Claude activity monitor
    if [ ! -f "$SCRIPT_DIR/claude_activity_summary.sh" ]; then
        echo -e "${RED}❌ claude_activity_summary.sh not found${NC}"
        missing=1
    else
        echo -e "${GREEN}✅ claude_activity_summary.sh found${NC}"
    fi
    
    # Check for Python dependencies
    if ! python3 -c "import watchdog, rich" 2>/dev/null; then
        echo -e "${YELLOW}⚠️  Python dependencies (watchdog, rich) may be missing${NC}"
        echo -e "${YELLOW}   Install with: pip3 install watchdog rich${NC}"
    else
        echo -e "${GREEN}✅ Python dependencies available${NC}"
    fi
    
    if [ $missing -eq 1 ]; then
        echo -e "${RED}❌ Some dependencies are missing. Please fix before continuing.${NC}"
        return 1
    fi
    
    return 0
}

# Function to create the monitoring dashboard
create_dashboard() {
    echo -e "${BLUE}🚀 Creating monitoring dashboard...${NC}"
    
    # Check if we're in a git repository
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        echo -e "${YELLOW}⚠️  Not in a Git repository. Git monitoring will be limited.${NC}"
        read -p "Continue anyway? (y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            return 1
        fi
    fi
    
    # Kill existing session if it exists
    tmux kill-session -t "$SESSION_NAME" 2>/dev/null
    
    # Create new session with main window
    tmux new-session -d -s "$SESSION_NAME" -c "$PWD"
    
    # Rename the first window
    tmux rename-window -t "$SESSION_NAME:0" "Dashboard"
    
    # Create the monitoring layout
    # Split into 4 panes in a 2x2 grid
    
    # Top half - split horizontally
    tmux split-window -h -t "$SESSION_NAME:0" -c "$PWD"
    
    # Bottom half - split both panes vertically
    tmux split-window -v -t "$SESSION_NAME:0.0" -c "$PWD"
    tmux split-window -v -t "$SESSION_NAME:0.1" -c "$PWD"
    
    # Configure pane sizes (adjust percentages as needed)
    tmux resize-pane -t "$SESSION_NAME:0.0" -x 50%
    tmux resize-pane -t "$SESSION_NAME:0.1" -x 50%
    
    # Start monitoring tools in each pane
    echo -e "${GREEN}📊 Starting monitoring tools...${NC}"
    
    # Pane 0 (top-left): TUI File Watcher
    tmux send-keys -t "$SESSION_NAME:0.0" "clear && echo '🔍 TUI File Watcher' && echo 'Starting in 2 seconds...' && sleep 2 && python3 ~/tui_watcher.py" C-m
    
    # Pane 1 (top-right): Git Status Summary
    tmux send-keys -t "$SESSION_NAME:0.1" "clear && echo '📊 Git Status Monitor' && echo 'Starting in 3 seconds...' && sleep 3 && bash $SCRIPT_DIR/git_status_summary.sh" C-m
    
    # Pane 2 (bottom-left): Claude Activity Monitor
    tmux send-keys -t "$SESSION_NAME:0.2" "clear && echo '🧠 Claude Activity Monitor' && echo 'Starting in 4 seconds...' && sleep 4 && bash $SCRIPT_DIR/claude_activity_summary.sh" C-m
    
    # Pane 3 (bottom-right): Live Git Diff
    tmux send-keys -t "$SESSION_NAME:0.3" "clear && echo '🔄 Live Git Diff' && echo 'Starting in 5 seconds...' && sleep 5 && while true; do clear; echo '🔄 Live Git Diff ($(date +%H:%M:%S))'; echo '============================'; git diff --color=always --stat 2>/dev/null || echo 'No changes'; echo; git log --oneline -5 2>/dev/null || echo 'No commits'; sleep 5; done" C-m
    
    # Select the first pane
    tmux select-pane -t "$SESSION_NAME:0.0"
    
    # Add pane titles
    tmux set-option -t "$SESSION_NAME" pane-border-status top
    tmux set-option -t "$SESSION_NAME" pane-border-format "#{?pane_active,#[reverse],}#{pane_index}#[default] #{pane_title}"
    
    # Set pane titles
    tmux select-pane -t "$SESSION_NAME:0.0" -T "File Watcher"
    tmux select-pane -t "$SESSION_NAME:0.1" -T "Git Status"
    tmux select-pane -t "$SESSION_NAME:0.2" -T "Claude Activity"
    tmux select-pane -t "$SESSION_NAME:0.3" -T "Git Diff"
    
    echo -e "${GREEN}✅ Monitoring dashboard created!${NC}"
    echo -e "${BLUE}📋 Dashboard Layout:${NC}"
    echo "  ┌─────────────────────┬─────────────────────┐"
    echo "  │   File Watcher      │    Git Status       │"
    echo "  │   (TUI)             │    (Summary)        │"
    echo "  ├─────────────────────┼─────────────────────┤"
    echo "  │   Claude Activity   │    Git Diff         │"
    echo "  │   (Commands/Edits)  │    (Live Changes)   │"
    echo "  └─────────────────────┴─────────────────────┘"
    echo
    echo -e "${YELLOW}Navigation:${NC}"
    echo "  • Ctrl+b + Arrow keys: Switch between panes"
    echo "  • Ctrl+b + z: Zoom into current pane"
    echo "  • Ctrl+b + x: Close current pane"
    echo "  • Ctrl+b + d: Detach from session"
    echo
    echo -e "${BLUE}To reattach: tmux attach -t $SESSION_NAME${NC}"
    echo -e "${BLUE}To kill dashboard: tmux kill-session -t $SESSION_NAME${NC}"
}

# Function to attach to existing dashboard
attach_dashboard() {
    if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
        echo -e "${GREEN}📊 Attaching to existing dashboard...${NC}"
        tmux attach-session -t "$SESSION_NAME"
    else
        echo -e "${RED}❌ No existing dashboard found. Creating new one...${NC}"
        create_dashboard
        if [ $? -eq 0 ]; then
            tmux attach-session -t "$SESSION_NAME"
        fi
    fi
}

# Function to kill dashboard
kill_dashboard() {
    if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
        tmux kill-session -t "$SESSION_NAME"
        echo -e "${GREEN}✅ Monitoring dashboard stopped${NC}"
    else
        echo -e "${YELLOW}⚠️  No dashboard session found${NC}"
    fi
}

# Main function
main() {
    case "$1" in
        "start"|"")
            check_dependencies
            if [ $? -eq 0 ]; then
                create_dashboard
                if [ $? -eq 0 ]; then
                    tmux attach-session -t "$SESSION_NAME"
                fi
            fi
            ;;
        "attach")
            attach_dashboard
            ;;
        "kill"|"stop")
            kill_dashboard
            ;;
        "check")
            check_dependencies
            ;;
        "help")
            echo "Monitoring Dashboard Commands:"
            echo "  start  - Create and start new dashboard (default)"
            echo "  attach - Attach to existing dashboard"
            echo "  kill   - Stop the dashboard"
            echo "  check  - Check dependencies"
            echo "  help   - Show this help"
            ;;
        *)
            echo "Usage: $0 {start|attach|kill|check|help}"
            echo "Run '$0 help' for more information"
            ;;
    esac
}

# Run main function
main "$@"