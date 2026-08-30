{ pkgs, lib, config, inputs, ... }: {
  programs.zsh = {
    enable = true;
    # ponytail: `enableLsColors` was removed from home-manager's programs.zsh;
    # aliases force `eza --icons` anyway. Dropped.
    defaultKeymap = "viins";

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
      "....." = "cd../../../..";
      "......." = "cd ../../../..";
      "~" = "cd ~";
      "/" = "cd /";
      ls = "eza --icons";
      tree = "eza --icons -T";
      delta = "delta --pager less";
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
      cdi = "zi";
      calc = "qalc";
      ef = "exiftool";
      btop = "bottom";
      todo = "rg '\\- \\[ \\] ' --sortr 'modified' --glob '*.md' '/home/user/doc/'";
      td = "todo";
    };

    initExtraFirst = ''
      # system-wide command logging to /var/log/history.log
      precmd() {
        retrn=$?
        historylog="($(date +%s%N|cut -b1-10)) {$$} $(pwd) [$retrn] $(history -1 | sed 's/^[ ]*[0-9]\+[ ]*//')"
        echo "$historylog" >> /var/log/history.log
      }
    '';

    initExtra = ''
      # cheat.sh
      cht() {
        curl cheat.sh/"$@"
      }

      # lf: cd to last visited dir on quit (was provided by HM programs.lf,
      # which is disabled - lf config is a raw dotfile, see home/files.nix)
      zlf() {
        local last="$XDG_STATE_HOME/lf/lastdir"
        command lf -last-dir-path "$last" "$@"
        if [[ -s "$last" ]]; then
          cd "$(cat "$last")"
        fi
      }
    '';

    zsh-abbr = {
      enable = false;
    };
  };

  # zsh plugins via HM
  programs.zsh.plugins = [
    { name = "fzf-tab"; src = pkgs.zsh-fzf-tab; }
    { name = "zsh-autosuggestions"; src = pkgs.zsh-autosuggestions; }
    { name = "zsh-vi-mode"; src = pkgs.zsh-vi-mode; }
    { name = "zsh-history-substring-search"; src = pkgs.zsh-history-substring-search; }
    { name = "fast-syntax-highlighting"; src = pkgs.zsh-fast-syntax-highlighting; }
  ];

  # ponytail: oh-my-zsh `programs.oh-my-zsh` was removed from home-manager in
  # this revision (only `programs.oh-my-posh` remains). The git aliases it
  # provided are covered by shellAliases above, so the block is dropped.
  # # oh-my-zsh git plugin
  # programs.oh-my-zsh = {
  #   enable = true;
  #   plugins = [ "git" ];
  # };

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
        format = "[](fg:#181926 bg:none)$symbol[](fg:#181926 bg:none) ";
        success_symbol = "[󰠥](fg:#a6da95 bg:#181926)";
        error_symbol = "[󰠥](fg:#ed8796 bg:#181926)";
        vicmd_symbol = "[󰠥](fg:#8aadf4 bg:#181926)";
        disabled = false;
      };

      hostname = {
        ssh_only = true;
        trim_at = ".";
        format = "[](fg:#181926 bg:none)[󰍹](fg:#ee99a0 bg:#181926)[](fg:#181926 bg:#1e2030)[ $hostname]($style)[](fg:#1e2030 bg:none)";
        style = "fg:#ee99a0 bg:#1e2030";
        disabled = false;
      };

      username = {
        style_root = "fg:#ed8796";
        style_user = "fg:#eed49f";
        format = "[](fg:#181926 bg:none)[󰀉]($style bg:#181926)[](fg:#181926 bg:#1e2030)[ $user]($style bg:#1e2030)[](fg:#1e2030 bg:none)";
        show_always = false;
        disabled = false;
      };

      battery = {
        charging_symbol = "󰂄";
        discharging_symbol = "󰂃";
        format = "[](fg:#181926 bg:none)[$symbol]($style bg:#181926)[](fg:#181926 bg:#1e2030)[ $percentage]($style bg:#1e2030)[](fg:#1e2030 bg:none)";
        disabled = false;
        display = [
          { threshold = 10; style = "fg:#ed8796"; }
          { threshold = 20; style = "fg:#f5a97f"; }
        ];
      };

      directory = {
        truncation_length = 5;
        truncate_to_repo = false;
        format = "([](fg:#181926 bg:none)[$read_only]($read_only_style)[](fg:#181926 bg:none) )[](fg:#181926 bg:none)[](fg:#8bd5ca bg:#181926)[](fg:#181926 bg:#1e2030)[ $path]($style)[](fg:#1e2030 bg:none)";
        style = "fg:#8db5ca bg:#1e2030";
        disabled = false;
        read_only = "󰍁";
        read_only_style = "fg:#ed8796 bg:#181926";
        repo_root_style = "fg:#8aadf4 bg:#1e2030";
        home_symbol = "~";
        use_os_path_sep = true;
      };

      git_branch = {
        format = "[](fg:#181926 bg:none)[$symbol](fg:#c6a0f6 bg:#181926)[](fg:#181926 bg:#1e2030)[ $branch]($style)[](fg:#1e2030 bg:none) ";
        symbol = "";
        style = "fg:#c6a0f6 bg:#1e2030";
        disabled = false;
      };

      git_status = {
        format = "([](fg:#181926 bg:none)[󰊢](fg:#f0c6c6 bg:#181926)[](fg:#181926 bg:#1e2030)[ $all_status$ahead_behind]($style)[](fg:#1e2030 bg:none) )";
        conflicted = "= ";
        ahead = "";
        behind = "";
        diverged = "";
        up_to_date = "";
        untracked = "? ";
        stashed = " ";
        modified = "! ";
        staged = "+$count ";
        renamed = "» ";
        deleted = "󰆳 ";
        style = "fg:#f0c6c6 bg:#1e2030";
        disabled = false;
      };

      cmd_duration = {
        min_time = 10000;
        show_milliseconds = false;
        format = "[](fg:#181926 bg:none)[]($style bg:#181926)[](fg:#181926 bg:#1e2030)[ $duration]($style bg:#1e2030)[](fg:#1e2030 bg:none) ";
        style = "fg:#7dc4e4";
        disabled = false;
      };
    };
  };

  # zshenv environment variables (XDG, program paths, etc.)
  home.sessionVariables = {
    PAGER = "nvim +Man!";
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";

# ponytail: XDG_CONFIG/CACHE/DATA/STATE_HOME are set by the home-manager
    # `xdg` module (home/default.nix overrides them to ~/.cfg, ~/etc/cache,
    # ~/etc/data, ~/etc/state). They were re-defined here with trailing slashes
    # before, which conflicted. Now set here only the user dirs + PATH.
    XDG_DOCUMENTS_DIR = "${config.home.homeDirectory}/doc/";
    XDG_DOWNLOAD_DIR = "${config.home.homeDirectory}/tmp/";
    XDG_MUSIC_DIR = "${config.home.homeDirectory}/med/audio/";
    XDG_PICTURES_DIR = "${config.home.homeDirectory}/med/images/";
    XDG_VIDEOS_DIR = "${config.home.homeDirectory}/med/videos/";
    XDG_SHARE_HOME = "${config.home.homeDirectory}/etc/data/";

    PATH = "${config.home.homeDirectory}/.local/bin:${config.home.homeDirectory}/.bin:${config.home.homeDirectory}/etc/bin:$PATH";

    # GPU fixes
    MESA_GL_VERSION_OVERRIDE = "3.3";
    MESA_GLSL_VERSION_OVERRIDE = "330";

    # starship (config generated by home-manager programs.starship.settings
    # below — lives at ~/.cfg/starship.toml; keep STARSHIP_CONFIG in sync)
    STARSHIP_CONFIG = "${config.home.homeDirectory}/.cfg/starship.toml";
    STARSHIP_CACHE = "${config.home.homeDirectory}/etc/cache/starship/cache";

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

    # texlive
    TEXMFVAR = "/tmp/texlive/texmf-var";

    # ollama
    OLLAMA_MODELS = "/opt/user/ollama";

    # julia
    JULIA_DEPOT_PATH = "${config.home.homeDirectory}/etc/data/julia:$JULIA_DEPOT_PATH";
    JULIAUP_DEPOT_PATH = "${config.home.homeDirectory}/etc/data/julia";

    # fzf colors (Catppuccin Macchiato)
    FZF_DEFAULT_OPTS = " --color=bg+:#363A4F,bg:#24273A,spinner:#F4DBD6,hl:#ED8796 --color=fg:#CAD3F5,header:#ED8796,info:#C6A0F6,pointer:#F4DBD6 --color=marker:#B7BDF8,fg+:#CAD3F5,prompt:#C6A0F6,hl+:#ED8796 --color=selected-bg:#494D64 --color=border:#363A4F,label:#CAD3F5";
  };

  # bash history logging for root
  programs.bash = {
    enable = false;
  };
}
