return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    image = {
      enabled = true,
      doc = {
        inline = false,
        float = true,
      },
    },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    picker = {
      enabled = true,
      layout = "ivy",
    },
  },
  keys = {
    {
      "<leader>fC",
      function()
        Snacks.picker.files({ cwd = vim.fn.expand("~/.config") })
      end,
      desc = "Find ~/.config Files",
    },
    {
      "<leader>uC",
      function()
        local builtin = {
          "default",
          "blue",
          "darkblue",
          "delek",
          "desert",
          "elflord",
          "evening",
          "habamax",
          "industry",
          "koehler",
          "lunaperche",
          "morning",
          "murphy",
          "pablo",
          "peachpuff",
          "quiet",
          "retrobox",
          "ron",
          "shine",
          "slate",
          "sorbet",
          "sunburst",
          "swamp",
          "torte",
          "wildcharm",
          "zaibatsu",
          "vim",
          "zellner",
          "unokai",
        }
        Snacks.picker.colorschemes({
          transform = function(item)
            if vim.tbl_contains(builtin, item.text) then
              return false
            end
          end,
        })
      end,
      desc = "Colorschemes (user only)",
    },
  },
}
