{ pkgs, lib, config, inputs, ... }:
let
  awecron = pkgs.callPackage ../pkgs/awecron { };
in
{
  # custom cron daemon
  systemd.services.awecron = {
    description = "Awecron cron daemon";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${awecron}/bin/awecron";
      User = "root";
      Type = "simple";
      Restart = "always";
    };
    # awecron looks up config in $XDG_CONFIG_HOME/awecron (os.UserConfigDir)
    # then /etc/awecron. The daemon runs as root and must land on the
    # home-manager-symlinked ~/.cfg/awecron (dotfiles/awecron), so pin
    # XDG_CONFIG_HOME to the user's XDG_CONFIG_HOME (~/.cfg via home/default.nix).
    environment.XDG_CONFIG_HOME = "/home/user/.cfg";
  };

  # music daemon (user service)
  services.mpd = {
    enable = false; # ponytail: enabled per-user via home-manager
  };

  # pipewire sound server (defaults: wireplumber + pipewire-pulse).
  services.pipewire = {
    enable = true;
  };

  services.syncthing = {
    enable = true;
    user = "user";
    dataDir = "/home/user";
    configDir = "/home/user/.cfg/syncthing";
    overrideDevices = false; # keep devices/folders added via Web UI (declarative list unused)
    overrideFolders = false;
    openDefaultPorts = true; # tcp 22000 + udp 21027 for NAT traversal
    guiAddress = "127.0.0.1:8384";
  };

  # ollama (disabled by default — enable + pull models when ready)
  services.ollama = {
    enable = lib.mkForce false;
    # acceleration = false;
    # models = "/opt/user/ollama";
    # user = "user";
    # group = "user";
  };

  # virtualization
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
    };
  };

  # chrony is in networking.nix
}
