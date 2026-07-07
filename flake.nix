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

    # flatpaks.url = "github:in-a-dil-emma/declarative-flatpak/latest";

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
      disko,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      libU = nixpkgs-unstable.lib;
      libS = nixpkgs-stable.lib;

      mkWorkstation =
        {
          deviceModule,
          userName ? "shin",
        }:
        let
          homeDir = "/home/${userName}";
        in
        libU.nixosSystem {
          inherit system;
          specialArgs = {
            inherit
              self
              inputs
              userName
              homeDir
              ;
          };
          modules = [
            deviceModule
            home-managerU.nixosModules.home-manager
            agenix.nixosModules.default
            {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  backupFileExtension = "backup";
                  extraSpecialArgs = {
                    inherit
                      self
                      inputs
                      userName
                      homeDir
                      ;
                  };
                  sharedModules = [
                    (
                      { osConfig, ... }:
                      {
                        _module.args = {
                          hostName = osConfig.networking.hostName;
                          isServer = osConfig.server.baseline.enable or false;
                        };
                      }
                    )
                  ];
                users.${userName} = {
                  imports = [ ./home ];
                };
              };
            }
          ];
        };

      mkServer =
        { deviceModule, userName ? "shin" }:
        let
          homeDir = "/home/${userName}";
        in
        libS.nixosSystem {
          inherit system;
          specialArgs = {
            inherit self inputs;
          };
          modules = [
            deviceModule
            disko.nixosModules.disko
            agenix.nixosModules.default
            ./modules/baseline.server.nix
            ./modules/home-options.nix
            ./modules/nixvim
            ./modules/ssh.nix
            home-managerS.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = {
                  inherit self inputs userName homeDir;
                };
                sharedModules = [
                  (
                    { osConfig, ... }:
                    {
                      _module.args = {
                        hostName = osConfig.networking.hostName;
                        isServer = osConfig.server.baseline.enable or false;
                      };
                    }
                  )
                ];
                users.${userName} = {
                  imports = [ ./home ];
                };
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        shin = mkWorkstation {
          deviceModule = ./devices/laptop/shin/default.nix;
          userName = "shin";
        };
        node1 = mkServer {
          deviceModule = ./devices/server/node1/default.nix;
          userName = "node1";
        };
      };
    };
}
