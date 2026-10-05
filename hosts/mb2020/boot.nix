{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  # kernel builds from a pinned nixpkgs so toolchain churn can't force a recompile
  kpkgs = import inputs.nixpkgs-kernel {
    system = "aarch64-linux";
    overlays = [ inputs.apple-silicon.overlays.default ];
  };

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
  # FIXME: compile flags issue
  # drop once https://github.com/nix-community/nixos-apple-silicon/pull/559 is merged
  nixpkgs.overlays = [
    (final: prev: {
      uboot-asahi = prev.uboot-asahi.overrideAttrs { postPatch = "patchShebangs tools scripts"; };
    })
  ];

  # systemd-boot on the dedicated NixOS ESP
  # U-Boot handles the OS selection
  # NixOS must not touch EFI variables
  boot = {
    # kconfig defaults + asahi.config instead of all nixpkgs default unnecessary modules
    kernelPackages = lib.mkForce (
      kpkgs.linuxPackagesFor (
        (kpkgs.linux-asahi.override { _kernelPatches = config.boot.kernelPatches; }).kernel.override {
          buildLinux =
            args:
            kpkgs.buildLinux (
              args
              // {
                autoModules = false;
                defconfig = "defconfig asahi.config";
                # nixpkgs common-config answers for subsystems that are now off
                ignoreConfigErrors = true;
              }
            );
        }
      )
    );

    kernelPatches =
      map (
        { sha, hash }:
        {
          name = "fairydust-${builtins.substring 0 12 sha}";
          patch = pkgs.fetchpatch {
            url = "https://github.com/AsahiLinux/linux/commit/${sha}.patch";
            inherit hash;
          };
        }
      ) fairydust
      ++ [
        {
          # what arm64 defconfig leaves off but this system loads
          name = "mb2020 config";
          patch = null;
          structuredExtraConfig = with lib.kernel; {
            # luks root
            DM_CRYPT = module;
            CRYPTO_USER_API_SKCIPHER = module;
            CRYPTO_USER_API_HASH = module;
            CRYPTO_USER_API_AEAD = module;
            # firewall (iptables-nft), docker, libvirt
            NF_TABLES = module;
            NFT_COMPAT = module;
            NFT_CT = module;
            NFT_NAT = module;
            NFT_QUEUE = module;
            NF_NAT = module;
            NF_CT_NETLINK = module;
            NETFILTER_NETLINK_QUEUE = module;
            NETFILTER_XT_NAT = module;
            NETFILTER_XT_TARGET_MASQUERADE = module;
            NETFILTER_XT_MATCH_PKTTYPE = module;
            IP_NF_MATCH_RPFILTER = module;
            IP6_NF_MATCH_RPFILTER = module;
            IP_SET = module;
            NETFILTER_XT_SET = module;
            # systemd default qdisc, networkmanager
            NET_SCH_FQ_CODEL = module;
            XFRM_USER = module;
            # wireguard vpn
            WIREGUARD = module;
            # tiny-dfr, pipewire midi
            INPUT_UINPUT = module;
            SND_SEQUENCER = module;
            SND_HRTIMER = module;
          };
        }
      ];

    # nixpkgs default initrd list names drivers this kernel no longer builds
    initrd.allowMissingModules = true;

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
