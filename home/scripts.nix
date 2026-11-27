{ ... }:
{
  flake.modules.homeManager.scripts =
    { pkgs, hostFeatures, ... }:
    let
      wm =
        if builtins.elem "umbriel" hostFeatures then
          "umbriel"
        else if builtins.elem "niri" hostFeatures then
          "niri"
        else
          "auto";
    in
    {
      home.packages = [ (pkgs.callPackage ../pkgs/scripts { inherit wm; }) ];
    }
  ;
}
