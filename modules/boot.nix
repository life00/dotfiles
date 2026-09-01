{ pkgs, ... }:
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
      font = "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNLNerdFontMono-Bold.ttf";
      fontSize = 32;
      extraConfig = ''
        set timeout=5
      '';
    };
  };

  boot.initrd.luks.devices = {
    "cryptroot" = {
      device = "/dev/disk/by-partlabel/disk-root";
    };
  };

  boot.supportedFilesystems = [ "btrfs" ];

  # hardening parameters
  boot.kernelParams = [
    "init_on_free=1"
    "panic_on_oops=1"
    "randomize_kstack_offset=1"
  ];
  boot.kernel.sysctl."kernel.yama.ptrace_scope" = 1;

}
