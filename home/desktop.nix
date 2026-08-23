{ pkgs, lib, config, inputs, ... }: {
  # sway window manager (config via dotfiles)
  programs.sway = {
    enable = true;
    # config is in dotfiles/sway/config — symlinked via home.file below
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

  # rofi (config via dotfiles)
  programs.rofi = { enable = true; };

  # dunst notifications (config via dotfiles)
  programs.dunst = {
    enable = true;
    settings = { };
  };

  # grim + slurp for screenshots
  programs.grim = { enable = true; };
  programs.slurp = { enable = true; };

  # xdg desktop portal for wayland
  systemd.user.services.xdg-desktop-portal-wlr = {
    enable = true;
  };

  # clipboard
  programs.wl-clipboard = { enable = true; };

  # ponytail: dotfiles symlinked in files.nix
}