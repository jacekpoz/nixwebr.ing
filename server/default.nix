{rustPlatform, ...}:
rustPlatform.buildRustPackage {
  pname = "nix-webring-server";
  version = "0.1.0";
  
  src = ./.;

  cargoHash = "sha256-rAs0tlc5Kfbx8VN7hiRGt2S45AgwqClA+qqnj9ry514=";
}
