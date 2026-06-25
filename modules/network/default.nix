{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.workstation.network;
in
{
  options.workstation.network = {
    enable = lib.mkEnableOption "Centralized firewall and networking configuration";
    torProxy = {
      enable = lib.mkEnableOption "Tor SOCKS5 proxy for proxying select sites";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [
        22
        80
        443
        8080
      ];
    };

    environment.systemPackages = with pkgs; [ networkmanagerapplet ];

    services.tor = lib.mkIf cfg.torProxy.enable {
      enable = true;
      client.enable = true;
    };
  };
}
