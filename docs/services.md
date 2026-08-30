# Services

## Enabled

| Service | Where | Notes |
|---------|-------|-------|
| `awecron` | modules/services.nix | Custom cron daemon (see custom-packages.md). Runs cronjobs from `~/.cfg/awecron/` as root. |
| `mpd` (user) | home/media.nix | Music daemon; pipewire output, playlist/state under `~/.cfg/mpd`. Started via HM `services.mpd`. |
| `pipewire` | modules/services.nix | Sound server (wireplumber + pipewire-pulse), drives mpd/volume keys. |
| `syncthing` | modules/services.nix | System service under `user`; config `~/.cfg/syncthing`, GUI `127.0.0.1:8384`. Devices/folders added via Web UI (overrideDevices/Folders off). |
| `virtqemud` + libvirtd | modules/services.nix | `virtualisation.libvirtd.enable`; qemu. Group `libvirtd` (gid 67) for `user`. |
| `NetworkManager` | modules/networking.nix | CLI/WiFi management (nm-applet in sway). |
| `chronyd` (NTS) | modules/networking.nix | Time sync. |
| `systemd-resolved` | modules/networking.nix | DNS. |
| `firewalld` | modules/networking.nix | Drop default zone. |
| `usbguard` | modules/security.nix | USB device authorization daemon. |
| `opensnitch` | modules/security.nix | App firewall daemon. |
| `greetd` | modules/greetd.nix | Login greeter (tuigreet → sway). |
| `systemd-oomd` | NixOS default | OOM protection. |
| `fstrim` + `btrfs-autoScrub` | modules/filesystems.nix | Weekly trim + scrub. |

## Disabled (declared but off)

| Service | Where | Why / How to enable |
|---------|-------|---------------------|
| `ollama` | modules/services.nix (`enable = lib.mkForce false`) | Models at `/opt/user/ollama`; un-comment when wanted. |
| `sshd` | modules/security.nix | Security default (matching Fedora). |

## Notes

- MPD state must persist: HM creates `~/.cfg/mpd/` (db, state, pid) — directory exists on first build, daemon auto-creates files.
- awecron requires `~/.cfg/awecron/` to be root-readable; HM symlinks it as user files — unit sets `User=root` and `XDG_CONFIG_HOME=/home/user/.cfg` so root resolves config through the same path; cronjob `run` files are chmod +x in dotfiles.
- virt-manager needs `user` in the `libvirtd` group (done — the docs/users.md group name).