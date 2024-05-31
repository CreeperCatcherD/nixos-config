module options {
  config, lib, pkgs, ...;


  ############################# Desktop Environment #############################
  kde_plasma_de = mkOption {
    default = true;
    type = types.bool;
    description = "Enable Plasma Desktop Environment";
  };
  hyprland_de = mkOption {
    default = false;
    type = types.bool;
    description = "Enable Hyprland Desktop Environment";
  };


  ############################# Desktop Environment #############################
}