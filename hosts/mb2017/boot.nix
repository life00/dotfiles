{ config, pkgs, ... }:
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

  # in-tree cs8409 only knows Dell boards; speakers/headphones need the Apple fork
  boot.extraModulePackages = [
    (config.boot.kernelPackages.callPackage ../../pkgs/snd-hda-macbookpro { })
  ];

  # hardening parameters
  boot.kernelParams = [
    "init_on_free=1"
    "oops=panic"
    "randomize_kstack_offset=1"
  ];
  boot.kernel.sysctl."kernel.yama.ptrace_scope" = 1;

}
