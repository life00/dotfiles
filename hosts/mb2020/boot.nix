{ pkgs, ... }:
let
  # fairydust branch (asahi-7.1.13-1 + dp-altmode hacks), t8103 subset only.
  # DP out on the front-left USB-C port. Drop when dcpext lands in the asahi branch.
  fairydust = [
    {
      sha = "296c91ac1fa51a21117524561cd77eaf0c7fe62a";
      hash = "sha256-2kobKo0SE1BjA4gfp2hUvhjc6CD7TbehH88wsv3or4U=";
    }
    {
      sha = "9c16792154f8454ccbc6a28309d57d531ced015a";
      hash = "sha256-2kkcb6w51iCLI/eTPDL8tujp9RIYHKmjHcF2qa4/wgc=";
    }
    {
      sha = "7eb5629306578387dbee2add2ee4ec00239f723d";
      hash = "sha256-th2tPXOe3ndboLAzQUzbuEEnVhwkMxXFYIAdMZHroko=";
    }
    {
      sha = "7003fe04cb40b6e16ca44726857fac2cba99ec43";
      hash = "sha256-VxjLs0rP/MccTz24l9F2qbann3wEv8H0vWNa7f7U5lw=";
    }
  ];
in
{
  # systemd-boot on the dedicated NixOS ESP
  # U-Boot handles the OS selection
  # NixOS must not touch EFI variables
  boot = {
    kernelPatches = map (
      { sha, hash }:
      {
        name = "fairydust-${builtins.substring 0 12 sha}";
        patch = pkgs.fetchpatch {
          url = "https://github.com/AsahiLinux/linux/commit/${sha}.patch";
          inherit hash;
        };
      }
    ) fairydust;

    loader = {
      systemd-boot = {
        enable = true;
        # limit due to size of ESP
        configurationLimit = 3;
      };
      efi = {
        canTouchEfiVariables = false;
        efiSysMountPoint = "/boot";
      };
    };

    initrd = {
      luks.devices."cryptroot".device = "/dev/disk/by-uuid/20223176-8b5f-4add-85ce-de307701abcb";
      availableKernelModules = [ "usb_storage" ];
      kernelModules = [ ];
    };
    kernelModules = [ ];
    extraModulePackages = [ ];
    supportedFilesystems = [ "btrfs" ];

    # hardening parameters
    kernelParams = [
      "init_on_free=1"
      "panic_on_oops=1"
      "randomize_kstack_offset=1"
    ];
    kernel.sysctl."kernel.yama.ptrace_scope" = 1;

    # fix `/~ swapped with </> on the internal apple keyboard
    extraModprobeConfig = ''
      options hid_apple iso_layout=0
    '';
  };
}
