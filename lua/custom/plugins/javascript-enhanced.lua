-- Enhanced JavaScript/TypeScript Tree-sitter highlighting plugin
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Ensure JS/TS parsers are installed
      if not opts.ensure_installed then
        opts.ensure_installed = {}
      end
      vim.list_extend(opts.ensure_installed, { 
        "javascript", "typescript", "tsx", "jsdoc" 
      })
      return opts
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      
      -- Define JavaScript/TypeScript-specific highlight groups
      local function setup_js_highlights()
        -- JavaScript Keywords
        vim.api.nvim_set_hl(0, "@keyword.javascript", { fg = "#bb9af7", bold = true })        -- const, let, var
        vim.api.nvim_set_hl(0, "@keyword.function.javascript", { fg = "#7dcfff", bold = true }) -- function, async
        vim.api.nvim_set_hl(0, "@keyword.return.javascript", { fg = "#f7768e", bold = true })  -- return
        vim.api.nvim_set_hl(0, "@keyword.import.javascript", { fg = "#e0af68", bold = true })  -- import, export
        vim.api.nvim_set_hl(0, "@keyword.export.javascript", { fg = "#e0af68", bold = true })  -- export
        vim.api.nvim_set_hl(0, "@keyword.conditional.javascript", { fg = "#bb9af7", bold = true }) -- if, else
        vim.api.nvim_set_hl(0, "@keyword.repeat.javascript", { fg = "#bb9af7", bold = true })  -- for, while
        vim.api.nvim_set_hl(0, "@keyword.operator.javascript", { fg = "#89ddff", bold = true }) -- typeof, instanceof
        
        -- JavaScript Functions
        vim.api.nvim_set_hl(0, "@function.javascript", { fg = "#7aa2f7" })                    -- function names
        vim.api.nvim_set_hl(0, "@function.call.javascript", { fg = "#7aa2f7" })               -- function calls
        vim.api.nvim_set_hl(0, "@function.builtin.javascript", { fg = "#7dcfff" })            -- console.log, etc.
        vim.api.nvim_set_hl(0, "@function.method.javascript", { fg = "#73daca" })             -- object.method()
        vim.api.nvim_set_hl(0, "@function.arrow.javascript", { fg = "#7aa2f7", italic = true }) -- arrow functions
        
        -- JavaScript Variables
        vim.api.nvim_set_hl(0, "@variable.javascript", { fg = "#c0caf5" })                    -- regular variables
        vim.api.nvim_set_hl(0, "@variable.builtin.javascript", { fg = "#f7768e" })            -- this, arguments
        vim.api.nvim_set_hl(0, "@variable.parameter.javascript", { fg = "#ff9e64" })          -- function params
        vim.api.nvim_set_hl(0, "@variable.member.javascript", { fg = "#e0af68" })             -- object.property
        
        -- JavaScript Constants
        vim.api.nvim_set_hl(0, "@constant.javascript", { fg = "#ff9e64", bold = true })       -- CONSTANTS
        vim.api.nvim_set_hl(0, "@constant.builtin.javascript", { fg = "#bb9af7", bold = true }) -- true, false, null
        vim.api.nvim_set_hl(0, "@constant.numeric.javascript", { fg = "#ff9e64" })            -- numbers
        
        -- JavaScript Strings and Templates
        vim.api.nvim_set_hl(0, "@string.javascript", { fg = "#9ece6a" })                      -- "string"
        vim.api.nvim_set_hl(0, "@string.template.javascript", { fg = "#9ece6a" })             -- `template`
        vim.api.nvim_set_hl(0, "@string.regex.javascript", { fg = "#73daca", italic = true }) -- /regex/
        vim.api.nvim_set_hl(0, "@punctuation.special.javascript", { fg = "#e0af68", bold = true }) -- ${}
        
        -- JavaScript Objects and Classes
        vim.api.nvim_set_hl(0, "@type.javascript", { fg = "#7dcfff", bold = true })           -- class names
        vim.api.nvim_set_hl(0, "@type.builtin.javascript", { fg = "#bb9af7", bold = true })   -- Array, Object, etc.
        vim.api.nvim_set_hl(0, "@constructor.javascript", { fg = "#f7768e", bold = true })    -- new Constructor
        vim.api.nvim_set_hl(0, "@property.javascript", { fg = "#e0af68" })                    -- object.prop
        
        -- JavaScript Operators
        vim.api.nvim_set_hl(0, "@operator.javascript", { fg = "#89ddff" })                    -- +, -, *, /
        vim.api.nvim_set_hl(0, "@operator.assignment.javascript", { fg = "#89ddff", bold = true }) -- =, +=, etc.
        vim.api.nvim_set_hl(0, "@operator.comparison.javascript", { fg = "#89ddff" })         -- ==, ===, !=
        vim.api.nvim_set_hl(0, "@operator.logical.javascript", { fg = "#bb9af7" })            -- &&, ||, !
        
        -- JavaScript Punctuation
        vim.api.nvim_set_hl(0, "@punctuation.bracket.javascript", { fg = "#565f89" })         -- []{}()
        vim.api.nvim_set_hl(0, "@punctuation.delimiter.javascript", { fg = "#565f89" })       -- ;,
        vim.api.nvim_set_hl(0, "@punctuation.accessor.javascript", { fg = "#89ddff" })        -- .
        
        -- JavaScript Comments
        vim.api.nvim_set_hl(0, "@comment.javascript", { fg = "#565f89", italic = true })      -- // /* */
        vim.api.nvim_set_hl(0, "@comment.jsdoc.javascript", { fg = "#73daca", italic = true }) -- /** JSDoc */
        
        -- JavaScript Modules
        vim.api.nvim_set_hl(0, "@module.javascript", { fg = "#7dcfff" })                      -- module names
        vim.api.nvim_set_hl(0, "@namespace.javascript", { fg = "#7dcfff" })                   -- namespace
        
        -- JavaScript Error Handling
        vim.api.nvim_set_hl(0, "@keyword.exception.javascript", { fg = "#f7768e", bold = true }) -- try, catch, throw
        
        -- JavaScript Async/Await
        vim.api.nvim_set_hl(0, "@keyword.async.javascript", { fg = "#bb9af7", bold = true })  -- async, await
        
        -- TypeScript Specific
        vim.api.nvim_set_hl(0, "@type.typescript", { fg = "#7dcfff", bold = true })           -- type annotations
        vim.api.nvim_set_hl(0, "@type.definition.typescript", { fg = "#e0af68", bold = true }) -- type definitions
        vim.api.nvim_set_hl(0, "@keyword.type.typescript", { fg = "#bb9af7", bold = true })   -- interface, type
        vim.api.nvim_set_hl(0, "@keyword.modifier.typescript", { fg = "#ff9e64" })            -- public, private
        vim.api.nvim_set_hl(0, "@type.qualifier.typescript", { fg = "#89ddff" })              -- readonly, const
        vim.api.nvim_set_hl(0, "@punctuation.bracket.angle.typescript", { fg = "#89ddff" })   -- <T>
        
        -- React/JSX Specific
        vim.api.nvim_set_hl(0, "@tag.jsx", { fg = "#f7768e", bold = true })                   -- JSX tags
        vim.api.nvim_set_hl(0, "@tag.builtin.jsx", { fg = "#bb9af7", bold = true })          -- div, span, etc.
        vim.api.nvim_set_hl(0, "@tag.component.jsx", { fg = "#7dcfff", bold = true })        -- <Component>
        vim.api.nvim_set_hl(0, "@attribute.jsx", { fg = "#e0af68", italic = true })          -- JSX attributes
        vim.api.nvim_set_hl(0, "@punctuation.bracket.jsx", { fg = "#565f89" })               -- JSX {}
        
        -- Modern JavaScript Features
        vim.api.nvim_set_hl(0, "@operator.spread.javascript", { fg = "#89ddff", bold = true }) -- ...spread
        vim.api.nvim_set_hl(0, "@operator.rest.javascript", { fg = "#89ddff", bold = true })   -- ...rest
        vim.api.nvim_set_hl(0, "@operator.optional.javascript", { fg = "#89ddff" })           -- ?.
        vim.api.nvim_set_hl(0, "@operator.nullish.javascript", { fg = "#89ddff" })            -- ??
        
        -- Decorators (TypeScript/Experimental JS)
        vim.api.nvim_set_hl(0, "@function.decorator.javascript", { fg = "#e0af68", bold = true }) -- @decorator
        
        -- Template Literal Tagged Functions
        vim.api.nvim_set_hl(0, "@function.tag.javascript", { fg = "#7dcfff", bold = true })   -- styled`...`
      end
      
      -- Apply JS/TS highlights when treesitter loads
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact", "tsx" },
        callback = function()
          vim.schedule(setup_js_highlights)
        end
      })
      
      -- Reapply on colorscheme change
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = setup_js_highlights
      })
      
      -- Apply immediately if we're in a JS/TS file
      if vim.tbl_contains({
        "javascript", "typescript", "javascriptreact", "typescriptreact", "tsx"
      }, vim.bo.filetype) then
        setup_js_highlights()
      end
    end,
  },
  
  -- JavaScript/TypeScript-specific text objects
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    config = function()
      require("nvim-treesitter.configs").setup({
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              -- JavaScript/TypeScript-specific text objects
              ["af"] = "@function.outer",       -- select entire function
              ["if"] = "@function.inner",       -- select function body
              ["ac"] = "@class.outer",          -- select entire class
              ["ic"] = "@class.inner",          -- select class body
              ["ao"] = "@object.outer",         -- select entire object
              ["io"] = "@object.inner",         -- select object content
              ["aa"] = "@array.outer",          -- select entire array
              ["ia"] = "@array.inner",          -- select array content
              ["al"] = "@loop.outer",           -- select entire loop
              ["il"] = "@loop.inner",           -- select loop body
              ["ai"] = "@conditional.outer",    -- select entire if statement
              ["ii"] = "@conditional.inner",    -- select if body
              ["ap"] = "@parameter.outer",      -- select parameter
              ["ip"] = "@parameter.inner",      -- select parameter name only
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
              ["]o"] = "@object.outer",
            },
            goto_next_end = {
              ["]F"] = "@function.outer",
              ["]C"] = "@class.outer",
              ["]O"] = "@object.outer",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
              ["[o"] = "@object.outer",
            },
            goto_previous_end = {
              ["[F"] = "@function.outer",
              ["[C"] = "@class.outer",
              ["[O"] = "@object.outer",
            },
          },
        },
      })
    end,
  },
}