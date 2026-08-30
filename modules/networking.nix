{ inputs, lib, pkgs, ... }:
{
  # ponytail: minimal-install — bare NetworkManager only.
  # Commented below (restore for full setup): firewalld drop zone, MAC
  # randomization service, stevenblack/extra hosts, chrony, resolved.
  networking.networkmanager = {
    enable = true;
    # disable active-scan power saving overrides (wlp2s0 on this host)
    wifi.powersave = false;
    # randomize the wifi MAC on every connection (native NM, no systemd
    # macchanger hack needed). Randomization is per-connection below.
    connectionConfig = {
      "wifi.cloned-mac-address" = lib.mkForce "random"; # nixpkgs default is "preserve"
      "wifi.scan-rand-mac-address" = "yes";
    };
  };

  networking.firewall = {
    enable = true;
    allowPing = false;
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
    # libvirtd's virbr0 NAT needs traffic permitted or guest networking breaks.
    trustedInterfaces = [ "virbr0" ];
  };

  # # MAC randomization is handled natively by NetworkManager
  # # `connectionConfig."wifi.cloned-mac-address" = "random"` above — the
  # # old systemd.service.macchanger (placeholder iface wlp1s0f0 + a broken
  # # `until` loop with a bare `false`) was removed in favour of it.

  networking.hosts = lib.pipe (inputs.stevenblack-hosts.outPath + "/hosts") [
    builtins.readFile
    (lib.splitString "\n")
    (lib.filter (line: lib.hasPrefix "0.0.0.0 " line))
    (map (line: lib.substring 8 (lib.stringLength line - 8) line))
    (map (host: { "${host}" = [ "0.0.0.0" ]; }))
    lib.mkMerge
  ];

  networking.extraHosts = ''
    # Brave Browser: prevent telemetry
    0.0.0.0 p3a.brave.com
    0.0.0.0 rewards.brave.com
    0.0.0.0 api.rewards.brave.com
    0.0.0.0 grant.rewards.brave.com
    0.0.0.0 variations.brave.com
    0.0.0.0 laptop-updates.brave.com
    0.0.0.0 static1.brave.com
  '';

  services.chrony = {
    enable = true;
    enableNTS = true;
  };

  services.resolved.enable = true;
}