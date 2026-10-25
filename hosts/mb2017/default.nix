{ inputs, lib, ... }:
{
  imports = [
    ./hardware.nix
    ./boot.nix
    ./disko.nix
    ../../modules/filesystems.nix
    ../../modules/networking.nix
    ../../modules/security.nix
    ../../modules/users.nix
    ../../modules/locale.nix
    ../../modules/services.nix
    ../../modules/packages.nix
    ../../modules/theme.nix
    ../../modules/browsing.nix
  ];

  networking.hostName = "mb2017";

  services.ollama.enable = lib.mkForce false;
  # theme.txt forces Unifont 16, which would override boot.nix's large font
  catppuccin.grub.enable = false;

  # battery job reads Apple Silicon's macsmc-battery
  system.activationScripts.awecron-mb2017 = lib.stringAfter [ "awecron" ] ''
    rm -rf /etc/awecron/battery
  '';

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs; };
    users.user.imports = [
      ../../home
      ./home.nix
    ];
  };

  system.stateVersion = "26.05";
}
