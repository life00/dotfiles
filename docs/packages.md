# Packages

System packages in `modules/packages.nix`, user packages in `home/packages.nix`. Both duplicate a common core; user set is what home-manager installs into the user profile.

## Categories

| Category | Notable packages |
|----------|-----------------|
| CLI utils | age, argon2, bat, cava, delta, eza, fd, figlet, fzf, git, gnuplot, ImageMagick, jq, mpc, pandoc, plantuml, ripgrep, signify, unar, wget, yt-dlp, zoxide, dash |
| Dev | cargo, gcc, go, rust, zig, uv, nodejs, npm, yarn, poetry |
| Media | ffmpeg, mpv, ncmpcpp, pipewire (+alsa/jack/pulse), pavucontrol, playerctl |
| LaTeX | texlivePackages.* — full thesis stack: biblatex(-apa/-iso690), babel-ukrainian/russian, cyrillic, tabularray, pgfplots, glossaries, forest, biber, latexmk |
| Science | R + rPackages (dplyr, ggplot2, knitr, rmarkdown, readxl, Rcpp, styler, car, vcd, zoo, here, usethis, IRkernel), quarto, jupyterlab, matplotlib/pandas/seaborn/numpy/scipy |
| GUI | chromium, gimp, libreoffice, obs-studio, virt-manager, syncthing, sioyek, qalculate, Thunar, imv |
| AI | ollama, aichat |
| System | btrfs-progs, cryptsetup, duperemove, firewalld, light, opensnitch, rofi-wayland, sway+WM stack, bottom, libnotify |

## Custom derivations

`pkgs/awecron/`, `pkgs/getmusic/` — Go programs built via `buildGoModule`. Sources are **gitignored** (`pkgs/*/src/`); derivations default to `fetchFromGitHub` with `fakeHash` placeholders (must be filled with real `vendorHash` + source `hash` after first build). See `custom-packages.md`.

## Fonts

`modules/fonts.nix`: JetBrainsMono Nerd Font, Papirus icon theme, Catppuccin cursors. `fontconfig.defaultFonts` set monospace+sans to JetBrains Mono.