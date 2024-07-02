{ config, pkgs, ... }:
{  
  #Most wayland compositors need this
  hardware = {
    graphics = {
      enable = true;
      extraPackages = [ pkgs.vaapiVdpau ];
    };
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
  };
}
