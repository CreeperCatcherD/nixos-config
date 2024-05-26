{ pkgs, ... }: {
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = ["python-2.7.18.8" "electron-25.9.0"];
  };

  environment.systemPackages = with pkgs; [
    # Desktop apps
    chromium
    firefox
    discord
    gparted
    obsidian

    # Coding stuff
    vscode
    #python
    #(python3.withPackages (ps: with ps; [ requests ]))

    # CLI utils
    wget
    git
    nix-index
    unzip
    ffmpeg
    zip
    ntfs3g
    openssl

    # GUI utils
    feh
    imv
    dmenu
    screenkey
    mako
    gromit-mpx

    # Sound
    pipewire
    pulseaudio
    pamixer

    # GPU stuff 

    # Gaming
    steam

    # Screenshotting
    grim
    grimblast
    slurp
    flameshot
    swappy

    # Other
    home-manager
    spice-vdagent
  ];

  fonts.packages = with pkgs; [

  ];
  
}
