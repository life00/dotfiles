{ pkgs, ... }:
{
  # white recolor of papirus single-color glyphs
  environment.etc."tiny-dfr/camera.svg".source = ./icons/camera.svg;
  environment.etc."tiny-dfr/input-keyboard.svg".source = ./icons/input-keyboard.svg;
  environment.etc."tiny-dfr/system-shutdown.svg".source = ./icons/system-shutdown.svg;
  environment.etc."tiny-dfr/system-run.svg".source = ./icons/system-run.svg;

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
          Icon = "camera";
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
          Icon = "input-keyboard";
          Action = "F9";
          Stretch = 2;
        } # layout
        # tools and power
        {
          Icon = "system-run";
          Action = "F11";
          Stretch = 2;
        } # tools
        {
          Icon = "system-shutdown";
          Action = "F10";
          Stretch = 2;
        } # power menu
      ];
    };
  };
}
