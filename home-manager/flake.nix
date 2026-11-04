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

    # Pinned nixpkgs for zls (current unstable has build failure: https://github.com/NixOS/nixpkgs/issues/488701)
    nixpkgs-zls.url = "github:nixos/nixpkgs/4dadbbb";

    # Dedicated nixpkgs input for azure-cli, pinned to nixos-26.05 (2.86.0)
    nixpkgs-azure.url = "github:nixos/nixpkgs/nixos-26.05";

    # Dedicated nixpkgs input so we can update OmniSharp independently
    nixpkgs-omnisharp.url = "github:nixos/nixpkgs/nixos-unstable";

    # care-nvim.url = "github:max397574/care.nvim/800741c255939c0f345239662ec268557ac3eefa";
    # nvim.url = "github:nix-community/kickstart-nix.nvim";
    # nvim.url = "github:mrcjkb/nvim";
    bugwarrior = {
      url = "path:./bugwarrior"; # Use `url` with `path` for a local flake
      inputs.nixpkgs.follows = "nixpkgs";
    };
    copilot-stats = {
      url = "path:./copilot-stats";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # tmux-which-key =     {
    #   inputs.tmux-which-key.url = "github:Nucc/tmux-which-key";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
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
      nixpkgs-zls,
      nixpkgs-azure,
      nixpkgs-omnisharp,
      home-manager,
      # care-nvim,
      bugwarrior,
      copilot-stats,
      # tmux-which-key,
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
            #
            #  "1password-cli"
            # ];
          };
           overlays = [
             # Pin azure-cli from nixos-26.05 (currently 2.86.0) to avoid
             # regressions seen in unstable's 2.89.1 packaging.
             (final: prev: {
               azure-cli = pkgs-azure.azure-cli;
             })

             # Allow updating OmniSharp independently from the main nixpkgs lock
             (final: prev: {
               omnisharp-roslyn = pkgs-omnisharp.omnisharp-roslyn;
             })

             # Pin github-copilot-cli to a newer version than nixpkgs
             # To update:
             #   1. Check latest: gh release list --repo github/copilot-cli --limit 5
             #   2. Update version below, set hash to "" (empty)
             #   3. Run home-manager switch, nix will error with the correct hash
             #   4. Copy the "got: sha256-..." hash into the hash field
             # (final: prev: {
             #   github-copilot-cli = prev.github-copilot-cli.overrideAttrs (old: rec {
             #     version = "1.0.2";
             #     src = prev.fetchurl {
             #       url = "https://github.com/github/copilot-cli/releases/download/v${version}/copilot-linux-x64.tar.gz";
             #       hash = "sha256-Uh+H0E8HM1bGWtlz23Eksy/zoj/TJX8M0/z0xdRkkEc=";
             #     };
             #   });
             # })
           ];
        }
      );
      # Pinned pkgs for zls due to build failure in current unstable
      pkgs-zls = import nixpkgs-zls { inherit system; };
      # Pinned pkgs for azure-cli from nixos-26.05
      pkgs-azure = import nixpkgs-azure { inherit system; };
      # Separate nixpkgs import for OmniSharp-only updates
      pkgs-omnisharp = import nixpkgs-omnisharp { inherit system; };
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
          inherit inputs pkgs-zls;
          bugwarrior = bugwarrior.defaultPackage.${system};
          copilot-stats = copilot-stats.defaultPackage.${system};
          # tmux-which-key-pkg = tmux-which-key.packages.${system}.default;
          # tmux-custom = tmux;
          # bugwarrior = bugwarrior;
        };
      };
    };
}
