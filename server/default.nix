{rustPlatform, ...}:
rustPlatform.buildRustPackage {
  pname = "nix-webring-server";
  version = "0.1.0";
  
  src = ./.;

  cargoHash = "sha256-O+rhWIjIBQdemTsFc1TV/lpKZpGE/IL7uPs3TP8KVu0=";
}
