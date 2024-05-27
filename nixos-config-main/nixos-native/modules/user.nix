{ pkgs, ... }: {
  programs.zsh.enable = true; # Redundant zsh.nix

  users = {
    defaultUserShell = pkgs.zsh;

    users.kleind = {
      isNormalUser = true;
      description = "Klein Davis";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [];
    };
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "kleind";
}
