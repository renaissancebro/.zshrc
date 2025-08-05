-- Python syntax highlighting fixes
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Ensure Python parser is installed
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "python")
      return opts
    end,
  },
  
  -- Fallback syntax highlighting for Python decorators
  {
    "vim-python/python-syntax",
    ft = "python",
    init = function()
      -- Enable all Python syntax highlighting features
      vim.g.python_highlight_all = 1
      vim.g.python_highlight_space_errors = 0
      vim.g.python_highlight_indent_errors = 0
    end,
    config = function()
      -- Custom autocmd to fix decorator highlighting
      vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter", "Syntax"}, {
        pattern = "*.py",
        callback = function()
          -- Force Python syntax highlighting
          vim.cmd([[
            " Enhanced decorator patterns
            syntax match pythonDecorator /@\w\+\.\w\+/ 
            syntax match pythonDecorator /@\w\+/
            syntax match pythonAsync /\<async\>/
            syntax match pythonAwait /\<await\>/
            
            " F-string highlighting
            syntax region pythonFString start=/f['"]\|f["]/ end=/['"]\|["]/ contains=pythonFStringBrace
            syntax match pythonFStringBrace /{[^}]*}/ contained
            
            " Import highlighting
            syntax match pythonImport /\<import\>\|\<from\>\|\<as\>/
            
            " Method calls
            syntax match pythonMethodCall /\.\w\+(/me=e-1
            
            " Apply colors
            highlight link pythonDecorator PreProc
            highlight link pythonAsync Keyword
            highlight link pythonAwait Keyword
            highlight link pythonFString String
            highlight link pythonFStringBrace Special
            highlight link pythonImport Include
            highlight link pythonMethodCall Function
          ]])
        end,
      })
    end,
  },
  
  -- Additional syntax support
  {
    dir = vim.fn.stdpath("config"),
    name = "python-syntax-enhancer",
    ft = "python",
    config = function()
      -- Immediate syntax fix
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function()
          -- Set up better syntax highlighting
          vim.cmd([[
            " Clear any broken highlighting
            syntax clear
            
            " Reload Python syntax
            runtime! syntax/python.vim
            
            " Add our custom patterns
            syntax match pythonDecoratorName /@[a-zA-Z_][a-zA-Z0-9_]*\.[a-zA-Z_][a-zA-Z0-9_]*/ 
            syntax match pythonDecoratorSimple /@[a-zA-Z_][a-zA-Z0-9_]*/
            syntax keyword pythonAsyncKeyword async await
            syntax keyword pythonImportKeyword import from as
            
            " F-strings with better matching
            syntax region pythonFStringRegion start=+f"+ end=+"+ contains=pythonFStringExpr
            syntax region pythonFStringRegion start=+f'+ end=+'+ contains=pythonFStringExpr
            syntax match pythonFStringExpr +{[^}]*}+ contained
            
            " Apply highlighting
            highlight link pythonDecoratorName PreProc
            highlight link pythonDecoratorSimple PreProc  
            highlight link pythonAsyncKeyword Keyword
            highlight link pythonImportKeyword Include
            highlight link pythonFStringRegion String
            highlight link pythonFStringExpr Special
          ]])
          
          -- Force buffer refresh
          vim.cmd("redraw!")
        end,
      })
    end,
  },
}