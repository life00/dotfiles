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
    # ponytail: alacritty is now a raw dotfile (dotfiles/alacritty/alacritty.toml,
    # self-contained palette) symlinked via home/terminal.nix — catppuccin's
    # alacritty option is dropped since programs.alacritty is no longer enabled.
    bat = { enable = true; };
    delta = { enable = true; };
    zsh-syntax-highlighting = { enable = true; };
    starship = { enable = true; };
    # ponytail: rofi/waybar/dunst/swaylock are NOT themed via catppuccin — their
    # configs are raw dotfiles carrying the palette themselves
    # (dotfiles/rofi, dotfiles/waybar, dotfiles/dunst, dotfiles/swaylock).
    # catppuccin.rofi/waybar/dunst would also collide with home/desktop.nix
    # dotfile symlinks (both write the same config files).
  };

  # ponytail: the GTK theme/icon/cursor/font dconf DB is applied SYSTEM-wide
  # in modules/fonts.nix (programs.dconf is a NixOS option, not home-manager);
  # the old HM `programs.dconf` block here was removed as a duplicate.
}