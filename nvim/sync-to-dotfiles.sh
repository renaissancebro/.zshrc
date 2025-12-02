#!/bin/bash
# Script to sync enhanced Neovim config to dotfiles repository

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if dotfiles directory path is provided
if [ -z "$1" ]; then
    print_error "Usage: $0 <path-to-dotfiles-repo>"
    print_error "Example: $0 ~/dotfiles"
    print_error "Example: $0 ~/projects/my-dotfiles"
    exit 1
fi

DOTFILES_DIR="$1"
NVIM_SOURCE="$HOME/.config/nvim"
NVIM_TARGET="$DOTFILES_DIR/nvim"

# Check if dotfiles directory exists
if [ ! -d "$DOTFILES_DIR" ]; then
    print_error "Dotfiles directory '$DOTFILES_DIR' does not exist!"
    exit 1
fi

print_status "Syncing Neovim config from $NVIM_SOURCE to $NVIM_TARGET"

# Create nvim directory in dotfiles if it doesn't exist
mkdir -p "$NVIM_TARGET"

# Essential files to copy
FILES_TO_COPY=(
    "init.lua"
    "lazy-lock.json"
)

# Essential directories to copy
DIRS_TO_COPY=(
    "lua/custom"
    "lua/kickstart" 
    "queries"
)

# Copy essential files
print_status "Copying essential files..."
for file in "${FILES_TO_COPY[@]}"; do
    if [ -f "$NVIM_SOURCE/$file" ]; then
        cp "$NVIM_SOURCE/$file" "$NVIM_TARGET/"
        print_success "Copied $file"
    else
        print_error "File $file not found in source!"
    fi
done

# Copy essential directories
print_status "Copying essential directories..."
for dir in "${DIRS_TO_COPY[@]}"; do
    if [ -d "$NVIM_SOURCE/$dir" ]; then
        # Remove existing directory in target and copy fresh
        rm -rf "$NVIM_TARGET/$dir"
        cp -r "$NVIM_SOURCE/$dir" "$NVIM_TARGET/$dir"
        print_success "Copied directory $dir"
    else
        print_error "Directory $dir not found in source!"
    fi
done

# Create a README for the nvim config
cat > "$NVIM_TARGET/README.md" << 'EOF'
# Enhanced Neovim Configuration

This is a highly customized Neovim configuration built on top of Kickstart.nvim with:

## ✨ Key Features

### 🎨 Easy Theme Switching
- `<space>tt` - Interactive theme picker
- `<space>t1-5` - Quick theme shortcuts
- 5 beautiful treesitter-optimized themes

### 🐛 Advanced Debugging  
- `<space>dd` - Start/Continue debugging
- `<space>di` - Step into
- `<space>do` - Step over
- `<space>du` - Toggle debug UI
- Support for Python, JavaScript, HTML/CSS, Bash

### 🤖 AI-Powered Completion
- Codeium + GitHub Copilot integration
- Advanced blink.cmp completion engine
- Smart snippet support

### 🌈 Visual Enhancements
- Rainbow brackets for better code structure
- Indent guides and function context
- Enhanced treesitter highlighting
- VS Code-like debugging UI

## 📦 Installation

1. Backup your existing config: `mv ~/.config/nvim ~/.config/nvim.backup`
2. Clone/copy this config: `cp -r /path/to/dotfiles/nvim ~/.config/nvim`  
3. Start Neovim: `nvim`
4. Authenticate Codeium: `:Codeium Auth`

## 🎯 Key Bindings

- `<space>sf` - Search files
- `<space>sg` - Live grep
- `<space>e` - File explorer
- `<space>tt` - Theme switcher
- `<space>dd` - Start debugging
- `<space>b` - Toggle breakpoint

Built with ❤️ using Kickstart.nvim as foundation.
EOF

print_success "Created README.md with configuration details"

# Show what was copied
print_status "Summary of copied items:"
echo "📁 Directories:"
for dir in "${DIRS_TO_COPY[@]}"; do
    if [ -d "$NVIM_TARGET/$dir" ]; then
        echo "  ✓ $dir"
    fi
done

echo "📄 Files:"
for file in "${FILES_TO_COPY[@]}"; do
    if [ -f "$NVIM_TARGET/$file" ]; then
        echo "  ✓ $file"
    fi
done
echo "  ✓ README.md"

print_success "Neovim config successfully synced to dotfiles!"
print_status "Next steps:"
echo "  1. cd $DOTFILES_DIR"
echo "  2. git add nvim/"
echo "  3. git commit -m 'Add enhanced Neovim configuration'"
echo "  4. git push"

print_status "To install on another machine:"
echo "  1. git clone <your-dotfiles-repo>"
echo "  2. cp -r dotfiles/nvim ~/.config/"
echo "  3. nvim (plugins will auto-install)"