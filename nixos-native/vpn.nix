{ lib, ... }:
{
  # sudo tailscale up --login-server https://head.kleindavis.xyz
  # sudo tailscale set --advertise-exit-node
  services.tailscale = {
    enable = true;
    openFirewall = true;
    #  extraUpFlags = [ "--login-server=http://192.168.12.180:8080" ];
    # client server both
    useRoutingFeatures = "both";
  };

}