{ pkgs, ... }: {
  extraPlugins = with pkgs.vimPlugins; [
    transparent-nvim
  ];

  extraConfigLua = ''
    require("transparent").setup({
      extra_groups = {
        "NormalFloat",
        "NvimTreeNormal",
      },
    })
  '';
}
