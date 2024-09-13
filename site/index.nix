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
        
        <div id="logo-and-name-and-shit">
          <h1>nix webring</h1>
          <img src="/nix-webring.svg">
        </div>

        ${h2 "webring members"}
        <ul>
          ${pkgs.lib.concatStrings (map (member: /*html*/''
            <li>
              <a href="https://${member.domain}">${member.name}</a>
            </li>
          '') webringMembers)}
        </ul>

        ${h2 "about"}
        <p>
          this is a webring for people passionate about <a href="https://nix.dev/">nix</a>/<a href="https://nixos.org/">os</a>
          <br>
        </p>

        ${h2 "joining"}
        <p>
          to join, have a personal website (bonus points if it uses nix!) and add the following links to it (they have to be on the main page):
          <ul>
            <li>webring site: <code>https://nixwebr.ing</code></li>
            <li>next site: <code>https://nixwebr.ing/next/&lt;name&gt;</code></li>
            <li>previous site: <code>https://nixwebr.ing/prev/&lt;name&gt;</code></li>
            <li>random site (optional): <code>https://nixwebr.ing/rand</code></li>
          </ul>
          and make a PR to one of <a href="https://codeberg.org/jacekpoz/nixwebr.ing">the</a> <a href="https://github.com/jacekpoz/nixwebr.ing">repos</a>
          <br>
          feel free to also link your nixos configuration in the PR!
          <br>
          if you don't know how to / can't make a PR for some reason feel free to <a href="https://jacekpoz.pl">contact me</a>, I can add you to the webring myself
        </p>
      </body>
    </html>
  '';
}
