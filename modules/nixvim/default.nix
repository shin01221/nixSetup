{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.workstation.nixvim;
in
{
  imports = [
    inputs.nixvim.nixosModules.nixvim
  ];

  options.workstation.nixvim.enable =
    lib.mkEnableOption "Nvim configuration";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ripgrep
      stylua
      shellcheck
      shfmt
      python3Packages.flake8
    ];
    environment.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    programs.nixvim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      nixpkgs = {
        config.allowUnfree = true;
        source = inputs.nixpkgs-unstable;
      };

      imports = [
        ./config
      ];
    };
  };
}
