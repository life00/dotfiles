{ pkgs, ... }:
{
  # systemd-boot on the dedicated NixOS ESP (one ESP per OS on Asahi).
  # U-Boot handles the OS selection; NixOS must not touch EFI variables.
  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = false;
      efiSysMountPoint = "/boot";
    };
  };

  boot.supportedFilesystems = [ "btrfs" ];

  # hardening parameters (same as mb2017)
  boot.kernelParams = [
    "init_on_free=1"
    "panic_on_oops=1"
    "randomize_kstack_offset=1"
  ];
  boot.kernel.sysctl."kernel.yama.ptrace_scope" = 1;

  # fix `/~ swapped with </> on the internal Apple keyboard
  boot.extraModprobeConfig = ''
    options hid_apple iso_layout=0
  '';

  # Touch Bar renders on the main display instead of the bar itself
  hardware.apple.touchBar = {
    enable = true;
    package = pkgs.tiny-dfr;
  };
}