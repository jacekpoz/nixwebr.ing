{
  description = "the ring";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nte = {
      url = "git+https://git.poz.pet/poz/nte";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default";
  };

  outputs = { nixpkgs, nte, self, systems, ... }: let
    forEachSystem = nixpkgs.lib.genAttrs (import systems);
    pkgsForEach = nixpkgs.legacyPackages;

    webringMembers = import ./webring.nix;
  in {
    packages = forEachSystem (
      system: let
        pkgs = pkgsForEach.${system};
      in {
        site = import ./site/default.nix {
          inherit pkgs webringMembers;
          inherit (pkgs) jetbrains-mono lib writeText;
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

          packages = with pkgs; [
            darkhttpd
          ];

          inputsFrom = [ self.packages.${system}.server ];
        };
      in {
        "nixwebr.ing" = shell;
        default = shell;
      }
    );
  };
}
