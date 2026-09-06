{
  inputs,
  lib,
  ...
}:
{
  # minimal network manager config
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd"; # apple silicon networking only works with iwd
    wifi.powersave = false;
    # FIXME:
    # randomize the wifi MAC on every connection
    connectionConfig = {
      "wifi.cloned-mac-address" = lib.mkForce "random";
      "wifi.scan-rand-mac-address" = "yes";
    };
  };

  networking.firewall = {
    enable = true;
    allowPing = false;
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
    # libvirtd virbr0 NAT needs traffic permitted or guest networking breaks
    trustedInterfaces = [ "virbr0" ];
  };

  # stevenblack hosts
  networking.hosts = lib.pipe (inputs.stevenblack-hosts.outPath + "/hosts") [
    builtins.readFile
    (lib.splitString "\n")
    (lib.filter (line: lib.hasPrefix "0.0.0.0 " line))
    (map (line: lib.substring 8 (lib.stringLength line - 8) line))
    (map (host: {
      "${host}" = [ "0.0.0.0" ];
    }))
    lib.mkMerge
  ];

  services.chrony = {
    enable = true;
    enableNTS = true;
  };

  services.resolved.enable = true;
}
