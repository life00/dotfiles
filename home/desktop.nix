{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.rofi = {
    enable = true;
    terminal = "alacritty";
    location = "center";
    plugins = [
      pkgs.rofi-calc
      pkgs.rofi-emoji
    ];
    font = "JetBrainsMono Nerd Font 12";
    modes = [
      "run"
      "drun"
      "window"
      "calc"
      "emoji"
    ];
    extraConfig = {
      icon-theme = "ePapirus-Dark";
      show-icons = true;
      drun-display-format = "{icon} {name}";
      disable-history = false;
      hide-scrollbar = true;
      display-drun = " 󰀘  Apps ";
      display-run = " 󰵊  Run ";
      display-combi = " 󰵊  Run ";
      display-window = " 󰕰  Window";
      display-Network = " 󰤨  Network";
      sidebar-mode = false;
    };
  };

  services.dunst = {
    enable = true;
    settings = {
      global = {
        frame_width = 1;
        separator_color = "frame";
      };
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    package = lib.mkForce null;
    systemd = {
      enable = true;
      dbusImplementation = "broker";
    };

    config = {
      modifier = "Mod4";
      terminal = "alacritty";
      # FIXME: doesn't open the right menu
      menu = "rofi -terminal alacritty -show combi -combi-modes drun"; # run -modes combi
      fonts = {
        names = [ "JetBrainsMono NFM" ];
        size = 11.0;
      };

      window = {
        titlebar = false;
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
          { app_id = "python3"; }
          { instance = "r_x11"; }
        ];
      };

      # catppuccin.sway colors are automatically included
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
          xkb_layout = "us,ru";
          xkb_options = "caps:escape_shifted_capslock";
          natural_scroll = "enabled";
        };
      };

      seat.seat0 = {
        hide_cursor = "10000";
      };

      keybindings = lib.mkOptionDefault {
        # launcher on space
        "Mod4+space" = "exec ${config.wayland.windowManager.sway.config.menu}";
        "Mod4+d" = null;
        # focus/floating toggle
        "Mod1+space" = "focus mode_toggle";
        "Mod1+Shift+space" = "floating toggle";
        "Mod4+Shift+space" = null;
        # floating terminal
        "Mod4+Shift+Return" = "exec alacritty --class alacritty-float";
        # scratchpad
        "Mod4+m" = "scratchpad show";
        "Mod4+Shift+m" = "move scratchpad";
        "Mod4+minus" = null;
        "Mod4+Shift+minus" = null;
        # workspace prev/next
        "Mod4+p" = "workspace prev";
        "Mod4+n" = "workspace next";
        # reload
        "Mod4+Shift+r" = "reload";
        "Mod4+Shift+c" = null;
        # close window; exit sway
        "Mod4+q" = "kill";
        "Mod4+Shift+q" = "exec swaynag -t warning -m 'Exit Sway?' -B 'Yes, exit sway' 'swaymsg exit'";
        "Mod4+Shift+e" = null;

        # fn keys
        "XF86MonBrightnessDown" =
          "exec brightnessctl set 1%- && notify-send \"display brightness decreased\"";
        "XF86MonBrightnessUp" =
          "exec brightnessctl set 1%+ && notify-send \"display brightness increased\"";
        "Shift+XF86MonBrightnessDown" =
          "exec brightnessctl -d kbd_backlight set 2%- && notify-send \"keyboard brightness decreased\"";
        "Shift+XF86MonBrightnessUp" =
          "exec brightnessctl -d kbd_backlight set 2%+ && notify-send \"keyboard brightness increased\"";
        "XF86AudioLowerVolume" =
          "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%- && notify-send \"volume decreased\"";
        "XF86AudioRaiseVolume" =
          "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+ && notify-send \"volume increased\"";
        "Shift+XF86AudioLowerVolume" =
          "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ 1 && notify-send \"audio output muted\"";
        "Shift+XF86AudioRaiseVolume" =
          "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && notify-send \"audio output unmuted\"";
        "XF86AudioMute" =
          "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && notify-send \"audio output toggled\"";
        "XF86AudioPrev" = "exec mpc prev && notify-send \"playing previous song in queue\"";
        "XF86AudioPlay" = "exec mpc toggle && notify-send \"toggled current audio stream\"";
        "XF86AudioNext" = "exec mpc next && notify-send \"playing next song in queue\"";
        "f4" = "exec /home/user/.bin/scsh";
        "f9" = "exec swaymsg input \"*\" xkb_switch_layout next && notify-send \"keyboard layout changed\"";
        "f10" = "exec /home/user/.bin/powermenu";
        "f11" = "exec /home/user/.bin/killer";
        "Mod4+slash" = "exec rofi -show calc -modi calc";
        "Mod4+period" = "exec rofi -show emoji -modi emoji";
      };

      startup = [
        { command = "swaymsg 'workspace number 1'"; }
        { command = "usbguard-notifier"; }
        { command = "sleep 1 && usbguard_gui"; }
        { command = "nm-applet --indicator"; }
        { command = "mpc volume 50"; }
        { command = "/bin/sh -c \"pkill -15 opensnitch-ui; opensnitch-ui\""; }
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

    # config HM can't express
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

  programs.waybar = {
    enable = true;
    settings.mainBar = {
      bar_id = "bar-0";
      ipc = true;
      height = 27;
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
        # interface = "wlp2*";
        format = " {bandwidthUpBytes}  {bandwidthDownBytes}";
        format-disconnected = "";
        tooltip-format = "Connected";
        tooltip-format-disconnected = "Disconnected";
        interval = 5;
        on-click = "alacritty --class alacritty-float -e btm -e --default_widget_type=net";
      };
      battery = {
        bat = "macsmc-battery";
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
        on-click = "alacritty --class alacritty-float -e bash -c 'if doas nixos-rebuild switch --impure --flake /home/user/dev/sysadmin/dotfiles#$(hostname); then printf 0 > /home/user/etc/cache/updater/count; fi; read -n1'";
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

    # catppuccin @palette vars
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

  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 120;
        command = "${pkgs.sway}/bin/swaymsg \"output * power off\"";
        # requires disabling/enabling the output
        resumeCommand = "${pkgs.sway}/bin/swaymsg \"output * power on; output * disable; output * enable\"";
      }
      {
        timeout = 130;
        command = "${pkgs.swaylock}/bin/swaylock -f";
        resumeCommand = "${pkgs.sway}/bin/swaymsg \"output * power on; output * disable; output * enable\"";
      }
    ];
    events.before-sleep = "${pkgs.swaylock}/bin/swaylock -f";
  };

}
