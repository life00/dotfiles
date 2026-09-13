{ ... }:
{
  # minimal network manager config
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd"; # apple silicon networking only works with iwd
    wifi.powersave = false;
  };

  # MAC randomization is controlled by iwd
  networking.wireless.iwd.settings.General.AddressRandomization = "network";

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
