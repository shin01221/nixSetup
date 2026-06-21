return {
  -- enabled = false,
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    file_types = { "markdown", "norg", "rmd", "org" },
    code = {
      enabled = true,
      sign = true,
      width = "block",
      right_pad = 10,
      left_pad = 3,
      language_pad = 1,
    },
    heading = {
      sign = true,
      signs = { "󰫎 " },
      -- icons = { "󰎤", "󰎧", "󰎪", "󰎭", "󰎱", "󰎳" },
      icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      -- icons = { "", "", "", "", "", "" },
      position = "overlay",
      width = "block",
      -- border = true,
      border_prefix = true,
      border_virtual = false,
    },
    dash = {
      enabled = true,
      -- render_modes = false,
      render_modes = { "n", "c", "t" },
      -- Replaces '---'|'***'|'___'|'* * *' of 'thematic_break'
      -- The icon gets repeated across the window's width
      icon = "──",
      -- Width of the generated line:
      --  <number>: a hard coded width value, if a floating point value < 1 is provided it is
      --            treated as a percentage of the available window space
      --  full:     full width of the window
      width = "full",
      -- Amount of margin to add to the left of dash
      -- If a floating point value < 1 is provided it is treated as a percentage of the available window space
      left_margin = 0,
      -- Highlight for the whole line generated from the icon
      highlight = "RenderMarkdownDash",
    },
    latex = {
      enabled = false,
      converter = "latex2text",
      highlight = "RenderMarkdownMath",
      top_pad = 0,
      bottom_pad = 0,
    },
  },
  config = function(_, opts)
    require("render-markdown").setup(opts)
    Snacks.toggle({
      name = "Render Markdown",
      get = function()
        return require("render-markdown.state").enabled
      end,
      set = function(enabled)
        local m = require("render-markdown")
        if enabled then
          m.enable()
        else
          m.disable()
        end
      end,
    }):map("<leader>um")
  end,
}
