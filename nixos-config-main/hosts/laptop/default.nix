{ pkgs, config, ... }: 
{
  imports = [
    ./hardware-configuration.nix
    ./../../nixos-native/default.nix
  ];

  environment.systemPackages = with pkgs; [
    acpi
    brightnessctl
    cpupower-gui
    light
    powertop
  ];
  
  services = {    
    # thermald.enable = true;
    # cpupower-gui.enable = true;
    power-profiles-daemon.enable = false;
 
    upower = {
      enable = true;
      percentageLow = 20;
      percentageCritical = 5;
      percentageAction = 3;
      criticalPowerAction = "PowerOff";
    };

    auto-cpufreq = {
      # balanced performance powersave
      enable = true;
      settings = {
        battery = {
          governor = "balanced";
          turbo = "auto";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };
  };

  boot = {
    kernelModules = ["acpi_call"];
    extraModulePackages = with config.boot.kernelPackages;
      [
        acpi_call
        cpupower
      ]
      ++ [pkgs.cpupower-gui];
  };
}
