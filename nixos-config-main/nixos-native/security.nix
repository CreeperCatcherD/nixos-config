{ lib, pkgs, ... }: 
{
  security.rtkit.enable = true;
  security.sudo.enable = true;
  #security.pam.services.swaylock = { };
  security.pam.services.swaylock.text = lib.readFile "${pkgs.swaylock}/etc/pam.d/swaylock";
  # IDK
  #security.pam.services.swaylock.fprintAuth = false;
}
