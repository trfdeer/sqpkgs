{
  lib,
  stdenvNoCC,
  fetchurl,
  makeBinaryWrapper,
  jre_headless,
  version,
  objectHash,
  sha256,
  udev,
}:

stdenvNoCC.mkDerivation {
  pname = "papermc";
  inherit version;

  src =
    let
      parts = lib.splitString "-" version;
      mcVersion = builtins.elemAt parts 0;
      buildNum = builtins.elemAt parts 1;
    in
    fetchurl {
      url = "https://fill-data.papermc.io/v1/objects/${objectHash}/paper-${mcVersion}-${buildNum}.jar";
      hash = sha256;
    };

  dontUnpack = true;

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall

    install -D $src $out/share/papermc/papermc.jar

    makeWrapper ${lib.getExe jre_headless} "$out/bin/minecraft-server" \
      --append-flags "-jar $out/share/papermc/papermc.jar nogui" \
      ${lib.optionalString stdenvNoCC.hostPlatform.isLinux "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ udev ]}"}

    runHook postInstall
  '';

  meta = with lib; {
    description = "High-performance Minecraft server (PaperMC)";
    homepage = "https://papermc.io/";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    mainProgram = "minecraft-server";
  };
}
