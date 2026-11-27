{ ... }:
{
  flake.modules.nixos.k3s-agent =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.cluster.k3sAgent = {
        serverAddr = lib.mkOption {
          type = lib.types.str;
          description = "Address of the k3s server";
        };
      };

      config = {
        networking.firewall.allowedUDPPorts = [ 8472 ]; # Flannel

        services.tailscale.authKeyFile = "/run/secrets/k3s-ts-auth";

        services.k3s = {
          enable = true;
          role = "agent";
          tokenFile = "/run/secrets/k3s-token";
          serverAddr = config.cluster.k3sAgent.serverAddr;
          gracefulNodeShutdown.enable = true;
        };

        age.secrets."k3s-token.age" = {
          file = ../../secrets/k3s-token.age;
          path = "/run/secrets/k3s-token";
          owner = "root";
          group = "root";
          mode = "0400";
        };

        age.secrets."k3s-ts-auth.age" = {
          file = ../../secrets/k3s-ts-auth.age;
          path = "/run/secrets/k3s-ts-auth";
          owner = "root";
          group = "root";
          mode = "0400";
        };
      };
    };
}
