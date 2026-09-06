# Networking

Implemented in `modules/networking.nix`.

## NetworkManager

`networking.networkmanager.enable = true`. WiFi backend `brcmfmac` on this host (`wlp2s0`). `wifi.powersave = false` (see MAC randomization below).

## Firewall

`networking.firewall` is NixOS's netfilter/nftables front-end. All inbound dropped by default (`allowPing = false`, no tcp/udp opened). Equivalent to Fedora's `firewall-cmd --set-default-zone drop`.

## MAC randomization

Handled by iwd (the `wifi.backend = "iwd"` makes NetworkManager delegate Wi-Fi control to iwd, so NM's `connectionConfig."wifi.cloned-mac-address"` is inert here): `networking.wireless.iwd.settings.General.AddressRandomization = "network"` writes `/etc/iwd/main.conf`, giving a stable randomized MAC per SSID that differs across networks. Interface on this host: `wlan0`, brcmfmac.

## Hosts

`networking.hosts` merges: (1) StevenBlack hosts (`fakenews + gambling + porn`, ~260 k hosts) fetched via the `stevenblack-hosts` flake input (non-flake, `outPath`), and (2) explicit Brave telemetry blocks in `networking.extraHosts`:

```
0.0.0.0 p3a.brave.com rewards.brave.com api.rewards.brave.com ...
```

Fetching ~260 k host lines at every build is heavy; `stevenblack-hosts` is pinned by git, so the closure is reproducible and only re-downloaded when the input rev changes.

## Time sync

`services.chrony.enable = true`, NTS enabled.

## DNS

`services.resolved.enable = true` (systemd-resolved).
