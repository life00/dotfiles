# AGENTS.md

NixOS flake (single host `localhost`, x86_64) replicating a Fedora Asahi workstation. System modules + home-manager (as NixOS module) + raw dotfiles. `docs/` is the authoritative architecture reference — read per-topic pages before editing.

## Verification

- Nix is **not available in this dev environment** (Fedora host) — you cannot `nix flake check` or build here. Syntax-check Nix carefully by hand; real verification happens on the target NixOS machine.
- On a Nix machine: `nix flake check` or `nixos-rebuild build --flake .#localhost` (flake is at repo root; host is `localhost`).

## Placeholders that break builds/installs until replaced

- `modules/disko.nix`: disk device is `/dev/nvme0n1` placeholder — must be edited per target machine.
- `hosts/localhost/hardware.nix`: kernel modules are guesses; regenerate on target via `nixos-generate-config` and merge.
- `pkgs/awecron/default.nix` and `pkgs/getmusic/default.nix`: `hash`/`vendorHash` are `lib.fakeHash` — every build fails until real hashes are filled in. Alternative (repo is meant to be copied to an offline machine): drop source into gitignored `pkgs/*/src/` and switch `src` to that local path. Do not remove the `ponytail:` comments explaining this.

## Structure conventions

- `modules/` = system-level NixOS modules; `home/` = home-manager modules; `pkgs/` = custom Go derivations; `dotfiles/` = raw configs that are the **authoritative editable copy**; `docs/` = per-topic docs (disk, boot, networking, security, theming, install, exclusions…).
- Raw dotfiles are symlinked into `~/.cfg/<name>` via `home.file` in `home/*.nix`. Dotfile paths are `~/.cfg/...` because `xdg.configHome` is overridden to `~/.cfg` (nonstandard XDG layout — explicit in `home/default.nix` and `modules/users.nix` tmpfiles).
- `~/.bin` scripts are symlinked by `systemd.tmpfiles.rules` in `modules/users.nix` (not home-manager) — add new bin links there.
- Placeholders are deliberate: commented-out HM blocks (chromium in `home/packages.nix`, obs/gimp/virt-manager in `home/media.nix`, syncthing/ollama disabled services in `modules/services.nix`). Keep this pattern for future additions — do not delete the stubs.

## Repo conventions

- Secrets stay out of the repo: `dotfiles/ssh/` contains only `config` + `allowed_signers` (no keys, no `known_hosts`). Syncthing/chromium profiles are not tracked. Never add them.
- `.gitignore` covers `pkgs/*/src/` (local source copies) and `result*` — keep it that way.
- Awecron `tmr` timer files are runtime state, not tracked. Root snapshot jobs (`tproot*`) were intentionally removed; tphome jobs retained.
- Commit in small logical units (one module group per commit) matching the existing log style.