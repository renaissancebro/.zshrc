-- Essential config with sidebar, fuzzy finder, and Python runner
-- Keeps what you like from Kickstart without the bloat

-- Set leader key before any mappings
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Ensure we're in the right mode for leader key to work
vim.opt.showcmd = true  -- Show partial commands (this might be causing the <20> display)
vim.opt.showmode = true -- Show current mode

-- Basic options
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 1000  -- Give more time for leader sequences
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.cursorline = false -- No distracting cursor line
vim.o.undofile = true
vim.o.clipboard = 'unnamedplus' -- Copy to system clipboard

-- Better diagnostics display
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

-- Essential keymaps (Kickstart style)
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Don't explicitly disable space - let leader handle it naturally

-- Auto-reload config when init.lua is saved
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = vim.fn.expand("~") .. "/.config/nvim/init.lua",
  callback = function()
    print("🔄 Reloading Neovim config...")
    vim.schedule(function()
      vim.cmd("source " .. vim.fn.expand("~/.config/nvim/init.lua"))
      print("✅ Config reloaded successfully!")
    end)
  end,
  desc = "Auto-reload Neovim config"
})

-- Manual reload keybinding
vim.keymap.set('n', '<leader>R', function()
  print("🔄 Manually reloading config...")
  vim.cmd("source " .. vim.fn.expand("~/.config/nvim/init.lua"))
  print("✅ Config reloaded!")
end, { desc = '[R]eload config' })

-- Debug: Simple test mapping to confirm leader works
vim.keymap.set('n', '<leader>z', function()
  print("✅ Leader key is working! Space + z pressed")
end, { desc = 'Test leader key' })

-- Save file shortcuts
vim.keymap.set('n', '<C-s>', '<cmd>w<cr>', { desc = 'Save file' })
vim.keymap.set('i', '<C-s>', '<esc><cmd>w<cr>', { desc = 'Save file' })

-- Better up/down (from Kickstart)
vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- LSP and diagnostics keymaps (Kickstart style)
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Show [D]iagnostic' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous [D]iagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next [D]iagnostic' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Copy/paste with system clipboard (y and p already work with clipboard=unnamedplus)
vim.keymap.set('v', '<C-c>', '"+y', { desc = 'Copy to clipboard' })
vim.keymap.set('n', '<C-v>', '"+p', { desc = 'Paste from clipboard' })
vim.keymap.set('i', '<C-v>', '<C-r>+', { desc = 'Paste from clipboard' })

-- Buffer navigation (your "tabs")
vim.keymap.set('n', '[b', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
vim.keymap.set('n', ']b', '<cmd>bnext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>x', '<cmd>bdelete<cr>', { desc = 'Close buffer' })

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus left' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus right' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus down' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus up' })

-- Terminal shortcuts
vim.keymap.set('n', '<leader>t', function()
  vim.cmd('belowright split | resize 15 | terminal')
  vim.cmd('startinsert')
end, { desc = 'Open terminal' })

vim.keymap.set('n', '<C-t>', function()
  vim.cmd('belowright split | resize 15 | terminal')
  vim.cmd('startinsert')
end, { desc = 'Quick terminal' })

-- Better terminal exit
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('t', '<C-w>', '<C-\\><C-n><C-w>', { desc = 'Terminal window nav' })

-- Python file runner - DEBUGGED VERSION
vim.keymap.set('n', '<leader>r', function()
  local file = vim.fn.expand('%')
  local ext = vim.fn.fnamemodify(file, ':e')
  
  if ext ~= 'py' then
    print("Not a Python file: " .. file)
    return
  end
  
  vim.cmd('w') -- Save file
  print("Running: " .. file)
  
  -- Close existing terminals
  local closed_count = 0
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == 'terminal' then
      vim.api.nvim_buf_delete(buf, { force = true })
      closed_count = closed_count + 1
    end
  end
  if closed_count > 0 then
    print("Closed " .. closed_count .. " existing terminals")
  end
  
  -- Check for venv
  local python_cmd = 'python3'
  local cwd = vim.fn.getcwd()
  local venv_paths = {
    cwd .. '/venv/bin/python',
    cwd .. '/.venv/bin/python',
    cwd .. '/env/bin/python'
  }
  
  for _, venv_python in ipairs(venv_paths) do
    if vim.fn.executable(venv_python) == 1 then
      python_cmd = venv_python
      print("Using venv: " .. venv_python)
      break
    end
  end
  
  if python_cmd == 'python3' then
    print("Using system Python: " .. python_cmd)
  end
  
  -- Run in terminal with better error handling
  local cmd = python_cmd .. ' "' .. file .. '"'
  print("Command: " .. cmd)
  
  vim.cmd('belowright split | resize 15')
  vim.cmd('terminal ' .. cmd)
  vim.cmd('startinsert')
end, { desc = 'Run Python file with venv' })

-- Install lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Essential plugins only
require('lazy').setup({
  -- File finder (fuzzy finder you like)
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require('telescope.builtin')
      
      -- Configure Telescope with better defaults
      require('telescope').setup({
        defaults = {
          file_ignore_patterns = {
            "node_modules/",
            ".git/",
            "dist/",
            "build/",
            "__pycache__/",
            "%.pyc",
            ".DS_Store",
            "%.jpg", "%.jpeg", "%.png", "%.pdf"
          },
          layout_config = {
            horizontal = { preview_width = 0.6 },
          },
        },
        pickers = {
          find_files = {
            hidden = false, -- Don't show hidden files by default
            follow = true,  -- Follow symlinks
          },
        },
      })
      
      -- Kickstart Telescope keymaps
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      
      -- Smart file finding
      vim.keymap.set('n', '<leader>sf', function()
        builtin.find_files({
          hidden = false,
          no_ignore = false, -- Respect .gitignore
        })
      end, { desc = '[S]earch [F]iles (smart)' })
      
      -- Local directory only (faster)
      vim.keymap.set('n', '<leader>sl', function()
        builtin.find_files({
          cwd = vim.fn.getcwd(),
          hidden = false,
          no_ignore = false,
          search_dirs = { "." },
          depth = 2, -- Only go 2 levels deep
        })
      end, { desc = '[S]earch [L]ocal files' })
      
      -- All files (including hidden)
      vim.keymap.set('n', '<leader>sa', function()
        builtin.find_files({
          hidden = true,
          no_ignore = true,
        })
      end, { desc = '[S]earch [A]ll files' })
      
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      
      -- Search in current buffer
      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })
    end,
  },

  -- Sidebar file explorer
  {
    'nvim-neo-tree/neo-tree.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    config = function()
      require('neo-tree').setup({
        close_if_last_window = false,
        popup_border_style = 'rounded',
        enable_git_status = true,
        enable_diagnostics = true,
        enable_normal_mode_for_inputs = false,
        enable_refresh_on_write = true,
        default_component_configs = {
          container = {
            enable_character_fade = true
          },
          indent = {
            indent_size = 2,
            padding = 1,
            with_markers = true,
            indent_marker = "│",
            last_indent_marker = "└",
            highlight = "NeoTreeIndentMarker",
            with_expanders = true,
            expander_collapsed = "",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander",
          },
        },
        window = {
          position = "left",
          width = 25, -- Reduced from default 40
          mapping_options = {
            noremap = true,
            nowait = true,
          },
        },
        filesystem = {
          filtered_items = {
            visible = false,
            hide_dotfiles = true,
            hide_gitignored = true,
          },
          follow_current_file = {
            enabled = true,
            leave_dirs_open = false,
          },
        },
      })
      vim.keymap.set('n', '\\', '<cmd>Neotree toggle<cr>', { desc = 'Toggle file explorer' })
    end,
  },

  -- LSP for Python autocomplete
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = desc })
          end
          
          -- Kickstart LSP keymaps
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        end,
      })

      -- Pyright configuration levels
      local pyright_settings = {
        off = false, -- Disable Pyright completely
        basic = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoImportCompletions = true,
              diagnosticMode = "workspace",
            }
          }
        },
        strict = {
          python = {
            analysis = {
              typeCheckingMode = "strict",
              autoImportCompletions = true,
              diagnosticMode = "workspace",
            }
          }
        }
      }

      -- Current setting (change this to 'off', 'basic', or 'strict')
      local current_pyright_mode = 'basic'

      require('mason-lspconfig').setup({
        ensure_installed = { 'pyright' },
        handlers = {
          function(server_name)
            if server_name == 'pyright' then
              if current_pyright_mode == 'off' then
                return -- Don't start Pyright
              end
              require('lspconfig')[server_name].setup({
                settings = pyright_settings[current_pyright_mode]
              })
            else
              require('lspconfig')[server_name].setup({})
            end
          end,
        },
      })

      -- Toggle Pyright function
      local function toggle_pyright()
        local modes = {'off', 'basic', 'strict'}
        local current_index = 1
        for i, mode in ipairs(modes) do
          if mode == current_pyright_mode then
            current_index = i
            break
          end
        end
        local next_index = (current_index % #modes) + 1
        current_pyright_mode = modes[next_index]
        
        print("Pyright mode: " .. current_pyright_mode .. " (restart Neovim to apply)")
      end

      vim.keymap.set('n', '<leader>tp', toggle_pyright, { desc = 'Toggle Pyright mode' })
    end,
  },

  -- Autocomplete 
  {
    'saghen/blink.cmp',
    version = '1.*',
    opts = {
      keymap = { preset = 'super-tab' },
      completion = { menu = { auto_show = true } },
      sources = { default = { 'lsp', 'path' } },
    },
  },

  -- Simplified Treesitter (disable problematic features)
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = { 'python', 'lua', 'vim', 'markdown' },
      auto_install = false, -- Disable auto install to prevent query issues
      highlight = { 
        enable = false, -- Temporarily disable to fix query error
        additional_vim_regex_highlighting = true, -- Use vim highlighting instead
      },
      indent = { enable = true },
    },
  },

  -- Git signs (minimal)
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      current_line_blame = false,
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '-' },
      },
    },
  },

  -- Enhanced Tokyo Night theme
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('tokyonight').setup {
        style = 'night',
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
          colors.comment = '#565f89'
          colors.purple = '#bb9af7'
          colors.cyan = '#7dcfff'
          colors.green = '#9ecdda'
        end,
        on_highlights = function(hl, c)
          -- Basic vim syntax highlighting (no treesitter)
          hl.Function = { fg = c.blue, bold = true }
          hl.Keyword = { fg = c.purple, bold = true }
          hl.String = { fg = c.green }
          hl.Number = { fg = c.orange }
          hl.Boolean = { fg = c.orange }
          hl.Type = { fg = c.cyan }
          hl.Operator = { fg = c.purple }
          hl.Delimiter = { fg = c.yellow }
          hl.MatchParen = { fg = c.orange, bold = true, bg = c.bg_highlight }
          hl.Constant = { fg = c.orange }
          
          -- Python specific vim syntax
          hl.pythonBuiltin = { fg = c.cyan }
          hl.pythonFunction = { fg = c.blue, bold = true }
          hl.pythonDecorator = { fg = c.yellow }
          hl.pythonException = { fg = c.red }
          hl.pythonString = { fg = c.green }
          hl.pythonNumber = { fg = c.orange }
          hl.pythonComment = { fg = c.comment, italic = true }
        end,
      }
      vim.cmd.colorscheme 'tokyonight'
      
      -- Remove problematic treesitter autocmd that causes query errors
    end,
  },
})

print("Essential config loaded: \\ (sidebar) | <leader>sf (files) | <leader>r (run Python)")