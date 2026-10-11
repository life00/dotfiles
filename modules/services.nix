{
  pkgs,
  lib,
  config,
  ...
}:
let
  awecron = pkgs.callPackage ../pkgs/awecron { };
in
{
  # awecron cron daemon
  systemd.services.awecron = {
    description = "Awecron cron daemon";
    wantedBy = [ "multi-user.target" ];
    # jobs need the system tools (btrfs, hostname, nix, ...); notify-send is user-profile only
    path = [
      "/run/current-system/sw"
      pkgs.libnotify
    ];
    serviceConfig = {
      ExecStart = "${awecron}/bin/awecron";
      User = "root";
      Type = "simple";
      Restart = "always";
    };
  };

  # symlink awecron config to /etc/awecron/
  system.activationScripts.awecron = lib.stringAfter [ "users" ] ''
    cfgsrc="${./../extra/awecron}"
    mkdir -p /etc/awecron
    for f in "$cfgsrc"/*; do
      [ -f "$f" ] && ln -sfn "$f" "/etc/awecron/$(basename "$f")"
    done
    for d in "$cfgsrc"/*/; do
      [ -d "$d" ] || continue
      name=$(basename "$d")
      mkdir -p "/etc/awecron/$name"
      for f in "$d"/*; do
        [ -f "$f" ] && ln -sfn "$f" "/etc/awecron/$name/$(basename "$f")"
      done
    done
  '';

  # chromium reads battery presence/level from upower over dbus
  services.upower = {
    enable = true;
    criticalPowerAction = "PowerOff";
  };

  services.pipewire = {
    enable = true;
  };

  # wireplumber hangs at shutdown
  systemd.user.services.wireplumber.serviceConfig.TimeoutStopSec = "5s";

  xdg.portal = {
    enable = true;
    wlr = {
      enable = true;
      settings.screencast = {
        chooser_type = "dmenu";
        chooser_cmd = "${pkgs.rofi}/bin/rofi -dmenu -p 'Select a source to share:'";
      };
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-termfilechooser
    ];
    config.common = {
      default = [ "gtk" ];
      "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
      "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
      "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
    };
  };

  # disabled by default
  services.syncthing = {
    enable = false;
    user = "user";
    dataDir = "/home/user";
    configDir = "${config.xdg.configHome}/syncthing";
    # devices/folders added via UI
    overrideDevices = false;
    overrideFolders = false;
    openDefaultPorts = true;
    guiAddress = "127.0.0.1:8384";
  };

  # disabled by default
  services.ollama = {
    enable = lib.mkForce false;
    modelsDir = "/opt/user/ollama";
    user = "user";
    group = "user";
  };

  # virtualization
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
    # containerd content store seals blobs with fs-verity, which reads back as
    # zeros on btrfs subpage mode (4k sectorsize under 16k pages)
    daemon.settings.features."containerd-snapshotter" = false;
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
    };
  };

  # fix qemu hypervisor issue
  systemd.tmpfiles.rules = [
    "L+ /usr/bin/qemu-system-x86_64 - - - - ${pkgs.qemu_kvm}/bin/qemu-system-x86_64"
  ];

  # login manager
  services.displayManager = {
    sessionPackages = [ pkgs.swayfx ];
    ly = {
      enable = true;
      x11Support = false;
      settings = {
        full_color = false;
        animation = "matrix";
        cmatrix_fg = 3;
        cmatrix_head_col = 16777224;
        bg = 0;
        fg = 8;
        border_fg = 5;
        error_fg = 16777218;
        bigclock = "en";
        clock = "%a %d %b  %H:%M";
        hide_version_string = true;
        session_log = "etc/state/ly-session.log";
      };
    };
  };
}
