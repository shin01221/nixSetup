{ pkgs, ... }:
let
  cendre = pkgs.vimUtils.buildVimPlugin {
    name = "cendre";
    src = pkgs.fetchFromGitHub {
      owner = "Aejkatappaja";
      repo = "cendre";
      rev = "f62d04d09e126cbac944d87f852908303172654e";
      sha256 = "sha256-eW4lHrN2mRl/4omxZBqicFajMU/Vwwvc/7UhNBr5fg0=";
    };
  };
  github-monochrome = pkgs.vimUtils.buildVimPlugin {
    pname = "github-monochrome.nvim";
    version = "2026-09-26";
    src = pkgs.fetchFromGitHub {
      owner = "idr4n";
      repo = "github-monochrome.nvim";
      rev = "e77321ecd5a68f020d9c543592e222d7786169bf";
      hash = "sha256-2+ie8X+ssWuDzkW4QztsROA5eDiCIkQIGvTxUsibEK4=";
    };
  };
  monochrome = pkgs.vimUtils.buildVimPlugin {
    pname = "monochrome.nvim";
    version = "2026-09-26";
    src = pkgs.fetchFromGitHub {
      owner = "kdheepak";
      repo = "monochrome.nvim";
      rev = "2de78d9688ea4a177bcd9be554ab9192337d35ff";
      hash = "sha256-TgilR5jnos2YZeaJUuej35bQ9yE825MQk0s6gxwkAbA=";
    };
  };
in
{
  colorschemes.catppuccin = {
    enable = true;
    settings = {
      background = {
        light = "macchiato";
        dark = "mocha";
      };
      flavour = "macchiato";
      transparent_background = true;
      integrations = {
        cmp = true;
        flash = true;
        fidget = true;
        gitsigns = true;
        indent_blankline.enabled = true;
        lsp_trouble = true;
        mini.enabled = true;
        neotree = true;
        noice = true;
        notify = true;
        bufferline = true;
        telescope.enabled = true;
        treesitter = true;
        treesitter_context = true;
        which_key = true;
        native_lsp = {
          enable = true;
          inlay_hints = {
            background = true;
          };
          virtual_text = {
            errors = [ "italic" ];
            hints = [ "italic" ];
            information = [ "italic" ];
            warnings = [ "italic" ];
            ok = [ "italic" ];
          };
          underlines = {
            errors = [ "underline" ];
            hints = [ "underline" ];
            information = [ "underline" ];
            warnings = [ "underline" ];
          };
        };
      };
    };
  };

  extraPlugins = with pkgs.vimPlugins; [
    cendre
    github-monochrome
    monochrome
    gruvbox-nvim
    rose-pine
    tokyonight-nvim
    everforest
    onedarkpro-nvim
    nordic-nvim
    solarized-osaka-nvim
    dracula-nvim
    ayu-vim
    miasma-nvim
    oxocarbon-nvim
    kanagawa-nvim
    omni-vim
    kanagawa-paper-nvim
  ];
}
