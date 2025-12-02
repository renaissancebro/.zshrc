-- return {
--   "epwalsh/obsidian.nvim",
--   version = "*",
--   lazy = true,
--   ft = "markdown",
--   dependencies = {
--     "nvim-lua/plenary.nvim",
--   },
--   opts = {
--     workspaces = {
--       {
--         name = "main",
--         path = "~/Documents/Obsidian Vault", -- Update this to your actual vault path
--       },
--     },

--     -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
--     completion = {
--       nvim_cmp = true,
--       min_chars = 2,
--     },

--     -- Optional, configure key mappings. These are the defaults.
--     mappings = {
--       -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
--       ["gf"] = {
--         action = function()
--           return require("obsidian").util.gf_passthrough()
--         end,
--         opts = { noremap = false, expr = true, buffer = true },
--       },
--       -- Toggle check-boxes.
--       ["<leader>ch"] = {
--         action = function()
--           return require("obsidian").util.toggle_checkbox()
--         end,
--         opts = { buffer = true },
--       },
--     },

--     -- Where to put new notes. Valid options are
--     --  * "current_dir" - put new notes in same directory as the current buffer.
--     --  * "notes_subdir" - put new notes in the default notes subdirectory.
--     notes_subdir = "notes",

--     -- Optional, set the log level for obsidian.nvim. This is an integer corresponding to one of the log
--     -- levels defined by "vim.log.levels.*".
--     log_level = vim.log.levels.INFO,

--     daily_notes = {
--       -- Optional, if you keep daily notes in a separate directory.
--       folder = "dailies",
--       -- Optional, if you want to change the date format for the ID of daily notes.
--       date_format = "%Y-%m-%d",
--       -- Optional, if you want to change the date format of the default alias of daily notes.
--       alias_format = "%B %-d, %Y",
--       -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
--       template = nil
--     },

--     -- Optional, customize how names/IDs for new notes are created.
--     note_id_func = function(title)
--       -- Create note IDs in a Zettelkasten style with a timestamp and a suffix.
--       -- In this case a note with the title 'My new note' will be given an ID that looks
--       -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
--       local suffix = ""
--       if title ~= nil then
--         -- If title is given, transform it into valid file name.
--         suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
--       else
--         -- If title is nil, just add 4 random uppercase letters to the suffix.
--         for _ = 1, 4 do
--           suffix = suffix .. string.char(math.random(65, 90))
--         end
--       end
--       return tostring(os.time()) .. "-" .. suffix
--     end,

--     -- Optional, customize how wiki links are formatted.
--     wiki_link_func = function(opts)
--       return require("obsidian.util").wiki_link_id_prefix(opts)
--     end,

--     -- Optional, customize how markdown links are formatted.
--     markdown_link_func = function(opts)
--       return require("obsidian.util").markdown_link(opts)
--     end,

--     -- Either 'wiki' or 'markdown'.
--     preferred_link_style = "wiki",

--     -- Optional, configure additional syntax highlighting / extmarks.
--     ui = {
--       enable = true,  -- set to false to disable all additional syntax features
--       update_debounce = 200,  -- update delay after a text change (in milliseconds)
--       -- Define how various check-boxes are displayed
--       checkboxes = {
--         -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
--         [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
--         ["x"] = { char = "", hl_group = "ObsidianDone" },
--         [">"] = { char = "", hl_group = "ObsidianRightArrow" },
--         ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
--       },
--       external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
--       reference_text = { hl_group = "ObsidianRefText" },
--       highlight_text = { hl_group = "ObsidianHighlightText" },
--       tags = { hl_group = "ObsidianTag" },
--     },

--     -- Optional, set to true if you use the Obsidian Advanced URI plugin.
--     use_advanced_uri = false,

--     -- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
--     open_app_foreground = false,

--     picker = {
--       -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
--       name = "telescope.nvim",
--       -- Optional, configure key mappings for the picker. These are the defaults.
--       mappings = {
--         -- Create a new note from your query.
--         new = "<C-x>",
--         -- Insert a link to the selected note.
--         insert_link = "<C-l>",
--       },
--     },

--     -- Optional, sort search results by "path", "modified", "accessed", or "created".
--     sort_by = "modified",
--     sort_reversed = true,

--     -- Optional, determines how certain commands open notes. The valid options are:
--     -- 1. "current" (default) - to always open in the current window
--     -- 2. "vsplit" - to open in a vertical split if there isn't already a vertical split
--     -- 3. "hsplit" - to open in a horizontal split if there isn't already a horizontal split
--     open_notes_in = "current",
--   },

--   config = function(_, opts)
--     require("obsidian").setup(opts)

--     -- Key mappings for quick access
--     vim.keymap.set('n', '<leader>on', ':ObsidianNew<CR>', { desc = '[O]bsidian [N]ew note' })
--     vim.keymap.set('n', '<leader>oo', ':ObsidianOpen<CR>', { desc = '[O]bsidian [O]pen in app' })
--     vim.keymap.set('n', '<leader>os', ':ObsidianSearch<CR>', { desc = '[O]bsidian [S]earch' })
--     vim.keymap.set('n', '<leader>oq', ':ObsidianQuickSwitch<CR>', { desc = '[O]bsidian [Q]uick switch' })
--     vim.keymap.set('n', '<leader>of', ':ObsidianFollowLink<CR>', { desc = '[O]bsidian [F]ollow link' })
--     vim.keymap.set('n', '<leader>ot', ':ObsidianToday<CR>', { desc = '[O]bsidian [T]oday note' })
--     vim.keymap.set('n', '<leader>oy', ':ObsidianYesterday<CR>', { desc = '[O]bsidian [Y]esterday note' })
--   end,
-- }

-- Obsidian plugin disabled - uncomment above to re-enable
return {}