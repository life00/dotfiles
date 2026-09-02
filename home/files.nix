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
  home.file.".cfg/lf/icons".source = ../dotfiles/lf/icons;
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
  # the bottom binary is installed from home/packages.nix (the sole explicit
  # user manifest). HM writes
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

  # sioyek — Nix-native via `programs.sioyek` (package comes from
  # home/packages.nix). Theme is the catppuccin macchiato palette inlined below.
  # ponytail: catppuccin.sioyek is broken on this HM rev — it writes a literal
  # `source <path>` line instead of merging colors, so the palette is inlined
  # here. bindings = keys_user.config, config = prefs_user.config (keys are
  # sorted alphabetically by HM's renderer, content is unchanged).
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

  # custom xkb layout (installed system-wide via locale.nix)
  # kept here for reference
  home.file.".cfg/xkb/custom-mech".source = ../modules/xkb/custom-mech;
}
