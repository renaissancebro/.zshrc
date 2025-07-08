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
alias rm='trash'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
alias refactor="/Users/joshuafreeman/Desktop/agent_projects/autogen/refactor_agent/refactor_alias.sh"

# Refactor with gemini CLI AI flow
alias refactorai='function _r() { cat "$1" | gemini -p "Extract reusable utilities"; }; _r'
alias codepick='function _c() { find . -type f -name "*.py" | fzf --preview "bat --style=numbers --color=always --line-range :100 {}"; }; _c'

# Load custom CLI aliases
[ -f ~/.aliases ] && source ~/.aliases

# Claude AI functionality 
#
# 
# ----- 🧠 Claude AI Integration -----
claude-repl() {
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    tmux new-session -d -s code_session -c "$PWD" \;\
      split-window -h -p 30 -c "$PWD" 'claude' \;\
      split-window -v -p 25 -c "$PWD" 'lazygit' \;\
      select-pane -t 0 \;\
      send-keys 'nvim .' C-m \;\
      attach-session -t code_session
  else
    echo "❌ Not in a Git repository. Please cd into a project first."
  fi
}

# Close workflow
alias close-claude='tmux kill-session -t code_session'

# Full on dual agent command
alias runflow="cd ~/dual_agent_refactor && tmux new-session \; \
  split-window -h 'sh scripts/inspector.sh' \; \
  split-window -v 'sh scripts/fixer.sh' \; \
  select-pane -t 0 && clear"

## git commit alias
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

# Tmux improvements
alias watch_claude_edit='watch -n 1 '\''cat ~/.claude/recently_edited.txt | xargs -I{} nvim +":e {}"'\'''

# Claude file edit watcher session
claude-watch() {
  tmux new-session -d -s claude_watch -c "$PWD" \
    "watch -n 1 'cat ~/.claude/recently_edited.txt | xargs -I{} nvim +\":e {}\"'" \;\
    attach-session -t claude_watch
}

alias claude_watch='~/claude-watcher.sh'
