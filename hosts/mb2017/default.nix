{ inputs, ... }: {
  imports = [
    ./hardware.nix
    ../../modules/boot.nix
    ../../modules/disko.nix
    ../../modules/filesystems.nix # btrfs scrub/fstrim/snsh dirs
    ../../modules/networking.nix
    ../../modules/security.nix
    ../../modules/users.nix
    ../../modules/locale.nix
    # ../../modules/services.nix # awecron (fakeHash pkg) + libvirtd
    ../../modules/packages.nix
    # ../../modules/fonts.nix
    ../../modules/greetd.nix
    # ponytail: minimal-install — home/default.nix is wired in below via
    # `home-manager.users.user`; importing it here at the system level
    # breaks the build ("option 'home' does not exist"). Restore only if
    # the home-manager wiring below is removed.
    # ../../home/default.nix
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
