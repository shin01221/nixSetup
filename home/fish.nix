{
  config,
  pkgs,
  lib,
  hostName,
  ...
}:
{
  programs.fish = {
    enable = true;

    shellAliases = {
      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
      lt = "eza --tree";
      cat = "bat";
      grep = "rg";
      find = "fd";
      top = "btop";
      vim = "nvim";
      vi = "nvim";
    };

    shellAbbrs = {
      gc = "sudo nixos-rebuild boot --flake .#shin";
      gu = "sudo nixos-rebuild boot --flake .#erebos";
      cz = "czkawka";
    };

    interactiveShellInit = ''
      set -g fish_greeting
    '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };
}
