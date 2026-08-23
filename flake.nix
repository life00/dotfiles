{
  description = "NixOS configuration replicating Fedora Asahi setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stevenblack-hosts = {
      url = "github:StevenBlack/hosts";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, disko, catppuccin, stevenblack-hosts, ... }@inputs: {
    nixosConfigurations.localhost = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        disko.nixosModules.disko
        home-manager.nixosModules.home-manager
        catppuccin.nixosModules.catppuccin
        ./hosts/localhost
      ];
    };
  };
}
