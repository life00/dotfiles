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
    # scripts require bash
    path = with pkgs; [
      bash
      dash
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

  services.pipewire = {
    enable = true;
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
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd sway";
        user = "greeter";
      };
    };
  };
}
