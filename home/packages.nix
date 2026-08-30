{ pkgs, lib, config, inputs, ... }: {
  # ponytail: minimal-install — opencode, plus the app whose config is a
  # raw dotfile and therefore NOT managed by a home-manager module anymore:
  # lf (dotfiles/lf, symlinked via home/files.nix). alacritty is Nix-native
  # now (home/terminal.nix `programs.alacritty` installs it).
  home.packages = with pkgs; [
    opencode
    lf
  ];

  # placeholders (commented out - enable when ready)
  # chromium configuration
  # programs.chromium = {
  #   enable = true;
  #   package = pkgs.chromium;
  #   # bookmarks, extensions, vimium config managed externally
  # };

  # syncthing
  # services.syncthing = {
  #   enable = true;
  #   dataDir = "${config.home.homeDirectory}/.cfg/syncthing";
  # };

  # opensnitch
  # programs.opensnitch = { enable = true; };
}