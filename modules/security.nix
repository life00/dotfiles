{ lib, pkgs, ... }:
{
  # ponytail: doas only (root locked, login via user). sshd disabled is
  # default; usbguard, opensnitch and kernel image protection are enabled
  # below.
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
      # passwordless `nixos-rebuild` so the release/config workflow can run
      # rebuilds without a password prompt
      {
        users = [ "user" ];
        cmd = "nixos-rebuild";
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
      allow
    '';
  };

  # application-level firewall (monitor mode: upstream default-config.json
  # ships DefaultAction=allow + InterceptUnknown=false, so nothing is blocked
  # until per-app rules are approved from opensnitch-ui)
  services.opensnitch = {
    enable = true;
    package = pkgs.opensnitch;
  };

  # kernel hardening. ponytail: this nixpkgs rev implements it as
  # `nohibernate` + `kernel.kexec_load_disabled` (see nixos/modules/security/
  # misc.nix) — milder than "refuse unsigned modules" that older docs claimed.
  security.protectKernelImage = true;
}