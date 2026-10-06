{
  config,
  pkgs,
  ...
}:
{
  programs.delta.enable = true;

  programs.git = {
    enable = true;
    signing = {
      key = "${config.home.homeDirectory}/etc/sec/ssh/key-r0.sec";
      format = "ssh";
    };
    settings = {
      user.name = "life00";
      user.email = "contact.5lu1v@simplelogin.co";
      gpg.ssh.allowedSignersFile = "${config.xdg.configHome}/ssh/allowed_signers";
      core.pager = "nvim +Man! -c 'set ft=git'";
      interactive.diffFilter = "delta --color-only";
      safe.directory = "${config.home.homeDirectory}/dev/sysadmin/dotfiles";
      delta = {
        navigate = true;
        dark = true;
      };
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
    };
    includes = [
      {
        condition = "gitdir:**/marketpsych/**";
        path = "~/.cfg/git/marketpsych-profile";
      }
      {
        condition = "gitdir:**/muni/**";
        path = "~/.cfg/git/muni-profile";
      }
    ];
  };

  # ssh config
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "github github.com" = {
        HostName = "github.com";
        User = "git";
        PreferredAuthentications = "publickey";
        IdentityFile = "${config.home.homeDirectory}/etc/sec/ssh/key-r0.sec";
      };
    };
  };

  programs.neovim = {
    enable = true;
    # extra are symlinked separately
    # pass the generated init via --cmd
    sideloadInitLua = true;
    # python provider for molten
    withPython3 = true;
    extraPython3Packages = ps: [
      ps.jupyter-client
      ps.pillow
      ps.nbformat
    ];
    extraPackages = with pkgs; [
      # lsp servers
      bash-language-server
      clang-tools
      gopls
      lua-language-server
      nil
      pyright
      ruff
      taplo
      texlab
      vscode-json-languageserver
      yaml-language-server

      # formatters
      bibtex-tidy
      gofumpt
      gotools
      nixfmt
      prettier
      shfmt
      stylua
      tex-fmt

      # linters
      golangci-lint
      shellcheck
      statix

      # debug adapters
      delve
      python3Packages.debugpy

      # treesitter parser builds
      tree-sitter
    ];
  };

  programs.bat = {
    enable = true;
  };

  programs.opencode = {
    enable = true;
    package = pkgs.callPackage ../pkgs/opencode { };
    settings = {
      formatter = true;
      plugins = [
        "ponytail@git+https://github.com/DietrichGebert/ponytail.git#v4.13.0"
      ];
      mcp = {
        chrome-devtools = {
          enabled = false;
          type = "local";
          command = [
            "npx"
            "-y"
            "chrome-devtools-mcp@latest"
            "--browser-url=http://127.0.0.1:9222"
            "--no-usage-statistics"
            "--no-performance-crux"
          ];
        };
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
            CREDENTIALS_PATH = "${config.home.homeDirectory}/opencode/extensions/mcp-google-sheets/credentials.json";
            TOKEN_PATH = "${config.home.homeDirectory}/opencode/extensions/mcp-google-sheets/token.json";
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
    context = ../extra/opencode/AGENTS.md;
    skills = ../extra/opencode/skills;
  };

  # FIXME: opencode v2 reads cli.json, not tui.json; HM has no option for it yet
  xdg.configFile."opencode/cli.json".force = true;
  xdg.configFile."opencode/cli.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/v2/cli.json";
    theme = {
      name = "catppuccin-macchiato";
      mode = "dark";
    };
    keybinds = {
      leader = "space";
      "agent.cycle" = "tab";
      "session.tab.next" = "ctrl+tab,alt+down,shift+l";
      "session.tab.previous" = "ctrl+shift+tab,alt+up,shift+h";
      "session.child.first" = "ctrl+shift+down";
      "session.child.next" = "ctrl+shift+right";
      "session.child.previous" = "ctrl+shift+left";
      "session.parent" = "ctrl+shift+up";
    };
    leader.timeout = 5000;
    tabs = {
      mode = "on";
      indicators = "status";
    };
    plugins = [
      {
        package = "vimcode@git+https://github.com/oribarilan/vimcode.git#v0.19.1";
        options.experimentalV2Leader = "space";
      }
      "opencode-bytheway@0.8.1"
    ];
  };

  programs.claude-code = {
    enable = true;
    configDir = "${config.home.homeDirectory}/.cfg/claude";
    plugins = {
      ponytail = pkgs.fetchFromGitHub {
        owner = "DietrichGebert";
        repo = "ponytail";
        rev = "v4.9.0";
        hash = "sha256-8cYggVltBAlZ/Zj4pl1bOu7mQdZFXCmDGW4RSpvRA+w=";
      };
    };
  };
}
