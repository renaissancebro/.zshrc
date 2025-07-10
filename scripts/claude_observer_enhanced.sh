#!/bin/bash

# Claude Observer Enhanced - Shell wrapper with existing integration
# Integrates with your existing monitoring infrastructure

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
CLAUDE_DIR="$HOME/.claude"
OBSERVER_LOG="$CLAUDE_DIR/observer.log"
OBSERVER_PID_FILE="$CLAUDE_DIR/observer.pid"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$OBSERVER_LOG"
}

start_observer() {
    if [ -f "$OBSERVER_PID_FILE" ] && kill -0 $(cat "$OBSERVER_PID_FILE") 2>/dev/null; then
        echo -e "${YELLOW}Observer is already running (PID: $(cat $OBSERVER_PID_FILE))${NC}"
        return 0
    fi
    
    echo -e "${GREEN}Starting Claude Observer...${NC}"
    
    # Check dependencies
    if ! command -v python3 &> /dev/null; then
        echo -e "${RED}Python3 is required but not installed${NC}"
        exit 1
    fi
    
    # Install Python dependencies if needed
    python3 -c "import watchdog, langfuse, psutil" 2>/dev/null || {
        echo -e "${YELLOW}Installing Python dependencies...${NC}"
        pip3 install watchdog langfuse psutil
    }
    
    # Start the observer
    nohup python3 "$SCRIPT_DIR/claude_observer.py" \
        --config "$SCRIPT_DIR/claude_observer_config.json" \
        > "$OBSERVER_LOG" 2>&1 &
    
    echo $! > "$OBSERVER_PID_FILE"
    
    # Give it a moment to start
    sleep 2
    
    if kill -0 $(cat "$OBSERVER_PID_FILE") 2>/dev/null; then
        echo -e "${GREEN}✅ Observer started successfully (PID: $(cat $OBSERVER_PID_FILE))${NC}"
        log_message "Observer started successfully"
        
        # Update your existing monitoring
        if [ -f "$HOME/.claude/activity_summary.log" ]; then
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] Claude Observer started" >> "$HOME/.claude/activity_summary.log"
        fi
    else
        echo -e "${RED}❌ Failed to start observer${NC}"
        cat "$OBSERVER_LOG"
        exit 1
    fi
}

stop_observer() {
    if [ -f "$OBSERVER_PID_FILE" ] && kill -0 $(cat "$OBSERVER_PID_FILE") 2>/dev/null; then
        echo -e "${YELLOW}Stopping Claude Observer...${NC}"
        kill $(cat "$OBSERVER_PID_FILE")
        rm -f "$OBSERVER_PID_FILE"
        echo -e "${GREEN}✅ Observer stopped${NC}"
        log_message "Observer stopped"
    else
        echo -e "${YELLOW}Observer is not running${NC}"
    fi
}

status_observer() {
    if [ -f "$OBSERVER_PID_FILE" ] && kill -0 $(cat "$OBSERVER_PID_FILE") 2>/dev/null; then
        PID=$(cat "$OBSERVER_PID_FILE")
        echo -e "${GREEN}✅ Observer is running (PID: $PID)${NC}"
        
        # Show recent activity
        if [ -f "$OBSERVER_LOG" ]; then
            echo -e "\n${BLUE}Recent Activity:${NC}"
            tail -5 "$OBSERVER_LOG"
        fi
        
        # Show process info
        echo -e "\n${BLUE}Process Info:${NC}"
        ps -p $PID -o pid,ppid,start,time,comm
        
        # Show system impact
        echo -e "\n${BLUE}System Impact:${NC}"
        ps -p $PID -o pid,pcpu,pmem,rss,vsz
        
    else
        echo -e "${RED}❌ Observer is not running${NC}"
    fi
}

show_anomalies() {
    if [ -f "$OBSERVER_LOG" ]; then
        echo -e "${BLUE}Recent Anomalies:${NC}"
        grep -i "anomaly" "$OBSERVER_LOG" | tail -10
    else
        echo -e "${YELLOW}No observer log found${NC}"
    fi
}

watch_live() {
    echo -e "${GREEN}Watching live observer output (Ctrl+C to stop)...${NC}"
    if [ -f "$OBSERVER_LOG" ]; then
        tail -f "$OBSERVER_LOG"
    else
        echo -e "${YELLOW}No observer log found${NC}"
    fi
}

integrate_with_existing() {
    echo -e "${BLUE}Integrating with existing monitoring...${NC}"
    
    # Add to your existing monitoring dashboard
    if [ -f "$HOME/scripts/monitoring_dashboard.sh" ]; then
        echo -e "${GREEN}Adding to monitoring dashboard...${NC}"
        
        # Add observer status to dashboard
        cat >> "$HOME/scripts/monitoring_dashboard.sh" << 'EOF'

# Claude Observer Status
echo "=== Claude Observer Status ==="
if [ -f "$HOME/.claude/observer.pid" ] && kill -0 $(cat "$HOME/.claude/observer.pid") 2>/dev/null; then
    echo "✅ Observer running (PID: $(cat $HOME/.claude/observer.pid))"
    # Show recent anomalies
    if [ -f "$HOME/.claude/observer.log" ]; then
        echo "Recent anomalies:"
        grep -i "anomaly" "$HOME/.claude/observer.log" | tail -3
    fi
else
    echo "❌ Observer not running"
fi
echo ""
EOF
    fi
    
    # Add to zshrc aliases
    if [ -f "$HOME/.zshrc" ]; then
        echo -e "${GREEN}Adding aliases to .zshrc...${NC}"
        
        # Check if aliases already exist
        if ! grep -q "claude-observer" "$HOME/.zshrc"; then
            cat >> "$HOME/.zshrc" << 'EOF'

# Claude Observer aliases
alias claude-observer='~/scripts/claude_observer_enhanced.sh'
alias observer-start='~/scripts/claude_observer_enhanced.sh start'
alias observer-stop='~/scripts/claude_observer_enhanced.sh stop'
alias observer-status='~/scripts/claude_observer_enhanced.sh status'
alias observer-watch='~/scripts/claude_observer_enhanced.sh watch'
alias observer-anomalies='~/scripts/claude_observer_enhanced.sh anomalies'
EOF
            echo -e "${GREEN}✅ Aliases added to .zshrc${NC}"
        else
            echo -e "${YELLOW}Aliases already exist in .zshrc${NC}"
        fi
    fi
    
    # Create systemd service for auto-start (optional)
    if command -v systemctl &> /dev/null; then
        echo -e "${BLUE}Setting up systemd service...${NC}"
        
        cat > "$HOME/.config/systemd/user/claude-observer.service" << EOF
[Unit]
Description=Claude Code Observer
After=network.target

[Service]
Type=forking
ExecStart=$SCRIPT_DIR/claude_observer_enhanced.sh start
ExecStop=$SCRIPT_DIR/claude_observer_enhanced.sh stop
Restart=always
RestartSec=10
Environment=HOME=$HOME
Environment=PATH=$PATH

[Install]
WantedBy=default.target
EOF
        
        systemctl --user daemon-reload
        echo -e "${GREEN}✅ Systemd service created${NC}"
        echo -e "${BLUE}To enable auto-start: systemctl --user enable claude-observer${NC}"
    fi
}

# Main command handling
case "$1" in
    start)
        start_observer
        ;;
    stop)
        stop_observer
        ;;
    restart)
        stop_observer
        sleep 2
        start_observer
        ;;
    status)
        status_observer
        ;;
    anomalies)
        show_anomalies
        ;;
    watch)
        watch_live
        ;;
    integrate)
        integrate_with_existing
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status|anomalies|watch|integrate}"
        echo ""
        echo "Commands:"
        echo "  start      - Start the Claude Observer"
        echo "  stop       - Stop the Claude Observer"
        echo "  restart    - Restart the Claude Observer"
        echo "  status     - Show observer status and recent activity"
        echo "  anomalies  - Show recent anomalies detected"
        echo "  watch      - Watch live observer output"
        echo "  integrate  - Integrate with existing monitoring setup"
        echo ""
        echo "After running 'integrate', you can use these aliases:"
        echo "  claude-observer, observer-start, observer-stop, observer-status"
        echo "  observer-watch, observer-anomalies"
        exit 1
        ;;
esac