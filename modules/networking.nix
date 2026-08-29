{ inputs, lib, pkgs, ... }:
{
  # ponytail: minimal-install — bare NetworkManager only.
  # Commented below (restore for full setup): firewalld drop zone, MAC
  # randomization service, stevenblack/extra hosts, chrony, resolved.
  networking.networkmanager = {
    enable = true;
    wifi.powerscan = false;
    # # ponytail: MAC randomization — placeholder interface name, replace with target
    # connectionConfig = {
    #   "wifi.cloned-mac-address" = "random";
    # };
  };

  # networking.firewall = {
  #   enable = true;
  #   allowPing = false;
  #   allowedTCPPorts = [ ];
  #   allowedUDPPorts = [ ];
  # };

  # # MAC randomization service (placeholder interface name)
  # systemd.services.macchanger = {
  #   description = "Randomize MAC address on wifi interface";
  #   wantedBy = [ "multi-user.target" ];
  #   after = [ "NetworkManager.service" ];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     User = "root";
  #     ExecStart = pkgs.writeShellScript "macchanger" ''
  #       INTERFACE=wlp1s0f0 # placeholder
  #       false
  #       until [ $? = 0 ]; do
  #         ${pkgs.iproute2}/bin/ip link set "$INTERFACE" address \
  #           $(${pkgs.openssl}/bin/openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/./0/2; s/.$//')
  #       done
  #     '';
  #   };
  # };

  # networking.hosts = lib.pipe inputs.stevenblack-hosts.outPath [
  #   builtins.readFile
  #   (lib.splitString "\n")
  #   (lib.filter (line: lib.hasPrefix "0.0.0.0 " line))
  #   (map (line: lib.substring 8 (lib.stringLength line - 8) line))
  #   (map (host: { "${host}" = [ "0.0.0.0" ]; }))
  #   lib.mkMerge
  # ];

  # networking.extraHosts = ''
  #   # Brave Browser: prevent telemetry
  #   0.0.0.0 p3a.brave.com
  #   0.0.0.0 rewards.brave.com
  #   0.0.0.0 api.rewards.brave.com
  #   0.0.0.0 grant.rewards.brave.com
  #   0.0.0.0 variations.brave.com
  #   0.0.0.0 laptop-updates.brave.com
  #   0.0.0.0 static1.brave.com
  # '';

  # services.chrony = {
  #   enable = true;
  #   enableNTS = true;
  # };

  # services.resolved.enable = true;
}