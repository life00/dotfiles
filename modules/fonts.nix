{ pkgs, ... }:
{
  # fonts

  fonts.packages = with pkgs; [
    (nerd-fonts.jetbrains-mono)
    papirus-icon-theme
    catppuccin-cursors.macchiatoDark
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font" ];
      sansSerif = [ "JetBrainsMono Nerd Font" ];
    };
  };

  # disable catppuccin auto enable
  catppuccin = {
    enable = true;
    autoEnable = false;
  };

  # icon theme

  environment.systemPackages = with pkgs; [
    papirus-icon-theme
    catppuccin-cursors.macchiatoDark
    (catppuccin-gtk.override {
      variant = "macchiato";
      accents = [ "lavender" ];
      size = "standard";
    })
  ];

  programs.dconf = {
    enable = true;
    profiles.user.databases = [
      {
        settings = {
          "org/gnome/desktop/interface" = {
            gtk-theme = "catppuccin-macchiato-lavender-standard";
            icon-theme = "Papirus-Dark";
            cursor-theme = "catppuccin-macchiato-dark-cursors";
            font-name = "JetBrainsMono Nerd Font 11";
            color-scheme = "prefer-dark";
          };
        };
      }
    ];
  };
}
