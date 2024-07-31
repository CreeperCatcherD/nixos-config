{ pkgs, enable-nvidia, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 20;
  boot.initrd.kernelModules = if (enable-nvidia == true) then [ "nvidia" ] else [];
  boot.kernelParams = [ "psmouse.synaptics_intertouch=0" ] ++
  (if (enable-nvidia == true) then [ "nvidia-drm.fbdev=1" ] else []);
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
