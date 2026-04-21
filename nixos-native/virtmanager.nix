{ pkgs, pkgsBundle, ... }: {
  # Enable virtualization
  virtualisation.libvirtd = {
    enable = true;
    qemu.vhostUserPackages = with pkgs; [
      virtiofsd
    ];
  };

  # virtualisation.waydroid.enable = true;

  programs.virt-manager = {
    enable = true;
    package = pkgsBundle.pkgs-stable.virt-manager;
  };

  virtualisation.waydroid.enable = true;

  networking.firewall.trustedInterfaces = [ "waydroid0" ];
  boot.kernelModules = [ "binder_linux" "ashmem_linux" ];
  networking.nftables.enable = true;

  environment.systemPackages = [
    pkgs.virt-viewer
  ];
}

