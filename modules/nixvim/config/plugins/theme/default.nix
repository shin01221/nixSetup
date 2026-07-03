{ pkgs, ... }:
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
