{ config, pkgs, lib, ... }: {

  environment.variables = {
    EDITOR = "code";
    RANGER_LOAD_DEFAULT_RC = "FALSE";
    #QT_QPA_PLATFORMTHEME = "qt5ct";
    GSETTINGS_BACKEND = "keyfile";
  };

  # Hyperland Nvidia configuration
  #environment.sessionVariables = {
   # # If your cursor becomes invisible
    #LR_NO_HARDWARE_CURSORS = "1";
    # Hint electron apps to use wayland
    #NIXOS_OZONE_WL = "1";
  #};
  environment.sessionVariables =
    {
      NIXOS_OZONE_WL = "1";
    }
    // lib.optionalAttrs config.programs.hyprland.enable (
      {
        LIBVA_DRIVER_NAME = "nvidia";
        GBM_BACKEND = "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      }
    );

  nix.settings = {
    substituters = [ "https://cuda-maintainers.cachix.org" ];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };
}