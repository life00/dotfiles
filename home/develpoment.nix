{
  config,
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
      safe.directory = "${config.home.homeDirectory}/dev/src/nix";
      delta = {
        navigate = true;
        dark = true;
      };
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
    };
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

  # allowed_signers
  home.file."${config.xdg.configHome}/ssh/allowed_signers".text = ''
    # me
    life00 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHvrvklEwdxbJIe5KUL4y6cRIwhpmwx06w76fy6x31/A
  '';

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = {
          family = "JetBrainsMono NFM";
          style = "Regular";
        };
        bold = {
          family = "JetBrainsMono NFM";
          style = "Bold";
        };
        italic = {
          family = "JetBrainsMono NFM";
          style = "Italic";
        };
        bold_italic = {
          family = "JetBrainsMono NFM";
          style = "Bold Italic";
        };
        size = 11;
      };
      cursor = {
        style = {
          shape = "Beam";
          blinking = "On";
        };
        vi_mode_style = {
          shape = "Block";
        };
      };
      keyboard.bindings = [
        {
          key = "Return";
          mods = "Shift";
          chars = "\\u001B[13;2u";
        }
        {
          key = "Return";
          mods = "Control";
          chars = "\\u001B[13;5u";
        }
      ];
    };
  };

  programs.neovim = {
    enable = true;
    # dotfiles are symlinked separately
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
      plugin = [ "vimcode@git+https://github.com/oribarilan/vimcode.git#v0.16.0" ];
    };
    context = ../dotfiles/opencode/AGENTS.md;
    skills = ../dotfiles/opencode/skills;
  };

}
