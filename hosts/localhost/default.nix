{ inputs, ... }: {
  imports = [
    ./hardware.nix
    ../../modules/boot.nix
    ../../modules/disko.nix
    ../../modules/filesystems.nix
    ../../modules/networking.nix
    ../../modules/security.nix
    ../../modules/users.nix
    ../../modules/locale.nix
    ../../modules/services.nix
    ../../modules/packages.nix
    ../../modules/fonts.nix
    ../../modules/greetd.nix
    ../../home/default.nix
  ];

  networking.hostName = "localhost";

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs; };
    users.user = import ../../home;
  };

  system.stateVersion = "25.05";
}
