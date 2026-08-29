# Users

Implemented in `modules/users.nix`.

## Primary user

| Property | Value |
|----------|-------|
| Name | `user` |
| UID/GID | 1000 |
| Shell | zsh |
| Home | `/home/user` (not auto-created — disko mounts home subvolume) |
| Groups | `wheel`, `video`, `audio`, `libvirt`, `networkmanager` |

## Groups

- `users.groups.user.gid = 1000`
- `users.groups.libvirt = { }` — for virt-manager access.

## Root account

- Locked (`hashedPassword = "!"`) — no interactive root login. All admin via doas.

## Home-folder ownership model

Top-level directories under `/home/user` (`dev/`, `doc/`, `med/`, `tmp/`, `etc/`) and the zsh/bash history logdirs are owned by `root`, matching Fedora/Asahi. Implemented via `systemd.tmpfiles.rules` (applied on every boot, after home-manager has created user files).

```
d /home/user/dev    0755 root root -
d /home/user/doc    0755 root root -
d /home/user/med    0755 root root -
d /home/user/tmp    0755 root root -
d /home/user/etc    0755 root root -
d /var/log/zsh      0755 root root -
f /var/log/zsh/histfile  0666 user user -
f /var/log/history.log   0666 root root -
d /snsh/automatic/home   0755 root root -
d /snsh/static           0755 root root -
d /opt/user              0755 user user -
```

Note: home-manager-managed dotfiles under `~/.cfg` remain user-owned; only the top-level hierarchy is chowned.