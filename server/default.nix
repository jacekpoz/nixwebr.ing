{rustPlatform, ...}:
rustPlatform.buildRustPackage {
  pname = "nix-webring-server";
  version = "0.1.0";
  
  src = ./.;

  cargoHash = "sha256-0MKkHkgTHM9LbaoDyqVMhCkIAtmSN8CBpM9v9bp5u3U=";
}
