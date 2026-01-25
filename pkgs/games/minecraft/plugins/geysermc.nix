{
  lib,
  stdenvNoCC,
  fetchurl,
}:
let
  version = "2.9.2"; # From https://download.geysermc.org/v2/projects/geyser
  build = "1044"; # From https://download.geysermc.org/v2/projects/geyser/versions/2.9.2/builds
  sha256 = "sha256-801b4knumTaAuL3LVtQTdIy5jLY/yoWoEAsB+jp08nA="; # From ^above^ (spigot) with nix hash convert --to sri --hash-algo sha256
in

stdenvNoCC.mkDerivation {
  pname = "geysermc";
  version = "${version}-${build}";

  src = fetchurl {
    url = "https://download.geysermc.org/v2/projects/geyser/versions/${version}/builds/${build}/downloads/spigot";
    hash = sha256;
  };

  dontUnpack = true;

  installPhase = ''
    install -Dm644 $src $out/geyser-spigot.jar
  '';

  passthru.pluginJar = "geyser-spigot.jar";

  meta = with lib; {
    description = "GeyserMC – allow Bedrock clients to join Java servers";
    homepage = "https://geysermc.org/";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
