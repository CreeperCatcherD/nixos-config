{ lib, config, pkgs, inputs, myOptions, ... }:

{
  qt = {
    enable = true;
    platformTheme = "qt5ct"; # required for Qt apps (e.g. qpwgraph) to pick up qt5ct/qt6ct + Noctalia's generated color scheme
  };

  programs.dconf.enable = true;
}
