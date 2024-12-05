{
  description = "Home Manager configuration of nonni";
  # Nonni, what does home-manager actually do?
  # it gets programs, puts them in the path and creates .config
  # pretty simple actually

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    # Nonni: can we be more specific?
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable/811c0af5f59b2d78e9344ef6a64c7a357214c417";
    # nixpkgs.url = "github:nixos/nixpkgs";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    care-nvim.url = "github:max397574/care.nvim/800741c255939c0f345239662ec268557ac3eefa";
    # nvim.url = "github:nix-community/kickstart-nix.nvim";
    # nvim.url = "github:mrcjkb/nvim";
    tmux-custom.url = "path:./tmux-flake"; # Use `url` with `path` for a local flake
    tmux-custom.inputs.nixpkgs.follows = "nixpkgs";
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
      care-nvim,
      tmux-custom,
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
          };
        }
      );
      tmux = tmux-custom.defaultPackage.${system};
      # customTmux = tmux-custom.packages.${system}.tmux;
      # tmux-custom = pkgs.tmux.overrideAttrs (oldAttrs: rec {
      #   version = "3.6-99790c9";
      #   # version = "your-desired-version";
      #
      #   src = pkgs.fetchFromGitHub {
      #     owner = "tmux";
      #     repo = "tmux";
      #     rev = "99790c90aa95152cef011b7339be34d8536e99a9"; # master since dec 4
      #     sha256 = "sha256-vh1NzHdfmXCP3eHPEXZIp5lFiNwRztjq/VKNVDoyAnw="; # Replace with actual hash
      #   };
      # });

      # bugwarrior = pkgs.python312Packages.buildPythonPackage rec {
      bugwarrior = pkgs.python3Packages.buildPythonPackage rec {
        pname = "bugwarrior";
        version = "1.8-develop"; # Optionally, you can specify a custom version here

        src = pkgs.fetchFromGitHub {
          owner = "GothenburgBitFactory";
          repo = "bugwarrior";
          rev = "develop"; # Or specify a specific commit hash or tag
          sha256 = "sha256-kMNxA3Datbj5D4PHE1qdMXvBX5+HPtHEIc+P0r6f+Pg="; # Replace with the correct sha256 hash
        };

        propagatedBuildInputs = with pkgs.python3Packages; [
          setuptools
          twiggy
          requests
          offtrac
          python-bugzilla
          taskw
          python-dateutil
          pytz
          keyring
          six
          jinja2
          pycurl
          dogpile-cache
          lockfile
          click
          pyxdg
          future
          jira
          pydantic
        ];
        # propagatedBuildInputs = with pkgs.python3Packages; [
        #   lockfile
        #   # Add other missing dependencies here if needed
        # ];

        # Reuse all other dependencies and build steps from the nixpkgs definition
        meta = with pkgs.lib; {
          description = "A tool to help with building and testing packages for Nixpkgs";
          license = licenses.mit;
          platforms = platforms.linux;
        };
      };

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
          # tmux-custom = customTmux; # inputs.tmux-custom.packages.${system}.tmux;
          tmux-custom = tmux;
          bugwarrior = bugwarrior;
        };
      };
    };
}
