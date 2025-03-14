{rustPlatform, ...}:
rustPlatform.buildRustPackage {
  pname = "nixwebring-server";
  version = "0.1.0";
  
  src = ./.;

  cargoHash = "sha256-0MKkHkgTHM9LbaoDyqVMhCkIAtmSN8CBpM9v9bp5u3U=";
}
