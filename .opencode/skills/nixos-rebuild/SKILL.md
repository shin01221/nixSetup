---
name: NixOS Rebuild
description: Safe validation and rebuild workflow for this repository's shin and node1 hosts. Load before running nix flake check, nixos-rebuild, or Home Manager activation checks.
---

# NixOS Rebuild

## Hosts

| Flake attribute | Host | Channel | Notes |
| --- | --- | --- | --- |
| `.#shin` | laptop/workstation | nixpkgs-stable 26.05 + `pkgsUnstable` overlay | standalone Home Manager, agenix |
| `.#node1` | server | nixpkgs-stable 26.05 | disko + agenix, `server.baseline` |

The flake attribute is the host key, not `networking.hostName`. The laptop sets
`networking.hostName = "nixos"` but must still be built as `.#shin`.

## Safe order

Run the narrowest check that proves the change, then stop before activation.

1. Evaluation only (fastest, catches option/type errors):

```bash
nix flake check
```

2. Build the host without activating (no root needed):

```bash
nixos-rebuild build --flake .#shin
nixos-rebuild build --flake .#node1
```

3. If Home Manager modules changed, build the standalone activation package:

```bash
nix build .#homeConfigurations.shin.activationPackage
nix build .#homeConfigurations.node1.activationPackage
```

4. Give the user the exact apply commands to run in their own terminal:

```bash
sudo nixos-rebuild switch --flake .#shin
sudo nixos-rebuild boot --flake .#shin
sudo nixos-rebuild switch --flake .#node1

home-manager switch --flake .#shin
home-manager switch --flake .#node1
```

Do not run `sudo`, type a password, ask for a password, or pipe credentials.
Use `build` or `dry-build` for non-root validation; leave `dry-activate`,
`switch`, and `boot` to the user. Hand `home-manager switch` to the user as well.
Use `-b backup` (or `HOME_MANAGER_BACKUP_EXT=backup`) if activation reports
existing files.

## Quick evaluation without a full build

To check that an option exists or inspect a value:

```bash
nix eval .#nixosConfigurations.shin.config.<option.path>
nix eval --json .#nixosConfigurations.shin.config.<option.path>
```

To check only the derivation path evaluates:

```bash
nix eval .#nixosConfigurations.shin.config.system.build.toplevel.drvPath
```

## Common failure modes

- **Wrong attribute**: `.#nixos` or `.#shin-niri` do not exist. Only `.#shin`
  and `.#node1` are defined.
- **Unfree package**: `modules/system/baseline.nix` sets
  `nixpkgs.config.allowUnfree = true` for workstations, and
  `modules/server/baseline.nix` does the same for the server. `mkHost` and
  `mkHome` with `withUnstable = true` also import `pkgsUnstable` with
  `allowUnfree = true`. A new host that does not enable a baseline will fail on
  unfree packages.
- **Not staged**: new or renamed files are invisible to Nix until added to the
  git index. Run `git add -A` before `nix flake check`/`nixos-rebuild build`.
- **agenix**: evaluation does not need the decrypted secrets, but activation
  does. Do not try to read or print secrets to fix an evaluation error.
- **Missing hardware module**: `devices/<host>/hardware-configuration.nix` is
  machine-specific. Do not copy it between hosts.
- **Feature not wired**: add the feature name to `nixosFeatures` or
  `homeFeatures` on the host. Feature modules apply their config directly; there
  is no `featureEnablePaths` mapping to update.
- **No cross-system reads**: NixOS cannot read Home Manager config, and
  standalone Home Manager cannot read NixOS config. Use `hostFeatures`/`isServer`
  or pass values through the builders' special args.
- **`unknown flake output 'modules'`**: expected with flake-parts; harmless.

## After a successful build

Report which host and check was run, and whether the change was only evaluated,
built, or applied. Never claim a switch happened unless the user ran it and
reported success.
