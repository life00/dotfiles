{
  pkgs,
  ...
}:
let
  usbguard-gui = pkgs.callPackage ../pkgs/usbguard-gui { };
in
{
  # all user packages
  home.packages = with pkgs; [
    # cli utilities
    age
    cava
    entr
    eza
    fd
    figlet
    fzf
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
    wget
    yt-dlp
    unzip
    exiftool
    brightnessctl
    libnotify
    bat
    starship
    zoxide
    libqalculate

    # development
    docker
    docker-compose
    cargo
    gcc
    go
    gnumake
    rustc
    zig
    uv
    ruff
    poetry
    nodejs
    pnpm
    yarn
    opencode
    alacritty
    git

    # media
    ffmpeg
    mpv
    ncmpcpp
    pavucontrol
    playerctl

    # latex
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

    # python/R/octave/quarto envs: notebooks.nix

    # gui apps
    chromium
    gimp
    libreoffice
    obs-studio
    virt-manager
    sioyek
    thunar
    imv

    # ai
    aichat

    # desktop and daemon apps
    usbguard-notifier
    usbguard-gui
    opensnitch-ui
    khal
    mpd
    bottom
    lf
    networkmanagerapplet
    xdg-desktop-portal-wlr

    # window manager
    waybar
    grim
    slurp
    wl-clipboard

    # editor
    nixfmt
    statix
    nil

    # comment out due to conflicts with program.{delta,neovim}
    # delta
    # neovim
    # rofi
  ];
}
