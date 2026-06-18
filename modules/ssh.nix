{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.workstation.ssh;
  userName = if config.workstation ? baseline then config.workstation.baseline.userName else cfg.userName;
in
{
  options.workstation.ssh = {
    enable = lib.mkEnableOption "Default SSH configuration";
    userName = lib.mkOption {
      type = lib.types.str;
      default = "gumbo";
      description = "SSH user account name";
    };
  };
  config = lib.mkIf cfg.enable {
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
}
