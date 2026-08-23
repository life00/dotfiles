{ lib, pkgs, ... }:
{
  # doas instead of sudo
  security.doas = {
    enable = true;
    wheelNeedsPassword = true;
    extraRules = [
      {
        users = [ "user" ];
        cmd = "nix";
        args = [ "store" "gc" ];
        noPass = true;
      }
    ];
  };
  security.sudo.enable = false;

  # disable sshd (as in Fedora setup)
  services.openssh = {
    enable = false;
    openFirewall = false;
  };

  # USB device authorization
  services.usbguard = {
    enable = true;
    package = pkgs.usbguard;
    rules = ''
      # ponytail: generated on first run — replace with target device rules
      # Run: sudo usbguard generate-policy > /etc/usbguard/rules.conf
      allow
    '';
  };

  # application-level firewall
  services.opensnitch = {
    enable = true;
    package = pkgs.opensnitch;
  };

  # kernel hardening
  security.protectKernelImage = true;
}
