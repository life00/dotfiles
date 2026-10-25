# Repository Guidelines

## Project Overview

NixOS flake for two laptops: `mb2020` (aarch64 Apple Silicon, active host, `apple-silicon` input) and `mb2017` (x86_64, disko). `README.md` has install steps but an incomplete file tree; trust the `.nix` files.

## Architecture & Data Flow

- `flake.nix` → `nixosConfigurations.{mb2020,mb2017}` → `hosts/<name>/default.nix` imports every `modules/*.nix` plus home-manager as a NixOS module (`home/default.nix`).
- Custom `pkgs/*` are `callPackage`d at their use site, not flake outputs (`nix build .#awecron` doesn't work).
- `extra/` holds raw configs HM can't express. They're wired via `home/files.nix` (`~/.cfg/<name>`), `modules/users.nix` (`~/.bin`) and `modules/services.nix` (`/etc/awecron`). These are store copies, so a rebuild is needed after edits. The one exception is `~/.cfg/nvim`: it's a live `mkOutOfStoreSymlink` to `~/dev/sysadmin/dotfiles/extra/nvim`, a hard-coded repo path, and `lazy-lock.json` gets written back there (commit it).
- Direction of travel: move things out of `extra/` and into native `programs.<x>` HM options. Don't add new raw files when an HM option exists.

## Key Directories

- `modules/`: system modules. `home/`: HM modules. `hosts/<name>/`: boot, hardware, host-only overrides.
- `pkgs/`: `awecron`, `usbguard-gui`, `mindustry`, `quarto`, `ort-webgpu`, `snd-hda-macbookpro`.
- `extra/`: `nvim` (LazyVim), `lf`, `bin`, `awecron` jobs, `omp` (local omp package), `swayfx`/`imv` patches used by overlays in `modules/packages.nix`.

## Development Commands

- Rebuild: `doas nixos-rebuild switch --impure --flake .#mb2020`. `--impure` is mandatory because apple-silicon probes `/boot/vendorfw`, so pure eval fails.
- Eval only: `nix eval --impure --raw .#nixosConfigurations.mb2020.config.system.build.toplevel.drvPath`.
- Routine update: `nix flake update nixpkgs home-manager catppuccin disko`, then rebuild. **Never run plain `nix flake update`**: it also moves the kernel inputs.
- Kernel update: `nix flake update apple-silicon` (deliberate; a full local compile).
- Format: `nixfmt <file>`.

## Code Conventions & Common Patterns

- Nix style: minimal, nixfmt, no comments on the obvious.
- Hand-bumped pins (`rev` + `hash`, plus `vendorHash` for awecron):
  - `pkgs/awecron`, `pkgs/usbguard-gui`, `pkgs/snd-hda-macbookpro`.
  - ponytail, three separate pins: omp `fetchFromGitHub` and the claude-code plugin `fetchFromGitHub` in `home/development.nix`, and the opencode `#v…` URL in `hosts/mb2017/home.nix`.
  - The fairydust kernel patches in `hosts/mb2020/boot.nix`. Re-pin these on every `apple-silicon` bump.
- Overlays with a `FIXME` removal condition live in `modules/packages.nix`.
- Host-only changes go in `hosts/mb2017/`. Never edit shared modules for this; use these overrides instead:
  - `disabledModules` (it silently ignores paths that match nothing).
  - `lib.mkForce` for scalars.
  - `lib.mkAfter` for overlays.
  - `lib.mkOptionDefault` for attrsets like sway `keybindings`. A plain-priority definition wipes the shared bindings.
- `hosts/mb2017/home.nix` replaces `home/packages.nix` with a hand-synced list. Keep the two in sync.
- Commits: small conventional commits, scope optional, e.g. `feat(omp): ...`, `fix(mb2017): ...`, `chore: ...`.

## Important Files

- `hosts/mb2020/boot.nix`: the kernel is built from the `nixpkgs-kernel` input (pinned separately) so toolchain churn can't trigger a recompile. No binary cache exists for `linux-asahi`, so any change to its derivation is a full local compile. Also sets `canTouchEfiVariables = false` (U-Boot owns EFI) and `configurationLimit = 3` (small ESP).
- `hosts/mb2020/hardware.nix`: has real UUIDs; don't touch them. `hosts/mb2017/{hardware,disko}.nix` are placeholders. `hardware.nix` is generated and not nixfmt-clean; leave it.
- `modules/users.nix`, `homePermissions` (enabled on mb2020): `~`, `~/.bin` and every HM-managed dir are root-owned.
  - Apps that write to their config dir must go in `homePermissions.exclude`.
  - New XDG/compat dirs need both a `compatLinks` entry and a tmpfiles rule.
  - Removing a dir from the set requires a manual `chown`.
  - Don't edit files under `~/.cfg` in place. Edit the repo and rebuild.
  - `initialPassword = "password"` is intentional.
- `extra/awecron/updater/{update,apply}`: both define `INPUTS`. A new flake input must be added to both files.
  - `update` is the daily job. It restores `flake.lock` afterwards and leaves the worktree clean.
  - `apply` is the waybar click. It updates, rebuilds (doas password prompt), then commits `flake.lock`.
  - awecron runs as root with a minimal `PATH`. Restart the service after changing jobs.
- `home/development.nix` + `home/shell.nix` (omp):
  - `PI_CONFIG_FILES=~/.cfg/omp/nix.yml` is an HM overlay that overrides omp's in-app settings.
  - Keep `modelRoles` out of `nix.yml`; roles come from `modelPresets`.
  - On mb2017, `pkgs.omp` is overlaid to `emptyDirectory`, so any new `pkgs.omp` reference breaks only that host.
- `extra/omp/`: a local omp package.
  - Test edits with `omp -e extra/omp`.
  - MCP servers go in `extra/omp/.mcp.json`. Never manage `~/.cfg/omp/agent/mcp.json` via HM: `/mcp` rewrites it, which breaks activation. To default a server off, use `disabledServers` rather than `enabled: false`.
  - `leader-key.ts` relies on omp internals, so an omp bump can break it.

## Runtime/Tooling Preferences

- Privilege escalation is `doas`, with no passwordless rules.
- The formatter is `nixfmt` for Nix. Nvim Lua and shell are formatted by nvim's conform config (`extra/nvim/lua/plugins/format.lua`).
- Secrets never go in the repo. Only `result` is gitignored, so any key or token file in the worktree gets committed.

## Testing & QA

- There are no tests, no CI and no flake `checks`. Verification means running the eval command for mb2020, or a rebuild.
- mb2017 can't be built from mb2020 (catppuccin needs IFD on x86_64), but option values still evaluate. Example: `nix eval --impure --json .#nixosConfigurations.mb2017.config.<path>`.
- Kernel-recompile check: compare `nix eval --impure --raw .#nixosConfigurations.mb2020.config.boot.kernelPackages.kernel.outPath` before and after a change. A different outPath means a full local compile. Use outPath, not drvPath: drvPath changes harmlessly whenever a fixed-output input is re-derived.
- Run `nixfmt --check $(git ls-files '*.nix')` before committing. The only expected failure is `hosts/mb2017/hardware.nix`.
