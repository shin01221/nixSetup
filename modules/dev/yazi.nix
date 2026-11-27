{ ... }:
{
  flake.modules.nixos.yazi =
    {
      config,
      lib,
      pkgs,
      inputs,
      ...
    }:
    {
      programs.yazi = {
        enable = true;
        settings = {
          yazi = {
            ratio = [
              1
              4
              3
            ];
            sort-by = "natural";
            sort-sensitive = true;
            sort-reverse = false;
            sort-dir-first = true;
            linemode = "none";
            show-hidden = "show";
            show-symlink = "show";
          };
        };
      };
    };
}
