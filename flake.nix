{
  description = "The whole kit n kaboodle";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:denful/import-tree";

    home-managerU = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-managerS = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell/cachix";
    };

    luciole = {
      url = "github:noctalia-dev/luciole/cachix";
    };

    umbriel = {
      url = "github:noctalia-dev/umbriel/cachix";
    };

    kopuz.url = "github:Kopuz-org/kopuz";

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

    tuios = {
      url = "github:Gaurav-Gosain/tuios";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    wayscrollshot.url = "github:jswysnemc/wayscrollshot";

    zapfast = {
      url = "github:crmne/zapfast";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    wlr-which-key-patched = {
      url = "github:shin01221/wlr-which-key/flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.flake-parts.flakeModules.modules
        inputs.home-managerS.flakeModules.home-manager
        (inputs.import-tree ./modules)
        (inputs.import-tree ./home)
        (inputs.import-tree.filter (path: builtins.baseNameOf path == "default.nix") ./devices)
      ];
    };
}
