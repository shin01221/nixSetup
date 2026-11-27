{ ... }:
{
  server.baseline.userName = "node1";

  workstation.nixvim = {
    servers.ansiblels = true;
  };

  system.stateVersion = "25.05";
}
