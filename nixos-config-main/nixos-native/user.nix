{ pkgs, inputs, username, host, ... }: {
  
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  home-manager = {
    backupFileExtension = "backup";
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs username host; };
    users.${username} = {
      imports = 
        if (host == "desktop") then 
          [ ./../home-manager/default.desktop.nix ]
        else [ ./../home-manager ];
      home.username = "${username}";
      home.homeDirectory = "/home/${username}";
      home.stateVersion = "24.05";
      programs.home-manager.enable = true;
    };
  };

  programs.zsh.enable = true;

  users = {
    defaultUserShell = pkgs.zsh;

    users.${username} = {
      isNormalUser = true;
      description = "user";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [];
      shell = pkgs.zsh;
    };
  };

  # Enable automatic login for the user.
  #services.displayManager.autoLogin.enable = true;
  #services.displayManager.autoLogin.user = username;

  nix.settings.allowed-users = [ "${username}" ];
}
