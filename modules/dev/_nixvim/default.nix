{
  config,
  lib,
  pkgs,
  inputs,
  isServer,
  ...
}:
let
  cfg = config.workstation.nixvim;

  groupPaths = {
    ai = ./config/plugins/ai;
    completion = ./config/plugins/completion;
    debug = ./config/plugins/debug;
    editor = ./config/plugins/editor;
    git = ./config/plugins/git;
    lang = ./config/plugins/lang;
    lsp = ./config/plugins/lsp;
    lspExtras = ./config/plugins/lspExtras;
    luasnip = ./config/plugins/luasnip;
    mini = ./config/plugins/mini;
    snacks = ./config/plugins/snacks;
    telescope = ./config/plugins/telescope;
    theme = ./config/plugins/theme;
    treesitter = ./config/plugins/treesitter;
    treesitterExtras = ./config/plugins/treesitterExtras;
    ui = ./config/plugins/ui;
    util = ./config/plugins/util;
  };

  groupDefaults = {
    ai = true;
    completion = true;
    debug = true;
    editor = true;
    git = true;
    lang = true;
    lsp = true;
    lspExtras = true;
    luasnip = true;
    mini = true;
    snacks = true;
    telescope = false;
    theme = true;
    treesitter = true;
    treesitterExtras = true;
    ui = true;
    util = true;
  };

  groupOrder = [
    "ai"
    "completion"
    "debug"
    "editor"
    "theme"
    "luasnip"
    "mini"
    "snacks"
    "telescope"
    "git"
    "lsp"
    "lspExtras"
    "lang"
    "treesitter"
    "treesitterExtras"
    "ui"
    "util"
  ];

  minimalDisabledGroups = [
    "ai"
    "debug"
    "editor"
    "lspExtras"
    "luasnip"
    "mini"
    "snacks"
    "theme"
    "treesitterExtras"
    "ui"
    "util"
  ];

  minimalDisabledPlugins = [
    "obsidian"
    "clangd-extensions"
    "dap-python"
    "markdown-preview"
    "treesitter-context"
    "blink-cmp-git"
    "blink-cmp-spell"
    "blink-cmp-words"
    "blink-emoji"
    "blink-ripgrep"
    "blink-copilot"
    "blink-cmp-dictionary"
    "easy-dotnet"
    "blink-indent"
  ];

  minimalDisabledLspServers = [
    "emmylua_ls"
    "jsonls"
    "yamlls"
    "marksman"
    "dockerls"
    "html"
    "cmake"
    "clangd"
    "pyright"
    "ruff"
    "biome"
    "eslint"
    "cssls"
    "stylelint_lsp"
    "tailwindcss"
    "typos_lsp"
    "sqls"
    "taplo"
  ];
in
{
  imports = [
    inputs.nixvim.nixosModules.nixvim
  ];

  options.workstation.nixvim = {
    enable = lib.mkEnableOption "Nvim configuration";

    server = lib.mkOption {
      type = lib.types.bool;
      default = isServer;
      description = "Use a minimal nvim configuration suitable for servers.";
    };

    minimal = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Minimal nvim without heavy UI, most LSPs, and non-essential plugins.";
    };

    groups = lib.mapAttrs (name: default: lib.mkOption {
      type = lib.types.bool;
      inherit default;
      description = "Enable the ${name} nixvim plugin group.";
    }) groupDefaults;

    plugins = lib.mkOption {
      type = lib.types.attrsOf lib.types.bool;
      default = { };
      description = "Per-plugin nixvim enable overrides (e.g. `{ snacks = false; }`).";
    };

    lspServers = lib.mkOption {
      type = lib.types.attrsOf lib.types.bool;
      default = { };
      description = "Per-LSP-server enable overrides (e.g. `{ pyright = false; }`).";
    };

    servers = {
      ansiblels = lib.mkEnableOption "ansiblels language server";
    };
  };

  config = lib.mkIf cfg.enable {
    workstation.nixvim.minimal = lib.mkDefault cfg.server;

    workstation.nixvim.groups = lib.mkIf cfg.minimal (
      lib.genAttrs minimalDisabledGroups (_: lib.mkDefault false)
    );

    workstation.nixvim.plugins = lib.mkIf cfg.minimal (
      lib.genAttrs minimalDisabledPlugins (_: lib.mkDefault false)
    );

    workstation.nixvim.lspServers = lib.mkIf cfg.minimal (
      lib.genAttrs minimalDisabledLspServers (_: lib.mkDefault false)
    );

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

    programs.nixvim = lib.mkMerge [
      {
        enable = true;
        viAlias = true;
        vimAlias = true;

        nixpkgs = {
          config.allowUnfree = true;
          source = inputs.nixpkgs-unstable;
        };

        imports =
          [
            ./config
            ./config/plugins/core
          ]
          ++ lib.concatMap (
            name: lib.optional cfg.groups.${name} groupPaths.${name}
          ) groupOrder
          ++ lib.optionals (!cfg.minimal) [
            ./config/plugins/lsp/devenv.nix
          ]
          ++ lib.optionals cfg.servers.ansiblels [
            ./config/plugins/lang/ansible.nix
          ];

        plugins = lib.mapAttrs (name: enabled: {
          enable = lib.mkForce enabled;
        }) cfg.plugins;

        lsp.servers = lib.mapAttrs (name: enabled: {
          enable = lib.mkForce enabled;
        }) cfg.lspServers;
      }
      (lib.mkIf cfg.minimal {
        version.enableNixpkgsReleaseCheck = false;
        colorschemes.catppuccin.enable = lib.mkForce false;
      })
    ];
  };
}
