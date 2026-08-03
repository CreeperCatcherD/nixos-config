{ config, pkgs, lib, myOptions, ... }: {

  environment.variables = {
    EDITOR = "code";
    RANGER_LOAD_DEFAULT_RC = "FALSE";
    GSETTINGS_BACKEND = "keyfile";
    LIBSEAT_BACKEND = "seatd";
    WAYLAND_DISPLAY = "wayland-1";
    # QT_QPA_PLATFORMTHEME = "qt5ct";
  };

  programs.direnv = {
    package = pkgs.direnv;
    silent = false;
    loadInNixShell = true;
    direnvrcExtra = "";
    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv;
    };
  };

  nix.settings = {
    keep-outputs = true;
    keep-derivations = true;
  };
}