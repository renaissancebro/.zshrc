return {
  -- Tokyo Night theme (modern VS Code-style)
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('tokyonight').setup {
        style = 'night', -- 'storm', 'moon', 'night', 'day'
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = false, bold = true },
          functions = { bold = true },
          variables = {},
          sidebars = 'dark',
          floats = 'dark',
        },
        sidebars = { 'qf', 'help', 'vista_kind', 'terminal' },
        day_brightness = 0.3,
        hide_inactive_statusline = false,
        dim_inactive = false,
        lualine_bold = false,
        on_colors = function(colors)
          -- Enhanced colors for better differentiation
          colors.comment = '#565f89'
          colors.purple = '#bb9af7'
          colors.cyan = '#7dcfff'
          colors.green = '#9ecdda'
        end,
        on_highlights = function(hl, c)
          -- VS Code-style enhanced highlighting
          hl.Function = { fg = c.blue, bold = true }
          hl.Keyword = { fg = c.purple, bold = true }
          hl.String = { fg = c.green }
          hl.Number = { fg = c.orange }
          hl.Boolean = { fg = c.orange }
          hl.Type = { fg = c.cyan }
          hl.Operator = { fg = c.purple }
          
          -- Enhanced bracket and punctuation highlighting
          hl.Delimiter = { fg = c.yellow }  -- General delimiters
          hl["@punctuation.delimiter"] = { fg = c.yellow }  -- Commas, semicolons
          hl["@punctuation.bracket"] = { fg = c.cyan }      -- [], {}, ()
          hl["@punctuation.special"] = { fg = c.red }       -- Special punctuation
          hl.MatchParen = { fg = c.orange, bold = true, bg = c.bg_highlight }
          
          -- Function call parentheses
          hl["@function.call"] = { fg = c.blue }
          hl["@function.builtin"] = { fg = c.cyan }
          hl["@function.macro"] = { fg = c.red }
          
          -- Variables and identifiers
          hl["@variable"] = { fg = c.fg }
          hl["@variable.builtin"] = { fg = c.red }
          hl["@variable.parameter"] = { fg = c.orange }
          hl["@variable.member"] = { fg = c.cyan }
          
          -- Python f-string specific highlighting
          hl["@string.escape"] = { fg = c.magenta }
          hl["@string.regexp"] = { fg = c.blue }
          hl["@string.special"] = { fg = c.yellow, bold = true }  -- f-string braces
          hl["@string.special.symbol"] = { fg = c.magenta }
          
          -- Python specific treesitter groups
          hl["@string.documentation.python"] = { fg = c.green, italic = true }
          hl["@keyword.function.python"] = { fg = c.purple, bold = true }
          hl["@keyword.import.python"] = { fg = c.purple, bold = true }
          hl["@type.builtin.python"] = { fg = c.cyan }
          
          -- JavaScript/TypeScript template literals
          hl["@string.template"] = { fg = c.green }
          hl["@punctuation.special.template"] = { fg = c.yellow, bold = true }
          hl["@embedded"] = { fg = c.blue }
          
          -- HTML specific highlighting
          hl.htmlTag = { fg = c.red }
          hl.htmlTagName = { fg = c.red, bold = true }
          hl.htmlArg = { fg = c.yellow }
          hl.htmlString = { fg = c.green }
          hl.htmlEndTag = { fg = c.red }
          hl["@tag"] = { fg = c.red }
          hl["@tag.attribute"] = { fg = c.yellow }
          hl["@tag.delimiter"] = { fg = c.cyan }
          
          -- CSS specific highlighting  
          hl.cssTagName = { fg = c.red, bold = true }
          hl.cssClassName = { fg = c.yellow }
          hl.cssIdentifier = { fg = c.yellow }
          hl.cssProp = { fg = c.cyan }
          hl.cssAttr = { fg = c.orange }
          hl.cssValueLength = { fg = c.orange }
          hl.cssValueNumber = { fg = c.orange }
          hl.cssValueKeyword = { fg = c.purple }
          hl.cssColor = { fg = c.orange }
          hl["@property.css"] = { fg = c.cyan }
          hl["@type.css"] = { fg = c.orange }
          
          -- JavaScript/TypeScript specific highlighting
          hl.jsFunction = { fg = c.purple, bold = true }
          hl.jsReturn = { fg = c.purple, bold = true }
          hl.jsThis = { fg = c.purple, bold = true }
          hl.jsVariableDef = { fg = c.fg }
          hl.jsFuncCall = { fg = c.blue }
          hl.jsTemplateBraces = { fg = c.yellow, bold = true }
          hl.jsTemplateString = { fg = c.green }
          hl["@constructor.javascript"] = { fg = c.cyan }
          hl["@constructor.typescript"] = { fg = c.cyan }
          
          -- More granular operators
          hl["@operator"] = { fg = c.purple }
          hl["@keyword.operator"] = { fg = c.purple }
          hl["@keyword.return"] = { fg = c.purple, bold = true }
          hl["@keyword.function"] = { fg = c.purple, bold = true }
          hl["@keyword.conditional"] = { fg = c.purple, bold = true }
          hl["@keyword.repeat"] = { fg = c.purple, bold = true }
          
          -- Constants and literals
          hl["@constant"] = { fg = c.orange }
          hl["@constant.builtin"] = { fg = c.orange, bold = true }
          hl["@constant.macro"] = { fg = c.red }
          hl.Constant = { fg = c.orange }
          
          -- Python specific highlighting
          hl.pythonBuiltin = { fg = c.cyan }
          hl.pythonFunction = { fg = c.blue, bold = true }
          hl.pythonDecorator = { fg = c.yellow }
          hl.pythonException = { fg = c.red }
          
          -- Rainbow delimiter colors
          hl.RainbowDelimiterRed = { fg = c.red }
          hl.RainbowDelimiterYellow = { fg = c.yellow }
          hl.RainbowDelimiterBlue = { fg = c.blue }
          hl.RainbowDelimiterOrange = { fg = c.orange }
          hl.RainbowDelimiterGreen = { fg = c.green }
          hl.RainbowDelimiterViolet = { fg = c.purple }
          hl.RainbowDelimiterCyan = { fg = c.cyan }
        end,
      }
      vim.cmd.colorscheme 'tokyonight'
      
      -- Force apply custom highlights after colorscheme loads
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          -- Enhanced treesitter highlighting
          vim.api.nvim_set_hl(0, "@punctuation.bracket", { fg = "#7dcfff" })  -- cyan
          vim.api.nvim_set_hl(0, "@punctuation.delimiter", { fg = "#e0af68" }) -- yellow
          vim.api.nvim_set_hl(0, "@punctuation.special", { fg = "#f7768e" })   -- red
          vim.api.nvim_set_hl(0, "@string.special", { fg = "#e0af68", bold = true }) -- f-string braces
          vim.api.nvim_set_hl(0, "@punctuation.special.template", { fg = "#e0af68", bold = true }) -- template literals
          
          -- Function and variable highlighting
          vim.api.nvim_set_hl(0, "@function.call", { fg = "#7aa2f7" })
          vim.api.nvim_set_hl(0, "@function.builtin", { fg = "#7dcfff" })
          vim.api.nvim_set_hl(0, "@variable.builtin", { fg = "#f7768e" })
          vim.api.nvim_set_hl(0, "@variable.parameter", { fg = "#ff9e64" })
          
          -- Python-specific highlighting
          vim.api.nvim_set_hl(0, "@function.decorator", { fg = "#e0af68", bold = true }) -- decorators
          vim.api.nvim_set_hl(0, "@keyword.async", { fg = "#bb9af7", bold = true })     -- async/await
          vim.api.nvim_set_hl(0, "@keyword.import", { fg = "#bb9af7", bold = true })   -- import/from
          vim.api.nvim_set_hl(0, "@module", { fg = "#7dcfff" })                        -- module names
          vim.api.nvim_set_hl(0, "@type.class", { fg = "#7dcfff", bold = true })       -- class names
          vim.api.nvim_set_hl(0, "@function.method", { fg = "#7aa2f7" })               -- method calls
          
          -- HTML highlighting
          vim.api.nvim_set_hl(0, "@tag", { fg = "#f7768e", bold = true })
          vim.api.nvim_set_hl(0, "@tag.attribute", { fg = "#e0af68" })
          vim.api.nvim_set_hl(0, "@tag.delimiter", { fg = "#7dcfff" })
        end,
      })
      
      -- Apply highlights immediately
      vim.schedule(function()
        vim.cmd("doautocmd ColorScheme")
      end)
    end,
  },
  
  -- Keep OneDark as alternative
  {
    'navarasu/onedark.nvim',
    lazy = true,
  },
}
