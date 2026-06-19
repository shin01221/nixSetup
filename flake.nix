{
  description = "The whole kit n kaboodle";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    home-managerU = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-managerS = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell/";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    flatpaks.url = "github:in-a-dil-emma/declarative-flatpak/latest";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs-stable";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    betterfox = {
      url = "github:yokoffing/Betterfox";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs-unstable,
      nixpkgs-stable,
      home-managerU,
      home-managerS,
      noctalia,
      agenix,
      nixvim,
      flatpaks,
      disko,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      libU = nixpkgs-unstable.lib;
      libS = nixpkgs-stable.lib;

      mkWorkstation =
        { deviceModule, hmImports, userName ? "gumbo" }:
        let
          homeDir = "/home/${userName}";
        in
        libU.nixosSystem {
          inherit system;
          specialArgs = { inherit self inputs userName homeDir; };
          modules = [
            deviceModule
            home-managerU.nixosModules.home-manager
            flatpaks.nixosModules.default
            agenix.nixosModules.default
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = { inherit self inputs userName homeDir; };
                sharedModules = [
                  (
                    { osConfig, ... }:
                    {
                      _module.args.hostName = osConfig.networking.hostName;
                    }
                  )
                ];
                users.${userName} = {
                  imports = hmImports;
                };
              };
            }
          ];
        };

      mkServer =
        { deviceModule, hmImports }:
        libS.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            deviceModule
            disko.nixosModules.disko
            agenix.nixosModules.default
            ./modules/baseline.server.nix
            ./modules/ssh.nix
            home-managerS.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = { inherit inputs; };
                sharedModules = [
                  (
                    { osConfig, ... }:
                    {
                      _module.args.hostName = osConfig.networking.hostName;
                    }
                  )
                ];
                users.gumbo = {
                  imports = hmImports;
                };
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        erebos = mkWorkstation {
          deviceModule = ./devices/desktop/erebos/default.nix;
          hmImports = [
            ./home/common.nix
            ./home/zsh.nix
            ./home/kde.nix
          ];
        };

        shin = mkWorkstation {
          deviceModule = ./devices/laptop/shin/default.nix;
          userName = "shin";
          hmImports = [
            ./home/common.nix
           # ./home/fish.nix
            ./home/theming.nix
            ./home/niri.nix
            ./home/dolphin
            ./home/audio.nix
            ./home/obs-studio.nix
            ./home/xdg.nix
          ];
        };

        null = mkWorkstation {
          deviceModule = ./devices/desktop/null/default.nix;
          hmImports = [
            ./home/common.nix
            ./home/zsh.nix
            ./home/kde.nix
          ];
        };

          seed = mkWorkstation {
          deviceModule = ./devices/server/vms/seed/default.nix;
          hmImports = [
            ./home/common.nix
            ./home/zsh.nix
            ./home/kde.nix
          ];
        };
        secret-mgmt = mkServer {
          deviceModule = ./devices/server/vms/secret-mgmt/default.nix;
          hmImports = [
            ./home/server.nix
            ./home/zsh.nix
          ];
        };
        k3s-a1 = mkServer {
          deviceModule = ./devices/server/vms/k3s-a1/default.nix;
          hmImports = [
            ./home/server.nix
            ./home/zsh.nix
          ];
        };
        k3s-a2 = mkServer {
          deviceModule = ./devices/server/vms/k3s-a2/default.nix;
          hmImports = [
            ./home/server.nix
            ./home/zsh.nix
          ];
        };
        k3s-a3 = mkServer {
          deviceModule = ./devices/server/vms/k3s-a3/default.nix;
          hmImports = [
            ./home/server.nix
            ./home/zsh.nix
          ];
        };
        k3s-a4 = mkServer {
          deviceModule = ./devices/server/vms/k3s-a4/default.nix;
          hmImports = [
            ./home/server.nix
            ./home/zsh.nix
          ];
        };
        k3s-s1 = mkServer {
          deviceModule = ./devices/server/vms/k3s-s1/default.nix;
          hmImports = [
            ./home/server.nix
            ./home/zsh.nix
          ];
        };
      };
    };
}
