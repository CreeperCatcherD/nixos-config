{
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

  # Enable the KDE Plasma Desktop Environment.
  #services.displayManager.sddm.enable = true;
  #services.desktopManager.plasma5.enable = true;

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
}
