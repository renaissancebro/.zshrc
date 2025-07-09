# 🛠️ Joshua's Dotfiles

A comprehensive zsh configuration with AI-powered development workflow, monitoring tools, and productivity enhancements.

## 🚀 Features

### 🧠 Claude AI Integration
- **AI-Powered Development Workflow** with tmux integration
- **Real-time Activity Monitoring** for Claude commands and file edits
- **Structured Monitoring Dashboard** with comprehensive project oversight
- **Safety Hooks** for dangerous command prevention and file backups

### 📊 Monitoring & Observability  
- **Live File Watching** with Rich TUI interface
- **Git Status Monitoring** with clean summaries
- **Activity Tracking** for all development actions
- **Comprehensive Dashboard** with 4-pane monitoring setup

### ⚡ Productivity Aliases
- **Git Shortcuts** for common operations
- **Development Tools** integration (fzf, bat, nvim)
- **Python Environment** management
- **Safety Features** including secure file deletion

## 🎯 Quick Start

### Core Commands
```bash
# AI Development
repl                    # Start Claude AI coding session
close-claude           # Close Claude session
claude-activity        # Monitor Claude activity
claude-summary         # Session summary

# Monitoring Dashboard
monitor                # Start comprehensive monitoring
monitor-attach         # Attach to existing dashboard
monitor-stop           # Stop monitoring dashboard

# File Watching
tuiwatch               # Live file monitoring with TUI

# Git Shortcuts
ga                     # git add .
gc "message"           # git commit with message
gp                     # git push
cg                     # git diff HEAD^ HEAD (see changes)
```

## 🏗️ Architecture

### Claude AI Workflow
The `repl` command creates a 3-pane tmux session:
```
┌─────────────────────┬─────────────────────┐
│                     │                     │
│      Neovim         │      Claude         │
│      Editor         │       CLI           │
│                     │                     │
├─────────────────────┼─────────────────────┤
│                     │                     │
│                     │   Activity Monitor  │
│                     │   (Live Updates)    │
│                     │                     │
└─────────────────────┴─────────────────────┘
```

### Monitoring Dashboard
The `monitor` command creates a 4-pane monitoring setup:
```
┌─────────────────────┬─────────────────────┐
│   File Watcher      │    Git Status       │
│   (TUI Interface)   │   (Summary View)    │
├─────────────────────┼─────────────────────┤
│   Claude Activity   │    Git Diff         │
│   (Commands/Edits)  │   (Live Changes)    │
└─────────────────────┴─────────────────────┘
```

## 🔧 Configuration

### Environment Setup
- **Homebrew** (macOS ARM support)
- **Pyenv** for Python version management
- **FZF** for fuzzy finding
- **Alacritty** terminal configuration

### Key Aliases & Functions

#### Development Workflow
- `repl` - Start Claude AI coding session
- `runpipe` - Activate pipe project environment
- `refactor` - AI-powered code refactoring
- `codepick` - FZF-based Python file picker

#### Git Operations
- `ga` - `git add .`
- `gc "msg"` - `git commit -m "msg"`
- `gp` - `git push`
- `cg` - Show diff between HEAD and previous commit

#### Monitoring Tools
- `claude-activity` - Live activity monitoring
- `claude-watch` - File change monitoring
- `claude-monitor` - Command monitoring
- `tuiwatch` - TUI file watcher
- `monitor` - Comprehensive dashboard

#### Utility Functions
- `please` - Repeat last command with sudo
- `reload` - Reload zsh configuration
- `venv` - Activate Python virtual environment

## 📦 Dependencies

### Required Tools
- `tmux` - Terminal multiplexer
- `git` - Version control
- `nvim` - Neovim editor
- `fzf` - Fuzzy finder
- `bat` - Better cat with syntax highlighting
- `trash` - Safe file deletion
- `python3` - Python runtime

### Python Packages
- `watchdog` - File system monitoring
- `rich` - TUI interface library

### Optional Tools
- `delta` - Better git diff viewer
- `gemini` - AI CLI tool

## 🛡️ Safety Features

### File Protection
- **Safe Delete**: `rm` aliased to `trash`
- **Auto Backup**: Files backed up before Claude edits
- **Size Limits**: Prevents editing files >10MB
- **Sensitive File Warnings**: Alerts for .env, keys, etc.

### Command Safety
- **Dangerous Command Detection**: Blocks `rm -rf`, `format`, etc.
- **Command Logging**: All bash commands logged
- **Activity Tracking**: Complete audit trail

## 🎨 Customization

### Adding New Aliases
```bash
# Add to ~/.zshrc
alias myalias='my command'

# Reload configuration
reload
```

### Extending Monitoring
```bash
# Add new monitoring script
~/scripts/my_monitor.sh

# Include in dashboard
# Edit ~/scripts/monitoring_dashboard.sh
```

## 📁 File Structure

```
~/dotfiles/
├── .zshrc                          # Main configuration
├── claude-settings.json            # Claude Code settings
├── scripts/
│   ├── claude_activity_summary.sh  # Activity monitoring
│   ├── git_status_loop.sh          # Git status monitoring
│   ├── git_status_summary.sh       # Git summary view
│   ├── monitoring_dashboard.sh     # Comprehensive dashboard
│   ├── safety_hooks.sh             # Safety features
│   └── pre_commit_snapshot.sh      # Git hooks
└── README.md                       # This file
```

## 🔄 Installation

1. **Clone Repository**
   ```bash
   git clone <repo-url> ~/dotfiles
   cd ~/dotfiles
   ```

2. **Install Dependencies**
   ```bash
   # Install required tools
   brew install tmux git nvim fzf bat trash
   
   # Install Python packages
   pip3 install watchdog rich
   ```

3. **Setup Configuration**
   ```bash
   # Backup existing config
   cp ~/.zshrc ~/.zshrc.backup
   
   # Link dotfiles
   ln -sf ~/dotfiles/.zshrc ~/.zshrc
   ln -sf ~/dotfiles/claude-settings.json ~/.claude/settings.json
   
   # Copy scripts
   cp -r ~/dotfiles/scripts ~/scripts
   chmod +x ~/scripts/*.sh
   ```

4. **Reload Shell**
   ```bash
   source ~/.zshrc
   ```

## 🚨 Troubleshooting

### Common Issues

**Claude hooks not working**
- Check `~/.claude/settings.json` exists
- Verify script permissions: `chmod +x ~/scripts/*.sh`

**Monitoring dashboard fails**
- Install Python dependencies: `pip3 install watchdog rich`
- Check tmux is installed: `brew install tmux`

**Git operations fail**
- Ensure you're in a git repository
- Check git configuration: `git config --list`

## 📝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This configuration is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- **Claude AI** for development assistance
- **tmux** for terminal multiplexing
- **Rich** for beautiful TUI interfaces
- **FZF** for fuzzy finding capabilities

---

*Last updated: 2025-07-09*
*Configuration optimized for macOS with ARM Homebrew*