{rustPlatform, ...}:
rustPlatform.buildRustPackage {
  pname = "nix-webring-server";
  version = "0.1.0";
  
  src = ./.;

  cargoHash = "sha256-v96+UzVjj44DOs4nFUR6+qyqI+0JwyQK+/5z/bi1J1o=";
}
