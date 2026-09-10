{
  config,
  lib,
  pkgs,
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

  systemd.user.services.mpd = {
    Service = {
      ExecStartPost = lib.mkAfter [ "${lib.getExe pkgs.mpc} volume 60" ];
    };
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

  programs.ncmpcpp = {
    enable = true;
    mpdMusicDir = config.services.mpd.musicDirectory;
    settings = {
      mpd_connection_timeout = 5;
      mpd_crossfade_time = 5;
      lyrics_directory = "${config.home.homeDirectory}/.cfg/ncmpcpp/lyrics";

      visualizer_data_source = "/tmp/mpd.fifo";
      visualizer_output_name = "Visualizer";
      visualizer_in_stereo = false;
      visualizer_type = "ellipse";
      visualizer_fps = 60;
      visualizer_look = "●▮";

      connected_message_on_startup = true;
      cyclic_scrolling = true;
      mouse_support = true;
      mouse_list_scroll_whole_page = true;
      lines_scrolled = 1;
      message_delay_time = 1;
      playlist_shorten_total_times = true;
      playlist_display_mode = "columns";
      browser_display_mode = "columns";
      search_engine_display_mode = "columns";
      playlist_editor_display_mode = "columns";
      autocenter_mode = true;
      centered_cursor = true;
      user_interface = "classic";
      follow_now_playing_lyrics = true;
      locked_screen_width_part = 50;
      ask_for_locked_screen_width_part = true;
      display_bitrate = false;
      external_editor = "nano";
      main_window_color = "default";
      startup_screen = "playlist";

      progressbar_look = "━━━";
      progressbar_elapsed_color = "magenta";
      progressbar_color = "black";

      header_visibility = false;
      statusbar_visibility = false;
      titles_visibility = false;
      enable_window_title = true;

      statusbar_color = "white";
      color1 = "white";
      color2 = "blue";

      now_playing_prefix = "$b$6";
      now_playing_suffix = "$/b$1";
      current_item_prefix = "$/b$0";
      current_item_suffix = "$1";
      song_columns_list_format = " (50)[]{t|f}(8f)[]{l}";
      song_window_title_format = "Now Playing ..";
    };
    bindings = [
      {
        key = "j";
        command = "scroll_down";
      }
      {
        key = "k";
        command = "scroll_up";
      }
      {
        key = "h";
        command = "previous_column";
      }
      {
        key = "l";
        command = "next_column";
      }
      {
        key = "ctrl-b";
        command = "page_up";
      }
      {
        key = "ctrl-u";
        command = "page_up";
      }
      {
        key = "ctrl-f";
        command = "page_down";
      }
      {
        key = "ctrl-d";
        command = "page_down";
      }
      {
        key = "g";
        command = "move_home";
      }
      {
        key = "G";
        command = "move_end";
      }
      {
        key = "n";
        command = "next_found_item";
      }
      {
        key = "N";
        command = "previous_found_item";
      }
    ];
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
