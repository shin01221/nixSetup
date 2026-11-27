{ pkgs, ... }:
{
  lsp.servers = {
    ansiblels = {
      enable = true;
      package = pkgs.ansible-language-server;
    };
  };
}
