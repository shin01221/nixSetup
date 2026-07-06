{ config, lib, ... }:
let
  cfg = config.workstation.touchpad;
in {
  options.workstation.touchpad.enable = lib.mkEnableOption "Touchpad configuration (libinput)";

  config = lib.mkIf cfg.enable {
    services.libinput = {
      touchpad = {
        naturalScrolling = true;
        tapping = true;
        clickMethod = "clickfinger";
        disableWhileTyping = true;
      };
    };
  };
}
