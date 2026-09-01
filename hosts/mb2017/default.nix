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
  ];

  networking.hostName = "nixos";

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs; };
    users.user = import ../../home;
  };

  system.stateVersion = "26.05";
}
