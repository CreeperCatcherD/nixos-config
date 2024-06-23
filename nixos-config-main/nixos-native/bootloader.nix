{ pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 20;
  #boot.initrd.kernelModules = [ "nvidia" ];
  boot.kernelParams = [ "psmouse.synaptics_intertouch=0" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
