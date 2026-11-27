{ pkgs, ... }: {
  extraPlugins = with pkgs.vimPlugins; [
    vim-markdown-toc
  ];
}
