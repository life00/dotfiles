# Architecture

## Design decisions

- **Flakes-based** NixOS config (not channels). Pinned inputs: `nixpkgs` (unstable), `home-manager`, `disko`, `catppuccin`, `stevenblack-hosts`.
- **Home Manager as a NixOS module** (`home-manager.nixosModules.home-manager`) — single `nixos-rebuild switch` rebuilds everything. HM is *not* used for everything; complex configs live as raw extra via `home.file`/`xdg.configFile`.
- **catppuccin/nix** supplies all Catppuccin themes as first-class HM modules (gtk, cursors, fzf, nvim, alacritty, bat, delta, zsh fsh, starship, swaylock, waybar, dunst).
- **disko** declaratively formats the disk (LUKS + btrfs subvolumes, swapfile).

## Layout

```
hosts/mb2017/default.nix  # host entry: imports all modules, home-manager
hosts/mb2017/hardware.nix # kernel modules (placeholder on target)

modules/          # NixOS options: boot, disko, filesystems, networking,
                  # security, users, locale, services, packages, fonts, greetd
home/             # HM options: shell, git, terminal, editor, desktop,
                  # media, files, theme, packages
pkgs/             # custom derivations: awecron, getmusic (Go build)
extra/          # raw configs: zsh, rofi, ncmpcpp,
                  # cava, lf, sioyek, khal, nvim, ssh, bin/, awecron
                  # (sway, swaylock, waybar, dunst are now Nix-native — see home/desktop.nix)
modules/xkb/      # custom-mech xkb layout file
```

## Ownership model

Home-manager manages user-owned `~/.cfg`. A `systemd.tmpfiles.rules` block in `modules/users.nix` chowns hierarchical structure (top-level dirs `dev/`, `doc/`, `med/`, `tmp/`, `etc/`) and system logdirs (`/var/log/zsh`, `/var/log/history.log`) to `root`. This replicates the Fedora/Asahi mixed-ownership model.
