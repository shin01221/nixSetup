{ config, lib, osConfig, ... }:
let
  hm = osConfig.workstation.home or {};
  e = name:
    let v = hm.${name} or false;
    in if builtins.isBool v then v else v.enable or false;
in {
  imports = [ ./common.nix ]
    ++ lib.optional (e "fish")       ./fish.nix
    ++ lib.optional (e "scripts")    ./scripts.nix
    ++ lib.optional (e "niri")       ./niri.nix
    ++ lib.optional (e "matugen")    ./matugen.nix
    ++ lib.optional (e "noctalia")   ./noctalia.nix
    ++ lib.optional (e "wlr-which-key") ./wlr-which-key.nix
    ++ lib.optional (e "theming")    ./theming.nix
    ++ lib.optional (e "audio")      ./audio.nix
    ++ lib.optional (e "tmux")       ./tmux.nix
    ++ lib.optional (e "spotify")    ./spotify.nix
    ++ lib.optional (e "xdg")        ./xdg.nix
    ++ lib.optional (e "obs-studio") ./obs-studio.nix
    ++ lib.optional (e "foot")       ./foot.nix
    ++ lib.optional (e "ghostty")    ./ghostty.nix
    ++ lib.optional (e "dolphin")    ./dolphin
    ++ lib.optional (e "bash")       ./bash.nix
    ++ lib.optional (e "zsh")        ./zsh.nix
    ++ lib.optional (e "steam")      ./steam.nix
    ++ lib.optional (e "kde")        ./kde.nix
    ++ lib.optional (e "hypr")       ./hypr.nix
    ++ lib.optional (e "xfce")       ./xfce.nix
    ++ lib.optional (e "gnome")      ./gnome.nix
  ;
}
