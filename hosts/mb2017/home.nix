{
  lib,
  pkgs,
  ...
}:
let
  usbguard-gui = pkgs.callPackage ../../pkgs/usbguard-gui { };
  kbd =
    dir:
    "exec notify-send -i input-keyboard -h string:x-dunst-stack-tag:kbl -h int:value:$(brightnessctl -d '*kbd_backlight' set 2%${dir} | grep -o '[0-9]*%' | tr -d %) \"keyboard brightness ${
      if dir == "+" then "increased" else "decreased"
    }\"";
in
{
  # notebooks: Asahi-only ORT wheel (aarch64), R/Python/quarto stack
  # packages: replaced by the trimmed list below
  disabledModules = [
    ../../home/notebooks.nix
    ../../home/packages.nix
  ];

  programs.claude-code.enable = lib.mkForce false;

  # treesitter parser builds (cc, node for grammar.js) and markdown-preview's `yarn install`;
  # on mb2020 these come from home/packages.nix
  programs.neovim.extraPackages = with pkgs; [
    gcc
    nodejs
    yarn
  ];

  # Intel ACPI names instead of Apple Silicon's macsmc-battery / kbd_backlight
  programs.waybar.settings.mainBar.battery.bat = lib.mkForce "BAT0";
  wayland.windowManager.sway.config.keybindings = {
    "--locked Shift+XF86MonBrightnessDown" = lib.mkForce (kbd "-");
    "--locked Shift+XF86MonBrightnessUp" = lib.mkForce (kbd "+");
  };

  # home/packages.nix minus dev toolchains, latex, heavy gui, ai
  home.packages = with pkgs; [
    # cli utilities
    age
    cava
    entr
    eza
    fd
    fzf
    gnupg
    jq
    imagemagick
    mpc
    fastfetch
    opus-tools
    pandoc
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
    git
    nixfmt

    # media
    ffmpeg
    mpv
    ncmpcpp
    pavucontrol
    playerctl

    # gui apps
    libreoffice
    sioyek
    thunar
    imv

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
  ];
}
