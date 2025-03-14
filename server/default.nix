{
  lib,
  rustPlatform,
  ...
}: rustPlatform.buildRustPackage {
  pname = "nixwebring-server";
  version = "0.1.0";
  
  src = ./.;

  cargoHash = "sha256-0MKkHkgTHM9LbaoDyqVMhCkIAtmSN8CBpM9v9bp5u3U=";

  meta = {
    description = "Backend for the nix webring";
    homepage = "https://nixwebr.ing";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.jacekpoz ];
    mainProgram = "nixwebring-server";
  };
}
