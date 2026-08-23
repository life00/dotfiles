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
    "d /opt/user 0755 user user -"
  ];

  # ensure home dir + symlink structure exists
  system.activationScripts.homeSetup = lib.stringAfter [ "users" ] ''
    mkdir -p /home/user
    chown root:root /home/user
    chmod 0755 /home/user
  '';
}
