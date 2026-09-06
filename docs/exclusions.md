# Exclusions & Reinterpretations

Things from the Fedora setup deliberately not ported, or ported differently.

## Dropped entirely

| Item | Why |
|------|-----|
| julia | User-requested exclusion (was only in /usr/local, no config) |
| octave | User-requested exclusion |
| piper-tts, privategpt, languagetool | User-requested exclusion; python venv-based installs not reproducible in Nix |
| lilypond | User-requested exclusion |
| sioyek custom patch (LINUX_STANDARD_PATHS) | Use stock nixpkgs sioyek — patch only mattered for non-standard install dirs |
| /etc/zshrc / /etc/zshenv ZDOTDIR trick | Replaced by HM-managed zsh (programs.zsh) |
| /etc/zprofile → dbus-run-session sway | Replaced by greetd (tuigreet) |
| dnf / rpm specific bits | N/A on NixOS: fastestmirror, max_parallel_downloads, dnf check-update doas rule → replaced with `nix store gc` nopass rule |
| awecron `tproot*` jobs (root btrfs snapshots) | NixOS generations make root snapshots redundant |
| Recovery subvolume `/snsh/.../rescue` + `vmlinuz-rescue` GRUB entry | Same reason — NixOS rollback is built-in |
| `networkmanager` disabled on boot (Fedora security) | NixOS: NM required for WiFi; firewalld drop zone covers the same goal |
| opensnitch saved rules/decisions | GUI-generated, device-specific — regenerate on install |
| usbguard generated policy | Same — run `usbguard generate-policy` |
| ~45 NetworkManager WiFi connections | Secrets + device-specific; import manually |
| Chromium profile (bookmarks, vimium, extensions) | External data — placeholder in HM for future |
| syncthing config (devices/folders) | Manual setup via Web UI after enabling service |
| ssh private keys (`~/etc/sec/ssh/`) | Never in repo — copy post-install |
| dconf `user` file | Split into HM dconf settings (theme.nix) |

## Changed behavior

| Fedora | NixOS here |
|--------|-----------|
| sudo removed, only doas | doas via `security.doas`, sudo disabled (same) |
| root locked | root locked (`hashedPassword="!"`) |
| zsh history to root-owned `/var/log/zsh/histfile` | same path, via HM + tmpfiles (0666) |
| bash PROMPT_COMMAND logging to `/var/log/history.log` | both user zsh `precmd` + root bash `PROMPT_COMMAND`, at system level in `modules/users.nix` |
| swapfile on `swap` subvol, 8 GiB | same, disko `swapDevices` |
| btrfs root at `/`; no nix subvol | **no /nix subvolume** (kept on root) — per decision |
| GRUB cryptodisk + serial rescue | GRUB cryptodisk; no rescue (generations) |
| `--sector-size=4096` + hw crypto flags | `allowHardwareCrypto` (no-op on x86) |
| system-wide `/etc/xdg/waybar`, `/etc/sway` configs | user-level via HM/extra |
| /usr/local/bin binaries (awecron, getmusic, btm, lf, ollama, quarto, opencode) | nixpkgs packages for btm/lf/ollama/quarto/opencode; custom derivations for awecron/getmusic |
