{
  lib,
  stdenvNoCC,
  fetchurl,
}:
let
  version = "2.2.5"; # From https://download.geysermc.org/v2/projects/floodgate
  build = "138"; # From https://download.geysermc.org/v2/projects/floodgate/versions/2.2.5/builds
  sha256 = "sha256-RL25COL7T/G5dNUxPQSKYlohVVqYRM+4Ylapjo4ca9E="; # From ^above^ (spigot) with nix hash convert --to sri --hash-algo sha256
in

stdenvNoCC.mkDerivation {
  pname = "floodgate";
  version = "${version}-${build}";

  src = fetchurl {
    url = "https://download.geysermc.org/v2/projects/floodgate/versions/${version}/builds/${build}/downloads/spigot";
    hash = sha256;
  };

  dontUnpack = true;

  installPhase = ''
    install -Dm644 $src $out/floodgate-spigot.jar
  '';

  passthru.pluginJar = "floodgate-spigot.jar";

  meta = with lib; {
    description = "Floodgate – authentication bridge for GeyserMC";
    homepage = "https://geysermc.org/wiki/floodgate";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
