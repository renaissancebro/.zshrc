#!/bin/bash
# Manual commands to sync Neovim config to dotfiles
# Replace "~/dotfiles" with your actual dotfiles directory

DOTFILES="~/dotfiles"  # ← Change this to your dotfiles path

echo "# Commands to manually sync to dotfiles:"
echo ""
echo "# 1. Create nvim directory in dotfiles"
echo "mkdir -p $DOTFILES/nvim"
echo ""
echo "# 2. Copy essential files"
echo "cp ~/.config/nvim/init.lua $DOTFILES/nvim/"
echo "cp ~/.config/nvim/lazy-lock.json $DOTFILES/nvim/"
echo ""
echo "# 3. Copy essential directories"  
echo "cp -r ~/.config/nvim/lua/custom $DOTFILES/nvim/lua/"
echo "cp -r ~/.config/nvim/lua/kickstart $DOTFILES/nvim/lua/"
echo "cp -r ~/.config/nvim/queries $DOTFILES/nvim/"
echo ""
echo "# 4. Commit to dotfiles repo"
echo "cd $DOTFILES"
echo "git add nvim/"
echo 'git commit -m "Add enhanced Neovim configuration with debugging, themes, and AI completion"'
echo "git push"
echo ""
echo "# 5. To install on another machine:"
echo "git clone <your-dotfiles-repo>"
echo "cp -r dotfiles/nvim ~/.config/"
echo "nvim  # Plugins will auto-install"