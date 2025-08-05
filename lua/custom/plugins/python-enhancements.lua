-- Python workflow enhancements for serious development
return {
  -- 📊 Jupyter notebook support
  {
    'benlubas/molten-nvim',
    build = ':UpdateRemotePlugins',
    init = function()
      vim.g.molten_image_provider = 'image.nvim'
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = false
    end,
    keys = {
      { '<leader>mi', '<cmd>MoltenInit<cr>', desc = 'Initialize Molten' },
      { '<leader>me', '<cmd>MoltenEvaluateOperator<cr>', desc = 'Evaluate operator', mode = 'n' },
      { '<leader>mr', '<cmd>MoltenReevaluateCell<cr>', desc = 'Re-evaluate cell' },
      { '<leader>md', '<cmd>MoltenDelete<cr>', desc = 'Delete cell' },
      { '<leader>mo', '<cmd>MoltenShowOutput<cr>', desc = 'Show output' },
      { '<leader>mh', '<cmd>MoltenHideOutput<cr>', desc = 'Hide output' },
    },
    ft = { 'python', 'jupyter' },
  },

  -- 🐍 Enhanced Python REPL
  {
    'Vigemus/iron.nvim',
    keys = {
      { '<leader>rs', '<cmd>IronRepl<cr>', desc = 'Start REPL' },
      { '<leader>rr', '<cmd>IronRestart<cr>', desc = 'Restart REPL' },
      { '<leader>rf', '<cmd>IronFocus<cr>', desc = 'Focus REPL' },
      { '<leader>rh', '<cmd>IronHide<cr>', desc = 'Hide REPL' },
    },
    config = function()
      local iron = require('iron.core')
      iron.setup {
        config = {
          scratch_repl = true,
          repl_definition = {
            python = {
              command = { 'python3' },
              format = require('iron.fts.common').bracketed_paste,
            },
          },
          repl_open_cmd = require('iron.view').bottom(40),
        },
        keymaps = {
          send_motion = '<space>sc',
          visual_send = '<space>sc',
          send_file = '<space>sf',
          send_line = '<space>sl',
          send_until_cursor = '<space>su',
          send_mark = '<space>sm',
          mark_motion = '<space>mc',
          mark_visual = '<space>mc',
          remove_mark = '<space>md',
          cr = '<space>s<cr>',
          interrupt = '<space>s<space>',
          exit = '<space>sq',
          clear = '<space>cl',
        },
        highlight = {
          italic = true
        },
        ignore_blank_lines = true,
      }
    end,
    ft = { 'python' },
  },

  -- 🔧 Enhanced Python debugging
  {
    'mfussenegger/nvim-dap-python',
    ft = 'python',
    dependencies = {
      'mfussenegger/nvim-dap',
      'rcarriga/nvim-dap-ui',
    },
    config = function()
      local dap_python = require('dap-python')
      dap_python.setup('python') -- Use system python or venv python
      
      -- Custom configurations for common Python scenarios
      table.insert(require('dap').configurations.python, {
        type = 'python',
        request = 'launch',
        name = 'Launch with args',
        program = '${file}',
        args = function()
          local args_string = vim.fn.input('Arguments: ')
          return vim.split(args_string, ' ')
        end,
        console = 'integratedTerminal',
      })
      
      vim.keymap.set('n', '<leader>dn', function() require('dap-python').test_method() end, { desc = 'Debug nearest test' })
      vim.keymap.set('n', '<leader>df', function() require('dap-python').test_class() end, { desc = 'Debug test class' })
      vim.keymap.set('v', '<leader>ds', function() require('dap-python').debug_selection() end, { desc = 'Debug selection' })
    end,
  },

  -- VenvSelect disabled - using automatic venv activation from shell instead

  -- 🧪 Test runner integration
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-neotest/neotest-python',
    },
    keys = {
      { '<leader>tn', function() require('neotest').run.run() end, desc = 'Run nearest test' },
      { '<leader>tf', function() require('neotest').run.run(vim.fn.expand('%')) end, desc = 'Run file tests' },
      { '<leader>td', function() require('neotest').run.run({ strategy = 'dap' }) end, desc = 'Debug nearest test' },
      { '<leader>ts', function() require('neotest').summary.toggle() end, desc = 'Toggle test summary' },
      { '<leader>to', function() require('neotest').output.open({ enter = true }) end, desc = 'Show test output' },
    },
    config = function()
      require('neotest').setup({
        adapters = {
          require('neotest-python')({
            dap = { justMyCode = false },
            runner = 'pytest',
          }),
        },
      })
    end,
    ft = { 'python' },
  },
}