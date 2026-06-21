{ config, lib, ... }:
{
  plugins.snacks = {
    settings = {
      gitbrowse.enabled = true;
    };
  };

  keymaps = lib.mkIf config.plugins.snacks.settings.gitbrowse.enabled [
    {
      mode = "n";
      key = "<leader>go";
      action = "<cmd>lua Snacks.gitbrowse()<CR>";
      options = {
        desc = "Open file in browser";
      };
    }
    {
      mode = "v";
      key = "<leader>go";
      action = "<cmd>lua Snacks.gitbrowse()<CR>";
      options = {
        desc = "Open selection in browser";
      };
    }
    {
      mode = "n";
      key = "<leader>gB";
      action = "<cmd>lua Snacks.gitbrowse()<CR>";
      options = {
        desc = "Git Browse (open)";
      };
    }
    {
      mode = "x";
      key = "<leader>gB";
      action = "<cmd>lua Snacks.gitbrowse()<CR>";
      options = {
        desc = "Git Browse (open)";
      };
    }
    {
      mode = "n";
      key = "<leader>gY";
      action.__raw = ''
        function()
          Snacks.gitbrowse({ open = function(url) vim.fn.setreg("+", url) end, notify = false })
        end
      '';
      options = {
        desc = "Git Browse (copy)";
      };
    }
    {
      mode = "x";
      key = "<leader>gY";
      action.__raw = ''
        function()
          Snacks.gitbrowse({ open = function(url) vim.fn.setreg("+", url) end, notify = false })
        end
      '';
      options = {
        desc = "Git Browse (copy)";
      };
    }
  ];
}
