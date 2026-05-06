{
  description = "OpenCode copilot-stats plugin from nilcaream/copilot-stats";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      copilot-stats = pkgs.stdenv.mkDerivation {
        pname = "copilot-stats";
        version = "2024-12-03";

        src = pkgs.fetchFromGitHub {
          owner = "nilcaream";
          repo = "copilot-stats";
          rev = "1f8b031ca253260b3d2e99199c260bc097b8c88a";
          sha256 = "sha256-zi7v47OM7WZmmgOsGugJb5eZfw6s3Ex2o1/nLNtOh/g=";
        };

        dontBuild = true;

        installPhase = ''
          mkdir -p $out/plugins $out/commands
          cp plugins/copilot-stats.ts $out/plugins/
          cp commands/copilot-stats.md $out/commands/
        '';

        meta = with pkgs.lib; {
          description = "OpenCode plugin that tracks GitHub Copilot premium request usage";
          homepage = "https://github.com/nilcaream/copilot-stats";
          license = licenses.asl20;
          platforms = platforms.linux;
        };
      };

    in
    {
      packages.${system}.copilot-stats = copilot-stats;
      defaultPackage.${system} = copilot-stats;
    };
}
