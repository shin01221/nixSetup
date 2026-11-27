{ ... }:
{
  flake.modules.homeManager.matugen =
    {
      xdg.configFile."matugen".source = ../config/matugen;
    }
  ;
}
