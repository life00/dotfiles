{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  # Desktop dotfiles (rofi, dunst) — referenced, not inlined.
  # sway, swaylock + waybar configs are generated natively below; sway
  # wallpapers moved to /wallpapers (referenced as an absolute store path, so
  # no XDG env dependency).
  home.file = {
    # waybar config + style are Nix-native (`programs.waybar` below), not
    # dotfile symlinks — the raw dotfiles were removed (dotfiles/waybar/).
    ".cfg/rofi/config".source = ../dotfiles/rofi/config;
    ".cfg/rofi/config.rasi".source = ../dotfiles/rofi/config.rasi;
    ".cfg/rofi/catppuccin-macchiato.rasi".source = ../dotfiles/rofi/catppuccin-macchiato.rasi;
    ".cfg/rofi/bin".source = ../dotfiles/rofi/bin;
    ".cfg/dunst/dunstrc".source = ../dotfiles/dunst/dunstrc;
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
          {
            command = "fullscreen toggle";
            criteria = {
              app_id = "mpv";
            };
          }
          {
            command = "move scratchpad";
            criteria = {
              app_id = "alacritty-float";
            };
          }
          {
            command = "scratchpad show";
            criteria = {
              app_id = "alacritty-float";
            };
          }
          {
            command = "focus_on_window_activation none";
            criteria = {
              app_id = "brave-browser";
            };
          }
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

      # Colors use the official catppuccin macchiato $color vars — defined by the
      # auto-included `catppuccin.sway` theme (catppuccin/macchiato include in
      # extraConfigEarly). The old custom hex (#1A1826, #C9CBFF, #575268 …
      # ) are snapped to the nearest palette var.
      colors = {
        background = "$crust";
        focused = {
          border = "$lavender";
          background = "$crust";
          text = "$text";
          indicator = "$sapphire";
          childBorder = "$lavender";
        };
        focusedInactive = {
          border = "$surface1";
          background = "$crust";
          text = "$text";
          indicator = "$surface1";
          childBorder = "$surface1";
        };
        unfocused = {
          border = "$mantle";
          background = "$crust";
          text = "$text";
          indicator = "$mantle";
          childBorder = "$crust";
        };
        urgent = {
          border = "$maroon";
          background = "$crust";
          text = "$text";
          indicator = "$maroon";
          childBorder = "$maroon";
        };
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
        "*" = {
          bg = "${../wallpapers}/tux.png fill";
        };
        "eDP-1" = {
          resolution = "2560x1600";
          position = "0,0";
        };
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

      seat.seat0 = {
        hide_cursor = "10000";
      };

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
        "f5+Shift" =
          "exec brightnessctl -d kbd_backlight set 1%- && notify-send \"keyboard brightness decreased\"";
        "f6+Shift" =
          "exec brightnessctl -d kbd_backlight set 1%+ && notify-send \"keyboard brightness increased\"";
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

  # Waybar — Nix-native via `programs.waybar`, rendered to ~/.cfg/waybar/{config,style.css}.
  # `settings` is the per-module JSON (launched by the sway `bars` entry above).
  # `style` is a CSS string that references catppuccin `@palette` vars; the
  # `catppuccin.waybar` module (home/theme.nix) prepends the `@import` that
  # defines them, so flavor/accent drives the whole bar.
  programs.waybar = {
    enable = true;
    settings.mainBar = {
      bar_id = "bar-0";
      ipc = true;
      height = 27; # Waybar height (to be removed for auto height)
      modules-left = [
        "sway/workspaces"
        "sway/window"
        "sway/mode"
      ];
      modules-center = [
        "mpd"
        "pulseaudio"
        "disk"
        "memory"
        "temperature"
        "cpu"
        "network"
        "battery"
      ];
      modules-right = [
        "custom/updater"
        "backlight"
        "tray"
        "sway/language"
        "clock"
      ];
      # margin was 12 for both without hide/show mode
      margin-left = 0;
      margin-right = 0;
      margin-bottom = 0;

      "sway/workspaces" = {
        disable-scroll = false;
        all-outputs = true;
        format = "{icon}";
        format-icons = {
          "1" = "󱓞";
          "2" = "";
          "3" = "";
          "4" = "󰚇";
          "high-priority-named" = [
            "1"
            "2"
            "3"
            "4"
            "8"
            "9"
            "10"
          ];
          urgent = "";
          focused = "";
          default = "";
        };
      };
      "sway/window" = {
        format = " {title}";
        max-length = 11;
        rewrite = {
          "" = "desktop";
        };
      };
      "sway/mode" = {
        format = "󰕮 {}";
      };
      mpd = {
        # format = "{elapsedTime:%M:%S}/{totalTime:%M:%S} {stateIcon}";
        format = "{stateIcon}";
        format-disconnected = "󰝛";
        format-stopped = "󰝛";
        on-click = "mpc toggle";
        on-click-right = "alacritty --class alacritty-float -e ncmpcpp";
        smooth-scrolling-threshold = "0.1";
        on-scroll-down = "mpc seek +1%";
        on-scroll-up = "mpc seek -1%";
        interval = 10;
        state-icons = {
          paused = "󰝛";
          playing = "󰝚";
        };
        tooltip-format = "MPD (connected)";
        tooltip-format-disconnected = "MPD (disconnected)";
      };
      pulseaudio = {
        scroll-step = 0.1;
        reverse-scrolling = true;
        format = "{icon} {volume}% {format_source}";
        format-bluetooth = "{volume}% {icon} {format_source}";
        format-bluetooth-muted = "󰆪 {icon} {format_source}";
        format-muted = "󰆪 {format_source}";
        format-source = " {volume}%";
        format-source-muted = "";
        format-icons = {
          headphone = "";
          hands-free = "󰂑";
          headset = "󰂑";
          phone = "";
          portable = "";
          car = "";
          default = [
            ""
            ""
            ""
          ];
        };
        on-click = "pavucontrol";
      };
      disk = {
        interval = 60;
        format = "󰋊 {percentage_used}%";
        on-click = "alacritty --class alacritty-float -e btm -e --default_widget_type=disk";
      };
      memory = {
        interval = 5;
        format = " {}%";
        on-click = "alacritty --class alacritty-float -e btm -e --default_widget_type=mem";
      };
      temperature = {
        interval = 10;
        critical-threshold = 80;
        format = "{icon} {temperatureC}°C";
        format-icons = [
          ""
          ""
          ""
        ];
        on-click = "alacritty --class alacritty-float -e btm -e --default_widget_type=temp";
      };
      cpu = {
        interval = 5;
        format = "󰍛 {usage}%";
        tooltip = false;
        on-click = "alacritty --class alacritty-float -e btm -e --default_widget_type=cpu";
        on-click-right = "alacritty --class alacritty-float -e btm -e --default_widget_type=proc";
      };
      network = {
        # interface = "wlp2*"; # (Optional) To force the use of this interface
        format = " {bandwidthUpBytes}  {bandwidthDownBytes}";
        format-disconnected = ""; # An empty format will hide the module.
        tooltip-format = "Connected";
        tooltip-format-disconnected = "Disconnected";
        interval = 5;
        on-click = "alacritty --class alacritty-float -e btm -e --default_widget_type=net";
      };
      battery = {
        bat = "BAT0";
        interval = 30;
        states = {
          fine = 80;
          caution = 60;
          warning = 40;
          critical = 20;
        };
        format = "{icon}  {capacity}%";
        format-icons = [
          ""
          ""
          ""
          ""
          ""
        ];
        format-full = "󰉁";
        format-charging = "󰛕 {capacity}%";
        tooltip-format-full = "Plugged";
        on-click = "alacritty --class alacritty-float -e btm -e --default_widget_type=battery";
      };
      "custom/updater" = {
        interval = 60;
        tooltip = true;
        exec = "echo 󰏗 $(cat /home/user/etc/cache/updater/count)";
        on-click-right = "/home/user/.cfg/awecron/updater/update";
        on-click = "alacritty --class alacritty-float -e bash -c 'if doas nixos-rebuild switch --impure --flake /home/user/dev/src/nix#mb2017; then printf 0 > /home/user/etc/cache/updater/count; read -n1; fi'";
      };
      backlight = {
        format = "{icon} {percent}%";
        format-icons = [
          "󰃞"
          "󰃠"
        ];
        on-scroll-down = "light -A 1";
        on-scroll-up = "light -U 1";
      };
      tray = {
        spacing = 10;
      };
      "sway/language" = {
        format = " {short}";
        on-click = "swaymsg input '*' xkb_switch_layout next";
        min-length = 4;
      };
      clock = {
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        format = " {:%H:%M}";
        format-alt = "󰃰 {:%A, %B %d}";
        on-click-right = "alacritty --class alacritty-float -e khal interactive";
      };
    };

    # All colors are catppuccin macchiato @palette vars
    style = ''
      * {
        border: none;
        font-family: JetBrainsMono Nerd Font;
        font-size: 13px;
      }

      window#waybar {
        background-color: transparent;
        /*background-color: @surface0;*/
        border-bottom: 0px solid transparent;
        color: @text;
        transition-property: background-color;
        transition-duration: .5s;
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      #workspaces,
      #mode,
      #disk,
      #cpu,
      #memory,
      #temperature,
      #custom-bemenu,
      #custom-media,
      #custom-fans,
      #clock,
      #idle_inhibitor,
      #window,
      #language,
      #pulseaudio,
      #backlight,
      #battery,
      #custom-updater,
      #network,
      #mpd,
      #tray {
        background-color: @mantle;
        padding: 0 10px;
        margin: 2px 4px 5px 4px;
        border: 1px solid @accent;
        border-radius: 90px;
        background-clip: padding-box;
      }

      #workspaces button {
        padding: 0 5px;
        min-width: 20px;
        color: @surface1;
      }

      /* This is supposed to remove that white color when hovering over the buttons but it simply does not work.*/
      #workspaces button:hover {
        background-color: @mantle;
      }

      #workspaces button.focused {
        color: @sapphire;
      }

      #workspaces button.urgent {
        color: @red;
      }

      #cpu {
        color: @red;
      }

      #memory {
        color: @pink;
      }

      #temperature {
        color: @maroon;
      }

      #temperature.critical {
        background-color: @red;
        color: @base;
      }

      #pulseaudio {
        color: @teal;
      }

      #custom-updater {
        color: @mauve;
      }

      #custom-media {
        background-color: @green;
        color: @base;
      }

      #clock {
        color: @accent;
      }

      #idle_inhibitor {
        color: @text;
      }

      #idle_inhibitor.activated {
        background-color: @text;
        color: @base;
      }

      #language {
        color: @flamingo;
      }

      #backlight {
        color: @peach;
      }

      #battery {
        color: @green;
      }

      #battery.charging, #battery.full {
        color: @teal;
      }

      #battery.fine:not(.charging) {
          color: @yellow;
      }

      #battery.caution:not(.charging) {
          color: @peach;
      }

      #battery.warning:not(.charging) {
          color: @maroon;
      }

      #battery.critical:not(.charging) {
          color: @red;
      }

      #mpd.playing {
        color: @pink;
      }
      #mpd.paused {
        color: @maroon;
      }

      #mpd.stopped {
        color: @red;
      }

      #mpd.disconnected {
        color: @red;
      }

      #network {
        color: @sky;
      }

      #network.linked {
       color: @green;
      }

      #network.disconnected {
          color: @red;
      }

      #mode {
        color: @red;
      }

      #disk {
        color: @yellow;
      }

      #window {
        color: @blue;
      }
    '';
  };

  # swaylock — Nix-native via `programs.swaylock`, rendered to
  # ~/.cfg/swaylock/config from xdg.configFile. The palette comes from the
  # catppuccin port (catppuccin.swaylock in home/theme.nix); the font and the
  # lock-screen wallpaper are hardcoded here (merged into the generated
  # settings). The wallpaper is the absolute store path to dark-cat.png (same
  # trick as the sway `output.bg` — no XDG env dependency under greetd). The
  # binary comes from the system `programs.sway` module (modules/packages.nix),
  # so the HM package is null.
  programs.swaylock = {
    enable = true;
    package = lib.mkForce null;
    settings = {
      font = "JetBrainsMono Nerd Font";
      font-size = 28;
      image = "${../wallpapers}/dark-cat.png";
      scaling = "fill";
      ignore-empty-password = true;
      indicator-y-position = 740;
      indicator-caps-lock = true;
    };
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
