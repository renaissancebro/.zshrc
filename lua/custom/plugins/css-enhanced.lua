-- Enhanced CSS Tree-sitter highlighting plugin
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Ensure CSS parser is installed
      if not opts.ensure_installed then
        opts.ensure_installed = {}
      end
      vim.list_extend(opts.ensure_installed, { "css", "scss" })
      return opts
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      
      -- Define CSS-specific highlight groups
      local function setup_css_highlights()
        -- CSS Selectors (different types)
        vim.api.nvim_set_hl(0, "@tag.css", { fg = "#f7768e", bold = true })              -- div, p, h1, etc.
        vim.api.nvim_set_hl(0, "@selector.class.css", { fg = "#7dcfff", bold = true })   -- .class-name
        vim.api.nvim_set_hl(0, "@selector.id.css", { fg = "#bb9af7", bold = true })     -- #id-name
        vim.api.nvim_set_hl(0, "@selector.pseudo.css", { fg = "#e0af68", italic = true }) -- :hover, :before
        vim.api.nvim_set_hl(0, "@selector.attribute.css", { fg = "#9ece6a" })           -- [type="text"]
        vim.api.nvim_set_hl(0, "@selector.universal.css", { fg = "#565f89" })           -- *
        
        -- CSS Properties
        vim.api.nvim_set_hl(0, "@property.css", { fg = "#e0af68", italic = true })      -- color, margin, etc.
        vim.api.nvim_set_hl(0, "@property.custom.css", { fg = "#ff9e64", italic = true }) -- --custom-props
        vim.api.nvim_set_hl(0, "@property.vendor.css", { fg = "#73daca", italic = true }) -- -webkit-, -moz-
        
        -- CSS Values
        vim.api.nvim_set_hl(0, "@string.css", { fg = "#9ece6a" })                       -- "Arial", 'Times'
        vim.api.nvim_set_hl(0, "@number.css", { fg = "#ff9e64", bold = true })          -- 10px, 1.5em, 100%
        vim.api.nvim_set_hl(0, "@number.unit.css", { fg = "#ff9e64" })                  -- px, em, rem, %
        vim.api.nvim_set_hl(0, "@constant.color.css", { fg = "#f7768e", bold = true })  -- red, blue, #fff
        vim.api.nvim_set_hl(0, "@constant.builtin.css", { fg = "#bb9af7" })             -- inherit, auto, none
        
        -- CSS Functions
        vim.api.nvim_set_hl(0, "@function.css", { fg = "#7aa2f7", bold = true })        -- rgb(), calc(), var()
        vim.api.nvim_set_hl(0, "@function.builtin.css", { fg = "#7dcfff", bold = true }) -- url(), linear-gradient()
        
        -- CSS Keywords
        vim.api.nvim_set_hl(0, "@keyword.css", { fg = "#bb9af7", bold = true })         -- @media, @import
        vim.api.nvim_set_hl(0, "@keyword.import.css", { fg = "#e0af68", bold = true })  -- @import
        vim.api.nvim_set_hl(0, "@keyword.media.css", { fg = "#7dcfff", bold = true })   -- @media
        vim.api.nvim_set_hl(0, "@keyword.keyframes.css", { fg = "#f7768e", bold = true }) -- @keyframes
        
        -- CSS Punctuation
        vim.api.nvim_set_hl(0, "@punctuation.bracket.css", { fg = "#565f89" })          -- { }
        vim.api.nvim_set_hl(0, "@punctuation.delimiter.css", { fg = "#89ddff" })        -- : ;
        vim.api.nvim_set_hl(0, "@punctuation.separator.css", { fg = "#565f89" })        -- ,
        
        -- CSS Comments
        vim.api.nvim_set_hl(0, "@comment.css", { fg = "#565f89", italic = true })       -- /* comments */
        
        -- CSS Important
        vim.api.nvim_set_hl(0, "@keyword.important.css", { fg = "#f7768e", bold = true }) -- !important
        
        -- CSS Variables and calc
        vim.api.nvim_set_hl(0, "@variable.css", { fg = "#c0caf5" })                     -- var(--name)
        vim.api.nvim_set_hl(0, "@operator.css", { fg = "#89ddff" })                     -- +, -, *, /
        
        -- Media queries
        vim.api.nvim_set_hl(0, "@string.media.css", { fg = "#73daca" })                 -- screen, print
        vim.api.nvim_set_hl(0, "@property.media.css", { fg = "#e0af68" })               -- max-width, min-height
        
        -- Animation properties
        vim.api.nvim_set_hl(0, "@property.animation.css", { fg = "#bb9af7", italic = true }) -- animation-name, etc.
        vim.api.nvim_set_hl(0, "@constant.animation.css", { fg = "#7aa2f7" })           -- ease-in-out, linear
        
        -- Grid and Flexbox
        vim.api.nvim_set_hl(0, "@property.grid.css", { fg = "#9ece6a", italic = true })     -- grid-template, etc.
        vim.api.nvim_set_hl(0, "@property.flex.css", { fg = "#7dcfff", italic = true })     -- flex-direction, etc.
        
        -- CSS Nesting (SCSS/SASS)
        vim.api.nvim_set_hl(0, "@punctuation.special.scss", { fg = "#bb9af7" })         -- & parent selector
        vim.api.nvim_set_hl(0, "@variable.scss", { fg = "#e0af68" })                    -- $variable
        vim.api.nvim_set_hl(0, "@function.mixin.scss", { fg = "#f7768e", bold = true }) -- @mixin, @include
        
        -- CSS-in-JS (styled-components style)
        vim.api.nvim_set_hl(0, "@string.template.css", { fg = "#9ece6a" })              -- template literals
        vim.api.nvim_set_hl(0, "@punctuation.template.css", { fg = "#e0af68", bold = true }) -- ${}
      end
      
      -- Apply CSS highlights when treesitter loads
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "css", "scss", "less" },
        callback = function()
          vim.schedule(setup_css_highlights)
        end
      })
      
      -- Reapply on colorscheme change
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = setup_css_highlights
      })
      
      -- Apply immediately if we're in a CSS file
      if vim.tbl_contains({"css", "scss", "less"}, vim.bo.filetype) then
        setup_css_highlights()
      end
    end,
  },
  
  -- CSS-specific text objects
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    config = function()
      require("nvim-treesitter.configs").setup({
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              -- CSS-specific text objects
              ["ar"] = "@rule.outer",           -- select entire CSS rule
              ["ir"] = "@rule.inner",           -- select rule content only
              ["ap"] = "@property.outer",       -- select property with value
              ["ip"] = "@property.inner",       -- select property value only
              ["as"] = "@selector.outer",       -- select selector
              ["is"] = "@selector.inner",       -- select selector content
            },
          },
        },
      })
    end,
  },
}