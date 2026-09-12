{ pkgs, lib, ... }:
let
  # same set as tiny-dfr's bundled icons: material symbols outlined, white
  rev = "40a7a292a79d9394157e1ea24f83d52d5e17c556";
  symbol =
    name: hash:
    pkgs.runCommand "${name}.svg" { } ''
      sed 's/<path /<path fill="white" /' ${
        pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/google/material-design-icons/${rev}/symbols/web/${name}/materialsymbolsoutlined/${name}_48px.svg";
          inherit hash;
        }
      } > $out
    '';
  icons = {
    photo_camera = "sha256-72RBkAefm3MPOaIV4wZDm7DIpmyGLNXQa/1RGvyAKd4=";
    keyboard = "sha256-C5fGmVN1Zr5EGCC5+feprUAcmp/C5FAjCL9IUnKrj9Q=";
    power_settings_new = "sha256-Drw7qdIGoNwG9x76FxyCuyJaAuglfcS1NwfiFBrqcho=";
    build = "sha256-7BBh/huATHgsPmgFwffAxa5r+BPtNOnVjvOtWmRfLiE=";
  };
in
{
  environment.etc = lib.mapAttrs' (
    name: hash: lib.nameValuePair "tiny-dfr/${name}.svg" { source = symbol name hash; }
  ) icons;

  hardware.apple.touchBar = {
    enable = true;
    package = pkgs.tiny-dfr;
    settings = {
      MediaLayerDefault = true;
      MediaLayerKeys = [
        # playback
        {
          Icon = "fast_rewind";
          Action = "PreviousSong";
          Stretch = 2;
        }
        {
          Icon = "play_pause";
          Action = "PlayPause";
          Stretch = 2;
        }
        {
          Icon = "fast_forward";
          Action = "NextSong";
          Stretch = 2;
        }
        # system
        {
          Icon = "photo_camera";
          Action = "F4";
          Stretch = 2;
        } # screenshot
        # brightness
        {
          Icon = "brightness_low";
          Action = "BrightnessDown";
          Stretch = 2;
        }
        {
          Icon = "brightness_high";
          Action = "BrightnessUp";
          Stretch = 2;
        }
        # volume
        {
          Icon = "volume_off";
          Action = "Mute";
          Stretch = 2;
        }
        {
          Icon = "volume_down";
          Action = "VolumeDown";
          Stretch = 2;
        }
        {
          Icon = "volume_up";
          Action = "VolumeUp";
          Stretch = 2;
        }
        # system
        {
          Icon = "keyboard";
          Action = "F9";
          Stretch = 2;
        } # layout
        # tools and power
        {
          Icon = "build";
          Action = "F11";
          Stretch = 2;
        } # tools
        {
          Icon = "power_settings_new";
          Action = "F10";
          Stretch = 2;
        } # power menu
      ];
    };
  };
}
