# Documentation Index

Detailed documentation for the NixOS configuration. Each page covers one aspect of the system, referencing the implementing files.

| Page | Topics |
|------|--------|
| [architecture.md](architecture.md) | Design decisions: flakes, home-manager, module layout |
| [disk.md](disk.md) | LUKS, btrfs subvolumes, disko, swap |
| [boot.md](boot.md) | GRUB EFI, kernel hardening, sysctl |
| [networking.md](networking.md) | NetworkManager, firewalld, MAC randomization, hosts files |
| [security.md](security.md) | doas, usbguard, opensnitch, sshd |
| [users.md](users.md) | user account, groups, root-ownership |
| [packages.md](packages.md) | Package categorization, custom derivations |
| [desktop.md](desktop.md) | sway, waybar, rofi, greetd, xkb |
| [shell.md](shell.md) | zsh, starship, history logging |
| [home-manager.md](home-manager.md) | HM-native vs dotfiles strategy |
| [custom-packages.md](custom-packages.md) | awecron, getmusic build details |
| [dotfiles.md](dotfiles.md) | Raw config file inventory and rationale |
| [services.md](services.md) | Enabled and disabled services |
| [theming.md](theming.md) | Catppuccin Macchiato implementation |
| [exclusions.md](exclusions.md) | Components intentionally not ported |
| [install.md](install.md) | Installation steps and post-install checklist |
