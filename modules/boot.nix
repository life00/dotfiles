{ ... }:
{
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      enableCryptodisk = true;
      # kernel hardening
      extraConfig = ''
        set timeout=5
      '';
    };
  };

  boot.kernelParams = [
    "init_on_free=1"
    "panic_on_oops=1"
    "randomize_kstack_offset=1"
  ];

  boot.initrd.luks.devices = {
    "cryptroot" = {
      device = "/dev/disk/by-partlabel/disk-root";
      allowHardwareCrypto = true;
    };
  };

  boot.supportedFilesystems = [ "btrfs" ];

  # ponytail: yama ptrace scope — upgrade to 2 (no ptrace at all) if hardening matters more
  boot.kernel.sysctl."kernel.yama.ptrace_scope" = 1;
}
