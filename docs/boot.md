# Boot

Implemented in `modules/boot.nix`.

## Bootloader

GRUB with UEFI. ESP at `/boot/efi`; `/boot` is a separate ext4 partition for kernels/initramfs. `grub.enable = true`, `grub.efiSupport = true`, `grub.enableCryptodisk = true`, `grub.device = "nodev"`.

## LUKS

`boot.initrd.luks.devices.cryptroot` — maps `/dev/disk/by-partlabel/disk-root` → `cryptroot`. `allowHardwareCrypto = true` (was `--perf-no_read_workqueue --perf-no_write_workqueue --persistent` on Asahi; on x86_64 this is a no-op passthrough).

## Kernel hardening

`boot.kernelParams`:

```
init_on_free=1
panic_on_oops=1
randomize_kstack_offset=1
```

Carried over from `/etc/default/grub` in the Fedora setup.

## sysctl

`kernel.yama.ptrace_scope = 1` (was `/etc/sysctl.d/yama.conf`).

## Hardware modules

`hosts/localhost/hardware.nix` is a placeholder (`nvme`, `xhci_pci`, `ahci`, `usbhid`, `sd_mod`, `kvm-intel`). Regenerate on the target with `nixos-generate-config` and merge.
