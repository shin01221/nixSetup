# NixOS configuration

Personal NixOS configuration for two hosts:

- `shin` — laptop/workstation, nixpkgs-stable with an `unstable` overlay.
- `node1` — server, nixpkgs-stable with disko and agenix.

The flake attribute is the host key (`.#shin`, `.#node1`). This is not always the
same as `networking.hostName`; for example, `shin` sets `hostName = "nixos"`.

## Repo structure

- `flake.nix` — flake-parts entry point. It imports
  `flake-parts.flakeModules.modules`,
  `home-managerS.flakeModules.home-manager`, and uses `import-tree` over
  `./modules`, `./home`, and `./devices`.
- `modules/<domain>/<name>.nix` — NixOS features, defined as
  `flake.modules.nixos.<name>`.
- `home/<name>.nix` — Home Manager features, defined as
  `flake.modules.homeManager.<name>`.
- `devices/<type>/<host>/default.nix` — host entry point. It defines separate
  `nixosFeatures` and `homeFeatures` lists and passes them to `mkHost` and
  `mkHome`.
- `devices/<type>/<host>/host.nix` — host-specific plain NixOS module.
- `config/` — raw dotfiles deployed by Home Manager.
- Files and directories prefixed with `_` are ignored by `import-tree` and are
  implementation details.

## How the host builders work

`modules/flake/_mk-host.nix` builds `flake.nixosConfigurations.<host>`, and
`modules/flake/_mk-home.nix` builds `flake.homeConfigurations.<host>`. A host
defines separate lists and passes the union as `hostFeatures`:

```nix
let
  mkHost = import ../../../modules/flake/_mk-host.nix { inherit inputs; };
  mkHome = import ../../../modules/flake/_mk-home.nix { inherit inputs; };

  nixosFeatures = [ "baseline" "tools" "dev" "nixvim" ];
  homeFeatures = [ "fish" "tmux" ];
  hostFeatures = nixosFeatures ++ homeFeatures;
in
{
  flake.nixosConfigurations.shin = mkHost {
    hostName = "nixos";
    userName = "shin";
    withUnstable = true;
    nixosModules = config.flake.modules.nixos;
    inherit nixosFeatures hostFeatures;
    extraModules = [ ./hardware-configuration.nix ./host.nix ];
  };

  flake.homeConfigurations.shin = mkHome {
    hostName = "nixos";
    userName = "shin";
    withUnstable = true;
    homeModules = config.flake.modules.homeManager;
    inherit homeFeatures hostFeatures;
  };
}
```

`mkHost` selects only `nixosFeatures`; `mkHome` selects only `homeFeatures`.
A name that exists in both attrsets is not enabled twice by accident. Add a
name to both lists only when both halves should apply. `hostFeatures` is the
union used for conditional checks, such as a Home Manager module checking for a
NixOS-only feature.

`mkHost` calls `inputs.nixpkgs-stable.lib.nixosSystem` with the selected NixOS
modules plus `extraModules`. `mkHome` calls
`inputs.home-managerS.lib.homeManagerConfiguration` with a stable `pkgs` (plus
the `unstable` overlay when `withUnstable = true`), always imports
`homeModules.common`, and adds the selected Home Manager features plus
`extraModules`.

Both builders pass `inputs`, `userName`, `homeDir`, `hostName`, `self`,
`hostFeatures`, and `isServer` to their modules. `isServer` is true when
`"server-baseline"` is in `hostFeatures`.

Home Manager is standalone: apply NixOS with `nh os switch .#shin` and Home
Manager with `nh home switch .#shin`.

## Adding a new module and feature

### NixOS module

Create `modules/<domain>/<name>.nix`:

```nix
{ ... }:
{
  flake.modules.nixos.example =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.hello ];
    };
}
```

Then add `"example"` to `nixosFeatures` in
`devices/<type>/<host>/default.nix`:

```nix
nixosFeatures = [
  "baseline"
  "example"
];
```

### Home Manager module

Create `home/<name>.nix`:

```nix
{ ... }:
{
  flake.modules.homeManager.example =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.hello ];
    };
}
```

Add the name to `homeFeatures` in the host's `default.nix`. If a NixOS module and
a Home Manager module share the name `example`, add it to both lists when both
halves should apply.

Home Manager is standalone and cannot read NixOS config. Modules receive
`hostFeatures`, `isServer`, `userName`, `homeDir`, `hostName`, `inputs`, and
`self`; use those instead. Host-only Home Manager modules can be passed through
`extraModules` in the `mkHome` call.

## Nixvim and server hosts

Nixvim is wrapped by `modules/dev/nixvim.nix`, which imports
`modules/dev/_nixvim` and sets `workstation.nixvim.enable = true` when the
`"nixvim"` feature is selected.

The useful options are:

- `workstation.nixvim.groups` — enable or disable whole plugin groups.
- `workstation.nixvim.plugins` — per-plugin overrides.
- `workstation.nixvim.lspServers` — per-LSP overrides.
- `workstation.nixvim.server` — use the server preset.
- `workstation.nixvim.minimal` — strip heavy UI, most LSPs, and non-essential
  plugins.
- `workstation.nixvim.servers.ansiblels` — enable the Ansible LSP.

On a host with `"server-baseline"` in `hostFeatures`:

- `isServer` is `true`.
- `workstation.nixvim.server` defaults to `isServer`.
- `workstation.nixvim.minimal` defaults to `server`.

So a server host gets the minimal nvim configuration automatically. To force the
minimal preset on a non-server host, set `workstation.nixvim.server = true;` or
`workstation.nixvim.minimal = true;`.

## Example server host

Create `devices/server/example/default.nix`:

```nix
{ inputs, config, ... }:
let
  mkHost = import ../../../modules/flake/_mk-host.nix { inherit inputs; };
  mkHome = import ../../../modules/flake/_mk-home.nix { inherit inputs; };

  nixosFeatures = [
    "server-baseline"
    "nixvim"
  ];

  homeFeatures = [
    "tmux"
    "fish"
  ];

  hostFeatures = nixosFeatures ++ homeFeatures;
in
{
  flake.nixosConfigurations.example = mkHost {
    hostName = "example";
    userName = "example";
    nixosModules = config.flake.modules.nixos;
    inherit nixosFeatures hostFeatures;
    extraModules = [
      ./hardware-configuration.nix
      ./host.nix
    ];
  };

  flake.homeConfigurations.example = mkHome {
    hostName = "example";
    userName = "example";
    homeModules = config.flake.modules.homeManager;
    inherit homeFeatures hostFeatures;
  };
}
```

Create `devices/server/example/host.nix`:

```nix
{ ... }:
{
  server.baseline.userName = "example";

  # Minimal nvim is automatic because "server-baseline" is selected.
  # Optional extras:
  workstation.nixvim.servers.ansiblels = true;

  system.stateVersion = "25.05";
}
```

## Commands

```bash
# Evaluate the flake
nix flake check

# Build a host without activating it
nixos-rebuild build --flake .#shin
nixos-rebuild build --flake .#node1

# Apply NixOS — these need root
nh os switch .#shin
nh os switch .#node1

# Build Home Manager without activating
nix build .#homeConfigurations.shin.activationPackage
nix build .#homeConfigurations.node1.activationPackage

# Apply Home Manager
nh home switch .#shin
nh home switch .#node1
```

Without `nh`, use `sudo nixos-rebuild switch --flake .#shin` and
`home-manager switch --flake .#shin`.

If `home-manager` is not on `PATH`, bootstrap with
`nix run github:nix-community/home-manager/release-26.05 -- switch --flake .#shin`.
Use `-b backup` (or `HOME_MANAGER_BACKUP_EXT=backup`) when existing files block
activation.
