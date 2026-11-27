# Operator notes

Durable, non-obvious knowledge for this repository. `/learn` appends new
sections here; `/evolve` reviews them. Keep secrets out of this file.

## 2026-11-27 — Flake-parts + import-tree migration

- **Finding:** The repo was migrated from `mkWorkstation`/`mkServer` and central
  import lists to flake-parts + `import-tree`. NixOS features are
  `flake.modules.nixos.<name>`, Home Manager features are
  `flake.modules.homeManager.<name>`, and hosts select them by name.
- **Why it matters:** There is no `modules/default.nix`, `home/default.nix`, or
  `modules/home-options.nix`; adding a file is not enough unless its feature name
  is in the host's `features` list.
- **Prescription:** Follow `.opencode/skills/nix-module-patterns/SKILL.md`. Use
  the `neolectron-nixfiles` reference for ideas, but this repo's paths and
  feature-list selection are authoritative.

## 2026-11-27 — Flake attribute vs hostname

- **Finding:** The laptop builds as `.#shin` but sets
  `networking.hostName = "nixos"`.
- **Why it matters:** `nixos-rebuild --flake .#nixos` fails even though the
  running hostname is `nixos`.
- **Prescription:** Use `.#shin` for the laptop and `.#node1` for the server.

## 2026-11-27 — Two nixpkgs channels

- **Finding:** Both hosts build on nixpkgs-stable 26.05 via `mkHost`. `shin`
  sets `withUnstable = true` and receives an extra `pkgsUnstable` exposed as
  `pkgs.unstable`; `node1` leaves it false.
- **Why it matters:** Referencing `pkgsUnstable` in a server module fails
  evaluation, and assuming `shin` uses unstable `pkgs` is wrong.
- **Prescription:** Check `withUnstable` in the host's `default.nix` before using
  `pkgsUnstable`. Add new inputs with `inputs.<name>.inputs.nixpkgs.follows` set
  to the channel the module actually consumes.

## 2026-11-27 — Features are selected by name

- **Finding:** `devices/<type>/<host>/default.nix` passes a `features` list to
  `mkHost`. The list selects both `flake.modules.nixos.<name>` and
  `flake.modules.homeManager.<name>`; `homeModules.common` is always imported.
  `mkHost` also passes `hostFeatures` and `isServer` to both module systems.
- **Why it matters:** Adding a feature file without listing its name does
  nothing. Feature modules apply their config directly, so there is no
  `featureEnablePaths` mapping to update. The nixvim wrapper
  (`modules/dev/nixvim.nix`) sets `workstation.nixvim.enable = true` when its
  feature is selected.
- **Prescription:** Add the file and add the name to the host's `features`. Use
  `hostFeatures` in Home Manager modules and `isServer` for server defaults.

## 2026-11-27 — Stage new files before evaluating

- **Finding:** Nix flakes evaluate the git tree, so untracked new files are
  invisible. The first `nix flake check` after the migration failed until the
  new modules were `git add`ed.
- **Why it matters:** `nix flake check`/`nixos-rebuild build` can fail with
  "path does not exist" even though the file is on disk.
- **Prescription:** Run `git add -A` (staging is not committing) before
  evaluating. Use `git status` to confirm the new files are staged.

## 2026-11-27 — import-tree ignores underscore paths

- **Finding:** `import-tree` skips any path containing a `_` component.
  `modules/flake/_mk-host.nix`, `modules/dev/_nixvim/`, and
  `modules/apps/_zen/` are therefore imported explicitly or via wrappers, not by
  the tree walk.
- **Why it matters:** Moving a file under a `_` directory silently removes it
  from the flake unless a wrapper imports it.
- **Prescription:** Keep implementation details under `_`; expose them through a
  non-underscore wrapper (`modules/dev/nixvim.nix`, `modules/apps/zen.nix`) or an
  explicit import.

## 2026-11-27 — Do not run home-manager switch

- **Finding:** This flake has no standalone `homeConfigurations`; Home Manager
  is a NixOS module.
- **Why it matters:** `home-manager switch` targets a different profile and
  desynchronizes the user environment.
- **Prescription:** Apply through `nixos-rebuild` or the integrated activation
  package only.

## 2026-11-27 — nixvim plugin groups and server preset

- **Finding:** `modules/dev/_nixvim/default.nix` exposes
  `workstation.nixvim.groups` (one toggle per
  `config/plugins/<group>/default.nix`), `workstation.nixvim.plugins`, and
  `workstation.nixvim.lspServers` for per-item overrides.
  `workstation.nixvim.server` defaults to `server.baseline.enable` and makes
  `minimal` default to true; `minimal` disables heavy groups, extra blink
  sources, and non-essential LSPs.
- **Why it matters:** Adding a plugin file does nothing unless its group index
  imports it, and adding a new group requires updating both `groupPaths` and
  `groupDefaults` in the main module.
- **Prescription:** Put new plugin files in the right
  `config/plugins/<group>/` and add them to that group's `default.nix`. Use
  `groups` for whole features and `plugins`/`lspServers` for one-off overrides.
  Server hosts can rely on `server = true` (or set `minimal = true` directly).
