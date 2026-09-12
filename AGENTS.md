# AGENTS.md

NixOS flake for two laptops. `flake.nix` defines `nixosConfigurations.{mb2017,mb2020}`; each `hosts/<name>/default.nix` imports every `modules/*.nix` plus home-manager (as a NixOS module) with `home/default.nix`. Active host: `mb2020` (aarch64 Apple Silicon via `nixos-apple-silicon`). `mb2017` is x86_64 with disko.

`README.md` is stale (lists files that no longer exist). Trust the `.nix` files, not the README.

## Commands

- Rebuild: `doas nixos-rebuild switch --impure --flake .#mb2020`. `--impure` is mandatory: `pkgs/awecron/default.nix` has `src = /home/user/dev/sysadmin/awecron` (absolute local path). `nix flake check` fails in pure mode for the same reason.
- Eval only: `nix eval --impure --raw .#nixosConfigurations.mb2020.config.system.build.toplevel.drvPath`.
- Format: `nixfmt <file>`. All tracked `.nix` files are nixfmt-clean except `hosts/mb2017/hardware.nix` (generated, leave it).
- After switch: `~/.bin/*` and `~/.cfg/*` should be populated.

## Layout

- `modules/` system NixOS modules. `home/` home-manager modules (`shell`, `development`, `desktop`, `media`, `files`, `theme`, `packages`). `pkgs/` custom derivations (`awecron`, `usbguard-gui`). `hosts/<name>/` boot, hardware, disko/touchbar.
- `extra/` raw configs, only for what HM can't express cleanly: `nvim` (LazyVim), `lf`, `bin` scripts, `awecron` jobs, `opencode` (AGENTS.md + skills). Wired in `home/files.nix` (`home.file.".cfg/<name>".source`), `modules/users.nix` (`~/.bin`), `modules/services.nix` (`/etc/awecron`), `home/development.nix` (`programs.opencode.context/skills`).
- Direction of travel is `extra/` -> native HM options (recent commits migrated cava, ncmpcpp). Prefer `programs.<x>` over new raw files.

## Non-standard home layout

- XDG: `configHome=~/.cfg`, `cacheHome=~/etc/cache`, `dataHome=~/etc/data`, `stateHome=~/etc/state` (`home/default.nix`). Compat symlinks `~/.config -> ~/.cfg`, `~/.cache`, `~/.local`, `~/.ssh -> ~/.cfg/ssh` are tmpfiles rules in `modules/users.nix`.
- `homePermissions.enable` (on for mb2020) makes `~`, `~/.bin`, top-level dirs, and every dir home-manager places files in root-owned (derived from `home.file`, fail-closed). Apps that must write into their config dir go in `homePermissions.exclude` (`modules/users.nix`). HM activation still runs as `user`; it gets `CAP_DAC_OVERRIDE` so no toggling/chown is needed to rebuild. tmpfiles never reverts ownership: removing a dir from the set needs a manual `chown`. Editing files in place under `~/.cfg` fails or is a store symlink; edit in the repo and rebuild.
- `~/.bin/*` are symlinks to the store copy of `extra/bin/`, created by the `homeSetup` activation script, not HM.

## Gotchas

- The awecron `updater` job (`extra/awecron/updater/run`, every 86400s, runs as `user`) does `nix flake update` in this repo. A dirty `flake.lock` in `git status` may be from cron, not from you. Don't revert it blindly.
- awecron runs as root; jobs get `PATH=/run/current-system/sw` + `libnotify` only. Restart the service after changing jobs (dynamic sleep won't pick them up until the next wake).
- `modules/users.nix`: `initialPassword = "password"` is a bootstrap value, intentional.
- `hosts/mb2017/disko.nix` device `/dev/nvme0n1` and `hosts/mb2017/hardware.nix` are placeholders for that host. `hosts/mb2020/hardware.nix` has real UUIDs; don't touch them.
- `mb2020` boot: `canTouchEfiVariables = false` is required (U-Boot owns EFI). Manual btrfs mounts, no disko. `/boot` is the ~480M ESP created by the asahi installer (`asahi,efi-system-partition` in the device tree): m1n1 stage 1 chainloads `m1n1/boot.bin` from there, so it must hold systemd-boot, kernels, `m1n1/` and `vendorfw/`. Hence `configurationLimit = 2`. Firmware refresh (`os-fw-version`) = delete stub + that ESP, rerun the asahi installer, update the UUID in `hardware.nix`.
- `services.syncthing` and `services.ollama` are `enable = false` stubs. Keep them.
- Secrets never live here: no ssh keys, no tokens (`.gitignore` blocks `*credentials*`, `*token*`). `allowed_signers` content is inline in `home/files.nix`.

## Conventions

- Nix style: minimal, nixfmt, no comments on the obvious.
- Commits: small logical units, conventional-commit style with scope (`feat(media): ...`, `fix(rofi): ...`, `chore: ...`).
