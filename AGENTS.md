# AGENTS.md

NixOS flake replicating a Fedora Asahi workstation. Two hosts: `mb2017` (x86_64 Intel, disko) and `mb2020` (aarch64 Apple Silicon, manual btrfs mounts). Active host is `mb2020`. System modules + home-manager (as NixOS module) + raw extra configs.

## Verification

- Rebuild: `doas nixos-rebuild switch --impure --flake .#<host>` (e.g. `.#mb2020`). `--impure` is mandatory — `pkgs/awecron` sources from a local absolute path.
- `nix flake check` fails in pure mode for the same reason.
- After switch: verify `~/.bin` and `~/.cfg/*` are populated.

## Placeholders

- `hosts/mb2017/disko.nix`: disk device `/dev/nvme0n1` — edit per target.
- `hosts/mb2017/hardware.nix`: synced from `nixos-generate-config` — regen on hardware change.
- `modules/users.nix`: `initialPassword = "password"` is the bootstrap password — update via `passwd` post-install.
- `pkgs/awecron/default.nix`: `src` points at LOCAL `/home/user/dev/sysadmin/awecron` — not a git source.

## Structure

- `modules/` = system NixOS modules. `home/` = home-manager modules. `pkgs/` = custom derivations. `extra/` = raw configs (authoritative editable copy). `hosts/<name>/` = host-specific (boot, hardware, disko).
- `extra/` is symlinked into `~/.cfg/<name>` via `home.file` in `home/files.nix`. XDG `configHome` = `~/.cfg` (nonstandard). Symlinks are store-immutable — edit in `extra/`.
- `~/.bin/*` created by `homeSetup` activation script in `modules/users.nix` (symlinks from `extra/bin/`). `~/.bin` is root-owned.
- `~/.config -> ~/.cfg` symlink created by tmpfiles in `modules/users.nix`.

## Conventions

- No secrets in repo: `extra/ssh/` has only `config` + `allowed_signers`. No keys, no known_hosts, no syncthing/chromium profiles.
- `.gitignore` covers `pkgs/*/src/` and `result*`.
- Disabled services (syncthing, ollama) are stubs — keep them, don't delete.
- Commit in small logical units, one module group per commit.
- NixOS coding style: minimal, no comments on obvious things.
