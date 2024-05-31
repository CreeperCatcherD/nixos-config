{
  imports = [ ./../../options.nix ];

  services = {
  
    xserver = {
      enable = true;
      windowManager.herbstluftwm.enable = true;

      # displayManager = {
      #   autoLogin.enable = true;
      #   autoLogin.user = "amper";
      #   lightdm.enable = true;
      # };

      xkb.layout = "us";
      xkb.variant = "";

      videoDrivers = [ "nvidia" ];
      deviceSection = ''Option "TearFree" "True"'';
    };

    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
      touchpad.accelProfile = "flat";
    };
    
  };


  # Enable the KDE Plasma Desktop Environment
  if options.kde_plasma_de then {
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma5.enable = true;
  }


  # Enable the Hyperland Desktop Environment
  if options.hyprland_de then {
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
  }
}
