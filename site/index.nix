{
  h2,
  pkgs,
  webringMembers,
  ...
}: {
  template = "passthrough";
  format = "html";

  output = /*html*/''
    <html lang="en">
      <head>
        <title>nix webring</title>
        <link rel="icon" type="image/svg" href="/nix-webring.svg">
        <link rel="stylesheet" href="/index.css">
        <meta property="og:title" content="nix webring">
        <meta property="og:image" content="https://jacekpoz.pl/nix-webring.svg">
        <meta property="og:type" content="website">
        <meta property="og:url" content="https://nixwebr.ing">
      </head>
      <body>
        <p>work in progress</p>
        ${h2 "webring members"}
        <ul>
          ${pkgs.lib.concatStrings (map (member: /*html*/''
            <li>
              <a href="https://${member.domain}">${member.name}</a>
            </li>
          '') webringMembers)}
        </ul>
      </body>
    </html>
  '';
}
