{ pkgs, ... }: {
  extraPlugins = with pkgs.vimPlugins; [
    tiny-inline-diagnostic-nvim
  ];

  extraConfigLua = ''
    require("tiny-inline-diagnostic").setup({ preset = "modern" })
    vim.diagnostic.config({ virtual_text = false })
  '';
}
