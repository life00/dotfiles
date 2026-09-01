{
  config,
  ...
}:
{
  # delta binary used by interactive.diffFilter
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
      gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/.cfg/ssh/allowed_signers";
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

  # ssh config (no keys — copy manually)
  # ponytail: enableDefaultConfig=false; the former ssh-module defaults are
  # reproduced explicitly in settings."*" below.
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        ForwardAgent = false;
        AddKeysToAgent = "no";
        Compression = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts = false;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
      };
      "github github.com" = {
        HostName = "github.com";
        User = "git";
        PreferredAuthentications = "publickey";
        IdentityFile = "${config.home.homeDirectory}/etc/sec/ssh/key-r0.sec";
      };
    };
  };

  # allowed_signers (public keys only — no private keys)
  home.file.".cfg/ssh/allowed_signers".text = ''
    # me
    life00 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHvrvklEwdxbJIe5KUL4y6cRIwhpmwx06w76fy6x31/A
  '';
}
