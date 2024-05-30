{
  services.xserver = {
      enable = true;
      #windowManager.herbstluftwm.enable = true;

      # displayManager = {
      #   autoLogin.enable = true;
      #   autoLogin.user = "amper";
      #   lightdm.enable = true;
      # };

      layout = "us";
      xkbVariant = "";

      libinput = {
        enable = true;
        mouse.accelProfile = "flat";
        touchpad.accelProfile = "flat";
      };

      #videoDrivers = [ "nvidia" ];
      #deviceSection = ''Option "TearFree" "True"'';
      #displayManager.gdm.enable = true;
      #desktopManager.gnome.enable = true;
    };

  # Enable the KDE Plasma Desktop Environment.
  #services.displayManager.sddm.enable = true;
  #services.desktopManager.plasma5.enable = true;

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
}
