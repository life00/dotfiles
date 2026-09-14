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
      ps.cairosvg
      ps.pnglatex
    ];
  };

  programs.bat = {
    enable = true;
  };

  programs.opencode = {
    enable = true;
    settings = {
      formatter = true;
      lsp = true;
      logLevel = "WARN";
      server = {
        port = 4096;
      };
      plugin = [
        "ponytail@git+https://github.com/DietrichGebert/ponytail.git#v4.9.0"
        "opencode-claude-auth@latest"
      ];
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
    tui = {
      keybinds.leader = "space";
      leader_timeout = 5000;
      plugin = [
        "vimcode@git+https://github.com/oribarilan/vimcode.git#v0.18.1"
        "opencode-bytheway@0.8.1"
      ];
    };
    context = ../extra/opencode/AGENTS.md;
    skills = ../extra/opencode/skills;
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
