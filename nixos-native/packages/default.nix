{ inputs, myOptions, pkgs, pkgsBundle, lib, host, ... }: {

  imports = []
    ++ [(import ./blender.nix)]
    ++ [(import ./docker.nix)]
    ++ [(import ./steam.nix)]                       # Steam integration
    # ++ [(import ./obs-studio.nix)]
    ++ [(import ./openrgb.nix)]           # OpenRGB for lighting control
    ++ [(import ./wireshark.nix)]
    ++ [(import ./flatpak.nix)];
    # Install jellyfin on desktop

  nixpkgs.config = {
    allowUnfree = true;
  };

  services.udev.packages = with pkgs; [ arduino ];

  environment.systemPackages = with pkgs; [
    # Desktop apps
    arduino-ide                           # Arduino IDE
    pkgsBundle.pkgs-old.chromium          # Chromium Web Browser
    # deskflow
    dig
    distrobox
    en-croissant
    freecad
    pkgsBundle.pkgs-stable.gimp
    ghidra
    google-chrome                         # Proprietary Web Browser
    gnome-sound-recorder
    gparted                               # Partition manager
    kicad
    libreoffice
    linux-wifi-hotspot                    # GUI hotspot creator
    lmstudio                              # GUI LLM interface
    mission-center
    mission-planner
    musescore
    nemo                                  # file manager
    nwg-look                              # GTK Config editor
    obsidian                              # Notetaking software
    opencode
    # orca-slicer                           # 3D Printer Slicer
    pavucontrol                           # pulseaudio volume controle (GUI)
    prismlauncher                         # minecraft launcher
    pkgsBundle.pkgs-stable.qalculate-gtk                         # calculator
    qpwgraph                              # Audio Routing Software
    # reaper
    remmina                               # RDP Client
    rpi-imager
    pkgsBundle.pkgs-stable.rustdesk
    vcv-rack
    viewnior                              # Image Viewer
    wdisplays
    winboat

    # CLI utils
    inputs.alejandra.defaultPackage.${myOptions.system}
    alsa-utils
    bitwise                               # cli tool for bit / hex manipulation
    bleachbit                             # cache cleaner
    bluetuith                             # TUI for bluetooth connections
    bluez                                 # Bluetooth audio tools
    bluez-tools                           # Bluetooth audio tools
    busybox                               # unused tools, remove if not needed for a while
    caligula                              # TUI iso flasher
    cliphist                              # clipboard manager
    cloc
    cmatrix
    ddcutil                               # Screen brightness
    devenv
    direnv
    docker
    dust
    entr                                  # perform action when file change
    entropy
    eza                                   # ls replacement
    fastfetch                             # Fetch program
    fd                                    # find replacement
    ffmpeg
    file                                  # show file information 
    file                                  # Show filetype
    foot                                  # Terminal Emulator
    fzf
    gettext                               # Translation Tools
    gh
    git                                   # Version Controll
    git-lfs
    gtrash                                # rm replacement, put deleted files in system trash
    gtt                                   # google translate TUI
    hexdump
    imv                                   # Image Viewer
    iperf3                                # Client to Client bandwidth tester
    jq jqp                                # JSON Tools
    killall
    lavat
    libcaca
    libnotify
    localsend
    lux                                   # Video Downloader
    mediainfo                             # Video file info
    mpv                                   # vide player
    ncdu                                  # disk space
    nh                                    # Usefull Nix Tools
    nitch                                 # systhem fetch util
    nix-prefetch-github
    nixos-generators
    nixpkgs-review                        # Used to review nixpkgs pr's
    nmap                                  # Network Scanning Tool
    ntfs3g                                # NTFS drivers?
    openssl
    osc                                   # Remote clipboard
    pamixer
    playerctl                             # controller for media players
    poweralertd
    qlcplus                               # Open Source DMX Controller
    ripgrep                               # grep replacement
    scope-tui                             # Terminal Oscilloscope
    ser2net                               # Serial connections over IP
    speedtest-cli                         # Internet Speedtesting tool
    stress                                # Benchmark workload generator
    tmux                                  # Terminal Multiplexer
    todo                                  # cli todo list
    # toipe                                 # typing test in the terminal
    tree                                  # Show file tree
    ttyper
    udiskie
    unzip
    usbip-ssh                             # USB Port over SSH
    valgrind                              # c memory analyzer
    w3m
    waypaper
    waypipe
    wayvnc
    wev
    wgcf
    wget
    wiremix                               # 
    wl-clipboard                          # clipoard utils for wayland (wl-copy, wl-paste)
    xdg-utils
    xxd
    yazi                                  # terminal file manager
    yt-dlp
    zenity
    zip
    zram-generator
    zsh-fzf-tab

    # Background stuff
    python315

    # Games
    ## Utils
    # winetricks
    protonplus

    ## Cli games
    _2048-in-terminal
    vitetris
    nethack

    ## Emulation
    dosbox-x
    sameboy
    snes9x
    # cemu
    dolphin-emu
    pkgsBundle.pkgs-unstable.eden
  ];

  fonts.packages = with pkgs; [
    pkgsBundle.pkgs-old.nerdfonts
    (pkgsBundle.pkgs-old.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    jetbrains-mono
    noto-fonts
    # noto-fonts-emoji
    # twemoji-color-font
    font-awesome
    powerline-fonts
    powerline-symbols
    # (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
  ] ++ (builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts));
}
