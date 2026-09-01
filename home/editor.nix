{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  # bat with Catppuccin Macchiato theme (installed by home/theme.nix's
  # `catppuccin.bat.enable` — the old `theme = inputs.catppuccin...` line was
  # invalid; programs.bat.theme expects a theme *name* string)
  programs.bat = {
    enable = true;
  };

  # neovim — LazyVim config managed externally via dotfiles
  # HM installs neovim; dotfiles provide the actual config
  programs.neovim = {
    enable = true;
    # dotfiles are symlinked separately
  };

  # opencode — native HM module. Writes ~/.cfg/opencode/{opencode.json,
  # tui.json, AGENTS.md, skills/} (XDG config home is ~/.cfg, see
  # home/default.nix). The `plugin` entries are fetched by opencode itself on
  # init (ponytail plugin + vimcode TUI keybinds) — nothing is vendored.
  # Secrets (mcp-google-sheets credentials/token.json) live on disk at
  # ~/.cfg/opencode/extensions/mcp-google-sheets/, untracked.
  programs.opencode = {
    enable = true;
    settings = {
      formatter = true;
      lsp = true;
      logLevel = "WARN";
      server = {
        port = 4096;
      };
      plugin = [ "ponytail@git+https://github.com/DietrichGebert/ponytail.git#v4.9.0" ];
      mcp = {
        consensus = {
          enabled = false;
          type = "remote";
          url = "https://mcp.consensus.app/mcp";
        };
        google-sheets = {
          enabled = false;
          type = "local";
          command = [
            "uvx"
            "mcp-google-sheets@latest"
          ];
          environment = {
            CREDENTIALS_PATH = "/home/user/.config/opencode/extensions/mcp-google-sheets/credentials.json";
            TOKEN_PATH = "/home/user/.config/opencode/extensions/mcp-google-sheets/token.json";
            DRIVE_FOLDER_ID = "12nidUMMcgwA7hSQk3qTDttWL2ygzDRnO";
          };
        };
        jupyter = {
          enabled = false;
          type = "local";
          command = [
            "jupyter-mcp-kernel"
            "--cell-timeout"
            "7200"
          ];
        };
      };
    };
    tui = {
      keybinds.leader = "space";
      leader_timeout = 5000;
      plugin = [ "vimcode@git+https://github.com/oribarilan/vimcode.git#v0.16.0" ];
    };
    context = ../dotfiles/opencode/AGENTS.md;
    skills = ../dotfiles/opencode/skills;
  };
}

