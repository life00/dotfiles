{ pkgs, lib, ... }:
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "claude-code" ];

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
    vim
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
    ly
  ];

  # nix settings
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  programs.nix-ld.enable = true;
}
