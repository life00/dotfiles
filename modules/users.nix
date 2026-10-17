{
  lib,
  pkgs,
  config,
  ...
}:
let
  home = config.users.users.user.home;
  compatLinks = {
    ".config" = ".cfg";
    ".cache" = "etc/cache";
    ".local" = "etc";
    "etc/share" = "etc/data";
    ".icons" = "etc/data/icons";
    ".npm" = "etc/data/npm";
    ".jupyter" = "etc/data/jupyter";
    ".ssh" = ".cfg/ssh";
    ".omp" = ".cfg/omp";
    ".ollama" = "etc/data/ollama";
  };
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
        ".cfg/chromium"
        ".cfg/gh"
        ".cfg/nvim"
        ".cfg/omp"
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
    # home-manager runs compinit with a cached dump
    programs.zsh.enableGlobalCompInit = false;

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

          # compatibility symlink targets
          "d ${home}/etc/data/icons 0755 user user -"
          "d ${home}/etc/data/npm 0755 user user -"
          "d ${home}/etc/data/jupyter 0755 user user -"
          "d ${home}/etc/data/ollama 0700 user user -"
          "d ${home}/.cfg/ssh 0755 user user -"
          "d ${home}/.cfg/omp 0700 user user -"
          "d ${home}/etc/data/omp 0700 user user -"
          "d ${home}/etc/state/omp 0700 user user -"
          "d ${home}/etc/cache/omp 0700 user user -"
        ]
        (lib.mapAttrsToList (l: t: "L+ ${home}/${l} - - - - ${home}/${t}") compatLinks)
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

    # tmpfiles never chowns symlinks, so do it here
    system.activationScripts.homePermissions = lib.mkIf config.homePermissions.enable (
      lib.stringAfter [ "users" ] ''
        ${pkgs.systemd}/bin/systemd-tmpfiles --create --prefix=${home}
        chown -h root:root ${lib.concatMapStringsSep " " (l: "${home}/${l}") (lib.attrNames compatLinks)}
      ''
    );

    # let home-manager (runs as user) write into root-owned dirs
    systemd.services.home-manager-user.serviceConfig.AmbientCapabilities =
      lib.mkIf config.homePermissions.enable
        [ "CAP_DAC_OVERRIDE" ];
  };
}
