{ pkgs, osConfig, ... }:
let
  wm =
    if osConfig.workstation.umbriel.enable or false then
      "umbriel"
    else if osConfig.workstation.niri.enable or false then
      "niri"
    else
      "auto";
in
{
  home.packages = [ (pkgs.callPackage ../pkgs/scripts { inherit wm; }) ];
}
