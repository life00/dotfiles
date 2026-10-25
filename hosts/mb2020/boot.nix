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

  # fairydust branch (asahi-7.2.12-2 + dp-altmode hacks), t8103 subset only.
  # Repin on every apple-silicon kernel bump: its DTS hacks must match the new DT bindings.
  # DP out on the front-left USB-C port. Drop when dcpext lands in the asahi branch.
  fairydust = [
    {
      sha = "f9296f91367f40850027e233e2c9dd40addc6aed";
      hash = "sha256-lXSwHE69PtHDVpbsQatUnhOc3qdnGrt4RZLwSz/ujfU=";
    }
    {
      sha = "994d32fe34b8494644356c6fde51938d0419093d";
      hash = "sha256-eSzppQSjsc+rzFUP8gzAAngXb6poRBKXvoGV1fgWCfk=";
    }
    {
      sha = "c3f7878dbfc98e846543896acb030dba00b1e85d";
      hash = "sha256-HmTSwPu8D4eKCCG3lh8E2OxRBSLbC52/XmIcZV+QIRY=";
    }
    {
      sha = "8173cf5cbee66e37126a823e84d91ab29cab3672";
      hash = "sha256-GhHKVmAt5OEQIe0hWIcoCa0EVRP5Pa3FKac374a9Gms=";
    }
  ];
in
{
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
