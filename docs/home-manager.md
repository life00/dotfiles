# Home Manager Strategy

Home-manager runs as a NixOS module (`home-manager.nixosModules.home-manager`, `useUserPackages = true`, `useGlobalPkgs = true`), so `nixos-rebuild switch` rebuilds the whole system including the user profile. `home-manager` is applied to user `user` via `hosts/mb2017/default.nix`.

## Nix-native (HM `programs.*`)

| Config | Module |
|--------|--------|
| zsh | `home/shell.nix` |
| starship | `home/shell.nix` |
| git (user/email/signing/delta) | `home/git.nix` |
| ssh client config | `home/git.nix` |
| alacritty | `home/terminal.nix` |
| bat (theme only) | `home/editor.nix` |
| neovim (installs binary) | `home/editor.nix` |
| sway (config) | `home/desktop.nix` |
| swaylock (config; palette via catppuccin flake, font in `home/desktop.nix`) | `home/desktop.nix` + `home/theme.nix` |
| swayidle, grim, slurp, wl-clipboard, dunst (packages) | `home/desktop.nix` |
| waybar (config via settings, style via catppuccin variables) | `home/desktop.nix` + `home/theme.nix` |
| mpd (user service) | `home/media.nix` |
| mpv | `home/media.nix` |
| bottom (theme via catppuccin flake, flags/filters) | `home/files.nix` (`package = null`; binary from system modules/packages.nix) |

## Raw dotfiles (`home.file."~/.cfg/…".source`)

| Config | Source dir |
|--------|------------|
| rofi + scripts | `dotfiles/rofi/` |
| dunst | `dotfiles/dunst/` |
| ncmpcpp | `dotfiles/ncmpcpp/` |
| cava (+shaders) | `dotfiles/cava/` |
| lf (+preview) | `dotfiles/lf/` |
| sioyek | `dotfiles/sioyek/` |
| khal | `dotfiles/khal/` |
| nvim (full LazyVim) | `dotfiles/nvim/` (external repo tracked in dotfiles/) |
| ssh allowed_signers | `dotfiles/ssh/` |
| ~/.bin scripts | `dotfiles/bin/` |
| awecron configs | `dotfiles/awecron/` |
| qalculate | `dotfiles/qalculate/` |

## Rationale

- Nix-native when the config is a) simple, b) value-checked by HM (e.g. alacritty strict settings types), c) maintained by HM (zsh plugin sources).
- Raw dotfiles when the config carries custom scripts (rofi/scsh/killer, waybar style scripts, lf preview, awecron run scripts) or would be a 1:1 copy with no HM benefit (ncmpcpp/cava).
- HM handles *where* files land (XDG = `~/.cfg`) and *which packages exist*; local edits outside HM are preserved because `home.file` symlinks to the store (immutable) — treat dotfiles dir as the source of truth.

| obs-studio | `home/media.nix` (per-user config only; this HM rev has no gimp/virt-manager modules) |