{ inputs, ... }: {
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
    ../../modules/fonts.nix
    ../../modules/browsing.nix
  ];

  networking.hostName = "mb2017";

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs; };
    users.user = import ../../home;
  };

  system.stateVersion = "26.05";
}
