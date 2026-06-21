{ pkgs, ... }: {
  extraPlugins = with pkgs.vimPlugins; [
    markdown-preview-nvim
  ];

  extraConfigLua = ''
    vim.g.mkdp_filetypes = { "markdown" }
  '';
}
