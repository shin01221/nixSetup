{ ... }:
let
  icons = import ../../../lib/icons.nix;
  time = "${icons.ui.Time}";
in
{
  plugins.lualine = {
    enable = true;

    settings = {
      options = {
        theme = "auto";
        globalstatus = true;
        component_separators = "";
        section_separators = {
          left = "";
          right = "";
        };
        disabled_filetypes.statusline = [
          "dashboard"
          "alpha"
          "ministarter"
          "snacks_dashboard"
        ];
      };

      extensions = [ "neo-tree" "nvim-tree" "lazy" "fzf" ];

      sections = {
        lualine_a = [
          {
            __unkeyed = "mode";
            separator = {
              left = "┃││";
              right = "";
            };
            padding = {
              left = 1;
              right = 1;
            };
          }
        ];

        lualine_b = [
          {
            __unkeyed = "branch";
            icon = "";
            separator = {
              right = "";
            };
            padding = {
              left = 1;
              right = 1;
            };
          }
        ];

        lualine_c = [
          {
            __raw = ''
              function()
                return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
              end
            '';
            separator = "";
            padding = {
              left = 1;
              right = 1;
            };
          }
          {
            __unkeyed = "filetype";
            icon_only = true;
            separator = "";
            padding = {
              left = 1;
              right = 0;
            };
          }
          {
            __raw = ''
              function()
                local path = vim.fn.expand("%:p")
                if path == "" then return "" end
                local cwd = vim.fn.getcwd()
                if path:find(cwd, 1, true) == 1 then
                  path = path:sub(#cwd + 2)
                end
                local parts = vim.split(path, "[\\/]")
                if #parts > 3 then
                  parts = { parts[1], "…", parts[#parts - 1], parts[#parts] }
                end
                return table.concat(parts, package.config:sub(1, 1))
              end
            '';
          }
          {
            __raw = ''
              function()
                local frames = { "󱚝", "󱚟", "󰚩", "󱚡", "󱚣", "󱜙", "󱚥", "", "", "", "✦" }
                local index = math.floor(os.time() / 4) % #frames + 1
                return frames[index]
              end
            '';
            padding = {
              left = 1;
              right = 1;
            };
            color.__raw = ''
              function()
                local hl_groups = {
                  "DiagnosticInfo", "Constant", "Function", "String", "Statement",
                  "Special", "Keyword", "DiagnosticWarn", "NeoTreeNormal", "Type", "Directory",
                }
                local index = math.floor(os.time() / 4) % #hl_groups + 1
                local fg_color = require("snacks").util.color(hl_groups[index])
                local hl = vim.api.nvim_get_hl(0, { name = "NeoTreeNormal", link = false })
                local bg_color = hl.bg and string.format("#%06x", hl.bg)
                return { fg = fg_color, bg = bg_color, gui = "bold" }
              end
            '';
          }
        ];

        lualine_x = [
          {
            __unkeyed = "diagnostics";
            symbols = {
              error = "${icons.diagnostics.Error}";
              warn = "${icons.diagnostics.Warning}";
              info = "${icons.diagnostics.Information}";
              hint = "${icons.diagnostics.Hint}";
            };
          }
          {
            __unkeyed = "diff";
            symbols = {
              added = "${icons.git.LineAdded}";
              modified = "${icons.git.LineModified}";
              removed = "${icons.git.LineRemoved}";
            };
          }
        ];

        lualine_y = [
          {
            __unkeyed = "progress";
            separator = {
              left = "";
            };
            padding = {
              left = 1;
              right = 1;
            };
          }
          {
            __unkeyed = "location";
            padding = {
              left = 0;
              right = 1;
            };
          }
        ];

        lualine_z = [
          {
            __raw = ''
              function()
                return "${time}" .. os.date("%I:%M")
              end
            '';
            separator = {
              left = "";
              right = "││┃";
            };
            padding = {
              left = 1;
              right = 1;
            };
          }
        ];
      };
    };
  };
}
