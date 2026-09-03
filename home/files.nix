{
  ...
}:
{
  # lf file manager
  home.file.".cfg/lf/lfrc".source = ../dotfiles/lf/lfrc;
  home.file.".cfg/lf/icons".source = ../dotfiles/lf/icons;
  home.file.".cfg/lf/preview.sh".source = ../dotfiles/lf/preview.sh;

  # nvim
  home.file.".cfg/nvim".source = ../dotfiles/nvim;

  # custom binaries
  home.file.".cfg/bin".source = ../dotfiles/bin;

  # bottom (btm)
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

  # sioyek
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
}
