-- Pro workflow enhancements to reduce friction
return {
  -- 🦘 Lightning fast navigation - jump anywhere in 2 keystrokes
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
      { 's', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'Flash' },
      { 'S', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'Flash Treesitter' },
    },
  },

  -- 📁 Better buffer management
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('bufferline').setup {
        options = {
          close_command = 'bdelete! %d',
          right_mouse_command = 'bdelete! %d',
          offsets = {
            { filetype = 'neo-tree', text = 'File Explorer', highlight = 'Directory', separator = true }
          },
          diagnostics = 'nvim_lsp',
          show_buffer_close_icons = false,
          show_close_icon = false,
        }
      }
      -- Buffer navigation keymaps
      vim.keymap.set('n', '[b', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Prev buffer' })
      vim.keymap.set('n', ']b', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next buffer' })
      vim.keymap.set('n', '<leader>x', '<cmd>bdelete<cr>', { desc = 'Close buffer' })
    end,
  },

  -- 🔍 Advanced search and replace across project  
  {
    'nvim-pack/nvim-spectre',
    build = false,
    cmd = 'Spectre',
    opts = { open_cmd = 'noswapfile vnew' },
    keys = {
      { '<leader>sr', function() require('spectre').open() end, desc = 'Replace in files (Spectre)' },
    },
  },

  -- 🌳 Undo tree visualization
  {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    keys = {
      { '<leader>u', '<cmd>UndotreeToggle<cr>', desc = 'Undo Tree' },
    },
  },

  -- 💾 Session management - restore your work instantly
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = { options = vim.opt.sessionoptions:get() },
    keys = {
      { '<leader>qs', function() require('persistence').load() end, desc = 'Restore Session' },
      { '<leader>ql', function() require('persistence').load({ last = true }) end, desc = 'Restore Last Session' },
      { '<leader>qd', function() require('persistence').stop() end, desc = "Don't Save Current Session" },
    },
  },

  -- 📋 Better terminal integration
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      require('toggleterm').setup {
        size = function(term)
          if term.direction == 'horizontal' then
            return 15
          elseif term.direction == 'vertical' then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = [[<c-\>]], -- Ctrl+\ to toggle terminal
        direction = 'horizontal',
        shell = vim.o.shell,
        auto_scroll = true,
        on_open = function(term)
          vim.api.nvim_buf_set_keymap(term.bufnr, 't', '<esc>', [[<C-\><C-n>]], { noremap = true, silent = true })
          vim.api.nvim_buf_set_keymap(term.bufnr, 't', '<C-h>', [[<Cmd>wincmd h<CR>]], { noremap = true, silent = true })
          vim.api.nvim_buf_set_keymap(term.bufnr, 't', '<C-j>', [[<Cmd>wincmd j<CR>]], { noremap = true, silent = true })
          vim.api.nvim_buf_set_keymap(term.bufnr, 't', '<C-k>', [[<Cmd>wincmd k<CR>]], { noremap = true, silent = true })
          vim.api.nvim_buf_set_keymap(term.bufnr, 't', '<C-l>', [[<Cmd>wincmd l<CR>]], { noremap = true, silent = true })
        end,
      }
      
      -- Floating terminal for quick commands
      local Terminal = require('toggleterm.terminal').Terminal
      local float_term = Terminal:new({
        direction = 'float',
        float_opts = {
          border = 'curved',
        },
        hidden = true,
      })
      
      vim.keymap.set('n', '<leader>tf', function() float_term:toggle() end, { desc = 'Toggle floating terminal' })
    end,
  },

  -- 🎯 Project management and switching
  {
    'ahmedkhalf/project.nvim',
    config = function()
      require('project_nvim').setup {
        detection_methods = { 'lsp', 'pattern' },
        patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json', 'pyproject.toml' },
        show_hidden = false,
        silent_chdir = true,
      }
      require('telescope').load_extension('projects')
      vim.keymap.set('n', '<leader>sp', '<cmd>Telescope projects<cr>', { desc = '[S]earch [P]rojects' })
    end,
  },

  -- 🔧 Better folding
  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    config = function()
      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      
      require('ufo').setup({
        provider_selector = function(bufnr, filetype, buftype)
          return {'treesitter', 'indent'}
        end
      })
      
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = 'Open all folds' })
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = 'Close all folds' })
    end,
  },
}