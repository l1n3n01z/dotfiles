{
  description = "Home Manager configuration of nonni";
  # Nonni, what does home-manager actually do?
  # it gets programs, puts them in the path and creates .config
  # pretty simple actually


  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    # Nonni: can we be more specific?
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      # Nonni: this is only available on nixos
      # useUserPackages = true;
    };
  #  nvim_flake.url = ~/flakes/nvim
  };
  # outputs = inputs@{ self, nixpkgs, home-manager, nixvim_flake, ... }:
  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations.nonni = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        # Nonni: why use input if we can do the module thing instead?
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
	extraSpecialArgs = { inherit inputs; };
      };
    };
}
