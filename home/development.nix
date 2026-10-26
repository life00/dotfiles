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

  # programs.claude-code.plugins symlinks hooks/ out of the plugin dir, which Claude Code refuses
  home.file."${config.programs.claude-code.configDir}/skills/footer-info".source =
    ../extra/claude/footer-info;

  home.file."${config.programs.claude-code.configDir}/themes/catppuccin-macchiato.json".text =
    let
      c = {
        rosewater = "#f4dbd6";
        flamingo = "#f0c6c6";
        pink = "#f5bde6";
        mauve = "#c6a0f6";
        red = "#ed8796";
        maroon = "#ee99a0";
        peach = "#f5a97f";
        yellow = "#eed49f";
        green = "#a6da95";
        teal = "#8bd5ca";
        sky = "#91d7e3";
        sapphire = "#7dc4e4";
        blue = "#8aadf4";
        lavender = "#b7bdf8";
        text = "#cad3f5";
        subtext1 = "#b8c0e0";
        subtext0 = "#a5adcb";
        overlay0 = "#6e738d";
        surface1 = "#494d64";
        base = "#24273a";
        mantle = "#1e2030";
      };
    in
    builtins.toJSON {
      name = "Catppuccin Macchiato";
      base = "dark";
      overrides = {
        claude = c.peach;
        claudeShimmer = c.flamingo;
        claudeBlue_FOR_SYSTEM_SPINNER = c.sapphire;
        claudeBlueShimmer_FOR_SYSTEM_SPINNER = c.sky;
        clawd_body = c.peach;
        clawd_background = c.base;
        text = c.text;
        inverseText = c.base;
        inactive = c.subtext0;
        inactiveShimmer = c.subtext1;
        subtle = c.overlay0;
        suggestion = c.lavender;
        permission = c.blue;
        permissionShimmer = c.lavender;
        remember = c.mauve;
        skill = c.sky;
        background = c.teal;
        professionalBlue = c.sapphire;
        chromeYellow = c.yellow;
        success = c.green;
        error = c.red;
        warning = c.yellow;
        warningShimmer = c.rosewater;
        merged = c.mauve;
        promptBorder = c.mauve;
        promptBorderShimmer = c.pink;
        planMode = c.teal;
        autoAccept = c.green;
        autoAcceptShimmer = c.teal;
        bashBorder = c.pink;
        ide = c.sapphire;
        fastMode = c.maroon;
        fastModeShimmer = c.flamingo;
        effortUltra = c.mauve;
        # accents blended over base: 15% / 28% / 50%
        diffAddedDimmed = "#384248";
        diffAdded = "#485953";
        diffAddedWord = "#658068";
        diffRemovedDimmed = "#423548";
        diffRemoved = "#5c4254";
        diffRemovedWord = "#885768";
        userMessageBackground = "#393c55";
        userMessageBackgroundHover = "#444864";
        bashMessageBackgroundColor = "#413c52";
        memoryBackgroundColor = "#3b3854";
        selectionBg = "#51496f";
        composerSidebarBackground = c.mantle;
        rate_limit_fill = c.mauve;
        rate_limit_empty = c.surface1;
        briefLabelYou = c.blue;
        briefLabelClaude = c.peach;
        red_FOR_SUBAGENTS_ONLY = c.red;
        blue_FOR_SUBAGENTS_ONLY = c.blue;
        green_FOR_SUBAGENTS_ONLY = c.green;
        yellow_FOR_SUBAGENTS_ONLY = c.yellow;
        purple_FOR_SUBAGENTS_ONLY = c.mauve;
        orange_FOR_SUBAGENTS_ONLY = c.peach;
        pink_FOR_SUBAGENTS_ONLY = c.pink;
        cyan_FOR_SUBAGENTS_ONLY = c.sky;
        rainbow_red = c.red;
        rainbow_orange = c.peach;
        rainbow_yellow = c.yellow;
        rainbow_green = c.green;
        rainbow_blue = c.blue;
        rainbow_indigo = c.lavender;
        rainbow_violet = c.mauve;
        rainbow_red_shimmer = c.maroon;
        rainbow_orange_shimmer = c.flamingo;
        rainbow_yellow_shimmer = c.rosewater;
        rainbow_green_shimmer = c.teal;
        rainbow_blue_shimmer = c.sky;
        rainbow_indigo_shimmer = c.text;
        rainbow_violet_shimmer = c.pink;
      };
    };
}
