{ pkgs, ... }: 
{
  programs.git = {
    enable = true;
    
    userName  = "CreeperCatcherD";
    userEmail = "49421694+CreeperCatcherD@users.noreply.github.com";
    
    extraConfig = { 
      init.defaultBranch = "main";
      credential.helper = "store";
    };
  };

  home.packages = [ pkgs.gh pkgs.git-lfs ];
}
