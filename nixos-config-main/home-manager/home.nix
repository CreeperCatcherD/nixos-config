{

  imports = [
    ./zsh.nix
    ./modules/bundle.nix
  ];

  home = {
    username = "kleind";
    homeDirectory = "/home/kleind";
    stateVersion = "23.11";
  };
}
