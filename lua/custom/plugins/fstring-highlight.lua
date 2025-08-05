return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      -- Ensure python is installed
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "python" })
      end
      
      -- Add custom highlight configuration
      opts.highlight = opts.highlight or {}
      opts.highlight.additional_vim_regex_highlighting = { "python" }
      
      return opts
    end,
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
      
      -- Custom f-string highlighting after treesitter setup
      vim.schedule(function()
        -- Override highlight groups
        vim.api.nvim_set_hl(0, '@punctuation.bracket.fstring', { 
          fg = '#ff0000', 
          bold = true,
          bg = '#ffff00'
        })
        
        -- Also try these common groups
        vim.api.nvim_set_hl(0, '@string.interpolation', { 
          fg = '#ff0000', 
          bold = true
        })
        
        print("F-string highlights applied!")
      end)
    end,
  }
}