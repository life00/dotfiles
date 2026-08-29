{ pkgs, ... }:
{
  # ponytail: minimal-install — sway (belt-and-braces with HM),
  # zsh (user shell), opencode. Everything else commented; restore
  # the full lists when the full setup is re-enabled.
  environment.systemPackages = with pkgs; [
    sway
    zsh
    opencode
  ];

  # texlive scheme for thesis + cyrillic
  # texlivePackages = pkgs.texlivePackages;
}