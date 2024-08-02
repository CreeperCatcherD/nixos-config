{ config, pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    openrgb-with-all-plugins
  ];

  let 
    openrgb-rules = builtins.fetchurl {
      url = "https://gitlab.com/CalcProgrammer1/OpenRGB/-/raw/master/60-openrgb.rules";
    };
  in {
    boot.kernelModules = [ "i2c-dev" "i2c-piix4" ];
    
    services.udev.extraRules =  builtins.readFile openrgb-rules;
  }
  
}