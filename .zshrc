# ----- 🧼 PATH Setup -----

# 1. Add Homebrew (macOS ARM)
export PATH="/opt/homebrew/bin:$PATH"

# 2. Pyenv setup
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# Initialize pyenv (must be after PATH)
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# Optional: Conda (commented out — only enable if needed)
# >>> conda initialize >>>
# __conda_setup="$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
#         . "/opt/anaconda3/etc/profile.d/conda.sh"
#     else
#         export PATH="/opt/anaconda3/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# <<< conda initialize <<<

# ----- ⚙️ Aliases -----

# Use neovim when typing vi
alias nvi="nvim"
alias runpipe="cd ~/projects/pipe && source venv/bin/activate"


export PATH="$HOME/.local/bin:$PATH"
export ALACRITTY_CONFIG="$HOME/.config/alacritty/alacritty.yml"

# Safe guard for rm -rf
# alias rm='trash'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
alias refactor="/Users/joshuafreeman/Desktop/agent_projects/autogen/refactor_agent/refactor_alias.sh"

# Refactor with gemini CLI AI flow
alias refactorai='function _r() { cat "$1" | gemini -p "Extract reusable utilities"; }; _r'
alias codepick='function _c() { find . -type f -name "*.py" | fzf --preview "bat --style=numbers --color=always --line-range :100 {}"; }; _c'

# Load custom CLI aliases
[ -f ~/.aliases ] && source ~/.aliases

# Claude AI functionality 
#
alias cld='claude' 
# ----- 🧠 Claude AI Integration -----
claude-repl() {
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    tmux new-session -d -s code_session -c "$PWD" \;\
      split-window -h -p 30 -c "$PWD" 'claude' \;\
      select-pane -t 0 \;\
      send-keys 'nvim .' C-m \;\
      attach-session -t code_session
  else
    echo "❌ Not in a Git repository. Please cd into a project first."
  fi
}

# Close workflow
alias close-claude='tmux kill-session -t code_session'
alias repl='claude-repl'

# Full on dual agent command
alias runflow="cd ~/dual_agent_refactor && tmux new-session \; \
  split-window -h 'sh scripts/inspector.sh' \; \
  split-window -v 'sh scripts/fixer.sh' \; \
  select-pane -t 0 && clear"

alias ga='git add .'
alias gp='git push origin main'
alias pushy='git push'
## git commit alias
#
gc() {
  if [ -z "$1" ]; then
    echo "❌ Commit message required"
  else
    git commit -m "$*"
  fi
}

alias please='sudo $(fc -ln -1)'
alias reload='source ~/.zshrc'
alias venv='source venv/bin/activate'
alias setenv='python3 -m venv venv'
# Tmux improvements
alias watch_claude_edit='watch -n 1 '\''cat ~/.claude/recently_edited.txt | xargs -I{} nvim +":e {}"'\'''

# Claude file edit watcher - shows file changes in real-time
claude-watch() {
  echo "🧠 Watching Claude file changes (Ctrl+C to stop)..."
  local last_file=""
  while true; do
    if [ -s ~/.claude/recently_edited.txt ]; then
      local current_file=$(cat ~/.claude/recently_edited.txt)
      if [ "$current_file" != "$last_file" ]; then
        echo "📂 $(date '+%H:%M:%S') - Claude edited: $current_file"
        last_file="$current_file"
      fi
    fi
    sleep 1
  done
}

# Watch both file changes and command log
claude-monitor() {
  echo "🧠 Monitoring Claude activity (Ctrl+C to stop)..."
  tail -f ~/.claude/bash-command-log.txt | while read line; do
    echo "⚡ $(date '+%H:%M:%S') - $line"
  done
}
alias cstatus='tail -f ~/.claude/bash-command-log.txt'
alias gwatch='watch -n 2 "clear && git status -s && git diff --stat"'

# New structured monitoring aliases
alias claude-activity='~/scripts/claude_activity_summary.sh'
alias claude-summary='~/scripts/claude_activity_summary.sh summary'
alias claude-repl-quiet='claude-repl-summary'

# Alternative claude-repl with less overwhelming git view
claude-repl-summary() {
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    tmux new-session -d -s code_session -c "$PWD" \;\
      split-window -h -p 30 -c "$PWD" 'claude' \;\
      split-window -v -p 25 -c "$PWD" '~/scripts/git_status_summary.sh' \;\
      select-pane -t 0 \;\
      send-keys 'nvim .' C-m \;\
      attach-session -t code_session
  else
    echo "❌ Not in a Git repository. Please cd into a project first."
  fi
}
# See what chagnes
alias cg='git --no-pager diff HEAD^ HEAD'

# Claude monitoring function with claude-watch/claude-activities on left and claude code on right
claude-monitor-repl() {
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    tmux new-session -d -s claude_monitor_session -c "$PWD" \;\
      split-window -h -p 50 -c "$PWD" 'claude' \;\
      split-window -v -p 50 -c "$PWD" 'claude-watch' \;\
      select-pane -t 0 \;\
      send-keys 'claude-activity' C-m \;\
      attach-session -t claude_monitor_session
  else
    echo "❌ Not in a Git repository. Please cd into a project first."
  fi
}

# Close claude monitor workflow
alias close-claude-monitor='tmux kill-session -t claude_monitor_session'

# TUI Watcher - Live file monitoring
tuiwatch() {
  python3 ~/tui_watcher.py "$@"
}

alias py='python'

# Monitoring Dashboard - Comprehensive monitoring setup
alias monitor='~/scripts/monitoring_dashboard.sh'
alias monitor-start='~/scripts/monitoring_dashboard.sh start'
alias monitor-stop='~/scripts/monitoring_dashboard.sh kill'
alias monitor-attach='~/scripts/monitoring_dashboard.sh attach'

# Claude Observer aliases
alias claude-observer='~/dotfiles/scripts/claude_observer_enhanced.sh'
alias observer-start='~/dotfiles/scripts/claude_observer_enhanced.sh start'
alias observer-stop='~/dotfiles/scripts/claude_observer_enhanced.sh stop'
alias observer-status='~/dotfiles/scripts/claude_observer_enhanced.sh status'
alias observer-watch='~/dotfiles/scripts/claude_observer_enhanced.sh watch'
alias observer-anomalies='~/dotfiles/scripts/claude_observer_enhanced.sh anomalies'
alias firstp='ga && gc initial commit && gp'


# 🚀 Claude Autonomous Engine
alias claude-auto='cd /Users/joshuafreeman/custom-claude-hooks && uv run .claude/instruction_dispatch.py --auto'
alias claude-once='cd /Users/joshuafreeman/custom-claude-hooks && uv run .claude/instruction_dispatch.py --once'
alias claude-status='cat /Users/joshuafreeman/custom-claude-hooks/logs/status.json | jq'
alias claude-setup='cp -r /Users/joshuafreeman/custom-claude-hooks/.claude/hooks ~/.claude/ && cp /Users/joshuafreeman/custom-claude-hooks/.claude/settings.json ~/.claude/'

# 🗃 Multi-project loader
alias claude-work='uv run /Users/joshuafreeman/custom-claude-hooks/.claude/instruction_dispatch.py --work-dir'

# 📁 Task file helpers
alias task-list='ls -la /Users/joshuafreeman/custom-claude-hooks/.claude/tasks/'
alias task-logs='tail -f /Users/joshuafreeman/custom-claude-hooks/logs/task_dispatcher.json'

# ⚡ Quick manual task creation
alias quick-task='function _qt() { echo "{\"id\":\"$1\",\"title\":\"$2\",\"description\":\"$3\",\"type\":\"general\"}" > "/Users/joshuafreeman/custom-claude-hooks/.claude/tasks/$1.json"; }; _qt'

# 🌍 Remote scheduling system
alias remote-task='function _rt() { echo "{\"id\":\"remote_$(date +%s)\",\"title\":\"$1\",\"description\":\"$2\",\"type\":\"general\",\"priority\":\"high\"}" > ~/claude_control/tasks/remote_$(date +%s).json; }; _rt'

# 🧠 Background daemon
alias claude-daemon='cd ~/claude_control && export CLAUDE_AUTO_MODE=true && uv run instruction_dispatch.py --auto &'

# Path shortcut
alias sandbox='cd ~/Desktop/agent_projects/'
