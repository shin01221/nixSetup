{ ... }:
{
  flake.modules.homeManager.common =
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
        username = lib.mkDefault userName;
        homeDirectory = lib.mkDefault homeDir;
        stateVersion = "25.05";
        packages = [ pkgs.home-manager ];

        file.".ssh/git.pub".text = ''
          ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAnU8Xy/qbxa4cDYxcxoTx2zsz4gBJBi6sXcfpcDnRbe shin@shin
        '';
      };

      fonts.fontconfig.enable = true;

      # Root's nix.gc does not expire standalone Home Manager generations.
      services.home-manager.autoExpire = {
        enable = lib.mkDefault true;
        frequency = lib.mkDefault "weekly";
        timestamp = lib.mkDefault "-14 days";
      };

    programs.git = {
        enable = true;
        package = pkgs.git;
        lfs.enable = false;

        # 1. Keep signing and ignores out here as they are top-level options
        signing = {
          format = "ssh";
          key = "${config.home.homeDirectory}/.ssh/git.pub";
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
  ;
}
