{ pkgs, ... }:
{
  # systemd-boot on the dedicated NixOS ESP
  # U-Boot handles the OS selection
  # NixOS must not touch EFI variables
  boot = {

    loader = {
      systemd-boot.enable = true;
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

  hardware.apple.touchBar = {
    enable = true;
    package = pkgs.tiny-dfr;
  };
}
