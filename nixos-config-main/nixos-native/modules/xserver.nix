{
  services.xserver = {
      enable = true;

      # Enable the KDE Plasma Desktop Environment.
      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;

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
    #services.displayManager.sddm.enable = true;
    #services.displayManager.sddm.wayland.enable = true;
}
