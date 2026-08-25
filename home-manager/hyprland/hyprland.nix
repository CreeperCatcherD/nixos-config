{ inputs, pkgs, ...}: 
{
  home.packages = with pkgs; [
    # swww
    # swaybg
    inputs.hypr-contrib.packages.${pkgs.stdenv.hostPlatform.system}.grimblast
    hyprpicker
    grim
    slurp
    swappy
    wl-clip-persist
    wf-recorder
    wayland
    hyprsunset
  ];

  systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
  wayland.windowManager.hyprland = {
    # Upstream's nix/default.nix supplies `glaze-hyprland` (nixpkgs' glaze,
    # version-compatible) as a buildInput, but find_package(glaze) in
    # CMakeLists.txt isn't locating it, so CMake falls back to FetchContent
    # git-cloning glaze live - which Nix's sandboxed build blocks (no
    # network). Force FetchContent to use the already-fetched nixpkgs glaze
    # source instead, sidestepping the live clone entirely.
    package = (inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland).overrideAttrs (old: {
      cmakeFlags = (old.cmakeFlags or []) ++ [
        "-DFETCHCONTENT_SOURCE_DIR_GLAZE=${pkgs.glaze.src}"
      ];
    });
    enable = true;
    configType = "lua";
    xwayland = {
      enable = true;
      # hidpi = true;
    };
    # enableNvidiaPatches = false;
    systemd.enable = true;
    
  };
}
