{ pkgs, lib, config, ... }:
{
  users.users.user = {
    isNormalUser = false;
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

  # root password locked
  users.users.root.hashedPassword = "!";

  # minimal-install tmpfiles: the .config -> .cfg symlink and zsh histfile
  # are required by home-manager (sway/alacritty/zsh configs live in ~/.cfg)
  systemd.tmpfiles.rules = [
    "L /home/user/.config - - - - /home/user/.cfg"
    "f /var/log/zsh/histfile 0666 user user -"
  ];

  # ponytail: commented below (restore for full setup) — top-level home dirs,
  # .bin links, etc/, snsh/ and opt/user structure, history.log.

  # ensure home dir + symlink structure exists
  system.activationScripts.homeSetup = lib.stringAfter [ "users" ] ''
    mkdir -p /home/user
    chown root:root /home/user
    chmod 0755 /home/user
  '';
}