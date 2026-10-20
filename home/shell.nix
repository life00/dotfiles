{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch = {
      enable = true;
      searchUpKey = [ "^[[A" ];
      searchDownKey = [ "^[[B" ];
    };

    setOptions = [
      "interactive_comments"
      # /var/log/zsh is root-owned, write the histfile in place
      "no_hist_save_by_copy"
    ];

    completionInit = "autoload -U compinit && compinit -d ${config.xdg.cacheHome}/zcompdump";

    history = {
      path = "/var/log/zsh/histfile";
      size = 100000;
      save = 100000;
      extended = true;
      ignoreAllDups = true;
      expireDuplicatesFirst = true;
    };

    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      ai = "aichat";
      tree = "eza -T";
      cat = "bat";
      delta = "delta --pager less";
      diff = "delta";
      lf = "zlf";
      R = "R --quiet --no-save";
      nmpc = "ncmpcpp";
      lv = "nvim";
      mv = "mv -v";
      cp = "cp -v";
      rm = "rm -v";
      e = "exit";
      mpi = "mpv --pause";
      calc = "qalc";
      ef = "exiftool";
      todo = "rg '\\- \\[ \\] ' --sortr 'modified' --glob '*.md' '/home/user/doc/'";
    };

    # some ugly legacy zsh configs
    initContent = lib.mkMerge [
      (lib.mkBefore ''
        # init zsh-vi-mode at source time, so fzf's ^R/^T bindings load after it
        ZVM_INIT_MODE=sourcing
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

        # zsh-autosuggestions: zsh-vi-mode's A should accept the suggestion too
        ZSH_AUTOSUGGEST_ACCEPT_WIDGETS+=(zvm_append_eol)

        # zsh-history-substring-search: match like autosuggestions (prefix, case-sensitive)
        HISTORY_SUBSTRING_SEARCH_PREFIXED=1
        HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS=
        HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
        HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="fg=#494d64,bg=#c6a0f6"
        HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="fg=#494d64,bg=#ed8796"
      ''
      # after HM sources history-substring-search (mkOrder 1250)
      (lib.mkOrder 1300 ''
        bindkey -M vicmd 'k' history-substring-search-up
        bindkey -M vicmd 'j' history-substring-search-down
      '')
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
      name = "zsh-vi-mode";
      src = pkgs.zsh-vi-mode;
      file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
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
    options = [
      "--cmd"
      "cd"
    ];
  };

  programs.eza = {
    enable = true;
    icons = "always";
    git = true;
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
      # tab bar: terminal background, flat, narrow; the CSS shrinks it to a ~20px strip
      window-theme = "ghostty";
      gtk-toolbar-style = "flat";
      gtk-wide-tabs = false;
      gtk-custom-css = "${pkgs.writeText "ghostty-tabs.css" ''
        tabbar .box {
          padding: 0;
          box-shadow: none;
        }
        tabbar tabbox {
          min-height: 0;
          padding: 0;
        }
        tabbar tabbox > separator {
          margin: 4px 0;
        }
        tabbar tab {
          min-height: 0;
          padding: 2px 8px;
          border-radius: 0;
          font-family: "JetBrainsMono NFM";
          font-size: 12px;
          color: #8087a2;
        }
        tabbar tab,
        tabbar tab:hover,
        tabbar tab:active,
        tabbar tab:selected,
        tabbar tab:selected:hover,
        tabbar tab:selected:active {
          background: none;
        }
        tabbar tab:hover {
          color: #cad3f5;
        }
        tabbar tab:selected {
          color: #cad3f5;
          box-shadow: inset 0 -2px #7dc4e4;
        }
        tabbar tab button.image-button {
          min-width: 16px;
          min-height: 16px;
          -gtk-icon-size: 12px;
        }
      ''}";
      keybind = [
        "shift+enter=csi:13;2u"
        "ctrl+enter=csi:13;5u"
        # ctrl+space prefix: unbound or no-op second keys are typed as usual, closes need d d / x x
        "ctrl+space>t=new_tab"
        "performable:ctrl+space>]=next_tab"
        "performable:ctrl+space>[=previous_tab"
        "performable:ctrl+space>9=last_tab"
        "performable:ctrl+space>shift+h=move_tab:-1"
        "performable:ctrl+space>shift+l=move_tab:1"
        "ctrl+space>d>d=close_tab:this"
        "ctrl+space>,=prompt_tab_title"
        "ctrl+space>f=toggle_tab_overview"
        "ctrl+space>-=new_split:down"
        "ctrl+space>shift+\\=new_split:right"
        "performable:ctrl+space>h=goto_split:left"
        "performable:ctrl+space>j=goto_split:down"
        "performable:ctrl+space>k=goto_split:up"
        "performable:ctrl+space>l=goto_split:right"
        "performable:ctrl+space>m=toggle_split_zoom"
        "ctrl+space>x>x=close_surface"
        "ctrl+space>r=activate_key_table:resize"
        "resize/h=resize_split:left,20"
        "resize/j=resize_split:down,20"
        "resize/k=resize_split:up,20"
        "resize/l=resize_split:right,20"
        "resize/==equalize_splits"
        "resize/escape=deactivate_key_table"
        "resize/enter=deactivate_key_table"
        "resize/unconsumed:catch_all=deactivate_key_table"
      ]
      ++ map (n: "performable:ctrl+space>${toString n}=goto_tab:${toString n}") (lib.range 1 8)
      # alt+1..9 stay with nvim bufferline (<A-1..5>)
      ++ [ "alt+9=unbind" ]
      ++ lib.concatMap (n: [
        "alt+${toString n}=unbind"
        "alt+digit_${toString n}=unbind"
      ]) (lib.range 1 8);
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

    # omp
    PI_CONFIG_DIR = ".cfg/omp";
    PI_CONFIG_FILES = "${config.home.homeDirectory}/.cfg/omp/nix.yml";
    PONYTAIL_HIDE_STATUS = "1";

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
