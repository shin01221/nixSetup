{ ... }:
{
  flake.modules.nixos.dev =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        python3
        uv
        devenv
        ansible
        minikube
        kubectl
      ];
    };
}
