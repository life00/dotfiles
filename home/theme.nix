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
    autoEnable = true;
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
    sioyek = {
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
    # rofi is themed via catppuccin: `catppuccin.rofi` writes the macchiato
    # theme files to ~/etc/data/rofi/themes and injects @theme/@import into
    # the `programs.rofi` config (home/desktop.nix). The legacy dotfile
    # catppuccin-macchiato.rasi was removed.
    rofi = {
      enable = true;
    };
    dunst = {
      enable = true;
    };
    # swaylock comes from the catppuccin port (official macchiato .conf renders
    # into `programs.swaylock.settings`); the only hardcoded addition is the
    # font, kept in home/desktop.nix.
    swaylock = {
      enable = true;
    };
    # waybar is themed via the catppuccin flake: `programs.waybar.style` (in
    # home/desktop.nix) references the palette vars the import defines, so the
    # flavor/accent set above (macchiato/lavender) drives the whole bar. The
    # raw dotfile symlinks for waybar were removed from home/desktop.nix so the
    # two don't collide.
    waybar = {
      enable = true;
    };
    # catppuccin.sway stays unset: this catppuccin rev has autoEnable=true, so
    # the sway integration auto-injects an `include` of its macchiato $color
    # vars into the generated config; `config.colors` in home/desktop.nix
    # references them ($crust, $lavender, $text …).
  };

  # ponytail: the GTK theme/icon/cursor/font dconf DB is applied SYSTEM-wide
  # in modules/fonts.nix (programs.dconf is a NixOS option, not home-manager);
  # the old HM `programs.dconf` block here was removed as a duplicate.

  # catppuccin.cursors sets home.pointerCursor without `.enable`; be explicit to
  # keep cursor config generation (and silence the deprecation warning).
  home.pointerCursor.enable = true;
}
