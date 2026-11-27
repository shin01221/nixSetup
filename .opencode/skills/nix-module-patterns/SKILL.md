---
name: Nix Module Patterns
description: Workflow for adding or changing NixOS and Home Manager features in this flake-parts + import-tree repository. Load before editing modules/, home/, devices/, or flake inputs.
---

# Nix Module Patterns

This repository is flake-parts with `import-tree`. Every feature is a flake
module, and hosts select features by name. Follow the existing pattern instead
of adding central import lists or toggle files.

## Before you start

Read at least one example of the kind of change you are making:

- `modules/system/memory.nix` — minimal NixOS feature; config applies when selected.
- `modules/dev/yazi.nix` — NixOS feature enabling a program.
- `modules/system/baseline.nix` — large workstation baseline with sub-options.
- `modules/server/baseline.nix` — server-side option tree.
- `modules/packages/dev.nix` — package-only feature.
- `home/scripts.nix` — Home Manager feature reading `hostFeatures`.
- `home/common.nix` — always-imported Home Manager baseline.
- `devices/laptop/shin/default.nix` — how a host selects features.
- `modules/flake/_mk-host.nix` — NixOS host builder; passes `hostFeatures`/`isServer`.
- `modules/flake/_mk-home.nix` — standalone Home Manager builder.

Also read `AGENTS.md` for the architecture and editing rules.

## Add a NixOS feature

1. Create `modules/<domain>/<name>.nix` and wrap the module in
   `flake.modules.nixos.<name>`:

```nix
{ ... }:
{
  flake.modules.nixos.<name> =
    { config, lib, pkgs, ... }:
    {
      # NixOS configuration
    };
}
```

2. Add `"<name>"` to `nixosFeatures` in the host's
   `devices/<type>/<host>/default.nix`. The module applies its config whenever
   the name is selected.

3. Keep sub-options that configure behavior (for example
   `mount.games.enable` or `network.torProxy.enable`). Do not add a top-level
   `workstation.<name>.enable` gate. The nixvim wrapper
   (`modules/dev/nixvim.nix`) is the exception: it sets
   `workstation.nixvim.enable = true` when its feature is selected.

4. For server-only features, use `options.server.<name>` and add the feature
   name to the server host's `nixosFeatures`. Use the `isServer` special arg for
   server-specific defaults; `server-baseline` is selected by name, not by
   enabling `server.baseline.enable`.

## Add a Home Manager feature

Home Manager features are selected by the separate `homeFeatures` list. There is
no separate `workstation.home.*` toggle.

1. Create `home/<name>.nix` and wrap the module in
   `flake.modules.homeManager.<name>`:

```nix
{ ... }:
{
  flake.modules.homeManager.<name> =
    { config, pkgs, hostFeatures, isServer, ... }:
    {
      # home.packages = ...;
    };
}
```

2. Add `"<name>"` to `homeFeatures` in the host's `default.nix`. If the same
   name also has a NixOS half and both should apply, add it to `nixosFeatures`
   too. `hostFeatures` is the union used for conditional checks.

3. `homeModules.common` is always imported; do not add `"common"` to a host.

Home Manager is standalone and cannot read NixOS config. Prefer
`hostFeatures`/`isServer` when selecting behavior; NixOS cannot read Home
Manager config either.

## Feature names and import-tree

- Feature names are global within their side. Reuse the same name for the
  NixOS and Home Manager halves of one feature.
- `import-tree` recursively imports `./modules` and `./home`; no central
  `default.nix` list exists.
- Paths containing a `_` component are ignored by `import-tree`. Use `_` for
  implementation details (`modules/dev/_nixvim/`, `home/_zen/`,
  `modules/flake/_mk-host.nix`, `modules/flake/_mk-home.nix`).
- `devices/` is filtered to `default.nix`, so `host.nix` and
  `hardware-configuration.nix` are plain modules passed via `extraModules`.

## Accessing flake inputs

`mkHost` and `mkHome` pass `inputs`, `userName`, `homeDir`, `hostName`, `self`,
`hostFeatures`, and `isServer` through `specialArgs`/`extraSpecialArgs`, so
modules receive them as arguments:

```nix
{ pkgs, inputs, ... }:
inputs.kopuz.packages.${pkgs.stdenv.hostPlatform.system}.default
```

When adding a new input, make it follow the channel whose package set the
module actually uses:

```nix
# Module uses the host's default (stable) pkgs
inputs.<name>.inputs.nixpkgs.follows = "nixpkgs-stable";

# Module uses pkgsUnstable / pkgs.unstable
inputs.<name>.inputs.nixpkgs.follows = "nixpkgs-unstable";
```

The existing inputs are mixed, so match the neighbouring input. Do not add a
second nixpkgs for a single app.

## Defaults and overrides

Use `lib.mkDefault` on leaf values so a host can override one value without
redefining the rest:

```nix
# Right — each value is independently overridable
layout.gaps = lib.mkDefault 8;
layout.border.width = lib.mkDefault 2;

# Wrong — overriding gaps forces the host to redefine border.width too
layout = lib.mkDefault { gaps = 8; border.width = 2; };
```

Never hardcode `/home/shin`. Use `userName`/`homeDir` from NixOS `specialArgs`
and Home Manager `extraSpecialArgs`, or `config.home.homeDirectory` inside Home
Manager.

## Hardware and host-only values

Disks, UUIDs, monitor names, bus IDs, and device workarounds belong in
`devices/<type>/<host>/`, never in `modules/`. `modules/` must stay reusable.

## Validate

Stage new or renamed files first; flakes only see the git tree:

```bash
git add -A
nix flake check
nixos-rebuild build --flake .#shin
```

For Home Manager changes, also build the standalone activation package:

```bash
nix build .#homeConfigurations.shin.activationPackage
```

For generated expressions, parse before evaluating:

```bash
nix-instantiate --parse --expr '<expr>'
nix-instantiate --eval --json --strict --expr '<expr>'
```

Do not run `sudo nixos-rebuild switch`/`boot` or `home-manager switch`; hand the
exact command to the user.
