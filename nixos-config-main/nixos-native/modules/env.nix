{ config, pkgs, ... }: {
  imports = [./../../options.nix];

  environment.variables = {
    EDITOR = "code";
    RANGER_LOAD_DEFAULT_RC = "FALSE";
    #QT_QPA_PLATFORMTHEME = "qt5ct";
    GSETTINGS_BACKEND = "keyfile";
  };

  # Define the config variable based on the options
  config = if config.hyprland_de then {
    # Hyperland Nvidia configuration
    environment.sessionVariables = {
      # If your cursor becomes invisible
      #LR_NO_HARDWARE_CURSORS = "1";
      # Hint electron apps to use wayland
      NIXOS_OZONE_WL = "1";
    };
  } else {
    # Configuration B
  };
}