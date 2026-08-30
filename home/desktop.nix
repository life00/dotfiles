{ pkgs, lib, config, inputs, ... }: {
  # ponytail: sway is now Nix-native via `wayland.windowManager.sway` (this HM
  # rev dropped `programs.sway`; the sway module moved under wayland/).
  # The sway BINARY stays system-wide (`programs.sway.enable` in
  # modules/packages.nix) — greetd's `--cmd sway` doesn't change — so the HM
  # `package` is forced null and HM only owns the generated config
  # (~/.cfg/sway/config). waybar/rofi/dunst/swaylock stay raw dotfiles.

  # packages whose config is NOT a raw dotfile (or that just install a binary)
  # slewidle comes from services.swayidle below; swayidle removed from this list.
  home.packages = with pkgs; [
    swaylock # used by swayidle/bindgesture; config from dotfiles/
    waybar # started via sway's `bar { swaybar_command waybar }`
    dunst # launched by sway startup; config from dotfiles/
    grim
    slurp
    wl-clipboard
    networkmanagerapplet # `exec nm-applet --indicator` in sway startup
    xdg-desktop-portal-wlr
  ];

  # desktop dotfiles (waybar, rofi, dunst, swaylock) — referenced, not inlined.
  # sway config is generated natively below; sway wallpapers moved to /wallpapers
  # (referenced as an absolute store path, so no XDG env dependency).
  home.file = {
    ".cfg/waybar/config".source = ../dotfiles/waybar/config;
    ".cfg/waybar/style.css".source = ../dotfiles/waybar/style.css;
    ".cfg/rofi/config".source = ../dotfiles/rofi/config;
    ".cfg/rofi/config.rasi".source = ../dotfiles/rofi/config.rasi;
    ".cfg/rofi/catppuccin-macchiato.rasi".source = ../dotfiles/rofi/catppuccin-macchiato.rasi;
    ".cfg/rofi/bin".source = ../dotfiles/rofi/bin;
    ".cfg/dunst/dunstrc".source = ../dotfiles/dunst/dunstrc;
    ".cfg/swaylock/config".source = ../dotfiles/swaylock/config;
  };

  # Sway — fully native config. Colors are Catppuccin Macchiato; the wallpaper
  # is the absolute store path `/wallpapers/tux.png` (the old
  # `$XDG_CONFIG_HOME/sway/wallpapers/…` broke because greetd's sway session
  # has an unset XDG_CONFIG_HOME). `systemd.enable` stays on so
  # sway-session.target→graphical-session.target runs services.swayidle.
  wayland.windowManager.sway = {
    enable = true;
    # ponytail: the binary comes from the NixOS `programs.sway` module
    # (modules/packages.nix), which greetd launches. HM package = null →
    # checkConfig auto-off; validated manually with `sway --validate` instead.
    package = lib.mkForce null;
    systemd = {
      enable = true;
      # host runs dbus-broker (services.dbus.implementation = "broker"): the
      # session-startup line must use `import-environment`, not
      # dbus-update-activation-environment (classic dbus).
      dbusImplementation = "broker";
    };

    config = {
      modifier = "Mod4";
      terminal = "alacritty";
      # -terminal alacritty: terminal apps from the run combi launch in
      # alacritty (matches the former dotfile $menu).
      menu = "rofi -terminal alacritty -show combi -combi-modes drun#run -modes combi";
      fonts = {
        names = [ "JetBrainsMono NFM" ];
        size = 11.0;
      };

      window = {
        titlebar = false; # default_border pixel 1
        border = 1;
        hideEdgeBorders = "smart";
        commands = [
          { command = "fullscreen toggle"; criteria = { app_id = "mpv"; }; }
          { command = "move scratchpad"; criteria = { app_id = "alacritty-float"; }; }
          { command = "scratchpad show"; criteria = { app_id = "alacritty-float"; }; }
          { command = "focus_on_window_activation none"; criteria = { app_id = "brave-browser"; }; }
        ];
      };

      floating = {
        criteria = [
          { app_id = "pavucontrol"; }
          { app_id = "nm-connection-editor"; }
          { app_id = "alacritty-float"; }
          { app_id = "opensnitch_ui"; }
          { instance = "r_x11"; }
        ];
      };

      colors = {
        background = "#1A1826";
        focused = { border = "#b7bdf8"; background = "#1A1826"; text = "#C9CBFF"; indicator = "#7dc4e4"; childBorder = "#b7bdf8"; };
        focusedInactive = { border = "#575268"; background = "#1A1826"; text = "#C9CBFF"; indicator = "#575268"; childBorder = "#575268"; };
        unfocused = { border = "#1E1E2E"; background = "#1A1826"; text = "#C9CBFF"; indicator = "#1E1E2E"; childBorder = "#1A1826"; };
        urgent = { border = "#F28FAD"; background = "#1A1826"; text = "#C9CBFF"; indicator = "#F28FAD"; childBorder = "#F28FAD"; };
      };

      gaps = {
        inner = 0;
        left = 0;
        right = 0;
        top = 0;
        bottom = 0;
        smartBorders = "on";
      };

      output = {
        "*" = { bg = "${../wallpapers}/tux.png fill"; };
        "eDP-1" = { resolution = "2560x1600"; position = "0,0"; };
      };

      input = {
        "*" = {
          tap = "enabled";
          natural_scroll = "enabled";
        };
        "1452:833:Apple_SPI_Keyboard" = {
          xkb_layout = "us,ru";
          xkb_options = "caps:escape_shifted_capslock";
        };
        "1452:591:hfd.cn_USB_DEVICE" = {
          xkb_layout = "custom-mech";
          xkb_options = "caps:escape_shifted_capslock";
        };
      };

      seat.seat0 = { hide_cursor = "10000"; };

      # Defaults from the HM module are merged per-key: overrides, additions
      # and nulls (removals). Wrapped in mkOptionDefault so the module's
      # native default bindings (workspace numbers, focus/move keys,
      # Mod4+Return, Mod4+q, …) are KEPT — a flat keybindings attrset would
      # silently replace them all (see docs/home-manager.md).
      keybindings = lib.mkOptionDefault {
        # launcher on space (d is freed)
        "Mod4+space" = "exec ${config.wayland.windowManager.sway.config.menu}";
        "Mod4+d" = null;
        # focus/floating toggle on Alt
        "Mod1+space" = "focus mode_toggle";
        "Mod1+Shift+space" = "floating toggle";
        "Mod4+Shift+space" = null;
        # floating terminal
        "Mod4+Shift+Return" = "exec alacritty --class alacritty-float";
        # scratchpad on m (minus combos removed)
        "Mod4+m" = "scratchpad show";
        "Mod4+Shift+m" = "move scratchpad";
        "Mod4+minus" = null;
        "Mod4+Shift+minus" = null;
        # workspace prev/next
        "Mod4+p" = "workspace prev";
        "Mod4+n" = "workspace next";
        # reload on Shift+r (Shift+c freed)
        "Mod4+Shift+r" = "reload";
        "Mod4+Shift+c" = null;
        # exit sway on Shift+q (as the former config); the module default
        # exit-on-Shift+e is removed. Mod4+q (kill) comes from the former
        # config too — this module binds kill to Mod4+Shift+q only.
        "Mod4+q" = "kill";
        "Mod4+Shift+q" = "exec swaynag -t warning -m 'Exit Sway?' -B 'Yes, exit sway' 'swaymsg exit'";
        "Mod4+Shift+e" = null;
        # commented-out defaults in the old config
        "Mod4+a" = null;
        "Mod4+s" = null;
        "Mod4+w" = null;
        "Mod4+e" = null;
        "Mod4+r" = null;

        # Fn keys (was the NON DEFAULT block)
        "f1" = "exec mpc prev && notify-send \"playing previous song in queue\"";
        "f2" = "exec mpc toggle && notify-send \"toggled current audio stream\"";
        "f3" = "exec mpc next && notify-send \"playing next song in queue\"";
        "f4" = "exec /home/user/.bin/scsh";
        "f5" = "exec brightnessctl set 1%- && notify-send \"display brightness decreased\"";
        "f6" = "exec brightnessctl set 1%+ && notify-send \"display brightness increased\"";
        "f5+Shift" = "exec brightnessctl -d kbd_backlight set 1%- && notify-send \"keyboard brightness decreased\"";
        "f6+Shift" = "exec brightnessctl -d kbd_backlight set 1%+ && notify-send \"keyboard brightness increased\"";
        "f7" = "exec pactl set-sink-volume 0 -1% && notify-send \"volume decreased\"";
        "f8" = "exec pactl set-sink-volume 0 +1% && notify-send \"volume increased\"";
        "f7+Shift" = "exec pactl set-sink-mute 0 1 && notify-send \"audio output muted\"";
        "f8+Shift" = "exec pactl set-sink-mute 0 0 && notify-send \"audio output unmuted\"";
        "f9" = "exec swaymsg input \"*\" xkb_switch_layout next && notify-send \"keyboard layout changed\"";
        "f10" = "exec /home/user/.bin/powermenu";
        "f11" = "exec /home/user/.bin/killer";
      };

      startup = [
        { command = "usbguard-notifier"; }
        { command = "nm-applet --indicator"; }
        { command = "dunst"; }
        # mpd runs as a systemd USER service (home/media.nix), not a sway exec —
        # starting it here would double-launch. Volume default kept.
        { command = "mpc volume 50"; }
        { command = "/bin/sh -c \"pkill -15 opensnitch-ui; opensnitch-ui\""; }
        # make brave work from other user
        { command = "chmod -R g+rwx /run/user/"; }
      ];

      bars = [
        {
          command = "${pkgs.waybar}/bin/waybar";
          position = "top";
          mode = "hide";
          hiddenState = "hide";
          extraConfig = "modifier Mod4";
        }
      ];
    };

    # Lines the HM module can't express: titlebar metrics + gesture bindings.
    # `include /etc/sway/config.d/*` dropped (native config replaces the default).
    extraConfig = ''
      titlebar_border_thickness 1
      titlebar_padding 1

      # gesture bindings
      bindgesture swipe:right workspace prev
      bindgesture swipe:left workspace next
      bindgesture swipe:down exec swaylock -f
      bindgesture swipe:up exec ${config.wayland.windowManager.sway.config.menu}
    '';
  };

  # swayidle as a systemd user service (was `exec swayidle -w …` in the dotfile).
  # The unit's PATH only contains bash, so commands use absolute store paths.
  # Binds to graphical-session.target, started via sway's sway-session.target.
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 120;
        command = "${pkgs.sway}/bin/swaymsg \"output * dpms off\"";
        resumeCommand = "${pkgs.sway}/bin/swaymsg \"output * dpms on\"";
      }
      {
        timeout = 130;
        command = "${pkgs.swaylock}/bin/swaylock -f";
        resumeCommand = "${pkgs.sway}/bin/swaymsg \"output * dpms on\"";
      }
    ];
    events.before-sleep = "${pkgs.swaylock}/bin/swaylock -f";
  };

  # XDG desktop portal (wlroots) for screen sharing / portal requests on sway.
  # D-Bus and xdg-desktop-portal normally activate the wlr backend, but we pin
  # the unit so it is available even before the wlr backend D-Bus name exists.
  systemd.user.services.xdg-desktop-portal-wlr = {
    Unit.Description = "XDG desktop portal for wlroots (sway)";
    Service = {
      ExecStart = "${pkgs.xdg-desktop-portal-wlr}/bin/xdg-desktop-portal-wlr";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "default.target" ];
  };
}