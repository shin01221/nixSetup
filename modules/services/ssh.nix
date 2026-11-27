{ ... }:
{
  flake.modules.nixos.ssh =
    {
      config,
      lib,
      pkgs,
      inputs,
      ...
    }:
    let
      userName =
        if config.workstation ? baseline then
          config.workstation.baseline.userName
        else
          config.workstation.ssh.userName;
    in
    {
      options.workstation.ssh = {
        userName = lib.mkOption {
          type = lib.types.str;
          default = "shin";
          description = "SSH user account name";
        };
      };
      config = {
        services.openssh = {
          enable = true;
          ports = [ 22 ];
          settings = {
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = false;
            PermitRootLogin = "no";
            AllowUsers = [ userName ];
          };
        };

        networking.firewall.allowedTCPPorts = [ 22 ];
      };
    };
}
