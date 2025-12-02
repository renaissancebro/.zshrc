# Neovim Configuration Updates

## Recent Improvements (2025-07-27)

### 🎨 **Theme & Highlighting**
- **Switched to OneDark theme** for better readability
- **VS Code-style f-string highlighting**: 
  - `f` prefix in purple (like keywords)
  - `{}` braces in yellow/bold  
  - String content uses normal colors
  - Content inside `{}` keeps proper syntax highlighting
- **Multi-language support**: Python, JavaScript, HTML, CSS
- **Custom Tree-sitter queries** for precise syntax highlighting

### 🔧 **Workflow Improvements**
- **Fixed `<leader>r`**: No more multiple terminals when running files
- **Added GitHub CLI integration** with 5 new keybindings:
  - `<leader>gc` - Create PR
  - `<leader>gp` - List PRs
  - `<leader>gi` - Create issue  
  - `<leader>gs` - Git status
  - `<leader>gr` - View repo

### 📚 **Better Documentation**
- **Organized help system**: All custom keybindings now show in which-key
- **Clear descriptions** for all functions
- **Easy discovery**: Press `<space>` to see organized command groups

### 🐍 **Python Development**
- **Type checking toggle**: `<leader>tc` switches Pyright between off/basic
- **File runner**: `<leader>r` runs Python/JS/shell files in terminal split
- **Enhanced f-string highlighting** for better code readability

### 💻 **Terminal & Display**
- **Font size optimization**: Increased to 16pt for better readability
- **Smart terminal management**: Reuses terminal windows efficiently

## Key Bindings Reference

| Key | Action |
|-----|--------|
| `<leader>r` | Run current file |
| `<leader>tc` | Toggle type checking |
| `<leader>gc` | Create GitHub PR |
| `<leader>gp` | List GitHub PRs |
| `<leader>gi` | Create GitHub issue |
| `<leader>sk` | Search all keymaps |
| `<space>` | Show organized help menu |

## Files Modified
- `init.lua` - Main configuration updates
- `lua/custom/plugins/init.lua` - Tree-sitter and highlighting
- `lua/custom/plugins/colorscheme.lua` - OneDark theme setup
- `queries/python/highlights.scm` - Python syntax highlighting
- `queries/javascript/highlights.scm` - JavaScript template literals
- `queries/html/highlights.scm` - HTML tag highlighting
- `queries/css/highlights.scm` - CSS selector highlighting
- Test files for all languages

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>