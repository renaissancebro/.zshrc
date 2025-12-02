# Personal Neovim Configuration

Essential Neovim setup focused on Python development with minimal bloat.

## Features

- **Sidebar file explorer** (`\` key)
- **Fuzzy file finder** (`<leader>sf`)
- **Python file runner** (`<leader>r`) with virtual environment detection
- **LSP autocomplete** (Pyright for Python)
- **Enhanced clipboard integration** (`<C-c>`, `<C-v>`)
- **Quick terminal access** (`<C-t>`, `<leader>t`)
- **Tokyo Night theme** with custom highlighting

## Key Bindings

### File Navigation
- `\` - Toggle sidebar file explorer
- `<leader>sf` - Search files (fuzzy finder)
- `<leader><leader>` - Find open buffers
- `[b` / `]b` - Previous/next buffer
- `<leader>x` - Close current buffer

### Python Development
- `<leader>r` - Run current Python file (auto-detects venv)
- `gd` - Go to definition
- `K` - Show hover documentation
- `<leader>ca` - Code actions

### Terminal
- `<C-t>` - Quick terminal
- `<leader>t` - Open terminal
- `<Esc>` - Exit terminal mode
- `<C-w>` - Window navigation from terminal

### Clipboard
- `<C-c>` - Copy to system clipboard (visual mode)
- `<C-v>` - Paste from system clipboard
- Regular `y` and `p` also work with system clipboard

### General
- `<C-s>` - Save file
- `<Esc>` - Clear search highlights
- `<C-h/j/k/l>` - Navigate between windows

## Virtual Environment Detection

The Python runner automatically detects and uses virtual environments in this order:
1. `./venv/bin/python`
2. `./.venv/bin/python`
3. `./env/bin/python`
4. Falls back to `python3`

## Installation

1. Backup existing config: `mv ~/.config/nvim ~/.config/nvim.backup`
2. Clone this repo: `git clone <repo-url> ~/.config/nvim`
3. Open Neovim - plugins will auto-install via lazy.nvim

## Dependencies

- Neovim 0.9+
- Git
- A Nerd Font for file icons
- Python 3 and Pyright LSP (auto-installed via Mason)

## Notes

- Treesitter highlighting is disabled to avoid query conflicts
- Uses vim's built-in syntax highlighting for stability
- Minimal plugin set for reduced startup time and fewer conflicts