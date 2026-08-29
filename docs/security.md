# Security

Implemented in `modules/security.nix` and `modules/users.nix`.

## Privilege escalation: doas

- `security.doas.enable = true` — replaces sudo entirely (`security.sudo.enable = false`).
- `wheelNeedsPassword = true` → `permit :wheel`.
- `nopass` rule for `nix store gc` (replaces the old `dnf -q check-update` permit; NixOS doesn't use dnf).
- Root account locked (`users.users.root.hashedPassword = "!"`).

## Services

| Service | State | Notes |
|---------|-------|-------|
| sshd | **disabled** | `services.openssh.enable = false`, no firewall opening |
| usbguard | enabled | Rules socket + daemon; policy is per-device interaction (initial `generate-policy` needed — see README) |
| opensnitch | enabled | App-level egress firewall (daemon in `services.opensnitch`, UI via `opensnitch-ui`) |
| firewalld | enabled | nftables front-end (drop zone) — see networking.md |

## Kernel hardening

- `security.protectKernelImage = true` — refuses loading unsigned kernel modules.
- sysctl `kernel.yama.ptrace_scope = 1`.

## Home-folder ownership

> Not applied — see `docs/users.md`. The home is user-owned; the historical
> root-owned tmpfiles list is preserved in git.