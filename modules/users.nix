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
  # are required by home-manager (sway/alacritty/zsh configs live in ~/.cfg).
  # L+ forces the symlink: at install the initial /home/user/.config may exist
  # as a real dir, which plain "L" would silently leave in place (and then the
  # systemd user manager never sees HM's ~/.cfg/systemd/user units).
  #
# ~/.bin links for the sway key bindings (f4/f10/f11 in dotfiles/sway/config).
  # Created at activation via homeSetup (see below) — systemd-tmpfiles refuses
  # `L` under /home/user ("unsafe path transition — /home/user owned by user").
  # The other historical ~/.bin links pointed into ~/dev/bin/* (workflow scripts
  # not in this repo) — left out until ~/dev/bin exists on target.
  systemd.tmpfiles.rules = [
    "L+ /home/user/.config - - - - /home/user/.cfg"
    "f /var/log/zsh/histfile 0666 user user -"
    "f /var/log/history.log 0666 root root -"
  ];

  # systemd-tmpfiles refuses to place the ~/.bin links above (user-owned
  # /home/user == "unsafe path transition"), so `ln -sfn` them at activation.
  # ponytail: commented below (restore for full setup) — top-level home dirs,
  # dot-<->etc symlinks, /opt/user structure, history.log.

  # ponytail: the Fedora-style root-owned top-level home model
  # (dev/doc/med/tmp/etc owned by root) is intentionally NOT applied: it breaks
  # day-to-day writes (XDG_DOWNLOAD_DIR=~/tmp, todo scans of ~/doc, home-manager
  # creating ~/etc/{data,cache,state} and ~/.cfg as a non-root user). Minimal
  # install runs with a fully user-owned home instead. Revisit only if the user
  # data model changes (e.g. all home subdirs pre-created user-owned + top-level
  # dirs become read-only mount points).
  system.activationScripts.homeSetup = lib.stringAfter [ "users" ] ''
    mkdir -p /home/user/.bin
    ln -sfn /home/user/.cfg/rofi/bin/killer    /home/user/.bin/killer
    ln -sfn /home/user/.cfg/rofi/bin/powermenu /home/user/.bin/powermenu
    ln -sfn /home/user/.cfg/rofi/bin/scsh      /home/user/.bin/scsh
  '';
}