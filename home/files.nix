{
  config,
  ...
}:
{
  # lf file manager
  home.file.".cfg/lf/lfrc".source = ../dotfiles/lf/lfrc;
  home.file.".cfg/lf/icons".source = ../dotfiles/lf/icons;
  home.file.".cfg/lf/preview.sh".source = ../dotfiles/lf/preview.sh;

  # nvim
  home.file.".cfg/nvim".source = ../dotfiles/nvim;

  # custom binaries
  home.file.".cfg/bin".source = ../dotfiles/bin;

  # rofi
  home.file.".cfg/rofi/config".source = ../dotfiles/rofi/config;

  # ncmpcpp
  home.file.".cfg/ncmpcpp/config".source = ../dotfiles/ncmpcpp/config;
  home.file.".cfg/ncmpcpp/bindings".source = ../dotfiles/ncmpcpp/bindings;

  # cava
  home.file.".cfg/cava/config".source = ../dotfiles/cava/config;

  # ssh
  home.file."${config.xdg.configHome}/ssh/allowed_signers".text = ''
    # me
    life00 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHvrvklEwdxbJIe5KUL4y6cRIwhpmwx06w76fy6x31/A
  '';

  # desktop entries
  xdg.dataFile."applications/neovim.desktop".source = ../dotfiles/neovim.desktop;
  xdg.dataFile."applications/lf.desktop".source = ../dotfiles/lf.desktop;
}
