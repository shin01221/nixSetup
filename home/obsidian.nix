{ pkgs, ... }:

{
  programs.obsidian = {
    enable = true;
    package = pkgs.obsidian;

    # Vaults are added imperatively in Obsidian (Open folder as vault).
    # You can configure them declaratively under `vaults.<name>.settings`, e.g.:
    #
    #   vaults.notes = {
    #     target = "/Media/Docs/notes";
    #     settings.app.vimMode = true;
    #   };
  };
}
