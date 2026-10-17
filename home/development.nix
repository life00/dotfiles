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
      key = "${config.home.homeDirectory}/etc/sec/ssh/key-r0.pub";
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
      "*".AddKeysToAgent = "yes";
      "github github.com" = {
        HostName = "github.com";
        User = "git";
        PreferredAuthentications = "publickey";
        IdentityFile = "${config.home.homeDirectory}/etc/sec/ssh/key-r0.sec";
      };
    };
  };
  services.ssh-agent.enable = true;
  systemd.user.services.ssh-agent.Unit.X-SwitchMethod = "keep-old";

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

  # FIXME: switch to a home-manager omp module once one exists
  home.packages = [ pkgs.omp ];
  xdg.configFile."omp/nix.yml".source = (pkgs.formats.yaml { }).generate "omp-config.yml" {
    extensions = [
      (pkgs.fetchFromGitHub {
        owner = "DietrichGebert";
        repo = "ponytail";
        rev = "v5.1.0";
        hash = "sha256-diYM3gqcEboVi7OQff/SvlE0TKAIPTJDIggX7rZWslY=";
      })
    ];
    symbolPreset = "nerd";
    composer.shape = "pi";
    tui.vimMode = true;
    theme = {
      dark = "dark-catppuccin";
      light = "light-catppuccin";
    };
    tools.approvalMode = "yolo";
    dev.autoqaConsent = "denied";
    secrets.enabled = true;
    retry.fallbackChains.web = [
      "web/hosted"
      "web/parallel"
      "web/duckduckgo"
      "web/public"
    ];
    task.agentModelOverrides = {
      scout = "@task";
      sonic = "@task";
      "security-reviewer" = "@task";
    };
    modelPresets = {
      anthropic.modelRoles = {
        default = "anthropic/claude-opus-5-5:max";
        task = "anthropic/claude-opus-5-5";
        smol = "anthropic/claude-sonnet-5-5";
        slow = "anthropic/claude-opus-5-5:max";
        web = "web/exa";
      };
      opencode-go.modelRoles = {
        default = "opencode-go/deepseek-v4-flash:max";
        smol = "opencode-go/deepseek-v4-flash";
        slow = "opencode-go/deepseek-v4-pro:max";
        vision = "opencode-go/deepseek-v4.1-flash";
        web = "web/exa";
      };
    };
  };

  xdg.configFile."omp/agent/mcp.json".source = (pkgs.formats.json { }).generate "omp-mcp.json" {
    "$schema" =
      "https://raw.githubusercontent.com/can1357/oh-my-pi/main/packages/coding-agent/src/config/mcp-schema.json";
    mcpServers.consensus = {
      enabled = false;
      type = "http";
      url = "https://mcp.consensus.app/mcp";
    };
  };

  programs.claude-code = {
    enable = true;
    configDir = "${config.home.homeDirectory}/.cfg/claude";
    settings = {
      editorMode = "vim";
      model = "opus";
      modelSettings.claude-opus-5.effortLevel = "high";
      theme = "dark-ansi";
      autoContinueAtUsageLimit = false;
    };
    plugins = {
      ponytail = pkgs.fetchFromGitHub {
        owner = "DietrichGebert";
        repo = "ponytail";
        rev = "v4.9.0";
        hash = "sha256-8cYggVltBAlZ/Zj4pl1bOu7mQdZFXCmDGW4RSpvRA+w=";
      };
    };
    lspServers.pyright = {
      command = "pyright-langserver";
      args = [ "--stdio" ];
      extensionToLanguage = {
        ".py" = "python";
        ".pyi" = "python";
      };
    };
  };
}
