-- Theme Switcher with Treesitter-optimized themes
return {
  -- Multiple excellent treesitter themes
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('tokyonight').setup({
        style = 'night', -- storm, moon, night, day
        styles = {
          functions = { bold = true },
          variables = {},
          sidebars = 'transparent',
        },
        on_highlights = function(hl, c)
          -- Better function highlighting
          hl['@function'] = { fg = c.blue1, bold = true }
          hl['@function.call'] = { fg = c.cyan, bold = false }
          hl['@method'] = { fg = c.blue1, bold = true }
          hl['@method.call'] = { fg = c.cyan }
          -- Better class highlighting
          hl['@type'] = { fg = c.yellow, bold = true }
          hl['@type.definition'] = { fg = c.yellow, bold = true }
        end,
      })
    end,
  },

  {
    'catppuccin/nvim',
    name = 'catppuccin',
    config = function()
      require('catppuccin').setup({
        flavour = 'mocha', -- latte, frappe, macchiato, mocha
        custom_highlights = function(colors)
          return {
            ['@function'] = { fg = colors.blue, style = { 'bold' } },
            ['@function.call'] = { fg = colors.sapphire },
            ['@method'] = { fg = colors.blue, style = { 'bold' } },
            ['@method.call'] = { fg = colors.sapphire },
            ['@type'] = { fg = colors.yellow, style = { 'bold' } },
            ['@type.definition'] = { fg = colors.yellow, style = { 'bold' } },
          }
        end,
      })
    end,
  },

  {
    'rebelot/kanagawa.nvim',
    config = function()
      require('kanagawa').setup({
        overrides = function(colors)
          return {
            ['@function'] = { fg = colors.palette.crystalBlue, bold = true },
            ['@function.call'] = { fg = colors.palette.lightBlue },
            ['@method'] = { fg = colors.palette.crystalBlue, bold = true },
            ['@method.call'] = { fg = colors.palette.lightBlue },
            ['@type'] = { fg = colors.palette.carpYellow, bold = true },
            ['@type.definition'] = { fg = colors.palette.carpYellow, bold = true },
          }
        end,
      })
    end,
  },

  {
    'rose-pine/neovim',
    name = 'rose-pine',
    config = function()
      require('rose-pine').setup({
        highlight_groups = {
          ['@function'] = { fg = 'iris', bold = true },
          ['@function.call'] = { fg = 'foam' },
          ['@method'] = { fg = 'iris', bold = true },
          ['@method.call'] = { fg = 'foam' },
          ['@type'] = { fg = 'gold', bold = true },
          ['@type.definition'] = { fg = 'gold', bold = true },
        },
      })
    end,
  },

  {
    'ellisonleao/gruvbox.nvim',
    config = function()
      require('gruvbox').setup({
        overrides = {
          ['@function'] = { fg = '#83a598', bold = true },
          ['@function.call'] = { fg = '#8ec07c' },
          ['@method'] = { fg = '#83a598', bold = true },
          ['@method.call'] = { fg = '#8ec07c' },
          ['@type'] = { fg = '#fabd2f', bold = true },
          ['@type.definition'] = { fg = '#fabd2f', bold = true },
        },
      })
    end,
  },
}