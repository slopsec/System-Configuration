{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

      Jovian-NixOS = {
        url = "github:Jovian-Experiments/Jovian-NixOS";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      zen-browser = {
        url = "github:0xc000022070/zen-browser-flake/beta";
        inputs = {
          # IMPORTANT: To ensure compatibility with the latest Firefox version, use nixpkgs-unstable.
          nixpkgs.follows = "nixpkgs";
          home-manager.follows = "home-manager";
       };
    };
      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
       };
    };

 outputs = { self, nixpkgs, Jovian-NixOS, home-manager, zen-browser,  ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {

      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [
            ./configuration.nix
            inputs.home-manager.nixosModules.default
            inputs.Jovian-NixOS.nixosModules.default
          ];
        };

    };
}
