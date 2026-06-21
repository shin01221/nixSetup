{ pkgs, ... }: {
  extraPlugins = with pkgs.vimPlugins; [
    render-markdown-nvim
  ];

  extraConfigLua = ''
    require("render-markdown").setup({
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
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        position = "overlay",
        width = "block",
        border_prefix = true,
        border_virtual = false,
      },
      dash = {
        enabled = true,
        render_modes = { "n", "c", "t" },
        icon = "──",
        width = "full",
        left_margin = 0,
        highlight = "RenderMarkdownDash",
      },
      latex = {
        enabled = false,
        converter = "latex2text",
        highlight = "RenderMarkdownMath",
        top_pad = 0,
        bottom_pad = 0,
      },
    })

    Snacks.toggle({
      name = "Render Markdown",
      get = function()
        return require("render-markdown.state").enabled
      end,
      set = function(enabled)
        local m = require("render-markdown")
        if enabled then m.enable() else m.disable() end
      end,
    }):map("<leader>um")
  '';
}
