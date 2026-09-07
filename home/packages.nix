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

    # development
    cargo
    gcc
    go
    gnumake
    rustc
    zig
    uv
    python3
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

    # R packages
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

    # data science
    quarto
    python3.pkgs.jupyterlab
    python3.pkgs.ipykernel
    python3.pkgs.matplotlib
    python3.pkgs.pandas
    python3.pkgs.seaborn
    python3.pkgs.numpy
    python3.pkgs.scipy

    # gui apps
    chromium
    gimp
    libreoffice
    obs-studio
    virt-manager
    sioyek
    qalculate-gtk
    thunar
    imv

    # ai
    aichat

    # desktop and daemon apps
    rofi
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

    # comment out due to conflicts with program.{delta,neovim}
    # delta
    # neovim
  ];
}
