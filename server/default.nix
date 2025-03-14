{
  lib,
  rustPlatform,
  ...
}: rustPlatform.buildRustPackage {
  pname = "nixwebring-server";
  version = "0.1.0";
  
  src = ./.;

  cargoHash = "sha256-Yx86reMsrs1xx3jWAg4j0vLZc9N4+CJgCgFLTUPpfwo=";

  meta = {
    description = "Backend for the nix webring";
    homepage = "https://nixwebr.ing";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.jacekpoz ];
    mainProgram = "nixwebring-server";
  };
}
