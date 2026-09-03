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

  # ncmpcpp (dotfiles config)
  home.file.".cfg/ncmpcpp/config".source = ../dotfiles/ncmpcpp/config;
  home.file.".cfg/ncmpcpp/bindings".source = ../dotfiles/ncmpcpp/bindings;

  # mpv
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

  # cava (dotfiles config)
  home.file.".cfg/cava/config".source = ../dotfiles/cava/config;
}
