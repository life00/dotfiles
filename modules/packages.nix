{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # CLI utilities
    age
    libargon2
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
    imagemagick
    mpc
    fastfetch
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
    rustc
    zig
    uv

    # python
    python3
    poetry

    # node
    nodejs
    pnpm
    yarn

    # media
    ffmpeg
    mpv
    ncmpcpp
    pipewire
    pavucontrol
    playerctl

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
    python3.pkgs.jupyterlab
    python3.pkgs.ipykernel
    python3.pkgs.matplotlib
    python3.pkgs.pandas
    python3.pkgs.seaborn
    python3.pkgs.numpy
    python3.pkgs.scipy

    # GUI apps
    chromium
    gimp
    libreoffice
    obs-studio
    virt-manager
    syncthing
    sioyek
    qalculate-gtk
    thunar
    imv

    # ai
    ollama
    aichat

    # system tools
    btrfs-progs
    cryptsetup
    curl
    lsof
    unzip
    duperemove
    exiftool
    firewalld
    brightnessctl
    networkmanager
    opensnitch
    opensnitch-ui
    rofi
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
  ];

  programs.nix-ld.enable = true;
}
