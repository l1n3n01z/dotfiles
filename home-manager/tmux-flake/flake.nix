{
  description = "Custom tmux package built from GitHub source";
  # inputs = {
  #   nixpkgs = self.inputs.nixpkgs;  # Reference nixpkgs from the parent flake
  # };
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
        src = pkgs.fetchFromGitHub {
          owner = "tmux";
          repo = "tmux";
          rev = "99790c90aa95152cef011b7339be34d8536e99a9"; # master commit you want to use
          sha256 = "sha256-vh1NzHdfmXCP3eHPEXZIp5lFiNwRztjq/VKNVDoyAnw="; # Correct hash for this commit
        };
      });

    in
    {
      # packages = {
      #   tmux = tmux; # Expose tmux package here
      # };
      packages.${system}.tmux = tmux; # Expose tmux package
      # defaultPackage.x86_64-linux = tmux;
      defaultPackage.${system} = tmux;
    };
}
# {
#
#   description = "Custom tmux configuration";
#
#   inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
#
#   outputs = { self, nixpkgs, ... }:
#   let
#     pkgs = import nixpkgs { system = "x86_64-linux"; };
#
#   tmux-custom = pkgs.tmux.overrideAttrs (oldAttrs: rec {
#     version = "3.6-99790c9";
#     # version = "your-desired-version";
#
#     src = pkgs.fetchFromGitHub {
#       owner = "tmux";
#       repo = "tmux";
#       rev = "99790c90aa95152cef011b7339be34d8536e99a9"; # master since dec 4
#       sha256 = "sha256-vh1NzHdfmXCP3eHPEXZIp5lFiNwRztjq/VKNVDoyAnw="; # Replace with actual hash
#     };
#     # to use my own fork of tmux
#     # src = pkgs.fetchFromGitHub {
#     #   owner = "yourusername";  # Your GitHub username
#     #   repo = "tmux";
#     #   rev = "your-commit-or-branch";  # Reference to your fork's commit or branch
#     #   sha256 = "sha256-xxxxxxxxxxxxxxxx";  # Replace with correct hash
#     # };
#   });
#
#   in
#   {
#     packages.x86_64-linux.tmux = tmux-custom;
#
#     # Optionally, if you want this to be the default package
#     defaultPackage.x86_64-linux = tmux-custom;
#   };
# }
# {
#   description = "Custom tmux package";
#
#   inputs.nixpkgs.url = "github:NixOS/nixpkgs";
#
#   outputs =
#     { self, nixpkgs }:
#     {
#       packages.x86_64-linux.tmux =
#         nixpkgs.lib.makeOverridable (import nixpkgs)
#           {
#             config = { };
#           }
#           .stdenv.mkDerivation
#           {
#             pname = "tmux";
#             version = "3.6-99790c9";
#
#             # src = nixpkgs.fetchurl {
#             #   url = "https://github.com/tmux/tmux/releases/download/${version}/tmux-${version}.tar.gz";
#             #   sha256 = "0jk8my99y8k9q0rlxxqfshc1lvbfsxa23q9r3j7jkpxcmqhng1n0"; # Correct hash here
#             # };
#             src = nixpkgs.fetchFromGitHub {
#               owner = "tmux";
#               repo = "tmux";
#               rev = "99790c90aa95152cef011b7339be34d8536e99a9"; # Fetch latest from master
#               sha256 = "sha256-xxxxxxxxxxxxxxxx"; # Replace with actual hash
#             };
#
#             nativeBuildInputs = [
#               nixpkgs.autoconf
#               nixpkgs.automake
#               nixpkgs.libtool
#               nixpkgs.pkg-config
#             ];
#             buildInputs = [
#               nixpkgs.ncurses
#               nixpkgs.libevent
#             ];
#
#             configureFlags = [
#               "--enable-debug"
#               "--prefix=$out"
#             ];
#
#             meta.description = "Custom tmux build with specific flags";
#           };
#     };
# }
# {
#   description = "Custom tmux package";
#
#   inputs.nixpkgs.url = "github:NixOS/nixpkgs";
#
#   outputs =
#     { self, nixpkgs }:
#     let
#       pkgs = import nixpkgs { system = "x86_64-linux"; };
#     in
#     {
#       packages.x86_64-linux.tmux = pkgs.stdenv.mkDerivation {
#         pname = "tmux";
#         version = "master";
#
#         src = pkgs.fetchFromGitHub {
#           owner = "tmux";
#           repo = "tmux";
#           rev = "99790c90aa95152cef011b7339be34d8536e99a9"; # master since dec 4
#           sha256 = "sha256-vh1NzHdfmXCP3eHPEXZIp5lFiNwRztjq/VKNVDoyAnw="; # Replace with actual hash
#         };
#
#         nativeBuildInputs = [
#           pkgs.autoconf
#           pkgs.automake
#           pkgs.libtool
#           pkgs.pkg-config
#           pkgs.bison
#         ];
#         # buildInputs = [
#         #   pkgs.ncurses
#         #   pkgs.libevent
#         # ];
#         buildInputs = [
#           pkgs.ncurses
#           pkgs.libevent
#         ];
#         # ] ++ pkgs.lib.optionals withSystemd [ systemd ]
#         # ++ lib.optionals withUtf8proc [ utf8proc ]
#         # ++ lib.optionals withUtempter [ libutempter ];
#         #
#         # configureFlags = [ "--enable-debug" ];
#         configureFlags =
#           [
#             "--sysconfdir=/etc"
#             "--localstatedir=/var"
#           ]
#           # ++ pkgs.lib.optionals withSystemd [ "--enable-systemd" ]
#           ++ pkgs.lib.optionals true [ "--enable-sixel" ]
#         # ++ pkgs.lib.optionals withUtempter [ "--enable-utempter" ]
#         # ++ pkgs.lib.optionals withUtf8proc [ "--enable-utf8proc" ];
#
#         ;
#         meta.description = "Custom build of tmux from master branch";
#       };
#
#       # Add a defaultPackage to simplify usage
#       defaultPackage.x86_64-linux = self.packages.x86_64-linux.tmux;
#
#       # Optionally, defaultApp can point to an executable
#       defaultApp.x86_64-linux = {
#         type = "app";
#         program = "${self.defaultPackage.x86_64-linux}/bin/tmux";
#       };
#     };
# }
