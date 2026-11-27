{ ... }:
{
  flake.modules.nixos.touchpad =
    { config, lib, ... }:
    {
      boot.kernelModules = [
        "i2c_hid"
        "hid_multitouch"
      ];

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
