{ lib, ... }:
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1"; # ponytail: placeholder — replace with target disk
        content = {
          type = "gpt";
          partitions = {
            efi = {
              size = "512M";
              type = "EF00";
              label = "disk-efi";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot/efi";
                mountOptions = [ "umask=0077" "shortname=winnt" ];
              };
            };
            boot = {
              size = "1G";
              label = "disk-boot";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/boot";
                mountOptions = [ "defaults" ];
              };
            };
            root = {
              size = "100%";
              label = "disk-root";
              content = {
                type = "luks";
                name = "cryptroot";
                settings = {
                  allowDiscards = true;
                  # ponytail: hardware crypto (Apple Silicon optimization) — harmless on x86, remove if it causes issues
                };
                content = {
                  type = "btrfs";
                  subvolumes = {
                    "root" = {
                      mountpoint = "/";
                      mountOptions = [ "noatime" "compress=zstd:2" "ssd" "discard=async" "space_cache=v2" ];
                    };
                    "home" = {
                      mountpoint = "/home";
                      mountOptions = [ "noatime" "compress=zstd:2" "ssd" "discard=async" "space_cache=v2" ];
                    };
                    "swap" = {
                      mountpoint = "/var/swap";
                      mountOptions = [ "noatime" "compress=zstd:2" "ssd" "discard=async" "space_cache=v2" ];
                    };
                    "snapshots" = {
                      mountpoint = "/snsh";
                      mountOptions = [ "noatime" "compress=zstd:2" "ssd" "discard=async" "space_cache=v2" ];
                    };
                    "opt" = {
                      mountpoint = "/opt/user";
                      mountOptions = [ "noatime" "compress=zstd:2" "ssd" "discard=async" "space_cache=v2" ];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  # swapfile on swap subvolume
  swapDevices = [
    { device = "/var/swap/swapfile"; size = 8 * 1024; } # 8G
  ];

  fileSystems."/snsh/automatic/home" = {
    fsType = "none";
    device = "none";
    options = [ "bind" ];
    mountPoint = lib.mkForce "/snsh/automatic/home";
  };
}
