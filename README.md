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
- `devices/<type>/<host>/default.nix` — host entry point. It calls `mkHost` and
  lists the features enabled on that host.
- `devices/<type>/<host>/host.nix` — host-specific plain NixOS module.
- `config/` — raw dotfiles deployed by Home Manager.
- Files and directories prefixed with `_` are ignored by `import-tree` and are
  implementation details.

## How `mkHost` works

`modules/flake/_mk-host.nix` is the shared host builder. A host passes:

```nix
mkHost {
  hostName = "nixos";
  userName = "shin";
  withUnstable = true;
  nixosModules = config.flake.modules.nixos;
  homeModules = config.flake.modules.homeManager;
  features = [ "baseline" "tools" "dev" "nixvim" "fish" ];
  extraModules = [ ./hardware-configuration.nix ./host.nix ];
}
```

It does three important things:

1. **Selects features by name.** `halves` walks the `features` list and looks up
   each name in `nixosModules` and `homeModules` independently:
   - if the name exists in `nixosModules`, that NixOS module is applied;
   - if it exists in `homeModules`, that Home Manager module is applied;
   - if it exists in both, both are applied.
2. **Builds the NixOS system.** It calls
   `inputs.nixpkgs-stable.lib.nixosSystem` with the selected NixOS modules plus
   `extraModules`.
3. **Builds Home Manager inside NixOS.** It imports
   `home-managerS.nixosModules.home-manager`, enables
   `useGlobalPkgs`/`useUserPackages`, and sets
   `home-manager.users.<user>.imports` to `homeModules.common` plus the selected
   Home Manager features. `homeModules.common` is always imported.

It also passes `inputs`, `userName`, `homeDir`, `hostName`, `self`,
`hostFeatures`, and `isServer` to both module systems. `isServer` is true when
`"server-baseline"` is in the feature list.

Because Home Manager is integrated into NixOS, do not run
`home-manager switch`. Use `nixos-rebuild switch` instead.

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

Then add `"example"` to the host's `features` list in
`devices/<type>/<host>/default.nix`:

```nix
features = [
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

Add the same feature name to the host's `features` list. If a NixOS module and a
Home Manager module share the name `example`, both are selected automatically.

Home Manager modules receive `hostFeatures`, `isServer`, `userName`, `homeDir`,
`hostName`, `inputs`, and `self`. Use those instead of reading NixOS `osConfig`.
Host-only Home Manager modules can be passed through `extraHomeModules`.

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

On a host with `"server-baseline"` in `features`:

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
in
{
  flake.nixosConfigurations.example = mkHost {
    hostName = "example";
    userName = "example";
    nixosModules = config.flake.modules.nixos;
    homeModules = config.flake.modules.homeManager;
    features = [
      "server-baseline"
      "nixvim"
      "tmux"
      "fish"
    ];
    extraModules = [
      ./hardware-configuration.nix
      ./host.nix
    ];
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

# Apply — these need root
sudo nixos-rebuild switch --flake .#shin
sudo nixos-rebuild switch --flake .#node1
```

To verify the Home Manager side builds:

```bash
nix build .#nixosConfigurations.shin.config.home-manager.users.shin.home.activationPackage
```
