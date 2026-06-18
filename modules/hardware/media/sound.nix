{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkForce;
in
{
  security.rtkit.enable = true;

  services.pulseaudio.enable = mkForce false;

  services.pipewire = {
    enable = true;

    audio.enable = true;
    pulse.enable = true;
    jack.enable = true;

    alsa = {
      enable = true;
      support32Bit = pkgs.stdenv.hostPlatform.isx86;
    };

    extraLadspaPackages = [ pkgs.rnnoise-plugin ];

    extraConfig.pipewire."10-loopback" = {
      "context.modules" = [
        {
          "node.description" = "playback loop";
          "audio.position" = [ "FL" "FR" ];

          "capture.props" = {
            "node.name" = "playback_sink";
            "node.description" = "playback-sink";
            "media.class" = "Audio/Sink";
          };

          "playback.props" = {
            "node.name" = "playback_sink.output";
            "node.description" = "playback-sink-output";
            "media.class" = "Audio/Source";
            "node.passive" = true;
          };
        }
      ];
    };
  };

  systemd.user.services = {
    pipewire.wantedBy = [ "default.target" ];
    pipewire-pulse.wantedBy = [ "default.target" ];
  };
}
