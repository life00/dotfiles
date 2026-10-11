# AGENTS.md

NixOS flake for two laptops. `flake.nix` defines `nixosConfigurations.{mb2017,mb2020}`; each `hosts/<name>/default.nix` imports every `modules/*.nix` plus home-manager (as a NixOS module) with `home/default.nix`. Active host: `mb2020` (aarch64 Apple Silicon via `nixos-apple-silicon`). `mb2017` is x86_64 with disko.

`README.md` is stale (lists files that no longer exist). Trust the `.nix` files, not the README.

## Commands

- Rebuild: `doas nixos-rebuild switch --impure --flake .#mb2020`. `--impure` is mandatory: `pkgs/awecron/default.nix` has `src = /home/user/dev/sysadmin/awecron` (absolute local path). `nix flake check` fails in pure mode for the same reason.
- General update: waybar updater click, or `nix flake update nixpkgs home-manager catppuccin disko` + rebuild. Never plain `nix flake update`: it moves the kernel inputs too.
- Kernel update: `nix flake update apple-silicon` + rebuild. The only thing that should bump the kernel, and it always costs a full local compile.
- Eval only: `nix eval --impure --raw .#nixosConfigurations.mb2020.config.system.build.toplevel.drvPath`.
- Format: `nixfmt <file>`. All tracked `.nix` files are nixfmt-clean except `hosts/mb2017/hardware.nix` (generated, leave it).
- After switch: `~/.bin/*` and `~/.cfg/*` should be populated.

## Layout

- `modules/` system NixOS modules. `home/` home-manager modules (`shell`, `development`, `desktop`, `media`, `files`, `theme`, `packages`, `notebooks`). `pkgs/` custom derivations (`awecron`, `usbguard-gui`, `quarto`, `ort-webgpu`, `opencode`). `hosts/<name>/` boot, hardware, disko/touchbar.
- `extra/` raw configs, only for what HM can't express cleanly: `nvim` (LazyVim), `lf`, `bin` scripts, `awecron` jobs, `opencode` (AGENTS.md + skills). Wired in `home/files.nix` (`home.file.".cfg/<name>".source`; `nvim` uses `mkOutOfStoreSymlink`, a live link to the worktree so `lazy.nvim` can write `lazy-lock.json` back), `modules/users.nix` (`~/.bin`), `modules/services.nix` (`/etc/awecron`), `home/development.nix` (`programs.opencode.context/skills`).
- Direction of travel is `extra/` -> native HM options (recent commits migrated cava, ncmpcpp). Prefer `programs.<x>` over new raw files.

## Non-standard home layout

- XDG: `configHome=~/.cfg`, `cacheHome=~/etc/cache`, `dataHome=~/etc/data`, `stateHome=~/etc/state` (`home/default.nix`). Compat symlinks `~/.config -> ~/.cfg`, `~/.cache`, `~/.local`, `~/.ssh -> ~/.cfg/ssh` are tmpfiles rules in `modules/users.nix`.
- `homePermissions.enable` (on for mb2020) makes `~`, `~/.bin`, top-level dirs, and every dir home-manager places files in root-owned (derived from `home.file`, fail-closed). Apps that must write into their config dir go in `homePermissions.exclude` (`modules/users.nix`). HM activation still runs as `user`; it gets `CAP_DAC_OVERRIDE` so no toggling/chown is needed to rebuild. tmpfiles never reverts ownership: removing a dir from the set needs a manual `chown`. Editing files in place under `~/.cfg` fails or is a store symlink; edit in the repo and rebuild. Exception: `~/.cfg/nvim` is a live link to `extra/nvim` (`home/files.nix`), so `:Lazy update` writes `lazy-lock.json` straight into the worktree; commit it.
- `~/.bin/*` are symlinks to the store copy of `extra/bin/`, created by the `homeSetup` activation script, not HM.

## Gotchas

- No binary cache exists for `linux-asahi` anywhere (upstream ships none, nixpkgs has no asahi kernel at all), so any change to its derivation is a full local compile. `hosts/mb2020/boot.nix` therefore builds it from `nixpkgs-kernel`, a second nixpkgs input pinned by `flake.lock`, so nixpkgs toolchain churn cannot trigger one. Check with `...config.boot.kernelPackages.kernel` (outPath; `drvPath` churns harmlessly whenever a fixed-output input is re-derived).
- The awecron `updater` job (`extra/awecron/updater/run`, every 86400s, runs as `user`) updates the lock in this repo only to count pending updates, then restores the old `flake.lock` from a tmpdir via an `EXIT` trap. It leaves the worktree clean. The real update happens in `extra/awecron/updater/apply` (waybar click): `nix flake update $INPUTS` -> `nixos-rebuild switch` -> commits `flake.lock` itself. `$INPUTS` is duplicated in `update` and `apply`; a new flake input must be added to both or it never updates.
- `updater/update` checks the kernel separately (`nix flake update apple-silicon`, then compares the kernel outPath to `/run/current-system/kernel`) and appends one line to the list. Its name-based closure diff cannot see kernel updates: `asahi-7.1.13-2` -> `-3` is `linux-asahi-7.1.13` on both sides. A kernel line in the list is informational; `apply` will not act on it.
- awecron runs as root; jobs get `PATH=/run/current-system/sw` + `libnotify` only. Restart the service after changing jobs (dynamic sleep won't pick them up until the next wake).
- `modules/users.nix`: `initialPassword = "password"` is a bootstrap value, intentional.
- `hosts/mb2017/disko.nix` device `/dev/nvme0n1` and `hosts/mb2017/hardware.nix` are placeholders for that host. `hosts/mb2020/hardware.nix` has real UUIDs; don't touch them.
- `mb2020` boot: `canTouchEfiVariables = false` is required (U-Boot owns EFI). Manual btrfs mounts, no disko. `/boot` is the ~480M ESP created by the asahi installer (`asahi,efi-system-partition` in the device tree): m1n1 stage 1 chainloads `m1n1/boot.bin` from there, so it must hold systemd-boot, kernels, `m1n1/` and `vendorfw/`. Hence `configurationLimit = 2`. Firmware refresh (`os-fw-version`) = delete stub + that ESP, rerun the asahi installer, update the UUID in `hardware.nix`.
- opencode is v2 from `pkgs/opencode` (prebuilt npm `@opencode/cli-linux-arm64`, run via nix-ld), not nixpkgs (still v1). The updater never bumps it: edit `version` + `hash` (npm `dist.integrity`) by hand. Terminal config is `~/.cfg/opencode/cli.json`, written raw in `home/development.nix`; `programs.opencode.tui` (v1 `tui.json`) is unused.
- omp (`pkgs.omp`, `home/development.nix`): env vars in `home/shell.nix`. `PI_CONFIG_DIR=.cfg/omp` (relative to `$HOME`; in `homePermissions.exclude` since omp writes there). `PI_CONFIG_FILES` points at `~/.cfg/omp/nix.yml`, the HM-written settings overlay; it beats omp's own `agent/config.yml`, so in-app changes to those keys don't persist. Keep `modelRoles` out of it: roles come from the overlay's `modelPresets` (`anthropic`, `opencode-go`) via `/modelpreset switch`, which writes `agent/config.yml`; the overlay pins `retry.fallbackChains.web` instead (`web/hosted`, `web/parallel`, `web/duckduckgo`, `web/public`, after the `web/exa` primary), so the search fallback order is not editable in-app. Data/state/cache live in `~/etc/{data,state,cache}/omp`. omp uses those only if the dirs exist; they are tmpfiles rules in `modules/users.nix`, next to `.cfg/omp`. `nix.yml` also carries `extensions`: the repo root of a pinned `DietrichGebert/ponytail` checkout (`pkgs.fetchFromGitHub`, bump `rev` + `hash` by hand); omp reads its `package.json#pi.extensions` and wires its `skills/`, so no marketplace/plugin-registry entry is involved (the `ponytail@ponytail` entries under `~/etc/data/omp/plugins` are stale leftovers pointing at a missing path). `PONYTAIL_HIDE_STATUS=1` (`home/shell.nix`) suppresses ponytail's status item, ruleset stays active. `~/.cfg/ponytail` is deliberately absent (root-owned `.cfg`), so `/ponytail default <level>` fails to persist; levels are session-only. `~/.omp` is legacy, unused.
- `services.syncthing` and `services.ollama` are `enable = false` stubs. Keep them.
- Secrets never live here: no ssh keys, no tokens (`.gitignore` blocks `*credentials*`, `*token*`). `allowed_signers` content is inline in `home/files.nix`.

## Conventions

- Nix style: minimal, nixfmt, no comments on the obvious.
- Commits: small logical units, conventional-commit style with scope (`feat(media): ...`, `fix(rofi): ...`, `chore: ...`).
