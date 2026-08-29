# Desktop (Wayland)

## Login flow

`modules/greetd.nix`: **greetd** with **tuigreet** TUI greeter on VT1, launching `sway` (`--cmd sway`). Replaces Fedora's `/etc/zprofile` → `dbus-run-session sway` autostart. Password via PAM; session is a full Wayland environment.

```
greetd (tuigreet) --sway--> sway --waybar/rofi/etc.
```

## Sway

`home/desktop.nix` (HM) + raw config in `dotfiles/sway/config`.

- Mod4 (super) as mod, vim home-row keys, resize mode, scratchpad (`$mod+Shift+m` / `$mod+m`), gestures (swipe for workspaces/lock/menu).
- Output: default 2560x1600 (placeholder — the Asahi panel size; adjust for target).
- Start apps: `usbguard-notifier`, `nm-applet --indicator`, `mpd`, `opensnitch-ui`, `swayidle -w`, `swaylock`.
- Fn bindings: F1-F3 mpd control, F4 screenshot, F5/F6 brightness, F7/F8 volume, F9 keyboard layout next, F10 powermenu, F11 process killer.
- Catppuccin Macchiato border/background colors inline.
- Font: `JetBrainsMono NFM 11px`.

## Waybar

`dotfiles/waybar/` — top bar, hidden (`mode hide`), modules: workspaces, mpd, pulseaudio, disk, memory, temperature, cpu, network, battery, updater (reads `$XDG_CACHE_HOME/updater/count`), backlight, tray, language, clock. All Catppuccin Macchiato.

## Rofi

`dotfiles/rofi/` — combi launcher (`drun#run`), powermenu (`config/powermenu.rasi` + `bin/powermenu` with shutdown/reboot/lock/suspend + `ctrlcache get`), screenshot pager (`bin/scsh` → `grim`/`slurp`), process killer (`bin/killer`). Theme via `config.rasi` importing `catppuccin-macchiato`.

## Screenshots / locking

- `grim` + `slurp` (region/window).
- `swaylock -f` on idle (130s) / before-sleep; `swayidle -w` orchestrates (dpms off at 120s).
- `seat seat0 hide_cursor 10000`.

## Keyboard

- System xkb layout `custom-mech` (modules/xkb/custom-mech) — remaps Win/Alt/Ctrl + right block to navigate (slashes, arrows, menu→down).
- Sway per-input: Apple SPI keyboard `us,ru`; second `custom-mech`; `caps:escape_shifted_capslock`.
- F9 cycles layout.

## Status icons

All Fn bindings fire `notify-send` confirmations (dunst configured). Brightness via `light -A/-U 1` (sysfs), volume via `pactl set-sink-volume 0 ±1%`.

## Placeholders

`home/media.nix` keeps **obs-studio**, **gimp**, **virt-manager** commented (enable the `programs.*` blocks when needed). Chromium/syncthing/opensnitch placeholders live in `home/packages.nix`.