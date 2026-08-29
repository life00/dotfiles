{ pkgs, lib, config, ... }:
{
  users.users.user = {
    isNormalUser = true;
    uid = 1000;
    shell = pkgs.zsh;
    home = "/home/user";
    createHome = false; # managed by tmpfiles/disko
    group = "user";
    extraGroups = [ "wheel" "video" "audio" "networkmanager" ];
    # ponytail: minimal-install — change on first login (`passwd`), then remove
    initialPassword = "changeme";
  };

  users.groups.user.gid = 1000;

  # Ensure the zsh user shell gets the nix PATH dirs (fixes the
  # "programs.zsh.enable is not true" assertion). The restored home/shell.nix
  # (home-manager) also configures programs.zsh — both work fine together.
  programs.zsh.enable = true;

  # root password locked
  users.users.root.hashedPassword = "!";

  # minimal-install tmpfiles: the .config -> .cfg symlink and zsh histfile
  # are required by home-manager (sway/alacritty/zsh configs live in ~/.cfg)
  systemd.tmpfiles.rules = [
    "L /home/user/.config - - - - /home/user/.cfg"
    "f /var/log/zsh/histfile 0666 user user -"
    "f /var/log/history.log 0666 root root -"
  ];

  # ponytail: commented below (restore for full setup) — top-level home dirs,
  # .bin links, etc/, snsh/ and opt/user structure, history.log.

  # ponytail: minimal-install — root-ownership of /home/user disabled for now
  # (it prevented home-manager from creating ~/.cfg, ~/etc, ~/.ssh; the owner
  # is manually set to the user on the target). Restore the Fedora-style
  # root-owned top-level model (dev/doc/med/tmp/etc as root) when the home-setup
  # / tmpfiles hierarchy is fully wired and those dirs are pre-created by root.
  # ensure home dir + symlink structure exists
  system.activationScripts.homeSetup = lib.stringAfter [ "users" ] ''
    :
  '';
}