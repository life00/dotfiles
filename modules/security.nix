{ lib, pkgs, ... }:
{
  # ponytail: minimal-install — doas only (root locked, login via user).
  # Commented below (restore for full setup): sshd disabled is default,
  # usbguard, opensnitch, kernel image protection.
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

  # # USB device authorization
  # services.usbguard = {
  #   enable = true;
  #   package = pkgs.usbguard;
  #   rules = ''
  #     allow
  #   '';
  # };

  # # application-level firewall
  # services.opensnitch = {
  #   enable = true;
  #   package = pkgs.opensnitch;
  # };

  # # kernel hardening
  # security.protectKernelImage = true;
}