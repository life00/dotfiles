# Shell (zsh)

Implemented in `home/shell.nix`; raw config in `extra/zsh/`.

## ZDOTDIR mechanism

Fedora used `/etc/zshenv` → `export ZDOTDIR=$HOME/.cfg/zsh`. NixOS keeps zsh config fully in HM: `programs.zsh` sets `ZDOTDIR` equivalents by writing a small `zshenv` via `home.file`… (see below). In practice, HM writes extra to `~/.cfg/` because `xdg.configHome = ${home}/.cfg`; all `programs.*` config lands there.

## History / logging

- `history.path = /var/log/zsh/histfile` — the *system-wide* history shared by all zsh sessions (mode 0666 via tmpfiles, so user can write; dir root-owned).
- `history.size/save = 5000`.
- System-wide command logging to `/var/log/history.log` (mode 0666 via tmpfiles), all configured in `modules/users.nix`. Fedora logged root commands via `/root/.bashrc` `PROMPT_COMMAND`; root still runs bash here (the doas wrapper sets `SHELL=/bin/bash`), so `programs.bash.interactiveShellInit` sets `PROMPT_COMMAND` for root (UID 0 only). The user zsh `precmd` hook does the same via `programs.zsh.interactiveShellInit` — the equivalent of the old HM `initExtraFirst` hook (moved to keep all logging in one module).

## Aliases (from extra/zsh/aliases)

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

`extra/starship/starship.toml` → HM `programs.starship.settings` (full port: battery/username/hostname/character, cmd_duration/git_status/git_branch/directory, all colors).

## doas wrapper

`doas() { SHELL=/bin/bash; command doas "$@"; SHELL=/bin/zsh; }` — keeps doas running bash (interactive root).

## cheat.sh

`cht()` curl helper.
