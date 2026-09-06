{ ... }:
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        # this is a placeholder for the target device drive
        device = "/dev/nvme0n1";
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
                mountOptions = [
                  "umask=0077"
                  "shortname=winnt"
                ];
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
                };
                content = {
                  type = "btrfs";
                  subvolumes = {
                    "root" = {
                      mountpoint = "/";
                      mountOptions = [
                        "noatime"
                        "compress=zstd:2"
                        "ssd"
                        "discard=async"
                        "space_cache=v2"
                      ];
                    };
                    "home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "noatime"
                        "compress=zstd:2"
                        "ssd"
                        "discard=async"
                        "space_cache=v2"
                      ];
                    };
                    "swap" = {
                      mountpoint = "/var/swap";
                      mountOptions = [
                        "noatime"
                        "compress=zstd:2"
                        "ssd"
                        "discard=async"
                        "space_cache=v2"
                      ];
                    };
                    "snapshots" = {
                      mountpoint = "/snsh";
                      mountOptions = [
                        "noatime"
                        "compress=zstd:2"
                        "ssd"
                        "discard=async"
                        "space_cache=v2"
                      ];
                    };
                    "opt" = {
                      mountpoint = "/opt/user";
                      mountOptions = [
                        "noatime"
                        "compress=zstd:2"
                        "ssd"
                        "discard=async"
                        "space_cache=v2"
                      ];
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

  swapDevices = [
    {
      device = "/var/swap/swapfile";
      size = 16 * 1024;
    }
  ];

}
