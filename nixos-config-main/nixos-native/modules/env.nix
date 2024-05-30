{
  environment.variables = {
    EDITOR = "code";
    RANGER_LOAD_DEFAULT_RC = "FALSE";
    #QT_QPA_PLATFORMTHEME = "qt5ct";
    GSETTINGS_BACKEND = "keyfile";
  };

  #Hyperland Nvidia
  environment.sessionVariables = {
    #If your cursor becomes invisible
    #WLR_NO_HARDWARE_CURSORS = "1";
    #Hint electron apps to use wayland
    #NIXOS_OZONE_WL = "1";
  };
}
