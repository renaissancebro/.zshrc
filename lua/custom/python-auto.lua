-- Auto-detect and use project Python virtual environments
-- This makes Neovim behave more like VS Code for Python projects

local M = {}

-- Function to find and set Python path for current project
local function setup_python_path()
  local cwd = vim.fn.getcwd()
  
  -- Common venv locations to check
  local venv_paths = {
    cwd .. '/venv/bin/python',
    cwd .. '/.venv/bin/python', 
    cwd .. '/env/bin/python',
    cwd .. '/.env/bin/python'
  }
  
  -- Check each possible venv location
  for _, python_path in ipairs(venv_paths) do
    if vim.fn.executable(python_path) == 1 then
      vim.g.python3_host_prog = python_path
      
      -- Update LSP servers to use this Python
      local clients = vim.lsp.get_clients({name = 'pyright'})
      for _, client in ipairs(clients) do
        if client.config.settings then
          client.config.settings.python = client.config.settings.python or {}
          client.config.settings.python.pythonPath = python_path
          client.notify('workspace/didChangeConfiguration', {
            settings = client.config.settings
          })
        end
      end
      
      local venv_name = vim.fn.fnamemodify(vim.fn.fnamemodify(python_path, ':h'), ':h:t')
      print("🐍 Python venv detected: " .. venv_name)
      return
    end
  end
  
  -- Fallback to system Python
  local system_python = vim.fn.exepath('python3') or vim.fn.exepath('python')
  if system_python then
    vim.g.python3_host_prog = system_python
  end
end

-- Auto-detect venv when changing directories OR opening Neovim
vim.api.nvim_create_autocmd({ "DirChanged", "VimEnter" }, {
  group = vim.api.nvim_create_augroup("AutoPythonVenv", { clear = true }),
  callback = setup_python_path,
})

-- Also run when opening Python files
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("AutoPythonVenvFileType", { clear = true }),
  pattern = "python",
  callback = setup_python_path,
})

-- Run immediately
setup_python_path()

-- Command to manually refresh Python detection
vim.api.nvim_create_user_command('PyRefresh', setup_python_path, {
  desc = 'Refresh Python virtual environment detection'
})

return M