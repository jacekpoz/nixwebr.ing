{
  jetbrains-mono,
  lib,
  mkNteDerivation,
  webringMembers,
  writeText,
  ...
}: let
  inherit (lib.attrsets) listToAttrs;
  inherit (lib.lists) map;
  inherit (lib.strings) replaceStrings toLower;

  h = n: content: let
    id = replaceStrings [" " ";"] ["-" "-"] (toLower content);
  in /*html*/''
    <h${toString n} id="${id}"><a href="#${id}">#</a> ${content}</h${toString n}>
  '';

  hs = listToAttrs (map (n: {
    name = "h${toString n}";
    value = text: h n text;
  }) [ 1 2 3 4 5 6 ]);
in mkNteDerivation {
  name = "nix-webring-site";
  version = "0.1.0";
  src = ./.;

  extraArgs = hs // {
    inherit h webringMembers;
  };

  entries = [
    ./index.nix
  ];

  extraFiles = [
    { source = "./index.css"; destination = "/"; }
    { source = "./nix-webring.svg"; destination = "/"; }
    { source = "${jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf"; destination = "/"; }
    {
        source = writeText "webring.json" (builtins.toJSON webringMembers);
        destination = "/webring.json";
    }
  ];
}
