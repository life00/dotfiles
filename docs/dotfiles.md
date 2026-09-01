# Dotfiles Inventory

`dotfiles/` holds configs that stay closer to their upstream format than HM abstractions. Each is symlinked into `~/.cfg/<name>` by home-manager (`home.file`); treat this directory as the authoritative edited copy. The sway config is Nix-native (`home/desktop.nix`) since this HM rev's `programs.sway` was dropped in favor of `wayland.windowManager.sway`. swaylock is Nix-native too (`programs.swaylock.settings` in `home/desktop.nix`, rendered to `~/.cfg/swaylock/config`; palette from `catppuccin.swaylock` in `home/theme.nix`). Waybar is Nix-native too (`programs.waybar.settings` + `style` in `home/desktop.nix`, palette from `catppuccin.waybar`). Sway wallpapers live at the top-level `wallpapers/` (not a dotfile).

| Directory | Contents | Notes |
|-----------|----------|-------|
| `zsh/` | zshenv, zshrc, startup, aliases, addons, config/ | Kept as reference; effective config lives in `home/shell.nix` (HM). Not symlinked. |
| `rofi/` | `config.rasi`, `config/` (colors, font, askpass, confirm, powermenu), `bin/` (killer, powermenu, scsh) | Scripts used by sway F10/F11/F4. |
| `dunst/` | `dunstrc` | Minimal notification setup. |
| `ncmpcpp/` | `config`, `bindings` | ncmpcpp for mpd. |
| `cava/` | `config`, `shaders/` | Audio visualizer. |
| `lf/` | `lfrc`, `lfrc.cmd`, `colors`, `icons`, `icons_colored`, `preview.sh` | Extended lf config: zoxide/fzf integration, bulk rename, marks, git status, live preview script. |
| `sioyek/` | `prefs_user.config`, `keys_user.config` | PDF reader prefs. |
| `khal/` | `config` | Calendar CLI. |
| `nvim/` | full LazyVim dotfiles (`init.lua`, `lua/config`, `lua/plugins/` — ai, build, completion, format, git, jupyter, keys, latex, lsp, markdown, snacks, terminal, treesitter, ui, uml, utils; `snippets/`, `spell/` ru, `styles/`, `queries/`, `ftplugin/`) | External project tracked verbatim; neovim binary from HM. |
| `ssh/` | `config`, `allowed_signers` | **No private keys** (kept out of repo). `config` points to `~/etc/sec/ssh/key-r0.sec`. |
| `bin/` | 15 scripts | Port of `~/dev/bin` + `~/.bin`: fetch, zlf, todoi, pdf2nocopy, catexif, imgcompress, ipext, ipint, rmexif, sioyek-open, wgetweb, yt-dlp-lofi, btrfs-file-delete.sh, chromium-markdown-preview.sh, ufetch. Symlinked to `~/.cfg/bin` (home/files.nix) and each script `ln -sfn`'d into `~/.bin` (already in PATH) by the `homeSetup` activation script (modules/users.nix). Shebangs use `/usr/bin/env` (no `/bin/bash|dash|zsh` on NixOS). |
| `awecron/` | `cfg`, `tphome10min/`, `tphome1hour/`, `updater/` | Cronjob dirs for the awecron daemon. `tmr` files (timers) intentionally not committed — created on runtime. Root snapshot jobs (`tproot*`) removed. |
| `qalculate/` | `qalc.cfg` | Preferences only (history not committed). |

## Non-included configs

- `opensnitch/` — GUI-generated rules; reset on install.
- `syncthing/` — device-specific (manual setup).
- `mpd/` — state/db/pid files; config via HM.
- `fsh/` — theme now via catppuccin/nix.
- `chromium/` — profile data, external.