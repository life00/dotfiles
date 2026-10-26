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
    advisor.enabled = true;
    modelPresets = {
      opencode-go.modelRoles = {
        default = "opencode-go/deepseek-v4.1-flash:max";
        task = "opencode-go/deepseek-v4.1-flash:max";
        smol = "opencode-go/deepseek-v4.1-flash:max";
        slow = "opencode-go/gemini-4-argon:xhigh";
        advisor = "opencode-go/deepseek-v4.1-flash:max";
        web = "web/exa";
      };
    };
  };

  programs.claude-code = {
    enable = true;
    configDir = "${config.home.homeDirectory}/.cfg/claude";
    settings = {
      editorMode = "vim";
      model = "claude-opus-5-5";
      modelSettings.claude-opus-5-5.effortLevel = "high";
      theme = "custom:catppuccin-macchiato";
      autoContinueAtUsageLimit = false;
      tui = "fullscreen";
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

  home.file."${config.programs.claude-code.configDir}/themes/catppuccin-macchiato.json".text =
    builtins.toJSON
      {
        name = "Catppuccin Macchiato";
        base = "dark";
        overrides = {
          claude = "#f5a97f";
          claudeShimmer = "#e2bcb4";
          claudeBlue_FOR_SYSTEM_SPINNER = "#8aadf4";
          claudeBlueShimmer_FOR_SYSTEM_SPINNER = "#a7bef4";
          clawd_body = "#f5a97f";
          clawd_background = "#24273a";
          text = "#cad3f5";
          inverseText = "#24273a";
          inactive = "#8087a2";
          inactiveShimmer = "#939ab7";
          subtle = "#5b6078";
          suggestion = "#b7bdf8";
          permission = "#8aadf4";
          permissionShimmer = "#a7bef4";
          remember = "#c6a0f6";
          skill = "#c6a0f6";
          background = "#8bd5ca";
          professionalBlue = "#7dc4e4";
          chromeYellow = "#eed49f";
          success = "#a6da95";
          error = "#ed8796";
          warning = "#eed49f";
          warningShimmer = "#ded4c6";
          merged = "#c6a0f6";
          promptBorder = "#5b6078";
          promptBorderShimmer = "#8087a2";
          planMode = "#8bd5ca";
          autoAccept = "#c6a0f6";
          autoAcceptShimmer = "#c8b7f6";
          bashBorder = "#f5bde6";
          ide = "#7dc4e4";
          fastMode = "#ee99a0";
          fastModeShimmer = "#deb3c6";
          effortUltra = "#c6a0f6";
          diffAdded = "#445451";
          diffRemoved = "#563f51";
          diffAddedDimmed = "#343c45";
          diffRemovedDimmed = "#3c3345";
          diffAddedWord = "#5e7863";
          diffRemovedWord = "#7e5263";
          userMessageBackground = "#363a4f";
          userMessageBackgroundHover = "#494d64";
          bashMessageBackgroundColor = "#4d4a61";
          memoryBackgroundColor = "#474663";
          selectionBg = "#5b6078";
          composerSidebarBackground = "#1e2030";
          rate_limit_fill = "#b7bdf8";
          rate_limit_empty = "#494d64";
          briefLabelYou = "#8aadf4";
          briefLabelClaude = "#f5a97f";
          red_FOR_SUBAGENTS_ONLY = "#ed8796";
          blue_FOR_SUBAGENTS_ONLY = "#8aadf4";
          green_FOR_SUBAGENTS_ONLY = "#a6da95";
          yellow_FOR_SUBAGENTS_ONLY = "#eed49f";
          purple_FOR_SUBAGENTS_ONLY = "#c6a0f6";
          orange_FOR_SUBAGENTS_ONLY = "#f5a97f";
          pink_FOR_SUBAGENTS_ONLY = "#f5bde6";
          cyan_FOR_SUBAGENTS_ONLY = "#91d7e3";
          rainbow_red = "#ed8796";
          rainbow_orange = "#f5a97f";
          rainbow_yellow = "#eed49f";
          rainbow_green = "#a6da95";
          rainbow_blue = "#8aadf4";
          rainbow_indigo = "#b7bdf8";
          rainbow_violet = "#c6a0f6";
          rainbow_red_shimmer = "#dda9c1";
          rainbow_orange_shimmer = "#e2bcb4";
          rainbow_yellow_shimmer = "#ded4c6";
          rainbow_green_shimmer = "#b6d7c0";
          rainbow_blue_shimmer = "#a7bef4";
          rainbow_indigo_shimmer = "#c0c7f7";
          rainbow_violet_shimmer = "#c8b7f6";
        };
      };
}
