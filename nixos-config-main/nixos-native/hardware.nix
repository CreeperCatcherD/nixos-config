{ config, pkgs, ... }:
{  
  #Most wayland compositors need this
  hardware = {
    opengl = {
      enable = true;
      extraPackages = [ pkgs.vaapiVdpau ];
    };
    #nvidia = {
    #  modesetting.enable = true;
    #  powerManagement.enable = false;
    #  nvidiaSettings = true;
    #  package = config.boot.kernelPackages.nvidiaPackages.beta;
    #};
  };
}
