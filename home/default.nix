{
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    ./shell.nix
    ./develpoment.nix
    ./desktop.nix
    ./media.nix
    ./files.nix
    ./theme.nix
    ./packages.nix
  ];

  home.username = "user";
  home.homeDirectory = "/home/user";
  home.stateVersion = "26.05";

  # custom xdg directory layout
  xdg = {
    enable = true;
    configHome = "${config.home.homeDirectory}/.cfg";
    cacheHome = "${config.home.homeDirectory}/etc/cache";
    dataHome = "${config.home.homeDirectory}/etc/data";
    stateHome = "${config.home.homeDirectory}/etc/state";

    userDirs = {
      enable = true;
      download = "${config.home.homeDirectory}/tmp";
      desktop = "${config.home.homeDirectory}/tmp";
      documents = "${config.home.homeDirectory}/doc";
      music = "${config.home.homeDirectory}/med/audio";
      pictures = "${config.home.homeDirectory}/med";
      videos = "${config.home.homeDirectory}/med/videos";
    };

  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/.bin"
    "${config.home.homeDirectory}/etc/bin"
  ];

  programs.home-manager.enable = true;
}
