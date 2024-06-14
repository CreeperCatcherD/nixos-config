{ pkgs, ... }: {
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = ["python-2.7.18.8" "electron-25.9.0"];
  };

  environment.systemPackages = with pkgs; [
    # Desktop apps
    alacritty
    discord
    dolphin-emu
    firefox
    gparted
    kdenlive
    konsole
    mpv
    obsidian
    obs-studio
    pcmanfm-qt
    rofi
    telegram-desktop
    wofi
    zoom-us

    # Coding stuff
    gcc
    gnumake
    nodejs
    python
    python3.withPackages (ps: with ps; [ requests ])
    vscode

    # CLI utils
    atuin
    btop
    brightnessctl
    cava
    cmatrix
    fastfetch
    fzf
    ffmpeg
    file
    git
    htop
    lazygit
    light
    lux
    mediainfo
    neofetch
    nix-index
    ntfs3g
    openssl
    ranger
    scrot
    swww
    tmux
    tree
    unzip
    wget
    yt-dlp
    zram-generator
    zip

    # GUI utils
    dmenu
    feh
    gromit-mpx
    imv
    mako
    screenkey

    # Xorg stuff
    #xterm
    #xclip
    #xorg.xbacklight

    # Wayland stuff
    cliphist
    wl-clipboard
    xwayland

    # WMs and stuff
    herbstluftwm
    hyprland
    polybar
    seatd
    xdg-desktop-portal-hyprland
    waybar

    # Sound
    pamixer
    pipewire
    pulseaudio

    # GPU stuff
    amdvlk
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
