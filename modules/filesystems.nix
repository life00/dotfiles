{ ... }:
{
  # btrfs scrubbing and maintenance
  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [
      "/"
      "/home"
      "/var/swap"
      "/snsh"
      "/opt/user"
    ];
  };

  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  # snsh directory structure for awecron snapshots
  systemd.tmpfiles.rules = [
    "d /snsh/automatic/home/1d 0755 root root -"
    "d /snsh/automatic/home/1h 0755 root root -"
  ];
}
