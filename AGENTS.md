# nixos

Personal NixOS configuration for two hosts:

- `shin` — laptop/workstation (`devices/laptop/shin/`), nixpkgs-stable (26.05)
  plus an `unstable` overlay (`pkgsUnstable`), integrated Home Manager.
- `node1` — server (`devices/server/node1/`), nixpkgs-stable, disko + agenix.

The flake attribute is the host key (`.#shin`, `.#node1`). Do not confuse it with
`networking.hostName`; the laptop sets `networking.hostName = "nixos"`.

## Architecture

- `flake.nix` is a flake-parts flake. It imports
  `flake-parts.flakeModules.modules` and
  `home-managerS.flakeModules.home-manager`, then uses `import-tree` over
  `./modules`, `./home`, and `./devices` (filtered to `default.nix`).
- Every feature is a flake module:
  - NixOS features are `flake.modules.nixos.<name>` in
    `modules/<domain>/<name>.nix`.
  - Home Manager features are `flake.modules.homeManager.<name>` in
    `home/<name>.nix`.
  - `modules/flake/_mk-host.nix` is the shared host builder. It is ignored by
    `import-tree` (the `_` prefix) and imported explicitly from each host file.
- `devices/<type>/<host>/default.nix` calls `mkHost` with the host key, hostname,
  user, `withUnstable`, and a `features` list. The feature list selects both the
  NixOS and Home Manager modules; a name present in both attrsets is used by both.
  `mkHost` passes `hostFeatures` and `isServer` to both module systems.
- `homeModules.common` is always imported. Other Home Manager features come from
  the host's `features` list.
- `devices/<type>/<host>/host.nix` and `hardware-configuration.nix` are plain
  NixOS modules passed through `extraModules`; only `default.nix` is picked up by
  `import-tree`.
- Directories/files prefixed with `_` are ignored by `import-tree` and hold
  implementation details (`modules/dev/_nixvim/`, `modules/apps/_zen/`,
  `modules/flake/_mk-host.nix`).
- `config/` holds raw dotfiles deployed by Home Manager.
- nixvim is wrapped by `modules/dev/nixvim.nix` and implemented in
  `modules/dev/_nixvim/`. Toggle whole plugin groups with
  `workstation.nixvim.groups`, individual plugins with `.plugins`, LSP servers
  with `.lspServers`, and use `.server`/`.minimal` for the server preset.

## Commands

```bash
# Evaluate the flake without building (fastest Nix-level check)
nix flake check

# Build a host without activating it (safe, no root needed)
nixos-rebuild build --flake .#shin
nixos-rebuild build --flake .#node1

# Apply — these need root. Hand the exact command to the user to run.
sudo nixos-rebuild switch --flake .#shin
sudo nixos-rebuild boot --flake .#shin
sudo nixos-rebuild switch --flake .#node1
```

This repo uses NixOS-integrated Home Manager and has no standalone
`homeConfigurations`. Never run `home-manager switch`. To verify the HM side
builds, use:

```bash
nix build .#nixosConfigurations.shin.config.home-manager.users.shin.home.activationPackage
```

Agents may run `nix flake check`, `nix build`, `nix eval`, `nix-instantiate`, and
`nixos-rebuild build`/`dry-build` as the normal user. Do not type a sudo password,
ask the user for one, or pipe credentials through stdin. For `switch`/`boot`,
give the user the exact command to run in their own terminal.

## Editing rules

- One feature per module. A NixOS feature file wraps the module as
  `flake.modules.nixos.<name> = { config, lib, pkgs, ... }: { ... };`; a Home
  Manager feature file wraps it as `flake.modules.homeManager.<name> = ...`.
- Selecting a feature applies its config directly; do not gate the whole module
  behind a `workstation.*.enable`/`server.*.enable` option. Add the feature name
  to the host's `features` list. Keep sub-options that configure behavior (e.g.
  `mount.games.enable`, `network.torProxy.enable`) and the nixvim toggles
  (`workstation.nixvim.*`); `modules/dev/nixvim.nix` enables nixvim when the
  feature is selected.
- Home Manager modules should use the `hostFeatures` special arg instead of
  reading `osConfig`, and `isServer` for server-specific defaults.
- Use `lib.mkDefault` on leaf values (gaps, fonts, keybinds) so a device can
  override one value without redefining the rest. Never wrap a whole parent
  attrset in `mkDefault`.
- Never hardcode a home directory. Derive it from `homeDir`/`userName` (passed
  via `specialArgs`) or `config.home.homeDirectory`.
- Hardware values (disks, UUIDs, monitor names, device workarounds) belong in
  `devices/`, never in `modules/`.
- NixOS cannot read Home Manager config. Home Manager can read NixOS config via
  `osConfig` (already used in `home/scripts.nix`).
- When adding a flake input, make it follow the channel whose package set the
  module actually uses: `nixpkgs-stable` for the default host `pkgs`,
  `nixpkgs-unstable` only when the module uses `pkgsUnstable`/`pkgs.unstable`.
  The existing inputs are mixed, so match the neighbouring input rather than
  applying one rule everywhere.
- This laptop is hybrid-GPU (AMD + NVIDIA Prime). Do not give an app a private
  Mesa or `__EGL_VENDOR_LIBRARY_FILENAMES`; Chrome/Electron GPU processes then
  load conflicting Mesa versions and fall back to software rendering.

## Validation

Run the narrowest check that proves the change:

0. Stage new or renamed files (`git add -A`) before evaluating; flakes only see
   files in the git tree. Staging is not committing.
1. `nix flake check` (`unknown flake output 'modules'` is expected with
   flake-parts and is harmless)
2. `nixos-rebuild build --flake .#<host>`
3. For Home Manager changes, build the host's
   `home-manager.users.<user>.home.activationPackage` as shown above.
4. For generated Nix expressions, use
   `nix-instantiate --parse --expr '<expr>'` first, then
   `nix-instantiate --eval --json --strict --expr '<expr>'` when JSON-compatible.

## Secrets

Secrets are managed with agenix. The laptop identity is
`/home/shin/.ssh/agenix_shin` (`age.identityPaths` in
`devices/laptop/shin/host.nix`). Never print, commit, or copy decrypted
secrets, and do not weaken `.gitignore` entries for `secrets.fish`.

## Agent tooling

- Use the `nixos` MCP server to look up NixOS/Home Manager option types and
  defaults before setting them.
- Project OpenCode config is `opencode.jsonc`; reusable instructions live in
  `.opencode/`.
- Record durable, non-obvious repo knowledge in `.opencode/operator-notes.md`
  (via `/learn`). Keep it free of secrets.
- The agent tooling here is adapted from `neolectron/nixfiles`; that repo is
  available as the `neolectron-nixfiles` reference for comparison.

## Commits

Only commit when the user asks. Prefer clear, imperative subjects; Conventional
Commits (`feat:`, `fix:`, `docs:`, `refactor:`, `chore:`) are welcome.
