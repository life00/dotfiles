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

    dataFile."applications/neovim.desktop".source = ../dotfiles/neovim.desktop;
    dataFile."applications/lf.desktop".source = ../dotfiles/lf.desktop;

    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "chromium.desktop";
        "x-scheme-handler/http" = "chromium.desktop";
        "x-scheme-handler/https" = "chromium.desktop";

        "video/mp4" = "mpv.desktop";
        "video/webm" = "mpv.desktop";
        "audio/mp3" = "mpv.desktop";
        "audio/ogg" = "mpv.desktop";

        "application/pdf" = "sioyek.desktop";

        "image/png" = "imv.desktop";
        "image/jpeg" = "imv.desktop";
        "image/gif" = "imv.desktop";

        "inode/directory" = "lf.desktop";

        "text/plain" = "neovim.desktop";
      };
    };
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/.bin"
    "${config.home.homeDirectory}/etc/bin"
  ];

  programs.home-manager.enable = true;
}
