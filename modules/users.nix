{ pkgs, lib, config, ... }:
{
  users.users.user = {
    isNormalUser = true;
    uid = 1000;
    shell = pkgs.zsh;
    home = "/home/user";
    createHome = false; # managed by tmpfiles/disko
    group = "user";
    extraGroups = [ "wheel" "video" "audio" "networkmanager" "libvirtd" "qemu-libvirtd" ];
    # fresh installs need a bootstrap password; change on first login (`passwd`).
    # Kept intentionally — removing would break new installs.
    initialPassword = "password";
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
  # ~/.bin lives in /home/user but is root-owned (mkdir in homeSetup below);
  # systemd-tmpfiles refuses `L` under /home/user ("unsafe path transition —
  # /home/user owned by user"), so the links are created at activation via
  # homeSetup instead. Covers both the sway key-binding scripts (f4/f10/f11
  # in dotfiles/sway/config → ~/.cfg/rofi/bin/*) and dotfiles/bin.
  systemd.tmpfiles.rules = [
    "L+ /home/user/.config - - - - /home/user/.cfg"
    "f /var/log/zsh/histfile 0666 user user -"
    "f /var/log/history.log 0666 root root -"
  ];

  # Build-time store reference (${./../dotfiles/bin}) so the loop works even
  # before home-manager has created the ~/.cfg/bin symlink.
  system.activationScripts.homeSetup = lib.stringAfter [ "users" ] ''
    mkdir -p /home/user/.bin
    ln -sfn /home/user/.cfg/rofi/bin/killer    /home/user/.bin/killer
    ln -sfn /home/user/.cfg/rofi/bin/powermenu /home/user/.bin/powermenu
    ln -sfn /home/user/.cfg/rofi/bin/scsh      /home/user/.bin/scsh
    # dotfiles/bin workflow scripts — built-in store reference so activation
    # does not depend on the ~/.cfg/bin home-manager symlink (created later).
    for f in ${./../dotfiles/bin}/*; do
      [ -e "$f" ] || continue
      ln -sfn "$f" "/home/user/.bin/$(basename "$f")"
    done
  '';
}