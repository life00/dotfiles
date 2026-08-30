{
  ...
}:
{
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
  # ~/.bin -> ~/.cfg/bin symlinks are created at activation (modules/users.nix
  # homeSetup), because systemd-tmpfiles refuses L under /home/user.
  home.file.".cfg/bin".source = ../dotfiles/bin;

  # bottom (btm) — Nix-native via `programs.bottom`. `package = null` since
  # the bottom binary is installed system-wide (modules/packages.nix). HM writes
  # $XDG_CONFIG_HOME/bottom/bottom.toml → ~/.cfg/bottom/bottom.toml (the old raw
  # dotfile path, dotfiles/bottom removed — this is now the source of truth).
  # Colors come from `catppuccin.bottom` (home/theme.nix); only non-theme
  # options are set here.
  programs.bottom = {
    enable = true;
    package = null;
    settings = {
      flags = {
        hide_table_gap = false;
        battery = true;
        show_table_scroll_position = true;
      };
      processes = {
        default_tree = true;
        process_command = true;
      };
      network_graph.interface_filter = {
        is_list_ignored = true;
        list = [ "lo" ];
        regex = true;
        case_sensitive = false;
        whole_word = false;
      };
    };
  };

  # qalculate
  home.file.".cfg/qalculate/qalc.cfg".source = ../dotfiles/qalculate/qalc.cfg;

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
