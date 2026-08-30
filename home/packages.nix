{
  pkgs,
  ...
}:
{
  # ponytail: minimal-install — the app whose config is a raw dotfile and
  # therefore NOT managed by a home-manager module anymore: lf (dotfiles/lf,
  # symlinked via home/files.nix). alacritty is Nix-native now
  # (home/terminal.nix `programs.alacritty` installs it). opencode is
  # installed by home/editor.nix `programs.opencode`.
  # home.packages = with pkgs; [
  #   lf
  # ];

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

