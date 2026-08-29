{ pkgs, lib, config, inputs, ... }: {
  # ponytail: minimal-install — opencode only.
  # Restore the full package lists from git history when the full
  # setup is re-enabled (they were removed to skip awecron/getmusic,
  # whose fakeHash would break the build).
  home.packages = with pkgs; [
    opencode
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