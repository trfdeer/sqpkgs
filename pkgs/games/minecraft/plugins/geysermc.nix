{
  lib,
  stdenvNoCC,
  fetchurl,
}:
let
  version = "2.10.1"; # From https://download.geysermc.org/v2/projects/geyser
  build = "1177"; # From https://download.geysermc.org/v2/projects/geyser/versions/:version/builds
  sha256 = "sha256-UqBOIsSHajV7V6kFiMXl4plrfWfF2Rn6yQkaCSNSq8I="; # From ^above^ (spigot) with nix hash convert --to sri --hash-algo sha256
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
