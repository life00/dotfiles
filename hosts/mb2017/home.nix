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
  # omp itself is stubbed by an overlay in default.nix
  xdg.configFile."omp/nix.yml".enable = lib.mkForce false;

  # opencode config
  programs.opencode = {
    enable = true;
    settings = {
      formatter = true;
      plugins = [
        "ponytail@git+https://github.com/DietrichGebert/ponytail.git#v4.13.0"
      ];
    };
    cli = {
      theme = {
        name = "catppuccin-macchiato";
        mode = "dark";
      };
      keybinds = {
        leader = "space";
        "agent.cycle" = "tab";
        "session.tab.next" = "ctrl+tab,alt+down,shift+l";
        "session.tab.previous" = "ctrl+shift+tab,alt+up,shift+h";
        "session.child.first" = "ctrl+shift+down";
        "session.child.next" = "ctrl+shift+right";
        "session.child.previous" = "ctrl+shift+left";
        "session.parent" = "ctrl+shift+up";
      };
      leader.timeout = 5000;
      tabs = {
        mode = "on";
        indicators = "status";
      };
      plugins = [
        {
          package = "vimcode@git+https://github.com/oribarilan/vimcode.git#v0.19.2";
          options.experimentalV2Leader = "space";
        }
      ];
    };
  };
  # opencode rewrites cli.json from the TUI, which replaces the HM symlink
  xdg.configFile."opencode/cli.json".force = true;
  # its port writes the v1 tui.json theme; the theme is set in cli above
  catppuccin.opencode.enable = false;
  programs.zsh.shellAliases.oc = "opencode";

  # treesitter parser builds (cc, node for grammar.js) and markdown-preview's `yarn install`;
  # on mb2020 these come from home/packages.nix
  programs.neovim.extraPackages = with pkgs; [
    gcc
    nodejs
    yarn
  ];

  # Intel ACPI names instead of Apple Silicon's macsmc-battery / kbd_backlight
  programs.waybar.settings.mainBar.battery.bat = lib.mkForce "BAT0";
  # same priority as home/desktop.nix's mkOptionDefault, else these two replace every binding
  wayland.windowManager.sway.config.keybindings = lib.mkOptionDefault {
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
