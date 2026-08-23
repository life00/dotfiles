{ pkgs, lib, config, inputs, ... }: {
  # Catppuccin Macchiato themes via catppuccin/nix flake
  catppuccin = {
    enable = true;
    flavor = "macchiato";
    accent = "lavender";
    gtk = {
      enable = true;
      theme = "standard";
    };
    cursors = { enable = true; };
    fzf = { enable = true; };
    nvim = { enable = true; };
    alacritty = { enable = true; };
    bat = { enable = true; };
    delta = { enable = true; };
    zsh = {
      enable = true;
      plugin = "fast-syntax-highlighting";
    };
    starship = { enable = true; };
    rofi = { enable = true; };
    waybar = { enable = true; };
    dunst = { enable = true; };
  };

  # dconf system-wide GTK settings (mirrors .cfg/dconf/user)
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
          "org/gnome/terminal/legacy/profiles:/:" = {
            default = "b703f5a85f24558bd61621ef1a4d470";
          };
          "org/gnome/terminal/legacy/profiles:/:b703f5a85f24558bd61621ef1a4d470" = {
            font = "JetBrainsMono Nerd Font 11";
          };
          "org/virt-manager/virt-manager" = {
            autoconnect = "qemu:///system";
            confirm = true;
          };
        };
      }
    ];
  };
}