{ pkgs, lib, config, inputs, ... }: {
  # med/audio/music must exist for mpd (dirs not yet part of the root-owned
  # home model in modules/users.nix — placeholder creates the tree user-owned)
  home.file."med/audio/music/.keep".text = "";

  # mpd via home-manager. `services.mpd.settings` no longer exists in this HM;
  # use the module's typed options + extraConfig for the directives it doesn't
  # cover (pid_file name and state_file are HM's dataDir/state — same dir, so
  # the file names differ cosmetically from the old config).
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

  # mpv (minimal config via HM)
  programs.mpv = {
    enable = true;
    # ponytail: config is now an attrset (type-checked), not raw lines
    config = {
      background = "#181926";
      sub-color = "#cad3f5";
      sub-font = "JetBrainsMono Nerd Font";
    };
    # ponytail: `inputConfig` was renamed to `bindings` (attrs key -> command)
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