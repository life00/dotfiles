# Installation

Steps to install this NixOS config on a fresh x86_64 machine (UEFI).

## Prerequisites

- NixOS installation ISO (boot from USB).
- This repo copied to the target (or reachable from install media).
- Target disk device known (`lsblk`); default placeholder is `/dev/nvme0n1`.

## 1. Boot & partition

1. Boot the NixOS ISO into a shell.
2. Replace the placeholders in `modules/disko.nix`:
   - `device = "/dev/nvme0n1"` → real device.
3. (Optional) fix `hardware.nix` kernel modules after running `nixos-generate-config`.
4. Confirm `disko` runs **destroy,format,mount** (destroys disk!):

```sh
nix run github:nix-community/disko -- --mode destroy,format,mount ./modules/disko.nix
```

This creates GPT (ESP 512M @ /boot/efi, ext4 boot 1G @ /boot, LUKS2 root p3) and btrfs subvolumes (`root`, `home`, `swap`, `snapshots`, `opt`) with the `noatime,compress=zstd:2,ssd,discard=async,space_cache=v2` options, mounting everything under `/mnt`.

## 2. Generate hardware config

```sh
nixos-generate-config --no-filesystems --root /mnt
nix --extra-experimental-features 'nix-command flakes' flake show .#nixosConfigurations.localhost
```

Merge detected kernel modules from the generated `hardware-configuration.nix` into `hosts/localhost/hardware.nix`.

## 3. Install

```sh
nixos-install --flake /path/to/repo#localhost
# with custom disk device:
nixos-install --flake /path/to/repo#localhost --root /mnt
```

Sets root password prompt (root will be locked immediately after; user password set via `passwd user` in system).

## 4. First boot & post-install checklist

Reboot; greetd (tuigreet) asks for credentials; log in as `user` (shell zsh, sway starts automatically).

Then:

- [ ] Set user password (`passwd`) if not set during install.
- [ ] Copy SSH private keys → `~/etc/sec/ssh/` (`key-r0.sec`, etc.).
- [ ] Import WiFi connections: `nmcli connection import type wifi file <file>` (or re-enter networks).
- [ ] Sync SSH known_hosts; verify git signing (`git config --list`, test `ssh -T git@github.com`).
- [ ] USBGuard: `sudo usbguard generate-policy > /etc/usbguard/rules.conf && systemctl restart usbguard`.
- [ ] Opensnitch: allow rules will be re-requested by GUI on first forbidden egress.
- [ ] Syncthing: `sudo systemctl enable --now syncthing@user` (service defined but disabled) → configure devices/folders in Web UI (8384).
- [ ] Ollama: `sudo systemctl enable --now ollama` → `ollama pull <models>` (list in README).
- [ ] MPD: check `~/.cfg/mpd` writable; `mpc volume 50`.
- [ ] Chromium: install extensions, import bookmarks/Vimium (manual).
- [ ] Awecron: verify jobs run (`systemctl status awecron`, `ls ~/.cfg/awecron/*/tmr`).
- [ ] Custom packages: fill `vendorHash`/`hash` in pkgs/* or drop local `src/` (see custom-packages.md).
- [ ] Set up libreoffice/VirtManager defaults (dconf), GIMP theme if needed.

## Notes

- First `nixos-rebuild switch` may take a while (builds everything from closure).
- The repo is intended to be carried to offline system: keep `pkgs/*/src/` gitignored copies + fixed hashes for offline builds.