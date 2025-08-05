-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  -- Tree-sitter configuration
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { 
          'python', 'lua', 'vim', 'vimdoc', 'query',
          'html', 'css', 'javascript', 'typescript', 'tsx', 'jsx'
        },
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
      }
      
      -- Colors are now handled in colorscheme.lua
      -- Tree-sitter highlighting will use the custom highlight groups defined there
    end,
  },
  
  -- Note: Themes are configured in colorscheme.lua
  
  -- Mini.hipatterns for enhanced f-string highlighting
  {
    'echasnovski/mini.hipatterns',
    version = false,
    config = function()
      local hipatterns = require('mini.hipatterns')
      hipatterns.setup({
        highlighters = {
          -- Enhanced bracket highlighting (excluding f-string braces handled by treesitter)
          brackets = {
            pattern = '[()%[%]]',  -- Removed {} since f-strings handle those
            group = 'CustomBrackets',
          },
          -- HTML tags
          html_tags = {
            pattern = "</?%w+[^>]*>",
            group = 'HTMLTag',
          },
          -- CSS selectors (basic)
          css_selectors = {
            pattern = "%.%w+",
            group = 'CSSSelector',
          },
        },
      })
    end,
  },
}
