# AGENTS.md

NixOS flake (single host `mb2017`, x86_64) replicating a Fedora Asahi workstation. System modules + home-manager (as NixOS module) + raw dotfiles. `docs/` is the authoritative architecture reference (indexed in `docs/README.md`) — read the per-topic page before editing.

## Verification

- Nix 2.31 is installed here but **cannot evaluate anything**: `/nix/store` is not writable, so every command (`nix flake check`, `--parse`, even `nix-instantiate --parse`) dies with `creating directory '/nix/store/.links': Permission denied`. There is no daemon. Hand-check Nix syntax carefully; real verification happens on the target NixOS machine.
- On a Nix machine: `nixos-rebuild switch --impure --flake .#mb2017` (flake at repo root; host is `mb2017`). `--impure` is mandatory because `pkgs/awecron` sources from the absolute path `/home/user/dev/src/awecron`; `nix flake check` will fail in pure mode for the same reason.

## Placeholders that break builds/installs until replaced

- `modules/disko.nix`: disk device is `/dev/nvme0n1` placeholder — must be edited per target machine.
- `hosts/mb2017/hardware.nix`: kernel modules are guesses; regenerate on target via `nixos-generate-config` and merge.
- `pkgs/awecron/default.nix`: `src` points at the LOCAL dev tree `/home/user/dev/src/awecron` (life00/awecron, vendored). This absolute non-repo path forces **every rebuild/check to pass `--impure`** (pure mode rejects it). Do not reset to the old `fetchFromGitHub`/`pkgs/*/src` dance — flakes reject in-repo gitignored paths too (see `docs/custom-packages.md`).
- `pkgs/getmusic/default.nix`: upstream `life00/getmusic` is unreachable (private) and no module references it — `hash`/`vendorHash` stay `lib.fakeHash` but the package is never built. Keep the `ponytail:` comments.

## Structure conventions

- `modules/` = system-level NixOS modules; `home/` = home-manager modules; `pkgs/` = custom Go derivations; `dotfiles/` = raw configs that are the **authoritative editable copy**; `docs/` = per-topic docs (disk, boot, networking, security, theming, install, exclusions…).
- Raw dotfiles are symlinked into `~/.cfg/<name>` via `home.file` in `home/*.nix`. Paths are `~/.cfg/...` because `xdg.configHome` is overridden to `~/.cfg` (nonstandard XDG layout — see `home/default.nix`; `.config -> .cfg` symlink in `modules/users.nix`). Treat `dotfiles/` as source of truth — local edits are preserved since `home.file` symlinks are store-immutable.
- `~/.bin/*` links: `scsh`, `powermenu`, `killer` are created by `systemd.tmpfiles.rules` in `modules/users.nix` → `~/.cfg/rofi/bin/*` (used by sway key bindings in `dotfiles/sway/config`). The other historical `~/.bin` links pointed to `~/dev/bin/*` (workflow scripts not in the repo) and are NOT wired. `dotfiles/bin/` is a reference copy and is NOT wired into the build. Docs (`docs/home-manager.md`, `docs/dotfiles.md`) may claim more; code wins.
- Placeholders are deliberate: commented-out HM blocks (chromium in `home/packages.nix`, obs/gimp/virt-manager in `home/media.nix`, syncthing/ollama disabled services in `modules/services.nix`). Keep this pattern — do not delete the stubs.

## Repo conventions

- Secrets stay out of the repo: `dotfiles/ssh/` contains only `config` + `allowed_signers` (no keys, no `known_hosts`). Syncthing/chromium profiles are not tracked. Never add them.
- `.gitignore` covers `pkgs/*/src/` (local source copies) and `result*` — keep it that way.
- Awecron `tmr` timer files are runtime state, not tracked. Root snapshot jobs (`tproot*`) were intentionally removed; tphome jobs retained.
- Commit in small logical units (one module group per commit), matching the existing log style.