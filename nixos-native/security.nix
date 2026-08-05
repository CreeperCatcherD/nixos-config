{ myOptions, ... }:
{
  security.rtkit.enable = true;
  security.polkit.enable = true; # Enabled by rtkit

  security.sudo.enable = false;
  security.sudo-rs.enable = true;
  security.sudo-rs.execWheelOnly = true;

  # swaylock removed - Noctalia's lock screen authenticates against the
  # standard "login" PAM service, no custom PAM config needed.

  # security.sudo.extraRules = [
  #   {
  #     #users = [ "nixuser" ];
  #       commands = [
  #       {
  #         command = "nixos-rebuild";
  #         options = ["NOPASSWD"];
  #       }
  #     ];
  #   }
  # ];
}
