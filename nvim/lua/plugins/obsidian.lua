return {
  -- enabled = false,
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  -- lazy = true,
  -- ft = "markdown",
  --
  opts = {
    footer = {
      enabled = false, -- turn it off
      separator = false, -- turn it off
      -- separator = "", -- insert a blank line
      format = "{{backlinks}} backlinks  {{properties}} properties  {{words}} words  {{chars}} chars", -- works like the template system
      -- format = "({{backlinks}} backlinks)", -- limit to backlinks
      hl_group = "@property", -- Use another hl group
    },
    note_id_func = function(title)
      -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
      -- In this case a note with the title 'My new note' will be given an ID that looks
      -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
      local suffix = ""
      if title ~= nil then
        -- If title is given, transform it into valid file name.
        -- for
        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        -- If title is nil, just add 4 random uppercase letters to the suffix.
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return tostring(os.time()) .. "-" .. suffix
    end,
    legacy_commands = false,
    workspaces = {
      {
        name = "shin",
        path = "/Media/Docs/notes",
      },
    },
    checkbox = {
      enabled = true,
      create_new = true,
      order = { " ", "x", "!" },
    },
    daily_notes = {
      folder = "dailies",
      date_format = "%Y-%m-%d",
      alias_format = "%B %-d, %Y",
      default_tags = { "dailies" },
      template = nil,
    },
    attachments = {
      folder = "assets/imgs",
    },
    -- mappings = {
    -- 	["gf"] = {
    -- 		action = function()
    -- 			return require("obsidian").util.gf_passthrough()
    -- 		end,
    -- 		opts = { noremap = false, expr = true, buffer = true },
    -- 	},
    -- 	["<leader>ch"] = {
    -- 		action = function()
    -- 			return require("obsidian").util.toggle_checkbox()
    -- 		end,
    -- 		opts = { buffer = true },
    -- 	},
    -- 	["<cr>"] = {
    -- 		action = function()
    -- 			return require("obsidian").util.smart_action()
    -- 		end,
    -- 		opts = { buffer = true, expr = true },
    -- 	},
    -- },
    templates = {
      subdir = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M:%S",
    },
    ui = { enable = false },
    completion = {
      min_chars = 2,
    },
  },
}
