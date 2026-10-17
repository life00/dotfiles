# dotfiles

NixOS flake for two macbooks: `mb2020` and `mb2017`. System config is NixOS modules; user config is home-manager as a NixOS module. Sway + waybar + rofi desktop, Catppuccin Macchiato everywhere, LUKS + btrfs with snapshots, doas / usbguard / opensnitch security hardening.

## Structure

```
.
├── flake.nix        # inputs
├── hosts/
│   ├── mb2017/      # boot, hardware, disko
│   └── mb2020/      # boot, hardware, touchbar
├── modules/         # system configs
├── home/            # home-manager configs
├── pkgs/            # custom packages
│   ├── awecron/
│   └── usbguard-gui/
├── extra/           # raw configs
│   ├── nvim/        # LazyVim
│   ├── lf/
│   ├── bin/         # scripts symlinked to ~/.bin
│   └── awecron/     # croon jobs
└── wallpapers/
```

## Usage

### Rebuild

```sh
doas nixos-rebuild switch --impure --flake .#mb2020
```

`--impure` is required: `pkgs/awecron` builds from the local path `/home/user/dev/sysadmin/awecron`, which must exist.

### Update

```sh
nix flake update nixpkgs home-manager catppuccin disko   # general, or click the waybar updater
nix flake update apple-silicon                           # kernel only, always a local compile
```

Never plain `nix flake update`: the kernel inputs are pinned on purpose, since no binary cache
for `linux-asahi` exists and every change to it is compiled locally.

### Install: mb2020 (Apple Silicon)

1. Follow the [nixos-apple-silicon](https://github.com/nix-community/nixos-apple-silicon/blob/main/docs/uefi-standalone.md) guide to install m1n1 + U-Boot and boot the NixOS installer.
2. Partition manually: ESP (vfat) + one LUKS partition. Inside LUKS, btrfs with subvolumes `root`, `home`, `snapshots`, `swap`, `opt` (mounted at `/`, `/home`, `/snsh`, `/var/swap`, `/opt/user`). Disko is not used on this host.
3. Update the UUIDs in `hosts/mb2020/boot.nix` (LUKS) and `hosts/mb2020/hardware.nix` (ESP).
4. `nixos-install --impure --flake .#mb2020`

### Install: mb2017 (x86_64)

1. Set the target disk in `hosts/mb2017/disko.nix`.
2. `nix run github:nix-community/disko -- --mode destroy,format,mount ./hosts/mb2017/disko.nix`
3. `nixos-generate-config --no-filesystems --root /mnt` and merge kernel modules into `hosts/mb2017/hardware.nix`.
4. `nixos-install --impure --flake .#mb2017`

### Post-install

- Login and change user password via `passwd`.
- Import ssh and other credentials.
- Import WiFi connections.
- Initialize awecron for snapshots and updates.
- Generate usbguard policy: `usbguard generate-policy > /var/lib/usbguard/rules.conf`.
- Answer opensnitch prompts (default deny).
- Optionally enable syncthing / ollama in `modules/services.nix`.

## Notes

- XDG config is `~/.cfg`; cache/data/state under `~/etc/`. `~/.config`, `~/.cache`, `~/.local`, `~/.ssh` are compat symlinks.
- On `mb2020`, `~`, `~/.bin`, `~/.cfg` are root-owned. Edit in the repo and rebuild, not in place.
- `~/.bin` and `/etc/awecron` are symlinks to `extra/`, created by activation scripts.
- awecron runs as root: `tphome*` snapshot `/home` to `/snsh`, `updater` checks daily for updates (apply via `extra/awecron/updater/apply`). A `linux-asahi` line in its list means a kernel update is available; `apply` will not take it. Restart the service after changing jobs.
- Root is not snapshotted; use NixOS generations.
- Shell commands are logged to `/var/log/history.log`.
- `mb2020`: `canTouchEfiVariables = false` (U-Boot owns EFI); `hid_apple iso_layout=0` fixes the swapped `` ` `` / `<` keys.
- `custom-mech` xkb layout for external mechanical keyboards.
- StevenBlack hosts baked into `/etc/hosts`.
- Chromium policies in `modules/browsing.nix`; profile and extensions unmanaged.
- No secrets in the repo.
- `nixfmt` everything except the generated `hosts/mb2017/hardware.nix`.
