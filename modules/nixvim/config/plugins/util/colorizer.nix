{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimPlugins; [
    windows-nvim
  ];

  extraConfigLua = # lua
    ''
      vim.o.winwidth = 10
      vim.o.winminwidth = 10
      vim.o.equalalways = false
      require('windows').setup()
    '';

  plugins.colorizer = {
    enable = true;

    settings = {
      filetypes = {
        __unkeyed = "*";
      };
      user_default_options = {
        names = true;
        RRGGBBAA = true;
        AARRGGBB = true;
        rgb_fn = true;
        hsl_fn = true;
        css = true;
        css_fn = true;
        tailwind = true;
        mode = "virtualtext";
        virtualtext = "■";
        always_update = true;
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>uC";
      action.__raw = ''
        function ()
          vim.cmd('ColorizerToggle')
          vim.g.colorizing_enabled = require('colorizer').is_buffer_attached(0)
          vim.notify(string.format("Colorizing %s", tostring(vim.g.colorizing_enabled), "info"))
        end
      '';
      options = {
        desc = "Colorizing Toggle";
        silent = true;
      };
    }
  ];
}
