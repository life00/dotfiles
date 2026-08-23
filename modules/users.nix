{ pkgs, lib, config, ... }:
{
  users.users.user = {
    isNormalUser = false;
    uid = 1000;
    shell = pkgs.zsh;
    home = "/home/user";
    createHome = false; # managed by tmpfiles/disko
    group = "user";
    extraGroups = [ "wheel" "video" "audio" "libvirt" "networkmanager" ];
  };

  users.groups.user.gid = 1000;
  users.groups.libvirt = { };

  # root password locked
  users.users.root.hashedPassword = "!";

  # root-ownership of top-level home directories + selected configs
  # ponytail: chown after home-manager applies; mirrors Fedora Asahi ownership pattern
  systemd.tmpfiles.rules = [
    # top-level dirs
    "d /home/user/dev 0755 root root -"
    "d /home/user/doc 0755 root root -"
    "d /home/user/med 0755 root root -"
    "d /home/user/tmp 0755 root root -"
    "d /home/user/etc 0755 root root -"
    # etc/ second-level dirs (placeholders)
    "d /home/user/etc/bin 0755 root root -"
    "d /home/user/etc/cache 0755 root root -"
    "d /home/user/etc/data 0755 root root -"
    "d /home/user/etc/etc 0755 root root -"
    "d /home/user/etc/lib 0755 root root -"
    "d /home/user/etc/sec 0755 root root -"
    "d /home/user/etc/share 0755 root root -"
    # history log dirs
    "d /var/log/zsh 0755 root root -"
    "f /var/log/zsh/histfile 0666 user user -"
    "f /var/log/history.log 0666 root root -"
    # snsh structure
    "d /snsh/automatic/home 0755 root root -"
    "d /snsh/automatic/home/1d 0755 root root -"
    "d /snsh/automatic/home/1h 0755 root root -"
    "d /snsh/static 0755 root root -"
    # opt/user
    "d /opt/user 0755 root root -"
    # symlinks
    "L /home/user/.cache - - - - /home/user/etc/cache"
    "L /home/user/.cert - - - - /home/user/etc/data/cert"
    "L /home/user/.config - - - - /home/user/.cfg"
    "L /home/user/.local - - - - /home/user/etc"
    "L /home/user/.npm - - - - /home/user/etc/data/npm"
    "L /home/user/.ssh - - - - /home/user/.cfg/ssh"
    "L /home/user/.jupyter - - - - /home/user/etc/data/jupyter"
    "L /home/user/.qt_material - - - - /home/user/etc/cache/qt_material"
    "L /home/user/.ollama - - - - /opt/user/ollama"
    # .bin symlinks
    "L /home/user/.bin/fetch - - - - /home/user/dev/bin/fetch"
    "L /home/user/.bin/zlf - - - - /home/user/dev/bin/zlf"
    "L /home/user/.bin/todoi - - - - /home/user/dev/bin/todoi"
    "L /home/user/.bin/pdf2nocopy - - - - /home/user/dev/bin/pdf2nocopy"
    "L /home/user/.bin/catexif - - - - /home/user/dev/bin/catexif"
    "L /home/user/.bin/imgcompress - - - - /home/user/dev/bin/imgcompress"
    "L /home/user/.bin/ipext - - - - /home/user/dev/bin/ipext"
    "L /home/user/.bin/ipint - - - - /home/user/dev/bin/ipint"
    "L /home/user/.bin/rmexif - - - - /home/user/dev/bin/rmexif"
    "L /home/user/.bin/sioyek-open - - - - /home/user/dev/bin/sioyek-open"
    "L /home/user/.bin/wgetweb - - - - /home/user/dev/bin/wgetweb"
    "L /home/user/.bin/yt-dlp-lofi - - - - /home/user/dev/bin/yt-dlp-lofi"
    "L /home/user/.bin/ufetch - - - - /home/user/dev/bin/ufetch"
    "L /home/user/.bin/btrfs-file-delete - - - - /home/user/dev/bin/btrfs-file-delete.sh"
    "L /home/user/.bin/killer - - - - /home/user/.cfg/rofi/bin/killer"
    "L /home/user/.bin/powermenu - - - - /home/user/.cfg/rofi/bin/powermenu"
    "L /home/user/.bin/scsh - - - - /home/user/.cfg/rofi/bin/scsh"
  ];

  # ensure home dir + symlink structure exists
  system.activationScripts.homeSetup = lib.stringAfter [ "users" ] ''
    mkdir -p /home/user
    chown root:root /home/user
    chmod 0755 /home/user
  '';
}
