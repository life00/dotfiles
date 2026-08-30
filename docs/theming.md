# Theming

All themes are **Catppuccin Macchiato** (lavender accent). Two layers:

## 1. catppuccin/nix flake (dynamic)

Applied via `catppuccin.nixosModules.catppuccin` (hosts/mb2017/default.nix) and HM module in `home/theme.nix`:

| Program | HM option |
|---------|-----------|
| GTK icons | `catppuccin.gtk.icon.enable` (Papirus folder accents; the GTK *theme* itself comes from the `catppuccin-gtk` nixpkgs package, see below) |
| Cursors | `catppuccin.cursors.enable` |
| fzf | `catppuccin.fzf.enable` (via FZF_DEFAULT_OPTS in shell.nix) |
| nvim | `catppuccin.nvim.enable` |
| alacritty | `catppuccin.alacritty.enable` (colors via `settings.general.import`; font/cursor live in home/terminal.nix) |
| bat | `catppuccin.bat.enable` |
| delta | `catppuccin.delta.enable` |
| zsh fsh | `catppuccin.zsh-syntax-highlighting.enable` |
| starship | `catppuccin.starship.enable` |
| bottom | `catppuccin.bottom.enable` (theme only; non-theme options in `home/files.nix`) |
| swaylock | `catppuccin.swaylock.enable` (official macchiato .conf → `programs.swaylock.settings` in home/desktop.nix; font only hardcoded) |
| rofi/waybar/dunst | raw dotfiles carrying the palette themselves — NOT catppuccin flake modules (would collide with the dotfile symlinks) |

Flavor/accent set once: `flavor = "macchiato"`, `accent = "lavender"`. Themes fetched from the flake at build time, no vendored theme files in repo.

## 2. Hardcoded inline (configs not covered by the flake)

- Sway borders/background (`home/desktop.nix` — native sway config `config.colors`): `#b7bdf8 #1A1826 #C9CBFF #7dc4e4 …`. The catppuccin flake auto-injects its `catppuccin/macchiato` var-include into the generated config; the `$color` vars are unused (hardcoded hex kept for parity with the old dotfile).
- Swaylock colors: from the catppuccin port (`catppuccin.swaylock.enable` in home/theme.nix; official macchiato .conf rendered into `programs.swaylock.settings`). Only the font (`JetBrainsMono Nerd Font`) is hardcoded in `home/desktop.nix`.
- Git delta (in `home/git.nix` — catppuccin palette via `map-styles`, `blame-palette`, etc.).
- mpv (`home/media.nix`): `background="#181926"`, `sub-color="#cad3f5"`.
- rofi `colors.rasi` palette + `font.rasi` JetBrainsMono NF.
- cava shaders (bar_spectrum, northern_lights, pass_through).

## GTK / dconf

`modules/fonts.nix` installs the `catppuccin-gtk` package (overridden to `variant = "macchiato"`, `accent = "lavender"`, `size = "standard"`) and sets system/user dconf:

```
gtk-theme    = catppuccin-macchiato-lavender-standard
icon-theme   = Papirus-Dark
cursor-theme = catppuccin-macchiato-dark-cursors
font-name    = JetBrainsMono Nerd Font 11
color-scheme = prefer-dark
```

Note: nixpkgs' `fix-inconsistent-theme-name` patch drops the `+default` suffix the upstream installer uses, so the dconf name matches the installed `share/themes/catppuccin-macchiato-lavender-standard` dir exactly.

Fonts: JetBrainsMono Nerd Font (mono+sans default) from nerd-fonts (override only JetBrains). Wallpapers in the top-level `wallpapers/` (used via absolute store path in the native sway config) are the original PNGs (Asahi catppuccin, dark-cat, dreams, gargantua, gentoo, pacman, tetris, tux, waves).