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
