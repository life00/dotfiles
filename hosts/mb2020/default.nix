{ inputs, ... }:
{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./touchbar.nix
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

  networking.hostName = "mb2020";
  hardware.asahi.enable = true;

  homePermissions.enable = true;

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs; };
    users.user = import ../../home;
  };

  system.stateVersion = "26.05";
}
