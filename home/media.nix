{
  config,
  ...
}:
{
  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/med/audio/music/";
    playlistDirectory = "${config.home.homeDirectory}/.cfg/mpd/playlists";
    dataDir = "${config.home.homeDirectory}/.cfg/mpd";
    dbFile = "${config.home.homeDirectory}/.cfg/mpd/mpd.db";
    extraConfig = ''
      volume_normalization "yes"
      audio_output {
        type   "pipewire"
        name   "PipeWire Sound Server"
      }
      decoder {
        plugin  "mp4ff"
        enabled "no"
      }
    '';
  };

  programs.mpv = {
    enable = true;
    config = {
      background = "#181926";
      sub-color = "#cad3f5";
      sub-font = "JetBrainsMono Nerd Font";
    };
    bindings = {
      h = "add video-pan-x 0.05";
      l = "add video-pan-x -0.05";
      k = "add video-pan-y 0.05";
      j = "add video-pan-y -0.05";
      "+" = "add video-zoom 0.05";
      "-" = "add video-zoom -0.05";
    };
  };

  programs.sioyek = {
    enable = true;
    bindings = {
      screen_down = "<C-d>";
      screen_up = "<C-u>";
      previous_page = "<C-p>";
      next_page = "<C-n>";
      copy = "y";
      toggle_custom_color = "c";
    };
    config = {
      collapsed_toc = "1";
      font_size = "12";
      ui_font = "JetBrainsMono Nerd Font";
      status_bar_font_size = "16";
      page_separator_width = "3";

      startup_commands = [
        "toggle_horizontal_scroll_lock"
        "toggle_custom_color"
      ];
    };
  };

  accounts.calendar.accounts.private = {
    khal.enable = true;
    local.path = "/home/user/etc/data/khal/calendars/private";
  };

  programs.khal = {
    enable = true;
    locale = {
      timeformat = "%H:%M";
      dateformat = "%d.%m.%Y";
      longdateformat = "%d.%m.%Y";
      datetimeformat = "%d.%m.%Y %H:%M";
      longdatetimeformat = "%d.%m.%Y %H:%M";
    };
  };
}
