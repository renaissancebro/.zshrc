-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Language-specific debugger extensions
    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python',
    'microsoft/vscode-js-debug',
  },
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F1>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>b',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>B',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    {
      '<F7>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: See last session result.',
    },
    -- Language-specific debugging shortcuts
    {
      '<leader>dp',
      function()
        require('dap-python').test_method()
      end,
      desc = 'Debug: Python test method',
      ft = { 'python' },
    },
    {
      '<leader>dc',
      function()
        require('dap-python').test_class()
      end,
      desc = 'Debug: Python test class',
      ft = { 'python' },
    },
    {
      '<leader>ds',
      function()
        require('dap-python').debug_selection()
      end,
      desc = 'Debug: Python selection',
      ft = { 'python' },
      mode = { 'v' },
    },
    -- Restart debugging session
    {
      '<F6>',
      function()
        require('dap').restart()
      end,
      desc = 'Debug: Restart',
    },
    -- Terminate debugging session
    {
      '<F8>',
      function()
        require('dap').terminate()
      end,
      desc = 'Debug: Terminate',
    },
    
    -- Compact keyboard alternatives (Keychron-friendly)
    {
      '<leader>dd',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<leader>di',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<leader>do',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<leader>dO',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>dr',
      function()
        require('dap').restart()
      end,
      desc = 'Debug: Restart',
    },
    {
      '<leader>dt',
      function()
        require('dap').terminate()
      end,
      desc = 'Debug: Terminate',
    },
    {
      '<leader>du',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: Toggle UI',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Go debugger
        'delve',
        -- Python debugger
        'debugpy',
        -- JavaScript/Node.js debugger
        'js-debug-adapter',
        -- Bash debugger
        'bash-debug-adapter',
      },
    }

    -- Enhanced Dap UI setup with VS Code-like visual experience
    dapui.setup {
      icons = { expanded = '🔽', collapsed = '▶️', current_frame = '👉' },
      controls = {
        icons = {
          pause = '⏸️',
          play = '▶️',
          step_into = '⏬',
          step_over = '⏭️',
          step_out = '⏫',
          step_back = '⏪',
          run_last = '🔄',
          terminate = '⏹️',
          disconnect = '🔌',
        },
      },
      layouts = {
        {
          elements = {
            { id = 'scopes', size = 0.25 },
            { id = 'breakpoints', size = 0.25 },
            { id = 'stacks', size = 0.25 },
            { id = 'watches', size = 0.25 },
          },
          size = 40,
          position = 'left',
        },
        {
          elements = {
            { id = 'repl', size = 0.5 },
            { id = 'console', size = 0.5 },
          },
          size = 10,
          position = 'bottom',
        },
      },
      floating = {
        max_height = nil,
        max_width = nil,
        border = 'rounded',
        mappings = {
          close = { 'q', '<Esc>' },
        },
      },
      windows = { indent = 1 },
      render = {
        max_type_length = nil,
        max_value_lines = 100,
      },
    }

    -- Enhanced breakpoint icons and colors (VS Code style)
    vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400', bg = 'NONE' })
    vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00', bg = '#2d2006' })
    vim.api.nvim_set_hl(0, 'DapLogPoint', { fg = '#61afef', bg = 'NONE' })
    vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#98c379', bg = '#2a3d2a' })
    
    local breakpoint_icons = vim.g.have_nerd_font
        and { 
          Breakpoint = '🔴', 
          BreakpointCondition = '🔵', 
          BreakpointRejected = '🚫', 
          LogPoint = '📝', 
          Stopped = '▶️' 
        }
      or { 
        Breakpoint = '●', 
        BreakpointCondition = '◐', 
        BreakpointRejected = '⊘', 
        LogPoint = '◆', 
        Stopped = '→' 
      }
    
    for type, icon in pairs(breakpoint_icons) do
      local tp = 'Dap' .. type
      local hl = (type == 'Stopped') and 'DapStopped' or (type == 'LogPoint') and 'DapLogPoint' or 'DapBreak'
      vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    end
    -- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    -- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    -- local breakpoint_icons = vim.g.have_nerd_font
    --     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
    --   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    -- for type, icon in pairs(breakpoint_icons) do
    --   local tp = 'Dap' .. type
    --   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
    --   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    -- end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }

    -- Python debugging setup
    require('dap-python').setup('python3')
    -- Use the Python from your virtual environment
    local python_path = vim.fn.exepath('python3') or vim.fn.exepath('python')
    if python_path ~= '' then
      require('dap-python').setup(python_path)
    end

    -- JavaScript/Node.js debugging setup
    dap.adapters.node2 = {
      type = 'executable',
      command = 'node',
      args = { vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js' },
    }

    dap.configurations.javascript = {
      {
        name = 'Launch Node.js',
        type = 'node2',
        request = 'launch',
        program = '${file}',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = 'inspector',
        console = 'integratedTerminal',
      },
      {
        name = 'Attach to Process',
        type = 'node2',
        request = 'attach',
        processId = function()
          return require('dap.utils').pick_process({ filter = 'node' })
        end,
      },
    }

    -- TypeScript configuration (same as JavaScript)
    dap.configurations.typescript = dap.configurations.javascript

    -- Bash debugging setup
    dap.adapters.bashdb = {
      type = 'executable',
      command = vim.fn.stdpath('data') .. '/mason/packages/bash-debug-adapter/bash-debug-adapter',
      name = 'bashdb',
    }

    dap.configurations.sh = {
      {
        type = 'bashdb',
        request = 'launch',
        name = 'Launch Bash Script',
        showDebugOutput = true,
        pathBashdb = vim.fn.stdpath('data') .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb',
        pathBashdbLib = vim.fn.stdpath('data') .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir',
        trace = true,
        file = '${file}',
        program = '${file}',
        cwd = '${workspaceFolder}',
        pathCat = 'cat',
        pathBash = '/bin/bash',
        pathMkfifo = 'mkfifo',
        pathPkill = 'pkill',
        args = {},
        env = {},
        terminalKind = 'integrated',
      },
    }

    -- HTML/CSS debugging (using Chrome DevTools)
    dap.adapters.chrome = {
      type = 'executable',
      command = 'node',
      args = { vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js' },
    }

    dap.configurations.html = {
      {
        name = 'Launch Chrome',
        type = 'chrome',
        request = 'launch',
        url = 'file://${file}',
        webRoot = '${workspaceFolder}',
        sourceMaps = true,
        userDataDir = false,
      },
    }

    -- CSS debugging through HTML
    dap.configurations.css = dap.configurations.html
  end,
}
