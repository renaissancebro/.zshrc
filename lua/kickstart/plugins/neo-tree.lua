-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim
--
return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- optional, looks better with it
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    -- Press '\' to toggle file explorer
    { '\\', '<cmd>Neotree toggle<CR>', desc = 'Toggle NeoTree', silent = true },
  },
  opts = {
    window = {
      width = 25,
    },
    filesystem = {
      filtered_items = {
        visible = true, -- Show hidden files
        hide_dotfiles = false, -- Do not hide dotfiles
      },
      window = {
        mappings = {
          ['\\'] = 'close_window', -- Use '\' inside NeoTree to close it
        },
      },
    },
  },
}
