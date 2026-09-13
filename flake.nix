{
  description = "My custom NixOS configuration with Cattpuccin for macbook pro M1 2020";

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
    apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      disko,
      catppuccin,
      apple-silicon,
      ...
    }@inputs:
    {
      nixosConfigurations.mb2017 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          catppuccin.nixosModules.catppuccin
          ./hosts/mb2017
        ];
      };
      nixosConfigurations.mb2020 = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          apple-silicon.nixosModules.apple-silicon-support
          home-manager.nixosModules.home-manager
          catppuccin.nixosModules.catppuccin
          ./hosts/mb2020
        ];
      };
    };
}
