{ inputs, pkgs, ... } : {

  imports = [ inputs.noctalia.homeModules.default ];

  home.packages = [
    pkgs.noctalia-shell
  ];

  programs.noctalia = {
    enable = true;
    settings = {};
  };
}