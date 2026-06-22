{
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) getExe;
in
{
  lsp.servers = {
    statix.enable = true;

    nixd = {
      enable = true;

      config.settings.nixd = {
        formatting = {
          command = [ "${getExe pkgs.nixfmt}" ];
        };
        nixpkgs = {
          expr = "import <nixpkgs> { }";
        };
        options = {
          nixos = {
            expr = ''
              (builtins.getFlake (builtins.toString ./.)).nixosConfigurations.shin.options
            '';
          };
          home-manager = {
            expr = ''
              (builtins.getFlake (builtins.toString ./.)).nixosConfigurations.shin.options.home-manager.users.type.getSubOptions []
            '';
          };
        };
      };
    };
  };

  plugins = {
    nix.enable = true;
    # hmts.enable = true;
    direnv.enable = pkgs.stdenv.hostPlatform.isLinux;
    nix-develop.enable = true;

    conform-nvim.settings = {
      formatters_by_ft = {
        nix = [ "nixfmt" ];
      };
    };

    lint = {
      lintersByFt = {
        nix = [ "deadnix" ];
      };

      linters = {
        deadnix.cmd = getExe pkgs.deadnix;
      };
    };
  };
}
