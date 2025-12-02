-- Simple test config to debug Python file runner
-- To use: mv init.lua init-backup.lua && mv init-simple.lua init.lua

vim.g.mapleader = ' '

-- Basic options
vim.o.number = true
vim.o.mouse = 'a'
vim.o.clipboard = 'unnamedplus'

-- Simple Python file runner
vim.keymap.set('n', '<leader>r', function()
  local file = vim.fn.expand('%')
  local ext = vim.fn.fnamemodify(file, ':e')
  
  if ext ~= 'py' then
    print("❌ Not a Python file")
    return
  end
  
  vim.cmd('w') -- Save file
  print("🔧 Running: " .. file)
  
  -- Close existing terminals
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == 'terminal' then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
  
  -- Check for venv
  local python_cmd = 'python3'
  local venv_python = vim.fn.getcwd() .. '/venv/bin/python'
  
  if vim.fn.executable(venv_python) == 1 then
    python_cmd = venv_python
    print("🐍 Using venv: " .. venv_python)
  else
    print("🐍 Using system Python: " .. python_cmd)
  end
  
  -- Run in terminal
  vim.cmd('split | resize 15 | terminal ' .. python_cmd .. ' ' .. file)
  vim.cmd('startinsert')
end, { desc = 'Run Python file' })

-- Buffer navigation
vim.keymap.set('n', '[b', '<cmd>bprevious<cr>')
vim.keymap.set('n', ']b', '<cmd>bnext<cr>')

-- Simple terminal
vim.keymap.set('n', '<leader>t', function()
  vim.cmd('split | resize 15 | terminal')
  vim.cmd('startinsert')
end)

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>')

print("🧪 Simple config loaded. Test with <leader>r")