{ pkgs, lib, config, inputs, ... }: {
  # bat with Catppuccin Macchiato theme via catppuccin/nix
  programs.bat = {
    enable = true;
    theme = inputs.catppuccin.homeManagerModules.catppuccin;
  };

  # neovim — LazyVim config managed externally via dotfiles
  # HM installs neovim; dotfiles provide the actual config
  programs.neovim = {
    enable = true;
    # dotfiles are symlinked separately
  };
}