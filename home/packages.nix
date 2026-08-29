{ pkgs, lib, config, inputs, ... }: {
  # ponytail: minimal-install — opencode, plus the two apps whose config is a
  # raw dotfile and therefore NOT managed by a home-manager module anymore:
  # alacritty (dotfiles/alacritty, symlinked via home/terminal.nix) and lf
  # (dotfiles/lf, symlinked via home/files.nix).
  home.packages = with pkgs; [
    opencode
    alacritty
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