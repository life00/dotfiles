{ pkgs, ... }:
{
  # system-scope packages only
  environment.systemPackages = with pkgs; [
    # daemons
    pipewire
    syncthing
    networkmanager
    opensnitch
    usbguard
    ollama
    firewalld

    # admin utils
    btrfs-progs
    cryptsetup
    duperemove
    lsof
    neovim
    libargon2
    file
    curl

    # shells
    zsh
    dash

    # WM
    sway
    swaylock
    swayidle
    regreet
  ];

  # nix settings
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.nix-ld.enable = true;
}
