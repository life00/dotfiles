{ pkgs, ... }:
{
  # System-scope packages only: daemons/infra the system services own, and the
  # root-admin tooling tied to systemd/hardware. Everything user-facing lives in
  # home/packages.nix (the complete explicit manifest).
  environment.systemPackages = with pkgs; [
    # daemons (also pulled by their service modules — explicit inventory)
    pipewire
    syncthing
    networkmanager
    opensnitch
    usbguard
    ollama # disabled service; kept for when it's enabled
    firewalld

    # hardware / storage / root admin
    btrfs-progs
    cryptsetup
    duperemove
    lsof
    libargon2
    file
    curl

    # shells
    zsh
    dash

    # WM stack (greetd launches sway; swaylock/swayidle pinned here per
    # home/desktop.nix — HM sets their packages to null)
    sway
    swaylock
    swayidle
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.nix-ld.enable = true;
}
