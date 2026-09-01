{
  pkgs,
  lib,
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
    path = with pkgs; [ bash ];
    serviceConfig = {
      ExecStart = "${awecron}/bin/awecron";
      User = "root";
      Type = "simple";
      Restart = "always";
    };
  };

  # symlink awecron config to /etc/awecron/
  system.activationScripts.awecron = lib.stringAfter [ "users" ] ''
    cfgsrc="${./../dotfiles/awecron}"
    mkdir -p /etc/awecron
    ln -sfn "$cfgsrc/cfg" /etc/awecron/cfg
    for d in "$cfgsrc"/*/; do
      name=$(basename "$d")
      [ -d "$d" ] || continue
      mkdir -p "/etc/awecron/$name"
      ln -sfn "$d/cfg" "/etc/awecron/$name/cfg"
      ln -sfn "$d/run" "/etc/awecron/$name/run"
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
    configDir = "/home/user/.cfg/syncthing";
    # devices/folders added via UI
    overrideDevices = false;
    overrideFolders = false;
    openDefaultPorts = true;
    guiAddress = "127.0.0.1:8384";
  };

  # disabled by default
  services.ollama = {
    enable = lib.mkForce false;
    models = "/opt/user/ollama";
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
