# Custom Packages

Two Go binaries were installed manually on Fedora (`/usr/local/bin`); they are now built from source.

## awecron

Custom cron daemon with **dynamic sleep** — polls cronjob dirs (`$cfgdir/*/` each containing `cfg`, `run`, `tmr`), runs jobs whose timer has expired, schedules next run by writing `tmr` mtime, sleeps until the soonest next run.

- Location: `pkgs/awecron/default.nix`
- Entrypoint: service in `modules/services.nix` (`systemd.services.awecron`, root, `Restart=always`)
- Config dir: `/etc/awecron/` — symlinks from `extra/awecron/` via an activation script in `modules/services.nix` (Go binary reads `$XDG_CONFIG_HOME/awecron`, falling back to `/etc/awecron` since the root service sets no XDG dir).
- Global config in `extra/awecron/cfg` (max/min/timeout: 9999/5/200).
- Jobs: `tphome10min` (10 min), `tphome1hour` (60 min) — btrfs snapshots; `updater` — dnf/`nix` update check + notify (writes `$XDG_CACHE_HOME/updater/count`).

## getmusic

Batch audio downloader built on yt-dlp (`github.com/lrstanley/go-ytdlp`). Usage: `getmusic FILE [-d DIR]`, parses URL lines (`*` suffix = favorites → `DIR/fav/`), asks confirmation, extracts audio at quality 0.

- Location: `pkgs/getmusic/default.nix`

## Build mechanics

Both use `buildGoModule` with `subPackages = ["."]`.

- `awecron`: src comes from the local dev tree `/home/user/dev/sysadmin/awecron`
  (clone of `life00/awecron`, branch `master`). Dependencies are fetched and
  vendored by buildGoModule itself (non-null `vendorHash`); the source tree has
  no `vendor/` dir. Regenerate `vendorHash` (build with `lib.fakeHash`, paste
  the `got:` hash) whenever `go.mod`/`go.sum` change. Because `src` is an
  absolute (non-repo) path, **every nixos-rebuild must pass `--impure`** — pure
  mode rejects it.
- `getmusic`: upstream (`life00/getmusic`) is unreachable (404/private) and no
  module references it, so it stays a `lib.fakeHash` stub that is never built.
  Restore src + hashes (or fetch) when the original repo becomes available.

> Why not the gitignored `pkgs/*/src/` copy documented before? Flakes cannot
> ingest gitignored/untracked in-tree paths (`nix flake check` / `nixos-rebuild
> --flake` fail with "not tracked by Git") and pure evaluation forbids absolute
> paths. The working offline approach is therefore: keep the checked-out source
> outside the repo and rebuild with `--impure` (see the awecron README comment).

## README note

README documents the copy command (`cp -r /path/to/{awecron,getmusic}-src pkgs/*/src`). That old
`pkgs/*/src` approach no longer works with flakes (see Build mechanics); awecron source instead
lives at `/home/user/dev/sysadmin/awecron`.
