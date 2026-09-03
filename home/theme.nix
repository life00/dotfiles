{
  ...
}:
{
  # Catppuccin Macchiato themes via catppuccin/nix flake
  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "macchiato";
    accent = "lavender";
    gtk.icon = {
      enable = true;
    };
    cursors.enable = true;
    fzf.enable = true;
    nvim.enable = true;
    alacritty.enable = true;
    bat.enable = true;
    delta.enable = true;
    sioyek.enable = true;
    zsh-syntax-highlighting.enable = true;
    starship.enable = true;
    bottom.enable = true;
    rofi.enable = true;
    dunst.enable = true;
    swaylock.enable = true;
    waybar.enable = true;
  };

  home.pointerCursor.enable = true;
}
