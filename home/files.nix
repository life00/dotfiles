{ pkgs, lib, config, inputs, ... }: {
  # lf file manager — the whole config is a raw dotfile. ponytail: HM's
  # `programs.lf` writes ~/.cfg/lf/lfrc itself (no option to sync a file),
  # so it is NOT enabled here; the `lf` package comes from home/packages.nix
  # and lfrc is symlinked verbatim from dotfiles/. The zlf cd-on-quit wrapper
  # is restored in home/shell.nix.
  home.file.".cfg/lf/lfrc".source = ../dotfiles/lf/lfrc;
  home.file.".cfg/lf/lfrc.cmd".source = ../dotfiles/lf/lfrc.cmd;
  home.file.".cfg/lf/colors".source = ../dotfiles/lf/colors;
  home.file.".cfg/lf/preview.sh".source = ../dotfiles/lf/preview.sh;

  # nvim — full LazyVim dotfiles tracked verbatim (see docs/dotfiles.md);
  # force=true since nvim may create ~/.cfg/nvim itself before first activation
  home.file.".cfg/nvim" = {
    source = ../dotfiles/nvim;
    force = true;
  };

  # .bin links point to ~/dev/bin + ~/.cfg/rofi/bin (managed by systemd tmpfiles
  # in modules/users.nix). ~/.bin is already on PATH via home/shell.nix.

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
  home.file.".cfg/xkb/custom-mech".source = ../modules/xkb/custom-mech;
}