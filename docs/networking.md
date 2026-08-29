# Networking

Implemented in `modules/networking.nix`.

## NetworkManager

`networking.networkmanager.enable = true`. WiFi backend `iwlwifi`/`brcmfmac` depending on target NIC. `wifi.powerscan = false` prevents active scanning overrides.

## Firewall

`networking.firewall` is NixOS's netfilter/nftables front-end. All inbound dropped by default (`allowPing = false`, no tcp/udp opened). Equivalent to Fedora's `firewall-cmd --set-default-zone drop`.

## MAC randomization

`systemd.services.macchanger` runs at `multi-user.target`. Script: random MAC from `openssl rand -hex 6`, strip second char (local-admin bit), retry loop on `ip link set` failure. Interface is **placeholder `wlp1s0f0`** — change to the target NIC (`ip a`).

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
