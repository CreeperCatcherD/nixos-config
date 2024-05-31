{ pkgs, ... }: {

  imports = [ ./../../options.nix ];

  if options.hyprland_de then {
    
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    hardware = {
      #Opengl
      opengl.enable = true;

      #Most wayland compositors need this
      nvidia.modesetting.enable = true;
    };
    xdg.portal.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  } else {
    # Configuration B
  }
  
}
