# Packages

System-scope packages in `modules/packages.nix` (daemons, infra, root admin, the sway/swaylock/swayidle trio greetd + sway configs pin to the system profile), user-scope packages in `home/packages.nix`.

`home/packages.nix` is the **complete explicit user manifest** — every user-facing binary, including those also pulled in by home-manager config modules (`programs.git`, `programs.mpv`, `programs.bottom`, …). The duplication is deliberate so the user package set lives in exactly one place; the header comment says not to prune it.

## Categories

| Category | Notable packages |
|----------|-----------------|
| CLI utils | age, argon2, bat, cava, curl, delta, exiftool, eza, fd, figlet, fzf, git, gnuplot, ImageMagick, jq, mpc, pandoc, plantuml, ripgrep, signify, unar, wget, yt-dlp, zoxide, dash |
| Dev | cargo, gcc, go, rust, zig, uv, nodejs, npm, yarn, poetry |
| Media | ffmpeg, mpv, ncmpcpp, mpd (user service), pavucontrol, playerctl |
| LaTeX | texlivePackages.* — full thesis stack: biblatex(-apa/-iso690), babel-ukrainian/russian, cyrillic, tabularray, pgfplots, glossaries, forest, biber, latexmk |
| Science | R + rPackages (dplyr, ggplot2, knitr, rmarkdown, readxl, Rcpp, styler, car, vcd, zoo, here, usethis, IRkernel), quarto, jupyterlab, matplotlib/pandas/seaborn/numpy/scipy |
| GUI | chromium, gimp, libreoffice, obs-studio, virt-manager, sioyek, qalculate, Thunar, imv |
| AI | aichat |
| Desktop | rofi, waybar, dunst, grim, slurp, wl-clipboard, networkmanagerapplet, xdg-desktop-portal-wlr, brightnessctl (sway F5/F6), usbguard-notifier, opensnitch-ui, bottom |
| System | btrfs-progs, cryptsetup, duperemove, firewalld, networkmanager, opensnitch, usbguard, ollama, pipewire, syncthing, sway+WM stack, libnotify |

`programs.nix-ld.enable` is set in `modules/packages.nix` — runs unpatched dynamic binaries (AppImages, vendor ELFs) via `NIX_LD`/`NIX_LD_LIBRARY_PATH`; default libraries; extend with `programs.nix-ld.libraries`.

## Custom derivations

`pkgs/awecron/`, `pkgs/getmusic/` — Go programs built via `buildGoModule`. Sources are **gitignored** (`pkgs/*/src/`); derivations default to `fetchFromGitHub` with `fakeHash` placeholders (must be filled with real `vendorHash` + source `hash` after first build). See `custom-packages.md`.

## Fonts

`modules/fonts.nix`: JetBrainsMono Nerd Font, Papirus icon theme, Catppuccin cursors. `fontconfig.defaultFonts` set monospace+sans to JetBrains Mono.