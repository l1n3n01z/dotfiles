{
  description = "Home Manager configuration of nonni";
  # Nonni, what does home-manager actually do?
  # it gets programs, puts them in the path and creates .config
  # pretty simple actually

  inputs = {
    nixpkgs-opencode.url = "github:nixos/nixpkgs/nixos-unstable";
    # Specify the source of Home Manager and Nixpkgs.
    # Nonni: can we be more specific?
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable/811c0af5f59b2d78e9344ef6a64c7a357214c417";
    # nixpkgs.url = "github:nixos/nixpkgs";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    opencode-src.url = "github:sst/opencode";
    # care-nvim.url = "github:max397574/care.nvim/800741c255939c0f345239662ec268557ac3eefa";
    # nvim.url = "github:nix-community/kickstart-nix.nvim";
    # nvim.url = "github:mrcjkb/nvim";
    tmux = {
      url = "path:./tmux-flake"; # Use `url` with `path` for a local flake
      inputs.nixpkgs.follows = "nixpkgs";
    };
    bugwarrior = {
      url = "path:./bugwarrior"; # Use `url` with `path` for a local flake
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      # Nonni: this is only available on nixos
      # useUserPackages = true;
    };
    #  nvim_flake.url = ~/flakes/nvim
  };
  # outputs = inputs@{ self, nixpkgs, home-manager, nixvim_flake, ... }:
  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      # care-nvim,
      tmux,
      bugwarrior,
      # nvim,
      ...
    }:
     let
       system = "x86_64-linux";
      # pkgs = nixpkgs.legacyPackages.${system};
      pkgs = (
        import nixpkgs {
          inherit system;
          config = {
            permittedInsecurePackages = [
              "dotnet-core-combined"
              "dotnet-sdk-6.0.428"
              "dotnet-sdk-7.0.410"
              "dotnet-sdk-wrapped-6.0.428"
              "dotnet-sdk-wrapped-7.0.410"
            ];
            # allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
            #  "1password-cli"
            # ];
          };
           overlays = [
             (final: prev: {
               opencode = inputs.opencode-src.packages.${system}.default;
             })
           ];
        }
      );
      # tmux = tmux.defaultPackage.${system};
      # bugwarrior = bugwarrior.defaultPackage.${system};

      # bugwarrior = pkgs.python312Packages.buildPythonPackage rec {
      # bugwarrior = pkgs.python3Packages.buildPythonPackage rec {
      #   pname = "bugwarrior";
      #   version = "1.8-develop"; # Optionally, you can specify a custom version here
      #
      #   src = pkgs.fetchFromGitHub {
      #     owner = "GothenburgBitFactory";
      #     repo = "bugwarrior";
      #     rev = "develop"; # Or specify a specific commit hash or tag
      #     sha256 = "sha256-kMNxA3Datbj5D4PHE1qdMXvBX5+HPtHEIc+P0r6f+Pg="; # Replace with the correct sha256 hash
      #   };
      #
      #   propagatedBuildInputs = with pkgs.python3Packages; [
      #     setuptools
      #     twiggy
      #     requests
      #     offtrac
      #     python-bugzilla
      #     taskw
      #     python-dateutil
      #     pytz
      #     keyring
      #     six
      #     jinja2
      #     pycurl
      #     dogpile-cache
      #     lockfile
      #     click
      #     pyxdg
      #     future
      #     jira
      #     pydantic
      #   ];
      #   # propagatedBuildInputs = with pkgs.python3Packages; [
      #   #   lockfile
      #   #   # Add other missing dependencies here if needed
      #   # ];
      #
      #   # Reuse all other dependencies and build steps from the nixpkgs definition
      #   meta = with pkgs.lib; {
      #     description = "A tool to help with building and testing packages for Nixpkgs";
      #     license = licenses.mit;
      #     platforms = platforms.linux;
      #   };
      # };

    in
    {
      homeConfigurations.nonni = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        # Nonni: why use input if we can do the module thing instead?
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit inputs;
          tmux-custom = tmux.defaultPackage.${system};
          bugwarrior = bugwarrior.defaultPackage.${system};
          # tmux-custom = tmux;
          # bugwarrior = bugwarrior;
        };
      };
    };
}
