{
  description = "Custom tmux package built from GitHub source";
  # note, inputs.nixpkgs follows home flake
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # You may want to use a specific channel
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      system = "x86_64-linux"; # Adjust the system if necessary
      pkgs = import nixpkgs { inherit system; };

      tmux = pkgs.tmux.overrideAttrs (oldAttrs: rec {
        version = "3.6-99790c9"; # Your desired version
        #consider using our own fork of tmux
        src = pkgs.fetchFromGitHub {
          owner = "tmux";
          repo = "tmux";
          rev = "99790c90aa95152cef011b7339be34d8536e99a9"; # master commit you want to use
          sha256 = "sha256-vh1NzHdfmXCP3eHPEXZIp5lFiNwRztjq/VKNVDoyAnw="; # Correct hash for this commit
        };
      });

    in
    {
      packages.${system}.tmux = tmux; # Expose tmux package
      defaultPackage.${system} = tmux;
    };
}
