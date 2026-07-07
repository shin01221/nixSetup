{ ... }: {
  imports = [
    ./hardware-configuration.nix
    # ./disko.nix  # uncomment when disko config is ready
  ];

  networking.hostName = "node1";

  users.users.node1 = {
    isNormalUser = true;
    group = "node1";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [ ];
  };

  users.groups.node1 = { };

  workstation = {
    home = {
      tmux.enable = true;
      fish = true;
    };
    nixvim.enable = true;
  };

  system.stateVersion = "25.05";
}
