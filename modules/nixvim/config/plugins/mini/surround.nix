{ config, lib, ... }:
let
  inherit (lib) mkIf;
in
{
  extraConfigLua = mkIf config.plugins.mini.enable # lua
    ''
      require('mini.surround').setup({
        mappings = {
          add = "gsa",
          delete = "gsd",
          find = "gsf",
          find_left = "gsF",
          highlight = "gsh",
          replace = "gsr",
          update_n_lines = "gsn",
        },
      })
    '';

  plugins.which-key.settings.spec = mkIf config.plugins.mini.enable [
    {
      __unkeyed-1 = "gs";
      mode = [
        "n"
        "x"
      ];
      group = "surround";
    }
  ];
}
