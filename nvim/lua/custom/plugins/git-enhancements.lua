-- Enhanced git workflow for pros
return {
  -- 🚀 Advanced git interface - like VSCode's git panel but better
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      local neogit = require('neogit')
      neogit.setup {
        integrations = {
          telescope = true,
          diffview = true,
        },
      }
      
      vim.keymap.set('n', '<leader>gg', '<cmd>Neogit<cr>', { desc = 'Open Neogit' })
      vim.keymap.set('n', '<leader>gc', '<cmd>Neogit commit<cr>', { desc = 'Git commit' })
    end,
  },

  -- 📊 Beautiful diff view
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'Open git diff' },
      { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = 'File history' },
    },
    opts = {
      enhanced_diff_hl = true,
    },
  },

  -- Git blame plugin removed - was causing distracting "Not Committed Yet" text

  -- Note: gitsigns is configured in init.lua - no duplicate config needed
}