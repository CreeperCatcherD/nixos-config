{ pkgs, ... }: {
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = ["python-2.7.18.8" "electron-25.9.0"];
  };

  environment.systemPackages = with pkgs; [
    # Desktop apps
    #chromium
    firefox
    discord
    gparted
    obsidian

    # Coding stuff
    vscode
    #python
    #(python3.withPackages (ps: with ps; [ requests ]))

    # CLI utils
    # Most of these were copied from ampere's config
    brightnessctl
    cava
    file
    fastfetch
    ffmpeg
    git
    htop
    light
    lazygit
    lux
    mediainfo
    neofetch
    ntfs3g
    openssl
    ranger
    scrot
    tree
    unzip
    wget
    yt-dlp
    zram-generator
    bluez-tools

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
    jetbrains-mono
    noto-fonts
    noto-fonts-emoji
    twemoji-color-font
    font-awesome
    powerline-fonts
    powerline-symbols
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
  ];
  
}
