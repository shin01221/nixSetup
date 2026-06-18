{ config, lib, ... }:
{
  services.libinput = {
    touchpad = {
      naturalScrolling = true;
      tapping = true;
      clickMethod = "clickfinger";
      disableWhileTyping = true;
    };
  };
}
