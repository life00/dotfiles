{
  pkgs,
  ...
}:
{
  # COMPLETE user-scope manifest. Everything a logged-in user touches lives
  # here; modules/packages.nix holds only system/daemon/admin packages.
  # Deliberate duplication: some of these are ALSO installed by home-manager
  # config modules (programs.git, programs.mpv, programs.bottom, …) — listed
  # here anyway as the single explicit inventory. Do not prune as "redundant".
  # sway/swaylock/swayidle deliberately stay OUT (system modules/packages.nix
  # + HM programs.sway/ssl services.swayidle own those binaries; HM package
  # overrides are null in home/desktop.nix).
  home.packages = with pkgs; [
    # CLI utilities
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
    brightnessctl # sway F5/F6 bindings (home/desktop.nix)
    libnotify # notify-send in sway bindings

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
    sioyek
    qalculate-gtk
    thunar
    imv

    # ai
    aichat

    # desktop / daemon companions
    rofi
    usbguard-notifier
    opensnitch-ui
    bottom # config via programs.bottom (home/files.nix)
    lf # config is a raw dotfile (dotfiles/lf)
    networkmanagerapplet # `exec nm-applet` in sway startup
    xdg-desktop-portal-wlr

    # WM stack companions (merged from home/desktop.nix's home.packages)
    waybar
    dunst
    grim
    slurp
    wl-clipboard

    # HM-module-installed (single explicit inventory — see header comment)
    git
    bat
    opencode
    alacritty
    starship
    zoxide
    mpd

    # comment out due to conflicts with program.{delta,neovim}
    # delta
    # neovim
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
