{ pkgs, lib, config, inputs, ... }: {
  # bat with Catppuccin Macchiato theme (installed by home/theme.nix's
  # `catppuccin.bat.enable` — the old `theme = inputs.catppuccin...` line was
  # invalid; programs.bat.theme expects a theme *name* string)
  programs.bat = {
    enable = true;
  };

  # neovim — LazyVim config managed externally via dotfiles
  # HM installs neovim; dotfiles provide the actual config
  programs.neovim = {
    enable = true;
    # dotfiles are symlinked separately
  };
}