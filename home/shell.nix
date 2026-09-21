{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.zsh = {
    enable = true;
    # vim mode
    defaultKeymap = "viins";

    setOptions = [
      "interactive_comments"
    ];

    # fast compinit
    completionInit = ''
      # regenrate compinit only if older than 24h
      autoload -U compinit
      for dumpfile in "''${ZDOTDIR:-$HOME}/.zcompdump"(N.mh+24); do
        compinit -d "''${ZDOTDIR:-$HOME}/.zcompdump"
      done
      [[ -n ''${dumpfile} ]] || compinit -C -d "''${ZDOTDIR:-$HOME}/.zcompdump"
      unset dumpfile
    '';

    history = {
      path = "/var/log/zsh/histfile";
      size = 5000;
      save = 5000;
      ignoreDups = true;
    };

    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      ai = "aichat";
      ls = "eza --icons always";
      tree = "eza --icons always -T";
      delta = "delta --pager less";
      sioyek = "sioyek-open";
      diff = "delta";
      lf = "zlf";
      R = "R --quiet --no-save";
      nmpc = "ncmpcpp";
      lv = "nvim";
      oc = "opencode --port";
      mv = "mv -v";
      cp = "cp -v";
      rm = "rm -v";
      e = "exit";
      mpi = "mpv --pause";
      cd = "z";
      calc = "qalc";
      ef = "exiftool";
      todo = "rg '\\- \\[ \\] ' --sortr 'modified' --glob '*.md' '/home/user/doc/'";
    };

    # some ugly legacy zsh configs
    initContent = lib.mkMerge [
      (lib.mkBefore ''
        # zsh-vi-mode highlight colors (set before the plugin loads).
        ZVM_VI_HIGHLIGHT_BACKGROUND=#494d64
        ZVM_VI_HIGHLIGHT_FOREGROUND=text
        ZVM_VI_HIGHLIGHT_EXTRASTYLE=bold
      '')
      ''
        # cheat.sh
        cht() {
          curl cheat.sh/"$@"
        }

        # fzf-tab Catppuccin Macchiato theme
        zstyle ':fzf-tab:*' fzf-flags --color=bg+:#363A4F,bg:#24273A,spinner:#F4DBD6,hl:#ED8796 \
          --color=fg:#CAD3F5,header:#ED8796,info:#C6A0F6,pointer:#F4DBD6 \
          --color=marker:#B7BDF8,fg+:#CAD3F5,prompt:#C6A0F6,hl+:#ED8796 \
          --color=selected-bg:#494D64 \
          --color=border:#363A4F,label:#CAD3F5

        # zsh-history-substring-search bindkeys + highlight colors
        bindkey '^[[A' history-substring-search-up
        bindkey '^[[B' history-substring-search-down
        bindkey -M vicmd 'k' history-substring-search-up
        bindkey -M vicmd 'j' history-substring-search-down
        export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="fg=#494d64,bg=#c6a0f6"
        export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="fg=#494d64,bg=#ed8796"
      ''
    ];
  };

  # zsh plugins
  programs.zsh.plugins = [
    {
      name = "fzf-tab";
      src = pkgs.zsh-fzf-tab;
      file = "share/fzf-tab/fzf-tab.plugin.zsh";
    }
    {
      name = "zsh-autosuggestions";
      src = pkgs.zsh-autosuggestions;
      file = "share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh";
    }
    {
      name = "zsh-vi-mode";
      src = pkgs.zsh-vi-mode;
      file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
    }
    {
      name = "zsh-history-substring-search";
      src = pkgs.zsh-history-substring-search;
      file = "share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.plugin.zsh";
    }
    {
      name = "fast-syntax-highlighting";
      src = pkgs.zsh-fast-syntax-highlighting;
      file = "share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh";
    }
    {
      name = "git";
      src = pkgs.oh-my-zsh;
      file = "share/oh-my-zsh/plugins/git/git.plugin.zsh";
    }
  ];

  # enables fzf keybindings in shell
  programs.fzf.enable = true;

  # zoxide
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # starship
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      format = "$battery$username$hostname$character";
      right_format = "$cmd_duration$git_status$git_branch$directory";

      character = {
        format = " [](fg:crust bg:none)$symbol[](fg:crust bg:none) ";
        success_symbol = "[󰠥](fg:green bg:crust)";
        error_symbol = "[󰠥](fg:red bg:crust)";
        vicmd_symbol = "[󰠥](fg:blue bg:crust)";
        disabled = false;
      };

      hostname = {
        ssh_only = true;
        trim_at = ".";
        format = " [](fg:crust bg:none)[󰍹](fg:maroon bg:crust)[](fg:crust bg:mantle)[ $hostname]($style)[](fg:mantle bg:none)";
        style = "fg:maroon bg:mantle";
        disabled = false;
      };

      username = {
        style_root = "fg:red";
        style_user = "fg:yellow";
        format = " [](fg:crust bg:none)[󰀉]($style bg:crust)[](fg:crust bg:mantle)[ $user]($style bg:mantle)[](fg:mantle bg:none)";
        show_always = false;
        disabled = false;
      };

      battery = {
        charging_symbol = "󰂄";
        discharging_symbol = "󰂃";
        format = " [](fg:crust bg:none)[$symbol]($style bg:crust)[](fg:crust bg:mantle)[ $percentage]($style bg:mantle)[](fg:mantle bg:none)";
        disabled = false;
        display = [
          {
            threshold = 10;
            style = "fg:red";
          }
          {
            threshold = 20;
            style = "fg:peach";
          }
        ];
      };

      directory = {
        truncation_length = 5;
        truncate_to_repo = false;
        format = "([](fg:crust bg:none)[$read_only]($read_only_style)[](fg:crust bg:none) )[](fg:crust bg:none)[](fg:teal bg:crust)[](fg:crust bg:mantle)[ $path]($style)[](fg:mantle bg:none)";
        style = "fg:teal bg:mantle";
        disabled = false;
        read_only = "󰍁";
        read_only_style = "fg:red bg:crust";
        truncation_symbol = "";
        repo_root_style = "fg:blue bg:mantle";
        repo_root_format = "([](fg:crust bg:none)[$read_only]($read_only_style)[](fg:crust bg:none) )[](fg:crust bg:none)[](fg:teal bg:crust)[](fg:crust bg:mantle)[ $repo_root]($repo_root_style)[$path]($style)[](fg:mantle bg:none)";
        home_symbol = "~";
        use_os_path_sep = true;
      };

      git_branch = {
        always_show_remote = false;
        format = "[](fg:crust bg:none)[$symbol](fg:mauve bg:crust)[](fg:crust bg:mantle)[ $branch]($style)[](fg:mantle bg:none) ";
        symbol = "";
        style = "fg:mauve bg:mantle";
        only_attached = false;
        disabled = false;
      };

      git_status = {
        format = "([](fg:crust bg:none)[󰊢](fg:flamingo bg:crust)[](fg:crust bg:mantle)[ $all_status$ahead_behind]($style)[](fg:mantle bg:none) )";
        conflicted = "= ";
        ahead = "";
        behind = "";
        diverged = "";
        up_to_date = "";
        untracked = "? ";
        stashed = " ";
        modified = "! ";
        staged = "+$count ";
        renamed = "» ";
        deleted = "󰆳 ";
        style = "fg:flamingo bg:mantle";
        ignore_submodules = false;
        disabled = false;
      };

      cmd_duration = {
        min_time = 10000;
        show_milliseconds = false;
        format = "[](fg:crust bg:none)[]($style bg:crust)[](fg:crust bg:mantle)[ $duration]($style bg:mantle)[](fg:mantle bg:none) ";
        style = "fg:sapphire";
        disabled = false;
        show_notifications = false;
        min_time_to_notify = 60000;
      };
    };
  };

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      font-family = "JetBrainsMono NFM";
      font-size = 11;
      gtk-single-instance = true;
      window-inherit-working-directory = false;
      tab-inherit-working-directory = false;
      split-inherit-working-directory = false;
      cursor-style = "bar";
      cursor-style-blink = true;
      confirm-close-surface = false;
      window-decoration = false;
      window-padding-x = 0;
      window-padding-y = 0;
      mouse-scroll-multiplier = "precision:0.3";
      keybind = [
        "shift+enter=csi:13;2u"
        "ctrl+enter=csi:13;5u"
      ];
    };
  };

  programs.bottom = {
    enable = true;
    package = null;
    settings = {
      flags = {
        hide_table_gap = false;
        battery = true;
        show_table_scroll_position = true;
      };
      processes = {
        default_tree = true;
        process_command = false;
      };
      network_graph.interface_filter = {
        is_list_ignored = true;
        list = [ "lo" ];
        regex = true;
        case_sensitive = false;
        whole_word = false;
      };
    };
  };

  # zshenv environment variables
  home.sessionVariables = {
    PAGER = "nvim +Man!";
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";

    # starship
    STARSHIP_CONFIG = "${config.home.homeDirectory}/.cfg/starship.toml";
    STARSHIP_CACHE = "${config.home.homeDirectory}/etc/cache/starship/cache";

    # docker
    DOCKER_CONFIG = "${config.home.homeDirectory}/.cfg/docker";

    # go
    GOPATH = "${config.home.homeDirectory}/etc/data/go";

    # rust
    CARGO_HOME = "${config.home.homeDirectory}/etc/data/cargo";

    # R
    R_HOME_USER = "${config.home.homeDirectory}/.cfg/R/";
    R_PROFILE_USER = "${config.home.homeDirectory}/.cfg/R/profile.r";
    R_HISTFILE = "${config.home.homeDirectory}/.cfg/R/history";
    R_LIBS = "${config.home.homeDirectory}/etc/lib/R/library:$R_LIBS";

    # readline
    INPUTRC = "${config.home.homeDirectory}/.cfg/readline/inputrc";

    # jupyter
    JUPYTER_CONFIG_DIR = "${config.home.homeDirectory}/.cfg/jupyter";
    IPYTHONDIR = "${config.xdg.dataHome}/ipython";

    # texlive
    TEXMFVAR = "/tmp/texlive/texmf-var";

    # xdg user dirs
    XDG_DOWNLOAD_DIR = config.xdg.userDirs.download;
    XDG_DESKTOP_DIR = config.xdg.userDirs.desktop;
    XDG_DOCUMENTS_DIR = config.xdg.userDirs.documents;
    XDG_MUSIC_DIR = config.xdg.userDirs.music;
    XDG_PICTURES_DIR = config.xdg.userDirs.pictures;
    XDG_VIDEOS_DIR = config.xdg.userDirs.videos;
  };
}
