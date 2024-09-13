{
  description = "the ring";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nte = {
      url = "git+https://git.jacekpoz.pl/jacekpoz/nte";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default";
  };

  outputs = { nixpkgs, nte, self, systems, ... }: let
    forEachSystem = nixpkgs.lib.genAttrs (import systems);
    pkgsForEach = nixpkgs.legacyPackages;
  in {
    packages = forEachSystem (
      system: let
        pkgs = pkgsForEach.${system};
      in {
        site = import ./site/default.nix {
          inherit pkgs;
          inherit (pkgs) jetbrains-mono lib;
          inherit (nte.functions.${system}) mkNteDerivation;
        };
        server = import ./server/default.nix {
          inherit pkgs;
          inherit (pkgs) rustPlatform;
        };
      }
    );
    devShells = forEachSystem (
      system: let
        pkgs = pkgsForEach.${system};
        shell = pkgs.mkShell {
          name = "nixwebr.ing";

          inputsFrom = [ self.packages.${system}.server ];
        };
      in {
        "nixwebr.ing" = shell;
        default = shell;
      }
    );
  };
}
