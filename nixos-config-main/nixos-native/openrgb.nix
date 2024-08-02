{ config, pkgs, rgb-lights-enable, ... }: {

    environment.systemPackages = []
    ++ (if (rgb-lights-enable) then [pkgs.openrgb-with-all-plugins] else []);
    services.hardware.openrgb.enable = rgb-lights-enable;
}