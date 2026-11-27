{ ... }:
{
  flake.modules.homeManager.luciole =
    { inputs, ... }:
    {
      imports = [ inputs.luciole.homeModules.default ];

      programs.luciole.enable = true;
    }
  ;
}
