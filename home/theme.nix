{
  ...
}:
{
  # Catppuccin Macchiato themes via catppuccin/nix flake.
  # ponytail: this catppuccin revision only exposes gtk.icon (Papirus folder
  # accents) — the GTK *theme* itself is set via dconf in modules/fonts.nix.
  # `catppuccin.zsh` is `catppuccin.zsh-syntax-highlighting` here.
  catppuccin = {
    enable = true;
    flavor = "macchiato";
    accent = "lavender";
    gtk.icon = {
      enable = true;
    };
    cursors = {
      enable = true;
    };
    fzf = {
      enable = true;
    };
    nvim = {
      enable = true;
    };
    # alacritty colors come from the flake via `settings.general.import`
    # (palette applied by catppuccin.alacritty; font/font-only options live
    # in home/terminal.nix).
    alacritty = {
      enable = true;
    };
    bat = {
      enable = true;
    };
    delta = {
      enable = true;
    };
    zsh-syntax-highlighting = {
      enable = true;
    };
    starship = {
      enable = true;
    };
    # bottom theme from the flake (macchiato); non-theme options live in
    # home/bottom.nix (`programs.bottom.settings`).
    bottom = {
      enable = true;
    };
    # ponytail: rofi/waybar/dunst are NOT themed via catppuccin — their
    # configs are raw dotfiles carrying the palette themselves
    # (dotfiles/rofi, dotfiles/waybar, dotfiles/dunst).
    # catppuccin.rofi/waybar/dunst would also collide with home/desktop.nix
    # dotfile symlinks (both write the same config files).
    # swaylock comes from the catppuccin port (official macchiato .conf renders
    # into `programs.swaylock.settings`); the only hardcoded addition is the
    # font, kept in home/desktop.nix.
    swaylock = {
      enable = true;
    };
    # catppuccin.sway stays unset: this catppuccin rev has autoEnable=true, so
    # the sway integration auto-injects an `include` of its macchiato $color
    # vars into the generated config — inert, since sway colors are hardcoded
    # hex in home/desktop.nix.
  };

  # ponytail: the GTK theme/icon/cursor/font dconf DB is applied SYSTEM-wide
  # in modules/fonts.nix (programs.dconf is a NixOS option, not home-manager);
  # the old HM `programs.dconf` block here was removed as a duplicate.
}
