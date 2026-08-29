# Theming

All themes are **Catppuccin Macchiato** (lavender accent). Two layers:

## 1. catppuccin/nix flake (dynamic)

Applied via `catppuccin.nixosModules.catppuccin` (hosts/localhost/default.nix) and HM module in `home/theme.nix`:

| Program | HM option |
|---------|-----------|
| GTK | `catppuccin.gtk.enable` (`theme = "standard"`) |
| Cursors | `catppuccin.cursors.enable` |
| fzf | `catppuccin.fzf.enable` (via FZF_DEFAULT_OPTS in shell.nix) |
| nvim | `catppuccin.nvim.enable` |
| alacritty | `catppuccin.alacritty.enable` |
| bat | `catppuccin.bat.enable` |
| delta | `catppuccin.delta.enable` |
| zsh fsh | `catppuccin.zsh.enable` (`plugin = "fast-syntax-highlighting"`) |
| starship | `catppuccin.starship.enable` |
| rofi | `catppuccin.rofi.enable` |
| waybar | `catppuccin.waybar.enable` |
| dunst | `catppuccin.dunst.enable` |

Flavor/accent set once: `flavor = "macchiato"`, `accent = "lavender"`. Themes fetched from the flake at build time, no vendored theme files in repo.

## 2. Hardcoded inline (configs not covered by the flake)

- Sway borders/background (`dotfiles/sway/config`): `#b7bdf8 #1A1826 #C9CBFF #7dc4e4 …`.
- Swaylock colors (`home/desktop.nix`).
- Git delta (in `home/git.nix` — catppuccin palette via `map-styles`, `blame-palette`, etc.).
- mpv (`home/media.nix`): `background="#181926"`, `sub-color="#cad3f5"`.
- Bottom/Fhigh (`dotfiles/bottom/bottom.toml`).
- rofi `colors.rasi` palette + `font.rasi` JetBrainsMono NF.
- cava shaders (bar_spectrum, northern_lights, pass_through).

## GTK / dconf

`modules/fonts.nix` + `home/theme.nix` set system/user dconf:

```
gtk-theme    = catppuccin-macchiato-lavender-standard+default
icon-theme   = Papirus-Dark
cursor-theme = Catppuccin-Macchiato-Dark-Cursors
font-name    = JetBrainsMono Nerd Font 11
color-scheme = prefer-dark
```

Fonts: JetBrainsMono Nerd Font (mono+sans default) from nerd-fonts (override only JetBrains). Wallpapers in `dotfiles/sway/wallpapers/` are the original PNGs (Asahi catppuccin, dark-cat, dreams, gargantua, gentoo, pacman, tetris, tux, waves).