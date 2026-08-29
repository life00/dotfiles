{ pkgs, lib, config, inputs, ... }: {
  # Catppuccin Macchiato themes via catppuccin/nix flake.
  # ponytail: this catppuccin revision only exposes gtk.icon (Papirus folder
  # accents) — the GTK *theme* itself is set via dconf in modules/fonts.nix.
  # `catppuccin.zsh` is `catppuccin.zsh-syntax-highlighting` here.
  catppuccin = {
    enable = true;
    flavor = "macchiato";
    accent = "lavender";
    gtk.icon = { enable = true; };
    cursors = { enable = true; };
    fzf = { enable = true; };
    nvim = { enable = true; };
    alacritty = { enable = true; };
    bat = { enable = true; };
    delta = { enable = true; };
    zsh-syntax-highlighting = { enable = true; };
    starship = { enable = true; };
    rofi = { enable = true; };
    waybar = { enable = true; };
    dunst = { enable = true; };
  };

  # ponytail: the GTK theme/icon/cursor/font dconf DB is applied SYSTEM-wide
  # in modules/fonts.nix (programs.dconf is a NixOS option, not home-manager);
  # the old HM `programs.dconf` block here was removed as a duplicate.
}