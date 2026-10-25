{
  pkgs,
  lib,
  ...
}:
let
  usbguard-gui = pkgs.callPackage ../pkgs/usbguard-gui { };
  mindustry = pkgs.callPackage ../pkgs/mindustry { };
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
    ufetch
    opus-tools
    pandoc
    mermaid-cli
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
    poppler-utils

    # development
    docker
    docker-compose
    cargo
    clang
    (lib.hiPrio gcc)
    go
    gnumake
    rustc
    zig
    uv
    poetry
    nodejs
    pnpm
    yarn
    git
    nixfmt
    ruff
    pyright
    opentofu
    google-cloud-sdk

    # media
    ffmpeg
    mpv
    ncmpcpp
    pavucontrol
    playerctl

    # latex
    (texliveSmall.withPackages (
      ps: with ps; [
        babel-russian
        babel-ukrainian
        biber
        biblatex
        biblatex-apa
        biblatex-iso690
        blindtext
        chngcntr
        csvsimple
        cyrillic
        enumitem
        fbox
        floatrow
        fontawesome5
        forest
        glossaries
        gobble
        helvetic
        inlinedef
        latexmk
        lh
        makecell
        ninecolors
        paratype
        pgf-pie
        pgfplots
        preprint
        standalone
        tabularray
        tex-gyre
        texcount
        titlesec
        todonotes
        xindy
      ]
    ))

    # python/R/quarto envs: notebooks.nix

    # gui apps
    gimp
    libreoffice
    obs-studio
    virt-manager
    sioyek
    thunar
    imv
    wlvncc
    mindustry

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
    kitty.kitten
    networkmanagerapplet
    xdg-desktop-portal-wlr

    # window manager
    waybar
    grim
    slurp
    wl-clipboard
    wtype
    wooz

    # comment out due to conflicts with program.{delta,neovim}
    # delta
    # neovim
    # rofi
    # chromium
  ];
}
