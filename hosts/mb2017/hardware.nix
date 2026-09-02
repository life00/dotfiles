# Kernel modules synced from `nixos-generate-config` output on this host (see /etc/nixos/hardware-configuration.nix).

{
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/hardware/network/broadcom-43xx.nix")
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "nvme"
    "usb_storage"
    "sd_mod"
    "applespi"
    "intel_lpss_pci"
    "spi_pxa2xx_platform"
  ];
  boot.initrd.kernelModules = [ "applesmc" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # MBP 2017 suspend/.resume fixes
  boot.kernelParams = [
    "intel_iommu=on" # required for applespi keyboard in stage 1
    "pcie_ports=compat" # fix Thunderbolt xHCI controller reset after resume
    "nvme_core.default_ps_max_latency_us=0" # prevent NVMe D3 cold deep sleep
  ];

  # Pre/post suspend hook: disable d3cold + force PCI re-probe of WiFi
  environment.etc."systemd/system-sleep/mbp-suspend" = {
    mode = "0755";
    text = ''
    #!/bin/sh
    case $1 in
      pre)
        # prevent NVMe/PCIe entering D3 cold (causes hang on resume)
        find /sys/devices -name d3cold_allowed -exec sh -c 'echo 0 > "$1"' _ {} \; 2>/dev/null
        # unload drivers that freeze during suspend entry
        modprobe -r applespi 2>/dev/null || true
        ;;
      post)
        sleep 2
        modprobe applespi 2>/dev/null || true
        # force full PCI re-enumeration of the Broadcom WiFi device,
        # module reload alone leaves it unenumerated (no wlan0)
        for d in /sys/bus/pci/devices/*; do
          [ "$(cat "$d/vendor" 2>/dev/null)" = "0x14e4" ] || continue
          echo 1 > "$d/remove" 2>/dev/null
        done
        echo 1 > /sys/bus/pci/rescan 2>/dev/null
        sleep 3
        # re-associate WiFi
        nmcli radio wifi off 2>/dev/null
        sleep 1
        nmcli radio wifi on 2>/dev/null
        ;;
    esac
    '';
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
