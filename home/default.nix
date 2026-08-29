{ inputs, pkgs, lib, config, ... }: {
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    ./shell.nix
    ./git.nix
    ./terminal.nix
    ./editor.nix
    ./desktop.nix
    ./media.nix
    ./files.nix
    ./theme.nix
    ./packages.nix
  ];

  home.username = "user";
  home.homeDirectory = "/home/user";
  home.stateVersion = "26.05";

  # XDG dirs (matches zshenv)
  xdg = {
    enable = true;
    configHome = "${config.home.homeDirectory}/.cfg";
    cacheHome = "${config.home.homeDirectory}/etc/cache";
    dataHome = "${config.home.homeDirectory}/etc/data";
    stateHome = "${config.home.homeDirectory}/etc/state";
  };

  # let home-manager manage itself
  programs.home-manager.enable = true;
}
