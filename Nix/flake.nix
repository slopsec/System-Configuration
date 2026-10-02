{
  description = "Home Manager configuration of saorsa";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

      zen-browser = {
        url = "github:youwen5/zen-browser-flake";
        inputs = {
          # IMPORTANT: To ensure compatibility with the latest Firefox version, use nixpkgs-unstable.
          nixpkgs.follows = "nixpkgs";
       };
    };
      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
       };
    };

  outputs =
    { self, nixpkgs, home-manager, zen-browser,  ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in
    {
      homeConfigurations."saorsa" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs;};
        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
