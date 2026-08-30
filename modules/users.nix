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

  # System-wide command logging to /var/log/history.log (mode 0666 from the
  # tmpfiles rule above), kept in one place. Fedora logged root commands via
  # PROMPT_COMMAND in /root/.bashrc; root still runs bash here (the doas
  # wrapper forces SHELL=/bin/bash), so it gets the same hook at system level.
  # The user zsh `precmd` hook (formerly HM initExtraFirst in home/shell.nix)
  # moved here too, as programs.zsh.interactiveShellInit.
  programs.zsh.interactiveShellInit = ''
    precmd() {
      retrn=$?
      historylog="($(date +%s%N|cut -b1-10)) {$$} $(pwd) [$retrn] $(history -1 | sed 's/^[ ]*[0-9]\+[ ]*//')"
      echo "$historylog" >> /var/log/history.log
    }
  '';

  programs.bash = {
    enable = true;
    # root-only: /etc/bashrc is shared by every interactive bash, but the user
    # shell is zsh — log only root sessions (doas sets SHELL=/bin/bash).
    interactiveShellInit = ''
      if [[ $UID -eq 0 ]]; then
        PROMPT_COMMAND='historylog="($(date +%s%N|cut -b1-10)) {$$} $(pwd) [$?] $(fc -ln -1)"; echo "$historylog" >> /var/log/history.log'
      fi
    '';
  };

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