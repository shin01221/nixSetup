{ pkgs, ... }: {
  extraPlugins = with pkgs.vimPlugins; [
    markdoc-nvim
  ];
}
