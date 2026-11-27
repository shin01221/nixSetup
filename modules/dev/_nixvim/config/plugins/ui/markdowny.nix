{ pkgs, ... }:
let
  markdowny = pkgs.vimUtils.buildVimPlugin {
    name = "markdowny-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "antonk52";
      repo = "markdowny.nvim";
      rev = "main";
      sha256 = "sha256-f0cmEi68q4aB42WIm7nKMMwcc6KH3PXmdB3U53FdahI=";
    };
  };
in
{
  extraPlugins = [ markdowny ];
}
