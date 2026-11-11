{ ... }:
{
  # minimal network manager config
  networking.networkmanager = {
    enable = true;
    wifi.backend = "wpa_supplicant";
    wifi.powersave = false;
    # new random mac on every wifi activation
    wifi.macAddress = "random";
  };

  networking.firewall = {
    enable = true;
    allowPing = false;
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
    # syncthing, LAN sources only; service runs on demand
    extraInputRules = ''
      ip saddr { 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 } tcp dport 22000 accept
      ip saddr { 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 } udp dport { 22000, 21027 } accept
    '';
    # libvirtd virbr0 NAT needs traffic permitted or guest networking breaks
    trustedInterfaces = [ "virbr0" ];
  };

  networking.stevenblack.enable = true;

  services.chrony = {
    enable = true;
    enableNTS = true;
  };

  services.resolved.enable = true;
}
