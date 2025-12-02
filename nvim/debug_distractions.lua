-- Debug script to identify what's causing distractions
-- Run this with :lua dofile(vim.fn.stdpath('config') .. '/debug_distractions.lua')

print("=== DEBUGGING DISTRACTIONS ===")

-- Check gitsigns current_line_blame setting
pcall(function()
  local gitsigns = require('gitsigns')
  local config = gitsigns.get_config()
  print("Gitsigns current_line_blame:", config.current_line_blame or "nil")
  print("Gitsigns blame enabled:", vim.g.gitsigns_blame_line_highlight or "nil")
end)

-- Check what's in virtual text (where git blame appears)
local ns_ids = vim.api.nvim_get_namespaces()
for name, id in pairs(ns_ids) do
  if name:match("gitsigns") or name:match("blame") then
    print("Found namespace:", name, "ID:", id)
    local extmarks = vim.api.nvim_buf_get_extmarks(0, id, 0, -1, {details = true})
    if #extmarks > 0 then
      print("  Active extmarks:", #extmarks)
      for i, mark in ipairs(extmarks) do
        if i <= 3 then -- Show first 3
          print("    Mark:", vim.inspect(mark))
        end
      end
    end
  end
end

-- Check LSP document highlighting
local clients = vim.lsp.get_clients({bufnr = 0})
for _, client in ipairs(clients) do
  print("LSP Client:", client.name)
  print("  Document highlight enabled:", 
    client.server_capabilities.documentHighlightProvider or "nil")
end

-- Check current highlight groups that might be causing issues
local problem_groups = {
  'LspReferenceText', 'LspReferenceRead', 'LspReferenceWrite',
  'IlluminatedWordText', 'IlluminatedWordRead', 'IlluminatedWordWrite'
}

for _, group in ipairs(problem_groups) do
  local hl = vim.api.nvim_get_hl(0, {name = group})
  if next(hl) then
    print("Highlight group", group, ":", vim.inspect(hl))
  end
end

print("=== END DEBUG ===")