# Custom Packages

Two Go binaries were installed manually on Fedora (`/usr/local/bin`); they are now built from source.

## awecron

Custom cron daemon with **dynamic sleep** — polls cronjob dirs (`$cfgdir/*/` each containing `cfg`, `run`, `tmr`), runs jobs whose timer has expired, schedules next run by writing `tmr` mtime, sleeps until the soonest next run.

- Location: `pkgs/awecron/default.nix`
- Entrypoint: service in `modules/services.nix` (`systemd.services.awecron`, root, `Restart=always`)
- Config dir: `~/.cfg/awecron/` (symlinked from `dotfiles/awecron/`) — root daemon reads `/etc/awecron` first, then `$HOME/.config/awecron`; here the systemd unit sets `HOME=/root` + `XDG_CONFIG_HOME` so it finds `~/.cfg/awecron`.
- Global config in `dotfiles/awecron/cfg` (max/min/timeout: 9999/5/200).
- Jobs: `tphome10min` (10 min), `tphome1hour` (60 min) — btrfs snapshots; `updater` — dnf/`nix` update check + notify (writes `$XDG_CACHE_HOME/updater/count`).

## getmusic

Batch audio downloader built on yt-dlp (`github.com/lrstanley/go-ytdlp`). Usage: `getmusic FILE [-d DIR]`, parses URL lines (`*` suffix = favorites → `DIR/fav/`), asks confirmation, extracts audio at quality 0.

- Location: `pkgs/getmusic/default.nix`

## Build mechanics

Both use `buildGoModule` with `subPackages = ["."]`.

- `src` currently `fetchFromGitHub` with `hash = lib.fakeHash` — **must be replaced** with the real `lib.fixedOutputHash` from the first build error (or `hash = ""` die message).
- `vendorHash = lib.fakeHash` likewise replaced by the `gotest`/`go-mod-vendor` impure error's real hash.

The user's stated intent: source gets copied into `pkgs/*/src/` (gitignored) so the repo can be moved to an offline external system and built from local source. The derivations are written so that if `./src` exists it is preferred over fetch — adjust `src` accordingly when adding local copies:

```nix
src = pkgs.lib.cleanSource ./src;   # local copy
```

## README note

README documents the copy command (`cp -r /path/to/{awecron,getmusic}-src pkgs/*/src`). Without local source or a fixed hash, the flake will fail to build until hashes are filled in.