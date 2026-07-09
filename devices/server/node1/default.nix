{ ... }: {
  imports = [
    ./hardware-configuration.nix
    # ./disko.nix  # uncomment when disko config is ready
  ];

  networking.hostName = "node1";

  server.baseline = {
    enable = true;
    userName = "node1";
  };

  workstation = {
    home = {
      tmux.enable = true;
      fish = true;
    };
    nixvim.enable = true;
  };

  system.stateVersion = "25.05";
}
