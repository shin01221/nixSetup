{ ... }:
{
  flake.modules.nixos.network =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.workstation.network = {
        torProxy = {
          enable = lib.mkEnableOption "Tor SOCKS5 proxy for proxying select sites";
        };
      };

      config = {
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

        services.tor = lib.mkIf config.workstation.network.torProxy.enable {
          enable = true;
          client.enable = true;
        };
      };
    };
}
