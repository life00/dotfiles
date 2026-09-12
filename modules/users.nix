{
  lib,
  pkgs,
  config,
  ...
}:
let
  home = config.users.users.user.home;
  hmDirs =
    let
      targets = map (f: f.target) (
        lib.filter (f: f.enable) (lib.attrValues config.home-manager.users.user.home.file)
      );
      ancestors =
        t:
        let
          d = dirOf t;
        in
        if d == "." then [ ] else [ d ] ++ ancestors d;
      excluded = d: lib.any (p: d == p || lib.hasPrefix "${p}/" d) config.homePermissions.exclude;
    in
    lib.filter (d: !excluded d) (lib.unique (lib.concatMap ancestors targets));
in
{
  options.homePermissions = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "root-owned home permission management";
    };
    exclude = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "etc/cache"
        "etc/data"
        "etc/state"
        ".cfg/ssh"
        ".cfg/claude"
        ".icons"
        ".ssh"
      ];
      description = "home-manager dirs (relative to home) left user-owned";
    };
  };

  config = {
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
        "docker"
      ];
      # placeholder password
      initialPassword = "password";
    };

    users.groups.user.gid = 1000;

    # zsh as default shell
    programs.zsh.enable = true;

    # root password locked
    users.users.root.hashedPassword = "!";

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

    # symlink everything under ~/.bin
    system.activationScripts.homeSetup = lib.stringAfter [ "users" ] ''
      mkdir -p /home/user/.bin
      # extra/bin
      for f in ${./../extra/bin}/*; do
        [ -e "$f" ] || continue
        ln -sfn "$f" "/home/user/.bin/$(basename "$f")"
      done
    '';

    # permission management
    systemd.tmpfiles.rules = (
      lib.mkMerge [
        [
          # history files
          "f /var/log/zsh/histfile 0666 user user -"
          "f /var/log/history.log 0666 root root -"

          # mount points
          "d /mnt 0755 root root -"
          "d /mnt/usb 0755 root root -"
          "d /mnt/cryptroot 0755 root root -"

          # compatibility symlinks
          # general
          "L+ ${config.users.users.user.home}/.config - - - - ${config.users.users.user.home}/.cfg"
          "L+ ${config.users.users.user.home}/.cache - - - - ${config.users.users.user.home}/etc/cache"
          "L+ ${config.users.users.user.home}/.local - - - - ${config.users.users.user.home}/etc"
          "L+ ${config.users.users.user.home}/etc/share - - - - ${config.users.users.user.home}/etc/data"
          # program specific
          "d ${config.users.users.user.home}/etc/data/icons 0755 user user -"
          "L+ ${config.users.users.user.home}/.icons - - - - ${config.users.users.user.home}/etc/data/icons"
          "d ${config.users.users.user.home}/etc/data/npm 0755 user user -"
          "L+ ${config.users.users.user.home}/.npm - - - - ${config.users.users.user.home}/etc/data/npm"
          "d ${config.users.users.user.home}/etc/data/jupyter 0755 user user -"
          "L+ ${config.users.users.user.home}/.jupyter - - - - ${config.users.users.user.home}/etc/data/jupyter"
          "d ${config.users.users.user.home}/.cfg/ssh 0755 user user -"
          "L+ ${config.users.users.user.home}/.ssh - - - - ${config.users.users.user.home}/.cfg/ssh"
        ]
        (lib.mkIf config.homePermissions.enable (
          [
            # top level directory ownership
            "d ${home} 0755 root root -"
            "d ${home}/.bin 0755 root root -"
            "d ${home}/dev 0755 root root -"
            "d ${home}/doc 0755 root root -"
            "d ${home}/med 0755 root root -"
            "d ${home}/tmp 0755 user user -"
          ]
          # every dir home-manager places files in
          ++ map (d: "d ${home}/${d} 0755 root root -") hmDirs
        ))
      ]
    );

    # re-apply as root so the compat symlinks aren't left user-owned
    system.activationScripts.homePermissions = lib.mkIf config.homePermissions.enable (
      lib.stringAfter [ "users" ] ''
        ${pkgs.systemd}/bin/systemd-tmpfiles --create --prefix=${config.users.users.user.home}
      ''
    );

    # let home-manager (runs as user) write into root-owned dirs
    systemd.services.home-manager-user.serviceConfig.AmbientCapabilities =
      lib.mkIf config.homePermissions.enable
        [ "CAP_DAC_OVERRIDE" ];
  };
}
