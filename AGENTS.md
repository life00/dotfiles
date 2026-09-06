# AGENTS.md

NixOS flake (single host `mb2017`, x86_64) replicating a Fedora Asahi workstation. System modules + home-manager (as NixOS module) + raw extra. `docs/` is the authoritative architecture reference (indexed in `docs/README.md`) — read the per-topic page before editing.

## Verification

- This repo evaluates on the real target (`doas nixos-rebuild switch --impure --flake .#mb2017` as root; Nix 2.34.8, `/nix/store` writable). `--impure` is mandatory because `pkgs/awecron` sources from the absolute path `/home/user/dev/src/awecron`; `nix flake check` will fail in pure mode for the same reason. Both NixOS activation scripts (e.g. `homeSetup` in `modules/users.nix`) and home-manager run on switch — verify `~/.bin` and `~/.cfg/*` afterwards.

## Placeholders that break builds/installs until replaced

- `modules/disko.nix`: disk device is `/dev/nvme0n1` placeholder — must be edited per target machine.
- `hosts/mb2017/hardware.nix`: synced from `nixos-generate-config` on the real host — regen + merge if hardware changes. Not a placeholder anymore.
- `modules/users.nix`: `initialPassword = "password"` is the bootstrap password for fresh installs — update via `passwd` post-install, keep the option.
- `pkgs/awecron/default.nix`: `src` points at the LOCAL dev tree `/home/user/dev/src/awecron` (life00/awecron, vendored). This absolute non-repo path forces **every rebuild/check to pass `--impure`** (pure mode rejects it). Do not reset to the old `fetchFromGitHub`/`pkgs/*/src` dance — flakes reject in-repo gitignored paths too (see `docs/custom-packages.md`).
- `pkgs/getmusic/default.nix`: upstream `life00/getmusic` is unreachable (private) and no module references it — `hash`/`vendorHash` stay `lib.fakeHash` but the package is never built. Keep the `ponytail:` comments.

## Structure conventions

- `modules/` = system-level NixOS modules; `home/` = home-manager modules; `pkgs/` = custom Go derivations; `extra/` = raw configs that are the **authoritative editable copy**; `docs/` = per-topic docs (disk, boot, networking, security, theming, install, exclusions…).
- Raw extra are symlinked into `~/.cfg/<name>` via `home.file` in `home/*.nix`. Paths are `~/.cfg/...` because `xdg.configHome` is overridden to `~/.cfg` (nonstandard XDG layout — see `home/default.nix`; `.config -> .cfg` symlink in `modules/users.nix`). Treat `extra/` as source of truth — local edits are preserved since `home.file` symlinks are store-immutable.
- `~/.bin/*` links are created by the `homeSetup` activation script in `modules/users.nix`: `scsh`/`powermenu`/`killer` → `~/.cfg/rofi/bin/*` (sway key bindings in `extra/sway/config`), plus every script in `extra/bin/` (built into the store path directly; also symlinked as `~/.cfg/bin` via `home/files.nix`). Not `systemd.tmpfiles` (refuses `L` under `/home/user`, which is user-owned). `~/.bin` itself is root-owned from `mkdir`.
- Placeholders are deliberate: commented-out HM blocks (chromium in `home/packages.nix`, obs-studio enabled but gimp/virt-manager dropped in `home/media.nix` — no such options in this HM rev) and the disabled `ollama` service in `modules/services.nix`. Keep this pattern — do not delete the stubs.

## Repo conventions

- Secrets stay out of the repo: `extra/ssh/` contains only `config` + `allowed_signers` (no keys, no `known_hosts`). Syncthing/chromium profiles are not tracked. Never add them.
- `.gitignore` covers `pkgs/*/src/` (local source copies) and `result*` — keep it that way.
- Awecron `tmr` timer files are runtime state, not tracked. Root snapshot jobs (`tproot*`) were intentionally removed; tphome jobs retained.
- Commit in small logical units (one module group per commit), matching the existing log style.
