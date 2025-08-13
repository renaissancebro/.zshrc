-- Enhanced HTML Tree-sitter highlighting plugin
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Ensure HTML parser is installed
      if not opts.ensure_installed then
        opts.ensure_installed = {}
      end
      vim.list_extend(opts.ensure_installed, { "html", "css", "javascript" })
      return opts
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      
      -- Define HTML-specific highlight groups
      local function setup_html_highlights()
        -- HTML Tag structure
        vim.api.nvim_set_hl(0, "@tag.html", { fg = "#f7768e", bold = true })           -- Main tags
        vim.api.nvim_set_hl(0, "@tag.builtin.html", { fg = "#bb9af7", bold = true })  -- Built-in tags like <html>, <body>
        vim.api.nvim_set_hl(0, "@tag.delimiter.html", { fg = "#565f89" })             -- < > brackets
        
        -- HTML Attributes with more specificity
        vim.api.nvim_set_hl(0, "@attribute.html", { fg = "#e0af68", italic = true })           -- attribute names
        vim.api.nvim_set_hl(0, "@attribute.builtin.html", { fg = "#ff9e64", italic = true })  -- common attrs like id, class
        vim.api.nvim_set_hl(0, "@punctuation.delimiter.attribute.html", { fg = "#89ddff" })    -- = signs
        
        -- HTML Attribute values
        vim.api.nvim_set_hl(0, "@string.quoted.html", { fg = "#9ece6a" })            -- "value"
        vim.api.nvim_set_hl(0, "@string.unquoted.html", { fg = "#73daca" })          -- unquoted values
        vim.api.nvim_set_hl(0, "@number.html", { fg = "#ff9e64" })                   -- numeric values
        
        -- HTML Content types
        vim.api.nvim_set_hl(0, "@text.html", { fg = "#c0caf5" })                     -- Regular text content
        vim.api.nvim_set_hl(0, "@text.strong", { fg = "#c0caf5", bold = true })      -- <strong> content
        vim.api.nvim_set_hl(0, "@text.emphasis", { fg = "#c0caf5", italic = true })  -- <em> content
        vim.api.nvim_set_hl(0, "@text.underline", { fg = "#c0caf5", underline = true }) -- <u> content
        vim.api.nvim_set_hl(0, "@text.strike", { fg = "#c0caf5", strikethrough = true }) -- <s> content
        vim.api.nvim_set_hl(0, "@text.literal", { fg = "#e0af68", bg = "#1a1b26" })  -- <code> content
        
        -- HTML Special elements
        vim.api.nvim_set_hl(0, "@comment.html", { fg = "#565f89", italic = true })   -- <!-- comments -->
        vim.api.nvim_set_hl(0, "@tag.doctype", { fg = "#565f89", italic = true })   -- <!DOCTYPE>
        vim.api.nvim_set_hl(0, "@character.special.html", { fg = "#ff9e64", bold = true }) -- &nbsp; entities
        
        -- HTML5 Semantic elements (distinct coloring)
        vim.api.nvim_set_hl(0, "@tag.semantic.html", { fg = "#7dcfff", bold = true }) -- <section>, <article>, etc.
        
        -- Form elements
        vim.api.nvim_set_hl(0, "@tag.form.html", { fg = "#f7768e", bold = true })    -- <form>, <input>, etc.
        vim.api.nvim_set_hl(0, "@attribute.form.html", { fg = "#e0af68" })           -- form-specific attributes
        
        -- Table elements
        vim.api.nvim_set_hl(0, "@tag.table.html", { fg = "#7aa2f7", bold = true })  -- <table>, <tr>, <td>
        
        -- Media elements
        vim.api.nvim_set_hl(0, "@tag.media.html", { fg = "#9ece6a", bold = true })  -- <img>, <video>, <audio>
        
        -- Script and style tags
        vim.api.nvim_set_hl(0, "@tag.script", { fg = "#bb9af7", bold = true })      -- <script>
        vim.api.nvim_set_hl(0, "@tag.style", { fg = "#e0af68", bold = true })       -- <style>
        
        -- CSS within HTML
        vim.api.nvim_set_hl(0, "@property.css", { fg = "#e0af68" })                 -- CSS properties
        vim.api.nvim_set_hl(0, "@value.css", { fg = "#9ece6a" })                    -- CSS values
        vim.api.nvim_set_hl(0, "@punctuation.delimiter.css", { fg = "#89ddff" })    -- CSS : ;
        vim.api.nvim_set_hl(0, "@selector.css", { fg = "#7dcfff" })                 -- CSS selectors
        
        -- JavaScript within HTML
        vim.api.nvim_set_hl(0, "@keyword.javascript.html", { fg = "#bb9af7", bold = true })
        vim.api.nvim_set_hl(0, "@function.javascript.html", { fg = "#7aa2f7" })
        vim.api.nvim_set_hl(0, "@variable.javascript.html", { fg = "#c0caf5" })
        
        -- URL and link highlighting
        vim.api.nvim_set_hl(0, "@string.url.html", { fg = "#73daca", underline = true })
        vim.api.nvim_set_hl(0, "@attribute.href", { fg = "#73daca", italic = true })
        
        -- Class and ID attribute values (special highlighting)
        vim.api.nvim_set_hl(0, "@string.class.html", { fg = "#7dcfff" })            -- class="..."
        vim.api.nvim_set_hl(0, "@string.id.html", { fg = "#f7768e" })               -- id="..."
      end
      
      -- Apply HTML highlights when treesitter loads
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "html", "htm", "xhtml" },
        callback = function()
          vim.schedule(setup_html_highlights)
        end
      })
      
      -- Reapply on colorscheme change
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = setup_html_highlights
      })
      
      -- Apply immediately if we're in an HTML file
      if vim.bo.filetype == "html" then
        setup_html_highlights()
      end
    end,
  },
  
  -- Additional HTML-specific configuration
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    config = function()
      require("nvim-treesitter.configs").setup({
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              -- HTML-specific text objects
              ["at"] = "@tag.outer",        -- select entire tag including content
              ["it"] = "@tag.inner",        -- select tag content only
              ["aa"] = "@attribute.outer",  -- select attribute with value
              ["ia"] = "@attribute.inner",  -- select attribute value only
            },
          },
        },
      })
    end,
  },
}