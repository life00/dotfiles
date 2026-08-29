{ pkgs, ... }:
{
  # Fonts go in fonts.packages; icon/cursor THEMES must be in
  # environment.systemPackages so GTK finds them via the icon search path
  # (fonts.packages only populates fontconfig font dirs).
  fonts.packages = with pkgs; [
    (nerd-fonts.jetbrains-mono)
    papirus-icon-theme
    catppuccin-cursors.macchiatoDark
  ];

  environment.systemPackages = with pkgs; [
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

  # GTK theme defaults via dconf (system-wide)
  programs.dconf = {
    enable = true;
    profiles.user.databases = [
      {
        settings = {
          "org/gnome/desktop/interface" = {
            gtk-theme = "catppuccin-macchiato-lavender-standard+default";
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
