{ pkgs, ... }:
{
  # doas instead of sudo
  security.doas = {
    enable = true;
    wheelNeedsPassword = true;
    # passwordless nix commands (temporary)
    extraRules = [
      {
        users = [ "user" ];
        cmd = "nix";
        args = [
          "store"
          "gc"
        ];
        noPass = true;
      }
      {
        users = [ "user" ];
        cmd = "nixos-rebuild";
        noPass = true;
      }
    ];
  };
  security.sudo.enable = false;

  # swaylock auth
  security.pam.services.swaylock = { };

  # disable sshd
  services.openssh = {
    enable = false;
    openFirewall = false;
  };

  # USB device authorization
  services.usbguard = {
    enable = true;
    package = pkgs.usbguard;
    rules = ''
      allow
    '';
  };

  # application-level firewall
  services.opensnitch = {
    enable = true;
    package = pkgs.opensnitch;
    settings = {
      DefaultAction = "deny";
      InterceptUnknown = true;
    };
  };

  # kernel hardening
  security.protectKernelImage = true;
}
