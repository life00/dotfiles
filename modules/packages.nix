{ pkgs, lib, ... }:
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "claude-code" ];

  # FIXME: remove pinned rev once swayfx updates
  # https://github.com/wlrfx/swayfx/issues/569
  # fixed in https://github.com/wlrfx/swayfx/commit/663cf66f92c2d4c99b9c2c4c79ce3538d37470ac
  # FIXME: remove patch once swayfx updates
  # https://github.com/wlrfx/swayfx/issues/565
  nixpkgs.overlays = [
    (final: prev: {
      swayfx-unwrapped = prev.swayfx-unwrapped.overrideAttrs (old: {
        src = final.fetchFromGitHub {
          owner = "wlrfx";
          repo = "swayfx";
          rev = "663cf66f92c2d4c99b9c2c4c79ce3538d37470ac";
          hash = "sha256-BYeQAEh47T02mBAModeIL4XNQKftfphN3I9segEb4CM=";
        };
        patches = old.patches ++ [ ../extra/swayfx/565-move-workspace-invisible.patch ];
      });
    })
  ];

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
    e2fsprogs
    cryptsetup
    duperemove
    lsof
    vim
    libargon2
    file
    curl
    git

    # shells
    zsh
    dash

    # WM
    swayfx
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
    options = "--delete-older-than 7d";
  };

  programs.nix-ld.enable = true;
}
