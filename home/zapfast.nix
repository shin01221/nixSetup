{ inputs, ... }:

{
  imports = [ inputs.zapfast.homeManagerModules.default ];

  programs.zapfast.enable = true;
}
