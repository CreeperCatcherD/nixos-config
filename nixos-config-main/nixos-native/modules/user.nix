{ pkgs, ... }: {
  programs.zsh.enable = true;

  users = {
    defaultUserShell = pkgs.zsh;

    users.kleind = {
      isNormalUser = true;
      description = "Klein Davis";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [steam];
    };
  };

  # Enable automatic login for the user.
  #services.getty.autologinUser = "amper";
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "kleind";
}
