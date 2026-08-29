# Disk & Filesystems

## Layout (disko)

Implemented in `modules/disko.nix`. Target device is a `/dev/nvme0n1` placeholder — edit before install.

| Partition | FS | Mount | Notes |
|-----------|-----|-------|-------|
| `p1` | FAT32 (ESP) | `/boot/efi` | `umask=0077 shortname=winnt` |
| `p2` | ext4 | `/boot` | fedora_boot equivalent |
| `p3` | LUKS2 → btrfs | (multiple mountpoints) | enrolled with `--reduce-device-size 32M --sector-size=4096` equivalent |

## Btrfs subvolumes (inside p3)

| Subvolume | Mount | Flags |
|-----------|-------|-------|
| `root` | `/` | `noatime,compress=zstd:2,ssd,discard=async,space_cache=v2` |
| `home` | `/home` | same |
| `swap` | `/var/swap` | same |
| `snapshots` | `/snsh` | same |
| `opt` | `/opt/user` | same |

## Swap

`/var/swap/swapfile` — 8 GB, created by `btrfs filesystem mkswapfile --size 8g --uuid clear`. Listed in `swapDevices`.

## Snapshots

btrfs baseline layout at `/snsh` with autosniper dirs (`automatic/home/{1d,1h}`). Root-snapshot directories intentionally omitted — NixOS generations supersede them. Snapshot creation is driven by `awecron` (see `services.md`).

## Maintenance

- `services.btrfs.autoScrub` enabled across all mountpoints.
- `services.fstrim` weekly.
- `systemd.tmpfiles.rules` creates `/snsh/automatic/home/{1d,1h}` with mode 0755.
