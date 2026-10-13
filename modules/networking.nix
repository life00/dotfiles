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
