{
  config,
  pkgs,
  lib,
  hostName,
  ...
}:

let
  niriConfig = builtins.concatStringsSep "\n" [
    # ── Startup ──────────────────────────────────────────────────
    ''
      spawn-at-startup "noctalia"
      spawn-sh-at-startup "dbus-update-activation-environment --all"
      spawn-sh-at-startup "sleep 1 & dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      spawn-sh-at-startup "wayscriber --daemon"
    ''

    # ── General Settings ─────────────────────────────────────────
    ''
      prefer-no-csd
      debug {
          honor-xdg-activation-with-invalid-serial
      }
      cursor {
          xcursor-theme "Bibata-Modern-Classic"
          xcursor-size 24
          hide-when-typing
          hide-after-inactive-ms 1000
      }

      xwayland-satellite {
          path "xwayland-satellite"
      }
    ''

    # ── Input ────────────────────────────────────────────────────
    ''
      input {
          keyboard {
              repeat-rate 50
              repeat-delay 300
              xkb {
                  layout "us,ara"
                  options "caps:super"
              }
          }
          touchpad {
              tap
              accel-speed 0.3
              disabled-on-external-mouse
          }
          mouse {
          }
          focus-follows-mouse max-scroll-amount="30%"
          workspace-auto-back-and-forth
      }
    ''

    # ── Gestures ─────────────────────────────────────────────────
    ''
      gestures {
          hot-corners {
              off
          }
      }
    ''

    # ── Outputs ──────────────────────────────────────────────────
    ''
      output "eDP-1" {
          variable-refresh-rate on-demand=true
      }
    ''

    # ── Layout ───────────────────────────────────────────────────
    ''
      layout {
          gaps 0
          center-focused-column "never"
          preset-column-widths {
              proportion 0.33333
              proportion 0.5
              proportion 0.66667
          }
          focus-ring {
              off
              width 2
          }
          border {
              off
              width 2
          }
          shadow {
              on
              softness 20
              spread 3
              draw-behind-window true
              offset x=2 y=7
          }
          tab-indicator {
              on
              place-within-column
              gap 4
              width 1
              length total-proportion=1.0
              position "right"
              gaps-between-tabs 2
              corner-radius 8
          }
          insert-hint {
              on
          }
          background-color "transparent"
      }
      hotkey-overlay {
          skip-at-startup
      }
    ''

    # ── Keybinds ─────────────────────────────────────────────────
    ''
      binds {
          Mod+Return { spawn "foot"; }
          Mod+Alt+D { spawn-sh "qs -c noctalia-shell ipc call launcher windows"; }
          Mod+Shift+Return { spawn "env" "NO_TMUX=1" "foot"; }
          Mod+D { spawn-sh "noctalia msg panel-toggle launcher"; }
          Mod+Print { spawn-sh "noctalia msg screenshot-region"; }
          Mod+Alt+Print { spawn-sh "noctalia msg screenshot-fullscreen all"; }
          Mod+F1 { spawn-sh "pkill -SIGUSR1 wayscriber"; }
          Mod+Equal{ spawn-sh "noctalia msg volume-up 5"; }
          Mod+Minus{ spawn-sh "noctalia msg volume-down 5"; }
          Mod+U { switch-layout "next"; }
          Mod+Alt+Return { spawn-sh "~/.local/bin/scratchpad.sh foot-dropterm"; }
          Mod+BracketRight { spawn-sh "playerctl --ignore-player=firefox --player=tauon,spotify,mpd position 10+"; }
          Mod+BracketLeft { spawn-sh "playerctl --ignore-player=firefox --player=tauon,spotify,mpd position 10-"; }

          XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0"; }
          XF86AudioLowerVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"; }
          XF86AudioMute        allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; }
          XF86AudioMicMute     allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; }
          XF86AudioPlay        allow-when-locked=true { spawn-sh "playerctl play-pause"; }
          XF86AudioStop        allow-when-locked=true { spawn-sh "playerctl stop"; }
          XF86AudioPrev        allow-when-locked=true { spawn-sh "playerctl previous"; }
          XF86AudioNext        allow-when-locked=true { spawn-sh "playerctl next"; }
          XF86MonBrightnessUp allow-when-locked=true   { spawn-sh "~/.local/bin/brightnesscontrol.sh -i"; }
          XF86MonBrightnessDown allow-when-locked=true { spawn-sh "~/.local/bin/brightnesscontrol.sh -d"; }

      // ── Window Management ──
          Mod+O repeat=false { toggle-overview; }
          Mod+Q repeat=false { close-window; }
          Mod+Left  { spawn-sh "~/.local/bin/float-tile-niri-navigation.sh left"; }
          Mod+Down  { focus-window-down; }
          Mod+Up    { focus-window-up; }
          Mod+Right { spawn-sh "~/.local/bin/float-tile-niri-navigation.sh right"; }
          Mod+H     { focus-column-left; }
          Mod+L     { focus-column-right; }

          Mod+Ctrl+Left  { move-column-left; }
          Mod+Ctrl+Down  { move-window-down; }
          Mod+Ctrl+Up    { move-window-up; }
          Mod+Ctrl+Right { move-column-right; }
          Mod+Ctrl+H     { move-column-left; }
          Mod+Ctrl+L     { move-column-right; }

          Mod+J     { focus-window-or-workspace-down; }
          Mod+K     { focus-window-or-workspace-up; }
          Mod+Ctrl+J { move-window-down-or-to-workspace-down; }
          Mod+Ctrl+K { move-window-up-or-to-workspace-up; }

          Mod+Home { focus-column-first; }
          Mod+End  { focus-column-last; }
          Mod+Ctrl+Home { move-column-to-first; }
          Mod+Ctrl+End  { move-column-to-last; }

          Mod+Page_Down      { focus-workspace-down; }
          Mod+Page_Up        { focus-workspace-up; }
          Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
          Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }

          Mod+Shift+J { move-workspace-down; }
          Mod+Shift+K { move-workspace-up; }
          Mod+Shift+U { move-workspace-down; }
          Mod+Shift+I { move-workspace-up; }

          Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
          Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
          Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
          Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

          Mod+Alt+WheelScrollDown      { focus-column-right; }
          Mod+Alt+WheelScrollUp       { focus-column-left; }
          Mod+Ctrl+Alt+WheelScrollDown { move-column-right; }
          Mod+Ctrl+Alt+WheelScrollUp  { move-column-left; }

          Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
          Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }

          Mod+1 { focus-workspace 1; }
          Mod+2 { focus-workspace 2; }
          Mod+3 { focus-workspace 3; }
          Mod+4 { focus-workspace 4; }
          Mod+5 { focus-workspace 5; }
          Mod+6 { focus-workspace 6; }
          Mod+7 { focus-workspace 7; }
          Mod+8 { focus-workspace 8; }
          Mod+9 { focus-workspace 9; }
          Mod+Ctrl+1 { move-column-to-workspace 1; }
          Mod+Ctrl+2 { move-column-to-workspace 2; }
          Mod+Ctrl+3 { move-column-to-workspace 3; }
          Mod+Ctrl+4 { move-column-to-workspace 4; }
          Mod+Ctrl+5 { move-column-to-workspace 5; }
          Mod+Ctrl+6 { move-column-to-workspace 6; }
          Mod+Ctrl+7 { move-column-to-workspace 7; }
          Mod+Ctrl+8 { move-column-to-workspace 8; }
          Mod+Ctrl+9 { move-column-to-workspace 9; }

          Mod+Alt+BracketLeft  { consume-or-expel-window-left; }
          Mod+Alt+BracketRight { consume-or-expel-window-right; }

          Mod+Shift+BracketRight { consume-window-into-column; }
          Mod+Shift+BracketLeft  { expel-window-from-column; }

          Mod+R { switch-preset-column-width; }
          Mod+Shift+R { quit; }
          Mod+Ctrl+R { reset-window-height; }
          Mod+Alt+F { maximize-column; }
          Mod+F { fullscreen-window; }
          Mod+Shift+F { expand-column-to-available-width; }

          Mod+Ctrl+C { center-visible-columns; }

          Mod+Alt+H { set-column-width "-6%"; }
          Mod+Alt+L { set-column-width "+6%"; }

          Mod+Alt+K { set-window-height "-6%"; }
          Mod+Alt+J { set-window-height "+6%"; }

          Mod+space { spawn-sh "~/.local/bin/niri-floating-toggle.sh"; }
          Mod+Shift+H { switch-focus-between-floating-and-tiling; }
          Mod+G { toggle-column-tabbed-display; }

          Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
          Ctrl+Alt+Delete { quit; }
          Mod+Shift+P { power-off-monitors; }
          Mod+backspace { spawn-sh "noctalia msg panel-toggle session"; }
          Mod+T { spawn-sh "~/.local/bin/niri-sidebar toggle-window"; }

      // ── WLR Which Key ──
          Mod+m { spawn-sh "wlr-which-key -k m niri"; }
          Mod+n { spawn-sh "wlr-which-key -k n niri"; }
          Mod+a { spawn-sh "wlr-which-key -k a niri"; }
          Mod+C { spawn-sh "wlr-which-key -k c niri"; }
          Mod+s { spawn-sh "wlr-which-key -k s niri"; }
      }
    ''

    # ── Named Workspaces ─────────────────────────────────────────
    ''
      workspace "Comm"
      workspace "Read"
      workspace "Net"
      workspace "Vms"
    ''

    # ── Window Rules ─────────────────────────────────────────────
    # ── Default opacity ──
    ''
      window-rule {
          opacity 0.92
      }
    ''

    # ── Blur ──
    ''
      blur {
         passes 4
         offset 4.0
         noise 0.06
         saturation 1.8
      }
    ''

    # ── Blur everywhere ──
    ''
      window-rule {
        background-effect {
          blur true
          xray true
        }
      }
    ''

    # ── Dolphin popups ──
    ''
      window-rule {
        match app-id="^org\\.kde\\.dolphin$"
        popups {
          background-effect {
            blur true
            xray false
          }
          geometry-corner-radius 7
        }
      }
    ''

    # ── WLR Which Key layer ──
    ''
      layer-rule {
          match namespace="^wlr_which_key$"
          opacity 0.90
          background-effect {
              blur true
              xray true
          }
          geometry-corner-radius 9
      }
    ''

    # ── Floating Noctalia settings ──
    ''
      window-rule {
        match app-id="dev.noctalia.noctalia-qs"
        open-floating true
      }
    ''

    # ── No blur/opacity on media viewers ──
    ''
      window-rule {
          match app-id=r#"\.*org\.kde\.okular.*|.*mpv.*|.*vlc.*|.*org\.kde\.gwenview.*|^com\.obsproject\.Studio$"#
          match app-id=r#".*zen.*"# title=r#"^(\([0-9]\))*.*YouTube.*"#
          opacity 1.00
          background-effect {
              blur false
          }
      }
    ''

    # ─── Workspace assignments & window-specific rules ──

    # Okular → maximized
    ''
      window-rule {
          match app-id=r#".*org\.kde\.okular.*"#
          open-maximized true
      }
    ''

    # Calibre ebook viewer → maximized
    ''
      window-rule {
          match app-id=r#".*calibre-ebook-viewer.*|vlc"# title=r#".*E-book viewer.*"#
          open-maximized true
      }
    ''

    # KDE portal → floating
    ''
      window-rule {
          match app-id=r#"org\.freedesktop\.impl\.portal\.desktop\.kde"#
          open-floating true
      }
    ''

    # Focused window → show focus ring
    ''
      window-rule {
          match is-focused=true
          focus-ring {
              on
              width 1
          }
      }
    ''

    # Zen browser → workspace Net, maximized
    ''
      window-rule {
          match app-id=r#"zen"#
          open-on-workspace "Net"
          open-maximized true
      }
    ''

    # VMs → workspace Vms, no blur, no transparency
    ''
      window-rule {
          match app-id="^virt-manager$|^Vmware$|^Vmplayer$"
          opacity 1.00
          open-on-workspace "Vms"
          background-effect {
              blur true
              xray false
        }
      }
    ''

    # Okular → workspace Read
    ''
      window-rule {
          match app-id=r#".*org\.kde\.okular.*"#
          open-on-workspace "Read"
      }
    ''

    # No border background
    ''
      window-rule {
          draw-border-with-background false
      }
    ''

    # Communication apps → workspace Comm, full width
    ''
      window-rule {
          match app-id=r#"vesktop|org\.telegram\.desktop"#
          open-on-workspace "Comm"
          default-column-width { proportion 1.00; }
      }
    ''

    # No rounded corners by default
    ''
      window-rule {
          geometry-corner-radius 0
          clip-to-geometry false
      }
    ''

    # Floating windows → rounded corners, border, fixed size
    ''
      window-rule {
          match is-floating=true
          geometry-corner-radius 5
          clip-to-geometry true
          border {
              on
              width 0
          }
          default-column-width { fixed 800; }
          default-window-height { fixed 800; }
      }
    ''

    # Firefox PiP → floating
    ''
      window-rule {
          match app-id=r#"firefox$"# title="^Picture-in-Picture$"
          open-floating true
      }
    ''

    # Zen "Save Image" → floating
    ''
      window-rule {
          match app-id=r#"zen"# title=r#"(?i)save image"#
          open-floating true
          default-column-width { fixed 900; }
          default-window-height { fixed 700; }
      }
    ''

    # Portal dialogs → floating
    ''
      window-rule {
        match app-id=r#"xdg-desktop-portal-gtk"#
        open-floating true
        default-column-width { fixed 900; }
        default-window-height { fixed 700; }
      }

      window-rule {
        match title=r#"Choose\sFiles"#
        open-floating true
        default-column-width { fixed 900; }
        default-window-height { fixed 700; }
      }
    ''

    # Settings apps → floating
    ''
      window-rule {
          match app-id=r#"dev.noctalia.Noctalia.Settings"#
          match app-id=r#"org\.gnome\.Calculator"#
          open-floating true
          default-column-width { fixed 900; }
          default-window-height { fixed 700; }
      }
    ''

    # Password managers → block screen capture
    ''
      window-rule {
          match app-id=r#"^org\.keepassxc\.KeePassXC$"#
          match app-id=r#"^org\.gnome\.World\.Secrets$"#
          block-out-from "screen-capture"
      }
    ''

    # Floating windows → min size
    ''
      window-rule {
          match is-floating=true
          min-width 100
          min-height 100
      }
    ''

    # Calibre Preferences → floating
    ''
      window-rule {
          match title=r#"calibre\s+-\s+Preferences"#
          open-floating true
          default-column-width { fixed 1100; }
          default-window-height { fixed 800; }
      }
    ''

    # Dropdown terminals → floating at bottom
    ''
      window-rule {
          match app-id="^foot-dropterm$|^kitty-dropterm$"
          open-floating true
          default-floating-position x=0 y=15 relative-to="bottom"
          default-window-height { proportion 0.5; }
          default-column-width { proportion 0.6; }
      }
    ''

    # OBS → min width
    ''
      window-rule {
          match app-id=r#"^com\.obsproject\.Studio$"#
          min-width 876
      }
    ''

    # Ark & hyprland-share-picker → floating
    ''
      window-rule {
          match app-id=r#"^org\.kde\.ark$|hyprland-share-picker"#
          open-floating true
          default-column-width { fixed 780; }
          default-window-height { fixed 500; }
      }
    ''

    # Misc media/tools → floating
    ''
      window-rule {
          match app-id=r#"^(mpv)$|^(snappergui)$|^(imv)$|^(org\.kde\.gwenview)$|^(org.gnome.Shotwell)$|org\.kde\.kdeconnect\.handler|org\.kde\.kdeconnect\.app|^(kvantummanager)$|^(qt6ct)$|^(qt5ct)$|^(org.gnome.ark)$|^(pavucontrol)$|^(pavucontrol-qt)$|^(org.gnome.FileRoller)$|^(com.gabm.satty)$|^(org\.kde\.partitionmanager)$|^(org\.qbittorrent\.qBittorrent)$"#
          open-floating true
          default-column-width { fixed 1200; }
          default-window-height { fixed 800; }
      }
    ''

    # ── Block-out for private browsing / social media ──
    ''
      window-rule {
          match app-id=r#"(zen|^org\.kde\.dolphin|^mpv$)"# title=r#"(.*[wW]hats[aA]pp.*|.*[iI]nstagram.*|.*[Rr]eddit.*|.*[zZ]en\s*[bB]rowser\s*[pP]rivate\s*[Bb]rowsing.*|.*priv.*|.*\.p.*)"#
          block-out-from "screencast"
      }
    ''

    # ── Dolphin sub-dialogs ──
    ''
      window-rule {
          match title=r#"^Deleting.*"#
          open-floating true
          default-column-width { proportion 0.30; }
          default-window-height { proportion 0.20; }
      }

      window-rule {
          match app-id=r#"^org\.kde\.dolphin$"#
          open-maximized true
      }
    ''

    # Dead Cells → fullscreen
    ''
      window-rule {
          match app-id=r#"^deadcells"#
          open-fullscreen true
      }
    ''

    # Dolphin compressing → floating
    ''
      window-rule {
          match app-id=r#"^org\.kde\.dolphin$"# title=r#"^[Cc]ompressing.*[Dd]olphin"#
          open-floating true
      }
    ''

    # Niri-shot → floating
    ''
      window-rule {
          match app-id="com.github.niri-shot"
          open-floating true
      }
    ''

    # ── Layer Rules ──────────────────────────────────────────
    # Noctalia OSD & notifications
    ''
      layer-rule {
          match namespace="(^noctalia-osd.*)|(noctalia-notification.*)"
          opacity 0.9
          background-effect {
              xray false
          }
      }
    ''

    # Noctalia dock
    ''
      layer-rule {
          match namespace="^noctalia-dock.*"
          background-effect {
              xray false
          }
      }
    ''

    # Noctalia wallpaper
    ''
      layer-rule {
        match namespace="^noctalia-wallpaper*"
        place-within-backdrop true
      }
    ''

    # ── Overview ─────────────────────────────────────────────
    ''
      overview {
        workspace-shadow {
          off
        }
      }
    ''

    # ── User Overrides (edit ~/.config/niri/override.kdl) ──
    ''
      include "override.kdl"
    ''
  ];
in
{
  # Deploy niri config directly — no niri-flake validation
  xdg.configFile."niri/config.kdl".text = niriConfig;

  # Symlink from raw config files — editable on disk
  xdg.configFile."niri/powersaver.kdl".source = ../config/niri/powersaver.kdl;
  xdg.configFile."niri/transparency.kdl".source = ../config/niri/transparency.kdl;
  xdg.configFile."niri/animations".source = ../config/niri/animations;

  # Copy (not symlink) override.kdl on first activation — user edits survive
  home.activation.ensureNiriOverrideKdl = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    let
      initialOverride = pkgs.writeText "niri-override-kdl" ''
        include "noctalia.kdl"
        include "transparency.kdl"
        // include "./animations/glitch_01.kdl"
        include "powersaver.kdl"
      '';
    in
    ''
      if [ ! -f "$HOME/.config/niri/override.kdl" ]; then
        install -Dm644 ${initialOverride} "$HOME/.config/niri/override.kdl"
      fi
    ''
  );

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    XDG_MENU_PREFIX = "plasma-";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    GTK_IM_MODULE = "simple";
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };
}
