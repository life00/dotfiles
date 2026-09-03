{
  pkgs,
  ...
}:
{
  users.users.user = {
    isNormalUser = true;
    uid = 1000;
    shell = pkgs.zsh;
    home = "/home/user";
    createHome = true;
    group = "user";
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "networkmanager"
      "libvirtd"
      "qemu-libvirtd"
    ];
    # placeholder password
    initialPassword = "password";
  };

  users.groups.user.gid = 1000;

  # zsh as default shell
  programs.zsh.enable = true;

  # root password locked
  users.users.root.hashedPassword = "!";

  # config links and history files
  systemd.tmpfiles.rules = [
    "L+ /home/user/.config - - - - /home/user/.cfg"
    "f /var/log/zsh/histfile 0666 user user -"
    "f /var/log/history.log 0666 root root -"
  ];

  # system-wide command logging to /var/log/history.log for zsh and bash
  programs.zsh.interactiveShellInit = ''
    precmd() {
      retrn=$?
      historylog="($(date +%s%N|cut -b1-10)) {$$} $(pwd) [$retrn] $(history -1 | sed 's/^[ ]*[0-9]\+[ ]*//')"
      echo "$historylog" >> /var/log/history.log
    }
  '';

  programs.bash = {
    enable = true;
    interactiveShellInit = ''
      if [[ $UID -eq 0 ]]; then
        PROMPT_COMMAND='historylog="($(date +%s%N|cut -b1-10)) {$$} $(pwd) [$?] $(fc -ln -1)"; echo "$historylog" >> /var/log/history.log'
      fi
    '';
  };
}
