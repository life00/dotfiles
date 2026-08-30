# NixOS Configuration

NixOS flake-based configuration replicating a Fedora Asahi Linux workstation setup on x86_64 hardware. System-level configuration is declarative via NixOS modules; user-level configuration uses home-manager (as a NixOS module) where practical and raw dotfiles for complex setups.

## Structure

```
.
├── flake.nix                    # flake entry: nixpkgs, home-manager, disko, catppuccin, stevenblack-hosts
├── hosts/
│   └── mb2017/               # host entry (hostname: nixos)
│       ├── default.nix          # imports all modules + home-manager
│       └── hardware.nix          # kernel modules, platform (placeholder — regenerate on target)
├── modules/                     # system-level NixOS modules
│   ├── boot.nix                # GRUB EFI, LUKS, kernel hardening, sysctl yama
│   ├── disko.nix               # declarative disk layout (LUKS + btrfs subvolumes)
│   ├── filesystems.nix         # btrfs mount options, swap
│   ├── networking.nix          # NetworkManager, firewalld (drop), MAC randomization, hosts
│   ├── security.nix            # doas, usbguard, opensnitch, sshd disabled
│   ├── users.nix               # user account, groups, root-ownership tmpfiles
│   ├── locale.nix              # timezone, locale, console font, custom-mech xkb
│   ├── services.nix            # awecron, mpd, syncthing (disabled), ollama (disabled), virt
│   ├── packages.nix            # system packages
│   ├── fonts.nix               # JetBrainsMono NFM, Papirus, Catppuccin cursors
│   └── greetd.nix              # greetd + regreet (Wayland greeter)
├── home/                        # home-manager modules
│   ├── default.nix             # entry, imports all
│   ├── shell.nix               # zsh, starship, history logging
│   ├── git.nix                 # git config, ssh, allowed_signers
│   ├── terminal.nix            # alacritty
│   ├── editor.nix              # neovim (dotfiles), bat
│   ├── desktop.nix             # sway (native config), waybar, rofi, dunst, swayidle
│   ├── media.nix               # mpd, ncmpcpp, mpv, cava, obs/gimp placeholders
│   ├── files.nix               # lf, dev/bin scripts, qalculate, bottom, sioyek
│   ├── theme.nix               # Catppuccin (GTK, cursors, fsh), dconf
│   └── packages.nix            # user packages + chromium/syncthing/opensnitch placeholders
├── pkgs/                         # custom derivations
│   ├── awecron/                # custom cron daemon (Go) — src/ is gitignored
│   └── getmusic/               # custom utility (Go) — src/ is gitignored
├── wallpapers/                   # sway wallpapers (tux.png, etc.) — absolute store path in config
└── dotfiles/                    # raw config files
    ├── zsh/                    # startup, aliases, addons, config/
    ├── waybar/                 # config + style.css
    ├── rofi/                   # config.rasi + config/ + bin/
    ├── dunst/                   # dunstrc
    ├── ncmpcpp/                # config + bindings
    ├── cava/                   # config + shaders/
    ├── lf/                     # lfrc, colors, preview.sh, lfrc.cmd
    ├── sioyek/                 # prefs_user.config, keys_user.config
    ├── khal/                   # config
    ├── nvim/                   # LazyVim config (external, HM installs neovim)
    ├── ssh/                    # config, allowed_signers (no keys)
    ├── bin/                    # custom scripts (fetch, zlf, todoi, etc.)
    └── awecron/                # cfg, tphome scripts, updater
```

## Installation

### 1. Prepare the disk device

Edit `modules/disko.nix` and replace the placeholder disk device (`/dev/nvme0n1`) with your target disk.

### 2. Build and apply the disk layout

```sh
nix run github:nix-community/disko -- --mode destroy,format,mount ./modules/disko.nix
```

### 3. Generate hardware config (optional but recommended)

```sh
nixos-generate-config --no-filesystems --root /mnt
# Merge any detected kernel modules into hosts/mb2017/hardware.nix
```

### 4. Install

```sh
nixos-install --flake .#mb2017
```

### 5. Post-install

Reboot, log in via greetd, and complete the manual steps below.

## Manual post-install exceptions

Some things cannot (or should not) be included in the declarative config:

- **Disk device name**: Replace the placeholder in `modules/disko.nix` before install.
- **SSH private keys**: Copy to `~/etc/sec/ssh/` (e.g. `key-r0.sec`).
- **NetworkManager connections**: ~45 WiFi networks with passwords — import manually via `nmcli connection import`.
- **Syncthing config**: Device IDs and shared folders — configure via the Syncthing Web UI after enabling the service.
- **Chromium profile**: Extensions, bookmarks, Vimium config — managed externally; `home/packages.nix` has a placeholder for future HM management.
- **Custom package sources**: `pkgs/awecron/src/` and `pkgs/getmusic/src/` are gitignored. Copy the source from the original dev tree before building:
  ```sh
  cp -r /path/to/awecron-src pkgs/awecron/src
  cp -r /path/to/getmusic-src pkgs/getmusic/src
  ```

## Notes

- `syncthing` and `ollama` services are defined but **disabled** by default. Enable in `modules/services.nix` when ready.
- Root snapshotting (awecron `tproot` jobs) was removed; only `tphome` snapshot jobs are kept. NixOS handles root rollback via generations.
- The custom `custom-mech` xkb layout (mechanical keyboard remap) is installed system-wide.
- Catppuccin themes are sourced via the `catppuccin/nix` flake input (not hardcoded).
- StevenBlack hosts (fakenews+gambling+porn) are fetched at build time via the flake input.
