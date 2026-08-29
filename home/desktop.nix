{ pkgs, lib, config, inputs, ... }: {
  # ponytail: minimal-install — sway session essentials only.
  # Commented below (restore for full setup): rofi, dunst, screenshots,
  # clipboard, xdg-desktop-portal-wlr.
  programs.sway = {
    enable = true;
    # minimal session: terminal bound to alacritty, waybar bar.
    # ponytail: replaces dotfiles/sway/config which is NOT wired in via home.file.
    extraConfig = ''
      set $mod Mod4
      set $term alacritty
      font JetBrainsMono NFM 11px
      bindsym $mod+Return exec $term
      bindsym $mod+Shift+q exec swaynag -t warning -m 'Exit Sway?' -B 'Yes, exit sway' 'swaymsg exit'
      bindsym $mod+d exec $term -e opencode
      bar { swaybar_command waybar }
      gaps inner 0
      default_border pixel 1
    '';
  };

  # swayidle + swaylock
  programs.swayidle = { enable = true; };
  programs.swaylock = {
    enable = true;
    font = "JetBrainsMono Nerd Font";
    background_color = "1A1826";
    indicator_idle = "2f343f";
    indicator = "0d1116";
    ring = "c6a0f6";
    line = "181926";
    inside = "181926";
    text = "cad3f5";
    key_hl = "f5bde6";
    bshl = "ed8796";
    separator = "1e2030";
    inside_wrong = "ed8796";
    inside_verifying = "f5a97f";
  };

  # waybar (config via dotfiles)
  programs.waybar = { enable = true; };

  # # rofi (config via dotfiles)
  # programs.rofi = { enable = true; };

  # # dunst notifications
  # programs.dunst = {
  #   enable = true;
  #   settings = { };
  # };

  # # grim + slurp for screenshots
  # programs.grim = { enable = true; };
  # programs.slurp = { enable = true; };

  # # xdg desktop portal for wayland
  # systemd.user.services.xdg-desktop-portal-wlr = {
  #   enable = true;
  # };

  # # clipboard
  # programs.wl-clipboard = { enable = true; };
}