{
  pkgs,
  lib,
  config,
  ...
}:
{
  # doas instead of sudo
  security.doas = {
    enable = true;
    wheelNeedsPassword = true;
  };
  security.sudo.enable = false;

  # swaylock auth
  security.pam.services.swaylock = { };

  # disable sshd
  services.openssh = {
    enable = false;
    openFirewall = false;
  };

  # rofi passphrase prompt whenever a display exists
  programs.ssh = {
    enableAskPassword = true;
    askPassword = "${pkgs.writeShellScript "ssh-askpass" ''
      case $1 in *"(yes/no"*) p= ;; *) p=-password ;; esac
      exec ${pkgs.rofi}/bin/rofi -dmenu $p -p "$1" </dev/null
    ''}";
  };
  environment.variables.SSH_ASKPASS_REQUIRE = "prefer";

  # USB device authorization
  services.usbguard = {
    enable = true;
    package = pkgs.usbguard;
    ruleFile = "/var/lib/usbguard/rules.conf";
    implicitPolicyTarget = "block";
    dbus.enable = true;
    IPCAllowedGroups = [ "wheel" ];
  };

  # application-level firewall
  services.opensnitch = {
    enable = true;
    package = pkgs.opensnitch;
    settings = {
      DefaultAction = "deny";
      InterceptUnknown = true;
    };
    # store paths change on every update, so pin them here instead of in the UI
    rules =
      let
        systemd = "${config.systemd.package}/lib/systemd";
      in
      lib.mapAttrs
        (name: path: {
          inherit name;
          enabled = true;
          action = "allow";
          duration = "always";
          operator = {
            type = "simple";
            sensitive = false;
            operand = "process.path";
            data = path;
          };
        })
        {
          chronyd = "${config.services.chrony.package}/bin/chronyd";
          systemd-resolved = "${systemd}/systemd-resolved";
          systemd-executor = "${systemd}/systemd-executor";
          nsncd = "${pkgs.nsncd}/bin/nsncd";
          networkmanager = "${config.networking.networkmanager.package}/bin/NetworkManager";
        };
  };

  # kernel hardening
  security.protectKernelImage = true;

  # stock-OpenSSL default CA file; non-nixpkgs builds (uv/pyenv/standalone pythons) expect it
  environment.etc."ssl/cert.pem".source = config.security.pki.caBundle;
}
