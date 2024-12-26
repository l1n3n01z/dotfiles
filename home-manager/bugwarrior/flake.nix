{
  description = "Custom bugwarrior package built from GitHub source";
  # note, inputs.nixpkgs follows home flake
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # You may want to use a specific channel
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      system = "x86_64-linux"; # Adjust the system if necessary
      pkgs = import nixpkgs { inherit system; };

      bugwarrior = pkgs.python3Packages.buildPythonPackage rec {
        pname = "bugwarrior";
        version = "1.8-develop"; # Optionally, you can specify a custom version here

        src = pkgs.fetchFromGitHub {
          owner = "GothenburgBitFactory";
          repo = "bugwarrior";
          rev = "develop"; # Or specify a specific commit hash or tag
          sha256 = "sha256-kMNxA3Datbj5D4PHE1qdMXvBX5+HPtHEIc+P0r6f+Pg="; # Replace with the correct sha256 hash
        };

        # can we reduce the dependencies?
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

        # Reuse all other dependencies and build steps from the nixpkgs definition
        meta = with pkgs.lib; {
          description = "A tool to help with building and testing packages for Nixpkgs";
          license = licenses.mit;
          platforms = platforms.linux;
        };
      };
    in
    {
      # packages = {
      #   tmux = tmux; # Expose tmux package here
      # };
      packages.${system}.bugwarrior = bugwarrior; # Expose tmux package
      # defaultPackage.x86_64-linux = tmux;
      defaultPackage.${system} = bugwarrior;
    };
}
