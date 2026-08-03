{ pkgs, myOptions, ... }: {
  environment.systemPackages = with pkgs; [
    deskflow
  ];

  networking.firewall = {
    allowedTCPPorts = [ 24800 ];
    allowedUDPPorts = [ 24800 ];
  };
}