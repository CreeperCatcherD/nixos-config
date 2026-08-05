{ pkgs, pkgsBundle, myOptions, ... }: 
{
  services = {
  
    xserver = {
      enable = true;

      xkb.layout = "us";
      xkb.variant = "";

      videoDrivers = if (myOptions.enable-nvidia-gpu == true) then [ "nvidia" ] else []
      ++ (if (myOptions.enable-nvidia-gpu == true) then [ "amdgpu" ] else []);
      deviceSection = ''Option "TearFree" "True"'';
    };

    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
      touchpad.accelProfile = "flat";
    };
    
  };

  # Enable the KDE Plasma Desktop Environment
  #services.displayManager.sddm.enable = true;
  #services.xserver.desktopManager.plasma5.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Enable the Hyperland Desktop Environment
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  # services.desktop-portal.enable = true;
  xdg.portal = {
    enable = true;
    # wlr.enable = true;
    # xdgOpenUsePortal = true;
    extraPortals = with pkgsBundle.pkgs-unstable; [
      xdg-desktop-portal
      xdg-desktop-portal-wlr
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
      # pkgs.xdg-desktop-portal-gnome
    ];
    config.common.default = "*";
  };
  services.displayManager.defaultSession = "hyprland";
}
