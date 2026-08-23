{ pkgs, lib, config, inputs, ... }: {
  # mpd via home-manager
  services.mpd = {
    enable = true;
    settings = {
      music_directory = "${config.home.homeDirectory}/med/audio/music/";
      playlist_directory = "${config.home.homeDirectory}/.cfg/mpd/playlists/";
      db_file = "${config.home.homeDirectory}/.cfg/mpd/mpd.db";
      pid_file = "${config.home.homeDirectory}/.cfg/mpd/mpd.pid";
      state_file = "${config.home.homeDirectory}/.cfg/mpd/mpdstate";
      auto_update = "no";
      volume_normalization = "yes";
      audio_output = [
        {
          type = "pipewire";
          name = "PipeWire Sound Server";
        }
      ];
      decoder = [
        { plugin = "mp4ff"; enabled = "no"; }
      ];
    };
  };

  # ncmpcpp (dotfiles config)
  home.file.".cfg/ncmpcpp/config".source = ../dotfiles/ncmpcpp/config;
  home.file.".cfg/ncmpcpp/bindings".source = ../dotfiles/ncmpcpp/bindings;

  # mpv (minimal config via HM)
  programs.mpv = {
    enable = true;
    config = ''
      background="#181926"
      sub-color="#cad3f5"
      sub-font="JetBrainsMono Nerd Font"
    '';
    inputConfig = ''
      h add video-pan-x 0.05
      l add video-pan-x -0.05
      k add video-pan-y 0.05
      j add video-pan-y -0.05
      + add video-zoom 0.05
      - add video-zoom -0.05
    '';
  };

  # cava (dotfiles config)
  home.file.".cfg/cava/config".source = ../dotfiles/cava/config;
  # shaders directory
  home.file.".cfg/cava/shaders".source = ../dotfiles/cava/shaders;

  # placeholders (commented out - enable when ready)
  # obs-studio
  # programs.obs-studio = { enable = true; };

  # gimp
  # programs.gimp = { enable = true; };

  # virt-manager
  # programs.virt-manager = { enable = true; };
}