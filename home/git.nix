{ pkgs, lib, config, ... }: {
  programs.git = {
    enable = true;
    userName = "life00";
    userEmail = "contact.5lu1v@simplelogin.co";
    signing = {
      key = "${config.home.homeDirectory}/etc/sec/ssh/key-r0.sec";
      format = "ssh";
    };
    extraConfig = {
      gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/.cfg/ssh/allowed_signers";
      core.pager = "nvim +Man! -c 'set ft=git'";
      interactive.diffFilter = "delta --color-only";
      delta = {
        navigate = true;
        dark = true;
        blame-palette = "#24273a #1e2030 #181926 #363a4f #494d64";
        commit-decoration-style = "box ul";
        file-decoration-style = "#cad3f5";
        file-style = "#cad3f5";
        hunk-header-decoration-style = "box ul";
        hunk-header-file-style = "bold";
        hunk-header-line-number-style = "bold #a5adcb";
        hunk-header-style = "file line-number syntax";
        line-numbers-left-style = "#6e738d";
        line-numbers-minus-style = "bold #ed8796";
        line-numbers-plus-style = "bold #a6da95";
        line-numbers-right-style = "#6e738d";
        line-numbers-zero-style = "#6e738d";
        minus-emph-style = "bold syntax #563f51";
        minus-style = "syntax #383143";
        plus-emph-style = "bold syntax #455450";
        plus-style = "syntax #313943";
        "map-styles" = "bold purple => syntax #4d4569, bold blue => syntax #3e4868, bold cyan => syntax #3f5364, bold yellow => syntax #575253";
      };
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
    };
  };

  # ssh config (no keys — copy manually)
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host github github.com
        HostName github.com
        User git
        PreferredAuthentications publickey
        IdentityFile ${config.home.homeDirectory}/etc/sec/ssh/key-r0.sec
    '';
  };

  # allowed_signers (public keys only — no private keys)
  home.file.".cfg/ssh/allowed_signers".text = ''
    # me
    life00 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHvrvklEwdxbJIe5KUL4y6cRIwhpmwx06w76fy6x31/A

    # Inference
    inference ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILHPGnrIg7dI7GUqA+lTztJSrn+7QyRceajqs4iaU8UG
  '';
}
