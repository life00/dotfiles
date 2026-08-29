# Alacritty — config is the raw dotfile (self-contained Catppuccin
# Macchiato palette + JetBrainsMono Nerd Font + cursor + keybindings),
# symlinked below. ponytail: HM's `programs.alacritty` rewrites
# ~/.cfg/alacritty/alacritty.toml itself and has no option to sync a file,
# so the module is DISABLED — the package is installed via
# home/packages.nix and the theme is a symlink into dotfiles/.
{ pkgs, lib, config, inputs, ... }: {
  home.file.".cfg/alacritty/alacritty.toml".source = ../dotfiles/alacritty/alacritty.toml;
}