{ pkgs, ... }:
let
  colorsaver = pkgs.vimUtils.buildVimPlugin {
    name = "colorsaver-nvim";
    src = pkgs.fetchFromSourcehut {
      owner = "~swaits";
      repo = "colorsaver.nvim";
      rev = "main";
      sha256 = "sha256-BEuQCqIND2fvog0CPj5XWYK6hwlt3oVBim94/qR/IWQ=";
    };
  };
in
{
  extraPlugins = [ colorsaver ];

  extraConfigLua = ''
    local colorsaver_path = vim.fn.stdpath("data") .. "/colorsaver"
    vim.fn.mkdir(vim.fn.stdpath("data"), "p")
    if vim.fn.isdirectory(colorsaver_path) == 1 then
      vim.fn.delete(colorsaver_path, "rf")
    end
    if vim.fn.filereadable(colorsaver_path) == 0 then
      vim.fn.writefile({ vim.g.colors_name or "catppuccin" }, colorsaver_path)
    end
    require("colorsaver").setup({})
  '';
}
