vim.opt.clipboard = 'unnamedplus'

-- Clear treesitter cache on startup to fix query errors
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    pcall(function()
      vim.treesitter.query.invalidate_cache()
    end)
  end,
})

-- F-string bracket highlighting
vim.api.nvim_create_autocmd({'ColorScheme', 'VimEnter', 'FileType'}, {
  callback = function()
    -- Define highlight groups for different bracket types
    vim.api.nvim_set_hl(0, '@punctuation.bracket.call', { fg = '#61afef' })
    vim.api.nvim_set_hl(0, '@punctuation.bracket.list', { fg = '#e06c75' })
    vim.api.nvim_set_hl(0, '@punctuation.bracket.dict', { fg = '#98c379' })
    vim.api.nvim_set_hl(0, '@punctuation.bracket.set', { fg = '#d19a66' })
    vim.api.nvim_set_hl(0, '@punctuation.bracket.tuple', { fg = '#c678dd' })
    vim.api.nvim_set_hl(0, '@punctuation.bracket.subscript', { fg = '#56b6c2' })
    vim.api.nvim_set_hl(0, '@punctuation.bracket.params', { fg = '#abb2bf' })
  end,
})

-- Debug command to test highlighting
vim.api.nvim_create_user_command('TestFString', function()
  vim.api.nvim_set_hl(0, '@punctuation.bracket.fstring', { 
    fg = '#ff0000', 
    bold = true,
    bg = '#ffff00'
  })
  print("F-string highlight set to red on yellow")
end, {})
