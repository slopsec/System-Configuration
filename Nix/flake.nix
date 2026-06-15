{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

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

 outputs = { self, nixpkgs, home-manager, zen-browser,  ... }@inputs:
    let
      system = "x86_64-linux";
      username = "saorsa";
      pkgs = import nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; };

    in
    {

      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {inherit inputs;};
          modules = [
            ./home.nix
            inputs.zen-browser.homeModules.beta
          ];
        };

    };
}
