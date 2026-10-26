{
  pkgs,
  inputs,
  ...
}:
{
  # Catppuccin Macchiato themes via catppuccin/nix flake
  catppuccin = {
    # use nixpkgs' cached whiskers instead of catppuccin/nix's uncached rust build
    sources = inputs.catppuccin.packages.${pkgs.stdenv.hostPlatform.system}.overrideScope (
      _final: _prev: { whiskers = pkgs.catppuccin-whiskers; }
    );
    enable = true;
    autoEnable = true;
    flavor = "macchiato";
    accent = "lavender";
    gtk.icon = {
      enable = true;
    };
    cursors.enable = true;
    fzf.enable = true;
    # colorscheme comes from lazy.nvim, see extra/nvim/lua/plugins/ui.lua
    nvim.enable = false;
    ghostty.enable = true;
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
    # custom catppuccin theme for cava
    cava.enable = false;
  };

  home.pointerCursor.enable = true;
}
