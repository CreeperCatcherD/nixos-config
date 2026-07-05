{ pkgs, lib, pkgsBundle, ... }:{
  programs.steam = {
    enable = true;
    gamescopeSession.enable = false;
    package = pkgsBundle.pkgs-unstable.steam;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    extraPackages = with pkgs; [
    ];
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-runtime"
  ];

  environment.systemPackages = with pkgs; [
    mangohud
    # steamcmd
    steam-tui
    steam-run
  ];
  programs.gamemode.enable = true;
  # Xbox Controller Support
  hardware.xpadneo.enable = true;
}