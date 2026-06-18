{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.workstation.adblock;
in
{
  options.workstation.adblock.enable = lib.mkEnableOption "DNS-level adblocking via custom hosts";

  config = lib.mkIf cfg.enable {
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
  };
}
