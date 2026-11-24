{
  inputs,
  ...
}:

{
  imports = [ inputs.umbriel.homeModules.default ];

  programs.umbriel.enable = true;

  # xdg.configFile."umbriel/config.toml".source = ../config/umbriel/config.toml;
}
