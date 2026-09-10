{
  config,
  ...
}:
{
  # lf file manager
  home.file.".cfg/lf/lfrc".source = ../extra/lf/lfrc;
  home.file.".cfg/lf/icons".source = ../extra/lf/icons;
  home.file.".cfg/lf/preview.sh".source = ../extra/lf/preview.sh;

  # nvim
  home.file.".cfg/nvim".source = ../extra/nvim;

  # custom binaries
  home.file.".cfg/bin".source = ../extra/bin;

  # cava
  home.file.".cfg/cava/config".source = ../extra/cava/config;

  # ssh
  home.file."${config.xdg.configHome}/ssh/allowed_signers".text = ''
    # me
    life00 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHvrvklEwdxbJIe5KUL4y6cRIwhpmwx06w76fy6x31/A
  '';

  # desktop entries
  xdg.dataFile."applications/neovim.desktop".source = ../extra/neovim.desktop;
  xdg.dataFile."applications/lf.desktop".source = ../extra/lf.desktop;
}
