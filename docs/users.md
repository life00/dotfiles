# Users

Implemented in `modules/users.nix`.

## Primary user

| Property | Value |
|----------|-------|
| Name | `user` |
| UID/GID | 1000 |
| Shell | zsh |
| Home | `/home/user` (not auto-created — disko mounts home subvolume) |
| Groups | `wheel`, `video`, `audio`, `libvirtd`, `qemu-libvirtd`, `networkmanager` |

## Groups

- `users.groups.user.gid = 1000`
- `libvirtd` (gid 67) + `qemu-libvirtd` (gid 301) — created by `virtualisation.libvirtd`; `user` is added for virt-manager/virsh access (the group is `libvirtd` in this nixpkgs — older docs called it `libvirt`).

## Root account

- Locked (`hashedPassword = "!"`) — no interactive root login. All admin via doas.

## Home-folder ownership model

> **Not currently applied.** The Fedora/Asahi root-owned top-level-home model
> (`dev/`, `doc/`, `med/`, `tmp/`, `etc/` owned by `root`) is incompatible
> with day-to-day use here: the user writes directly into `~/dev`, `~/doc`,
> `~/med`, `~/tmp`, and home-manager creates `~/.cfg` + `~/etc/{data,cache,
> state}` as a non-root user. The home is fully user-owned for now
> (see `modules/users.nix`). The historical tmpfiles list is preserved in git
> (`git show 86ba466:modules/users.nix`).

What the model would look like if it ever returns:

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

Note: home-manager-managed dotfiles under `~/.cfg` remain user-owned even in
that model; only the top-level hierarchy would be chowned.