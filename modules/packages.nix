{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # CLI utilities
    age
    argon2
    bat
    cava
    entr
    eza
    fd
    figlet
    fzf
    git
    gnupg
    gnuplot
    jq
    ImageMagick
    mpc
    neofetch
    opus-tools
    pandoc
    plantuml
    ripgrep
    signify
    unar
    usbguard
    usbguard-notifier
    wget
    yt-dlp
    zoxide
    zsh
    dash

    # development
    cargo
    gcc
    go
    gnumake
    rust
    rust-src
    zig
    uv

    # python
    python3
    python311
    poetry

    # node
    nodejs
    nodePackages.npm
    yarn

    # media
    ffmpeg
    mpv
    ncmpcpp
    pipewire
    pipewire-alsa
    pipewire-jack
    pipewire-pulse
    pavucontrol
    playerctl
    pulseaudio

    # docs / latex (full set from backup)
    texlivePackages.biblatex
    texlivePackages.biblatex-apa
    texlivePackages.biblatex-iso690
    texlivePackages.babel-ukrainian
    texlivePackages.babel-russian
    texlivePackages.blindtext
    texlivePackages.biber
    texlivePackages.chngcntr
    texlivePackages.csvsimple
    texlivePackages.cyrillic
    texlivePackages.fbox
    texlivePackages.floatrow
    texlivePackages.forest
    texlivePackages.glossaries
    texlivePackages.gobble
    texlivePackages.inlinedef
    texlivePackages.lh
    texlivePackages.makecell
    texlivePackages.ninecolors
    texlivePackages.paratype
    texlivePackages.pgf-pie
    texlivePackages.pgfplots
    texlivePackages.preprint
    texlivePackages.standalone
    texlivePackages.tabularray
    texlivePackages.tex-gyre
    texlivePackages.texcount
    texlivePackages.todonotes
    texlivePackages.xindy
    latexmk

    # R + packages
    R
    rPackages.dplyr
    rPackages.ggplot2
    rPackages.knitr
    rPackages.rmarkdown
    rPackages.readxl
    rPackages.Rcpp
    rPackages.styler
    rPackages.car
    rPackages.vcd
    rPackages.zoo
    rPackages.here
    rPackages.usethis
    rPackages.IRkernel

    # science
    quarto
    jupyterlab
    python311Packages.ipykernel
    python311Packages.matplotlib
    python311Packages.pandas
    python311Packages.seaborn
    python311Packages.numpy
    python311Packages.scipy

    # GUI apps
    chromium
    gimp
    libreoffice
    obs-studio
    virt-manager
    syncthing
    sioyek
    qalculate
    Thunar
    imv

    # ai
    ollama
    aichat

    # system tools
    btrfs-progs
    cryptsetup
    duperemove
    firewalld
    light
    networkmanager
    opensnitch
    rofi-wayland
    rofi-themes
    alacritty
    waybar
    sway
    swaylock
    swayidle
    grim
    slurp
    wl-clipboard
    dunst
    libnotify

    # bottom (system monitor)
    bottom
  ];

  # texlive scheme for thesis + cyrillic
  texlivePackages = pkgs.texlivePackages;
}
