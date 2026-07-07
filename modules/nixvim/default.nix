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

  options.workstation.nixvim = {
    enable = lib.mkEnableOption "Nvim configuration";
    minimal = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Minimal nvim without heavy UI, most LSPs, and non-essential plugins";
    };
  };

  config = lib.mkIf cfg.enable {
    workstation.nixvim.minimal = lib.mkDefault (config.server.baseline.enable or false);

    environment.systemPackages = with pkgs; [
      ripgrep
      stylua
      shellcheck
      shfmt
      fd
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
    } // lib.optionalAttrs cfg.minimal {
      plugins = {
        # Disable heavy UI
        alpha.enable = lib.mkForce false;
        bufferline.enable = lib.mkForce false;
        noice.enable = lib.mkForce false;
        notify.enable = lib.mkForce false;
        lualine.enable = lib.mkForce false;
        precognition.enable = lib.mkForce false;
        toggleterm.enable = lib.mkForce false;

        # Disable completion
        blink-cmp.enable = lib.mkForce false;
        friendly-snippets.enable = lib.mkForce false;

        # Disable debug
        dap.enable = lib.mkForce false;
        dap-virtual-text.enable = lib.mkForce false;

        # Disable editor extras
        yanky.enable = lib.mkForce false;
        neogen.enable = lib.mkForce false;

        # Disable lang-specific
        obsidian.enable = lib.mkForce false;

        # Disable LSP extras
        fastaction.enable = lib.mkForce false;
        trouble.enable = lib.mkForce false;
        otter.enable = lib.mkForce false;
        fidget.enable = lib.mkForce false;

        # Disable util extras
        compiler.enable = lib.mkForce false;
        devdocs.enable = lib.mkForce false;
        glance.enable = lib.mkForce false;
        img-clip.enable = lib.mkForce false;
        overseer.enable = lib.mkForce false;
        refactoring.enable = lib.mkForce false;
        package-info.enable = lib.mkForce false;

        # Disable language-specific plugins
        clangd-extensions.enable = lib.mkForce false;
      };

      # Disable heavy theme
      colorschemes.catppuccin.enable = lib.mkForce false;

      # Disable all non-nix/bash LSP servers
      lsp.servers = {
        emmylua_ls.enable = lib.mkForce false;
        jsonls.enable = lib.mkForce false;
        yamlls.enable = lib.mkForce false;
        marksman.enable = lib.mkForce false;
        dockerls.enable = lib.mkForce false;
        html.enable = lib.mkForce false;
        cmake.enable = lib.mkForce false;
        clangd.enable = lib.mkForce false;
        pyright.enable = lib.mkForce false;
        ruff.enable = lib.mkForce false;
        biome.enable = lib.mkForce false;
        typos_lsp.enable = lib.mkForce false;
        sqls.enable = lib.mkForce false;
        taplo.enable = lib.mkForce false;
      };
    };
  };
}
