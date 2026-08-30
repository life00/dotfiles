{ pkgs, ... }:
{
  # ponytail: restored full package lists (was stripped to zsh+opencode for the
  # minimal install). Sway is provided by the `programs.sway` module below
  # (installs sway + foot), so it is NOT listed explicitly.
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

  # Sway at the NixOS system level (verified in locked nixpkgs rev
  # 9fbb54...: `programs.sway` module exists with `enable`/`package`/
  # `wrapperFeatures`/`extraPackages`; `extraConfig` is NOT an option here,
  # so the sway config lives in /etc/sway/config or ~/.config/sway/config).
  # `extraPackages` defaults to [ brightnessctl foot grim pulseaudio
  # swayidle swaylock wmenu ] — `foot` gives sway a working terminal.
  programs.sway.enable = true;

  # Run unpatched, dynamically-linked ELF binaries (AppImages, vendor
  # binaries). `programs.nix-ld` not `programs.ld` in pinned rev 9fbb54b.
  # Session vars NIX_LD / NIX_LD_LIBRARY_PATH + loader at
  # /run/current-system/sw/share/nix-ld/lib/ld.so. Default `libraries` covers
  # zlib, zstd, glibc/gcc-libs (stdenv.cc.cc), curl, openssl, xz, systemd...
  # Extend via programs.nix-ld.libraries if a specific binary needs more.
  programs.nix-ld.enable = true;
}
