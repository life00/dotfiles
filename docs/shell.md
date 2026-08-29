# Shell (zsh)

Implemented in `home/shell.nix`; raw config in `dotfiles/zsh/`.

## ZDOTDIR mechanism

Fedora used `/etc/zshenv` → `export ZDOTDIR=$HOME/.cfg/zsh`. NixOS keeps zsh config fully in HM: `programs.zsh` sets `ZDOTDIR` equivalents by writing a small `zshenv` via `home.file`… (see below). In practice, HM writes dotfiles to `~/.cfg/` because `xdg.configHome = ${home}/.cfg`; all `programs.*` config lands there.

## History / logging

- `history.path = /var/log/zsh/histfile` — the *system-wide* history shared by all zsh sessions (mode 0666 via tmpfiles, so user can write; dir root-owned).
- `history.size/save = 5000`.
- Bash root prompt additionally appends every command to `/var/log/history.log` (Fedora's `/root/.bashrc` `PROMPT_COMMAND` equivalent → HM `programs.bash` on root; here via `initExtraFirst` for zsh `precmd` hook).

## Aliases (from dotfiles/zsh/aliases)

`..`→cd, `ls`→`eza --icons`, `tree`→exa -T, `delta`, `diff`, `lf`→zlf, `R`, `nmpc`, `lv`, `oc`→opencode, `mv/cp/rm -v`, `e`→exit, `mpi`→mpv --pause, `cd`→z (zoxide), `cdi`→zi, `calc`, `ef`→exiftool, `btop`→bottom, `todo`/`td` (ripgrep over ~/doc).

## Plugins

HM-managed (`programs.zsh.plugins`): `fzf-tab`, `zsh-autosuggestions`, `zsh-vi-mode`, `zsh-history-substring-search`, `fast-syntax-highlighting` + oh-my-zsh `git` plugin. `zoxide init zsh`, `starship init zsh` via `programs.zoxide`/`programs.starship` integrations.

## Environment (home.sessionVariables)

- XDG dirs: `*_HOME` → `~/.cfg`, `~/etc/...` (cache/data/state), `~/.doc/~/.tmp/~/med/*`.
- `PATH += ~/.local/bin:~/.bin:~/etc/bin`.
- GPU: `MESA_GL_VERSION_OVERRIDE=3.3`, `MESA_GLSL_VERSION_OVERRIDE=330`.
- Tool paths: GOPATH, CARGO_HOME, R_*, INPUTRC, JUPYTER_CONFIG_DIR, OLLAMA_MODELS, JULIA_DEPOT_PATH, TEXMFVAR=/tmp.
- `STARSHIP_CONFIG/CACHE` → `~/.cfg/starship/...`.
- `FZF_DEFAULT_OPTS` = Catppuccin Macchiato color scheme.

## Starship

`dotfiles/starship/starship.toml` → HM `programs.starship.settings` (full port: battery/username/hostname/character, cmd_duration/git_status/git_branch/directory, all colors).

## doas wrapper

`doas() { SHELL=/bin/bash; command doas "$@"; SHELL=/bin/zsh; }` — keeps doas running bash (interactive root).

## cheat.sh

`cht()` curl helper.