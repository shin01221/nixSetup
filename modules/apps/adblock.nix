{ ... }:
{
  flake.modules.nixos.adblock =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      networking.hosts = {
        "0.0.0.0" = [
          "doubleclick.net"
          "ad.doubleclick.net"
          "googleadservices.com"
          "googlesyndication.com"
          "adservice.google.com"
          "pagead2.googlesyndication.com"
          "pagead2.googlesyndication.com"
        ];
      };
    }
  ;
}
