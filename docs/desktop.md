# Desktop (Wayland)

## Login flow

`modules/greetd.nix`: **greetd** with **tuigreet** TUI greeter on VT1, launching `sway` (`--cmd sway`). Replaces Fedora's `/etc/zprofile` → `dbus-run-session sway` autostart. Password via PAM; session is a full Wayland environment.

```
greetd (tuigreet) --sway--> sway --waybar/rofi/etc.
```

## Sway

`home/desktop.nix` — fully Nix-native via `wayland.windowManager.sway` (this HM rev dropped `programs.sway`; sway moved under `wayland.windowManager`). The sway binary stays system-wide (`programs.sway.enable` in `modules/packages.nix`, launched by greetd); HM `package` is `mkForce null` so HM only generates `~/.cfg/sway/config` (XDG config home) and driver envy. `systemd.enable` with `dbusImplementation = "broker"` matches the host's `services.dbus.implementation`.

- Mod4 (super) as mod, vim home-row keys, resize mode, scratchpad (`$mod+Shift+m` / `$mod+m`), gestures (`bindgesture swipe:*` in `extraConfig` for workspaces/lock/menu).
- Output: `wallpapers/tux.png` (repo-root top-level dir, referenced as an **absolute store path** — old `$XDG_CONFIG_HOME/sway/wallpapers/…` broke because greetd's sway session has no `XDG_CONFIG_HOME`) + `eDP-1` 2560x1600 placeholder.
- Start apps: `usbguard-notifier`, `nm-applet --indicator`, `dunst`, `mpc volume 50`, `opensnitch-ui`, `chmod -R g+rwx /run/user/`. (mpd itself runs as a systemd user service from `home/media.nix`, not a sway exec.)
- Swayidle is a **systemd user service** (`services.swayidle`, binds to `graphical-session.target` via sway's `sway-session.target`); commands use absolute store paths because the unit PATH only has bash.
- Fn bindings: F1-F3 mpd control, F4 screenshot, F5/F6 brightness, F7/F8 volume, F9 keyboard layout next, F10 powermenu, F11 process killer.
- Catppuccin Macchiato border/background colors inline (`config.colors`); the auto-enabled `catppuccin.sway` include defines `$color` vars (harmless, unused).
- Font: `JetBrainsMono NFM 11px`.
- Config validated with `sway -c <generated> --validate --unsupported-gpu` (HM `checkConfig` is auto-off since `package = null`).

## Waybar

`dotfiles/waybar/` — top bar, hidden (`mode hide`), modules: workspaces, mpd, pulseaudio, disk, memory, temperature, cpu, network, battery, updater (reads `$XDG_CACHE_HOME/updater/count`), backlight, tray, language, clock. All Catppuccin Macchiato.

## Rofi

`dotfiles/rofi/` — combi launcher (`drun#run`), powermenu (`config/powermenu.rasi` + `bin/powermenu` with shutdown/reboot/lock/suspend + `ctrlcache get`), screenshot pager (`bin/scsh` → `grim`/`slurp`), process killer (`bin/killer`). Theme via `config.rasi` importing `catppuccin-macchiato`.

## Screenshots / locking

- `grim` + `slurp` (region/window).
- `swaylock -f` on idle (130s) / before-sleep via the `services.swayidle` user service (dpms off at 120s); `bindgesture swipe:down` also locks.
- `seat seat0 hide_cursor 10000`.

## Keyboard

- System xkb layout `custom-mech` (modules/xkb/custom-mech) — remaps Win/Alt/Ctrl + right block to navigate (slashes, arrows, menu→down).
- Sway per-input: Apple SPI keyboard `us,ru`; second `custom-mech`; `caps:escape_shifted_capslock`.
- F9 cycles layout.

## Status icons

All Fn bindings fire `notify-send` confirmations (dunst configured). Brightness via `light -A/-U 1` (sysfs), volume via `pactl set-sink-volume 0 ±1%`.

## Placeholders

`home/media.nix` keeps **obs-studio**, **gimp**, **virt-manager** commented (enable the `programs.*` blocks when needed). Chromium/syncthing/opensnitch placeholders live in `home/packages.nix`.