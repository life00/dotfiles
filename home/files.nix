{ pkgs, lib, config, inputs, ... }: {
  # lf file manager (config via dotfiles)
  home.file.".cfg/lf/lfrc".source = ../dotfiles/lf/lfrc;
  home.file.".cfg/lf/lfrc.cmd".source = ../dotfiles/lf/lfrc.cmd;
  home.file.".cfg/lf/colors".source = ../dotfiles/lf/colors;
  home.file.".cfg/lf/preview.sh".source = ../dotfiles/lf/preview.sh;
  # preview script needs exiftool, bat, pandoc, jq, lsar, xlsx2csv, etc.
  programs.lf = { enable = true; };

  # custom bin scripts (dev/bin)
  home.file.".bin/fetch".source = ../dotfiles/bin/fetch;
  home.file.".bin/zlf".source = ../dotfiles/bin/zlf;
  home.file.".bin/todoi".source = ../dotfiles/bin/todoi;
  home.file.".bin/pdf2nocopy".source = ../dotfiles/bin/pdf2nocopy;
  home.file.".bin/catexif".source = ../dotfiles/bin/catexif;
  home.file.".bin/imgcompress".source = ../dotfiles/bin/imgcompress;
  home.file.".bin/ipext".source = ../dotfiles/bin/ipext;
  home.file.".bin/ipint".source = ../dotfiles/bin/ipint;
  home.file.".bin/rmexif".source = ../dotfiles/bin/rmexif;
  home.file.".bin/sioyek-open".source = ../dotfiles/bin/sioyek-open;
  home.file.".bin/wgetweb".source = ../dotfiles/bin/wgetweb;
  home.file.".bin/yt-dlp-lofi".source = ../dotfiles/bin/yt-dlp-lofi;
  home.file.".bin/btrfs-file-delete".source = ../dotfiles/bin/btrfs-file-delete;
  home.file.".bin/ufetch".source = ../dotfiles/bin/ufetch;

  # ensure .bin is in PATH
  home.sessionVariables.PATH = "${config.home.homeDirectory}/.bin:${config.home.sessionVariables.PATH}";

  # qalculate
  home.file.".cfg/qalculate/qalc.cfg".source = ../dotfiles/qalculate/qalc.cfg;

  # bottom (btm)
  home.file.".cfg/bottom/bottom.toml".source = ../dotfiles/bottom/bottom.toml;

  # sioyek
  home.file.".cfg/sioyek/prefs_user.config".source = ../dotfiles/sioyek/prefs_user.config;
  home.file.".cfg/sioyek/keys_user.config".source = ../dotfiles/sioyek/keys_user.config;

  # khal
  home.file.".cfg/khal/config".source = ../dotfiles/khal/config;

  # awecron config directory
  home.file.".cfg/awecron/cfg".source = ../dotfiles/awecron/cfg;
  home.file.".cfg/awecron/tphome10min/cfg".source = ../dotfiles/awecron/tphome10min/cfg;
  home.file.".cfg/awecron/tphome10min/run".source = ../dotfiles/awecron/tphome10min/run;
  home.file.".cfg/awecron/tphome1hour/cfg".source = ../dotfiles/awecron/tphome1hour/cfg;
  home.file.".cfg/awecron/tphome1hour/run".source = ../dotfiles/awecron/tphome1hour/run;
  home.file.".cfg/awecron/updater/cfg".source = ../dotfiles/awecron/updater/cfg;
  home.file.".cfg/awecron/updater/run".source = ../dotfiles/awecron/updater/run;
  home.file.".cfg/awecron/updater/update".source = ../dotfiles/awecron/updater/update;

  # custom xkb layout (installed system-wide via locale.nix)
  # kept here for reference
  home.file:.cfg/xkb/custom-mech".source = ../modules/xkb/custom-mech;
}