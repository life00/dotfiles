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
  };

  # music daemon (user service)
  services.mpd = {
    enable = false; # ponytail: enabled per-user via home-manager
  };

  # syncthing (disabled by default — enable + configure when ready)
  services.syncthing = {
    enable = lib.mkForce false;
    # openDefaultPorts = true;
    # user = "user";
    # dataDir = "/home/user";
    # configDir = "/home/user/.cfg/syncthing";
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
