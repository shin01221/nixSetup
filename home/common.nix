{
  config,
  pkgs,
  lib,
  userName,
  homeDir,
  ...
}:

{
  home = {
    username = userName;
    homeDirectory = homeDir;
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;

programs.git = {
    enable = true;
    package = pkgs.git;
    lfs.enable = false;

    # 1. Keep signing and ignores out here as they are top-level options
    signing = {
      format = "ssh";
      key = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      signByDefault = true;
    };

    ignores = [
      ".cache/"
      ".DS_Store"
      ".Trashes"
      ".Trash-*"
      "*.bak"
      "*.swp"
      "*.swo"
      "*.elc"
      ".~lock*"
      "tmp/"
      "target/"
      "result"
      "result-*"
      "*.exe"
      "*.exe~"
      "*.dll"
      "*.so"
      "*.dylib"
      "node_modules"
      "vendor"
    ];

    # 2. Put user identity inside the settings block
    settings = {
      core.editor = "nvim";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      
      # Moved identity attributes here:
      user = {
        name = "shin01221";
        email = "mohamed" + "@" + "madin372" + "." + "com";
      };
    };
  };
}
