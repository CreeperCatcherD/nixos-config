{ pkgs, pkgs-stable, pkgs-unstable, ... }: {
  nixpkgs.config = {
    allowUnfree = true;
    #permittedInsecurePackages = ["python-2.7.18.8" "electron-25.9.0"];
  };

  environment.systemPackages = with pkgs; [
    # Desktop apps
    blender
    clementine
    firefox
    kdenlive
    obs-studio
    pkgs-unstable.obsidian
    #pcmanfm-qt

    (pkgs.lmstudio.overrideAttrs {
      src = fetchurl {
        url = "https://releases.lmstudio.ai/linux/x86/0.2.25/beta/LM_Studio-0.2.25.AppImage";
        hash = "sha256-2a3ac+0m3C/YyPM0Waia+x2Q/lodfbyHNvlbB2AHT78=";
      };
    })

    # Coding stuff
    #(python3.withPackages (ps: with ps; [ requests ]))
    gcc
    gnumake
    nodejs
    vscode

    # CLI utils
    atuin
    bluez
    bluez-tools
    fastfetch
    file
    lux
    mediainfo
    nix-index
    ntfs3g
    openssl
    ranger
    scrot
    swww
    tmux
    tree
    unzip
    w3m
    wget
    yt-dlp
    zip
    zram-generator

    # GUI utils
    #dmenu
    feh
    gromit-mpx
    screenkey

    #rocm-opencl-icd
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
