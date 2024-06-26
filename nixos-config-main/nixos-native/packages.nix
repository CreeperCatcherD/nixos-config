{ pkgs, ... }: {
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = ["python-2.7.18.8" "electron-25.9.0"];
  };

  environment.systemPackages = with pkgs; [
    # Desktop apps
    alacritty
    clementine
    #discord
    dolphin-emu
    firefox
    gparted
    kdenlive
    konsole
    mpv
    obs-studio
    obsidian
    pcmanfm-qt
    rofi
    telegram-desktop
    wofi
    zoom-us

    # Coding stuff
    (python3.withPackages (ps: with ps; [ requests ]))
    gcc
    gnumake
    nodejs
    python
    vscode

    # CLI utils
    atuin
    bluez
    bluez-tools
    brightnessctl
    btop
    cava
    cmatrix
    fastfetch
    ffmpeg
    file
    fzf
    git
    htop
    lazygit
    light
    lux
    mediainfo
    neofetch
    nix-index
    ntfs3g
    openrgb-with-all-plugins
    openssl
    ranger
    scrot
    swww
    tmux
    tree
    unzip
    wget
    yt-dlp
    zip
    zram-generator

    # GUI utils
    dmenu
    feh
    gromit-mpx
    imv
    mako
    screenkey

    # Xorg stuff
    #xclip
    #xorg.xbacklight
    #xterm

    # Wayland stuff
    cliphist
    wl-clipboard
    xwayland

    # WMs and stuff
    herbstluftwm
    hyprland
    polybar
    seatd
    waybar
    xdg-desktop-portal-hyprland

    # GPU stuff 
    glaxnimate
    rocm-opencl-icd

    # Screenshotting
    flameshot
    grim
    grimblast
    slurp
    swappy

    # Other
    home-manager
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugin-kvantum
    papirus-nord
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
