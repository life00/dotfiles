{
  config,
  pkgs,
  ...
}:
{
  programs.delta.enable = true;
  programs.gh.enable = true;

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
      jdt-language-server

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
    config = {
      paging = "never";
      style = "plain";
    };
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
      ../extra/omp
    ];
    symbolPreset = "nerd";
    composer.shape = "pi";
    tui.vimMode = true;
    theme = {
      dark = "dark-catppuccin-tuned";
      light = "light-catppuccin";
    };
    tools.approvalMode = "yolo";
    dev.autoqaConsent = "denied";
    secrets.enabled = true;
    browser.relay = true;
    retry.fallbackChains.web = [
      "web/parallel"
      "web/duckduckgo"
      "web/public"
    ];
    task.agentModelOverrides."security-reviewer" = "@task";
    worktree = {
      onExit = "ask";
    };
    modelPresets = {
      anthropic.modelRoles = {
        default = "anthropic/claude-opus-5-5:high";
        task = "anthropic/claude-opus-5-5";
        smol = "anthropic/claude-sonnet-5-5";
        slow = "anthropic/claude-opus-5-5:max";
        web = "web/hosted";
      };
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
