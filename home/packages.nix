{ pkgs, lib, config, inputs, ... }: {
  # user packages (not system-wide)
  home.packages = with pkgs; [
    # CLI utilities (already in system packages but ensure available)
    age
    bat
    delta
    eza
    fd
    fzf
    jq
    ripgrep
    signify
    unar
    wget
    yt-dlp
    zoxide

    # dev tools
    cargo
    go
    rust
    zig
    uv

    # python packages
    python3
    python311
    poetry

    # node
    nodejs
    nodePackages.npm
    yarn

    # media
    mpc
    ncmpcpp
    pipewire
    pipewire-alsa
    pipewire-jack
    pipewire-pulse
    pavucontrol
    playerctl

    # docs / latex
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

    # R packages
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

    # AI
    ollama
    aichat

    # system
    bottom
    light
    rofi-wayland
    waybar
    sway
    swaylock
    swayidle
    grim
    slurp
    wl-clipboard
    dunst
    libnotify

    # custom packages
    awecron
    getmusic

    # utils
    duperemove
    plantuml
    pandoc
    ImageMagick
    figlet
    neofetch
    khal
    cava
    lf
    starship
    qalculate
  ];

  # placeholders (commented out - enable when ready)
  # chromium configuration
  # programs.chromium = {
  #   enable = true;
  #   package = pkgs.chromium;
  #   # bookmarks, extensions, vimium config managed externally
  # };

  # syncthing
  # services.syncthing = {
  #   enable = true;
  #   dataDir = "${config.home.homeDirectory}/.cfg/syncthing";
  # };

  # opensnitch
  # programs.opensnitch = { enable = true; };
}