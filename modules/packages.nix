{ pkgs, ... }:
{
  # ponytail: minimal-install — sway, zsh (user shell), opencode.
  # Everything else commented; restore the full lists when the full
  # setup is re-enabled.
  #
  # Sway is enabled via the NixOS `programs.sway` module below (sets up the
  # wayland session/systemd integration and installs `foot` as sway's default
  # terminal, so `$mod+Return` opens a terminal out of the box). The bare
  # `sway` package no longer needs to be listed in `environment.systemPackages`
  # because the module installs it.
  environment.systemPackages = with pkgs; [
    zsh
    opencode
  ];

  # Sway at the NixOS system level (verified in locked nixpkgs rev
  # 9fbb54...: `programs.sway` module exists with `enable`/`package`/
  # `wrapperFeatures`/`extraPackages`; `extraConfig` is NOT an option here,
  # so the sway config lives in /etc/sway/config or ~/.config/sway/config).
  # `extraPackages` defaults to [ brightnessctl foot grim pulseaudio
  # swayidle swaylock wmenu ] — `foot` gives sway a working terminal.
  programs.sway.enable = true;

  # texlive scheme for thesis + cyrillic
  # texlivePackages = pkgs.texlivePackages;
}