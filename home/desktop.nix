{ pkgs, lib, config, inputs, ... }: {
  # ponytail: home-manager dropped programs.sway / programs.swayidle /
  # programs.grim / programs.slurp / programs.wl-clipboard / programs.dunst in
  # this revision (only swaylock/rofi/waybar HM modules remain, unused here).
  # Everything is dotfile-driven instead (see repo convention): raw configs in
  # dotfiles/ are symlinked below, sway's own dotfile launches the daemons
  # (swayidle, dunst, nm-applet) and `bar { swaybar_command waybar }` starts
  # waybar.

  # packages whose config is NOT a raw dotfile (or that just install a binary)
  home.packages = with pkgs; [
    swayidle # launched by dotfiles/sway/config
    swaylock # used by swayidle/bindgesture; config from dotfiles/
    waybar # started via sway's `bar { swaybar_command waybar }`
    dunst # launched by dotfiles/sway/config; config from dotfiles/
    grim
    slurp
    wl-clipboard
    networkmanagerapplet # `exec nm-applet --indicator` in dotfiles/sway/config
    xdg-desktop-portal-wlr
  ];

  # desktop dotfiles (sway, waybar, rofi, dunst, swaylock) — referenced, not
  # inlined. sway launches itself at login via greetd; config is here.
  home.file = {
    ".cfg/sway/config".source = ../dotfiles/sway/config;
    ".cfg/sway/wallpapers".source = ../dotfiles/sway/wallpapers;
    ".cfg/waybar/config".source = ../dotfiles/waybar/config;
    ".cfg/waybar/style.css".source = ../dotfiles/waybar/style.css;
    ".cfg/rofi/config".source = ../dotfiles/rofi/config;
    ".cfg/rofi/config.rasi".source = ../dotfiles/rofi/config.rasi;
    ".cfg/rofi/catppuccin-macchiato.rasi".source = ../dotfiles/rofi/catppuccin-macchiato.rasi;
    ".cfg/rofi/bin".source = ../dotfiles/rofi/bin;
    ".cfg/dunst/dunstrc".source = ../dotfiles/dunst/dunstrc;
    ".cfg/swaylock/config".source = ../dotfiles/swaylock/config;
  };

  # XDG desktop portal (wlroots) for screen sharing / portal requests on sway.
  # D-Bus and xdg-desktop-portal normally activate the wlr backend, but we pin
  # the unit so it is available even before the wlr backend D-Bus name exists.
  systemd.user.services.xdg-desktop-portal-wlr = {
    Unit.Description = "XDG desktop portal for wlroots (sway)";
    Service = {
      ExecStart = "${pkgs.xdg-desktop-portal-wlr}/bin/xdg-desktop-portal-wlr";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "default.target" ];
  };
}