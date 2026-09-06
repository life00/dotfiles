# Hardware configuration synced from `nixos-generate-config` output on this host (see /etc/nixos/hardware-configuration.nix).
{
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # apple silicon requires manual partitioning
  # therefore disko is not used

  fileSystems = {
    "/" = {
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = [
        "subvol=root"
        "noatime"
        "compress=zstd:2"
        "ssd"
        "discard=async"
        "space_cache=v2"
      ];
    };
    "/home" = {
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = [
        "subvol=home"
        "noatime"
        "compress=zstd:2"
        "ssd"
        "discard=async"
        "space_cache=v2"
      ];
    };

    "/snsh" = {
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = [
        "subvol=snapshots"
        "noatime"
        "compress=zstd:2"
        "ssd"
        "discard=async"
        "space_cache=v2"
      ];
    };

    "/var/swap" = {
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = [ "subvol=swap" ];
    };

    "/opt/user" = {
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = [
        "subvol=opt"
        "noatime"
        "compress=zstd:2"
        "ssd"
        "discard=async"
        "space_cache=v2"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/41EE-3266";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };

  swapDevices = [
    {
      device = "/var/swap/swapfile";
      size = 16 * 1024;
    }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
