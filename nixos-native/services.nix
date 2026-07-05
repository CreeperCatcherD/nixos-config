{ pkgs, host, ... }: 
{
  services = {
    dbus.enable = true;
    fstrim.enable = true;
    fwupd.enable = (host == "framework1");
    gnome.gnome-keyring.enable = false;
    gvfs.enable = true;
    seatd.enable = true;
    printing.enable = true;
    envfs.enable = true;
  };
  
  environment.systemPackages = with pkgs; [gvfs];
  services.udev.extraRules = ''
    KERNEL=="ttyACM[0-9]*",MODE="0666"
    # ESP32 / Arduino / Common Serial
    KERNEL=="ttyACM*", MODE="0666", GROUP="dialout"
    KERNEL=="ttyUSB*", MODE="0666", GROUP="dialout"
  '';
  
  services.logind.settings = {
    Login = {
      HandlePowerKey = "suspend";
    };
  };
  
}
