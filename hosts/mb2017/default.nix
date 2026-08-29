{ inputs, ... }: {
  imports = [
    ./hardware.nix
    ../../modules/boot.nix
    ../../modules/disko.nix
    # ponytail: minimal-install — restore when full setup wanted
    # ../../modules/filesystems.nix # btrfs scrub/fstrim/snsh dirs
    ../../modules/networking.nix
    ../../modules/security.nix
    ../../modules/users.nix
    ../../modules/locale.nix
    # ../../modules/services.nix # awecron (fakeHash pkg) + libvirtd
    ../../modules/packages.nix
    # ../../modules/fonts.nix
    ../../modules/greetd.nix
    ../../home/default.nix
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
