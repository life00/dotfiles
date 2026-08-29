{ pkgs, lib, config, inputs, ... }: {
  # ponytail: minimal-install — sway only.
  # Commented below (restore for full setup): swayidle, swaylock, waybar,
  # rofi, dunst, screenshots, clipboard, xdg-desktop-portal-wlr.
  # ponytail: minimal-install — HM `programs.sway` module was removed in this
  # home-manager version (option does not exist). Sway is instead enabled at
  # the NixOS SYSTEM level via `programs.sway.enable` (modules/packages.nix),
  # which installs sway + `foot` so a terminal is reachable via `$mod+Return`.
  # NOTE: this nixpkgs' `programs.sway` has NO `extraConfig` option; sway's
  # runtime config lives in /etc/sway/config or ~/.config/sway/config.
  # programs.sway = {
  #   enable = true;
  #   # minimal session: terminal bound to alacritty.
  #   # ponytail: replaces dotfiles/sway/config which is NOT wired in via home.file.
  #   extraConfig = ''
  #     set $mod Mod4
  #     set $term alacritty
  #     font JetBrainsMono NFM 11px
  #     bindsym $mod+Return exec $term
  #     bindsym $mod+Shift+q exec swaynag -t warning -m 'Exit Sway?' -B 'Yes, exit sway' 'swaymsg exit'
  #     bindsym $mod+d exec $term -e opencode
  #     gaps inner 0
  #     default_border pixel 1
  #   '';
  # };

  # # swayidle + swaylock
  # programs.swayidle = { enable = true; };
  # programs.swaylock = {
  #   enable = true;
  #   font = "JetBrainsMono Nerd Font";
  #   background_color = "1A1826";
  #   indicator_idle = "2f343f";
  #   indicator = "0d1116";
  #   ring = "c6a0f6";
  #   line = "181926";
  #   inside = "181926";
  #   text = "cad3f5";
  #   key_hl = "f5bde6";
  #   bshl = "ed8796";
  #   separator = "1e2030";
  #   inside_wrong = "ed8796";
  #   inside_verifying = "f5a97f";
  # };

  # # waybar
  # programs.waybar = { enable = true; };

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