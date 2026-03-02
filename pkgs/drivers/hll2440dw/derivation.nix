{
  lib,
  stdenv,
  fetchurl,
  cups,
  dpkg,
  makeWrapper,
  ghostscript,
  file,
  a2ps,
  coreutils,
  perl,
  gnugrep,
  gnused,
  which,
}:

stdenv.mkDerivation {
  pname = "cups-brother-hll2440dw";
  version = "4.1.0-1";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf105957/hll2440dwpdrv-4.1.0-1.i386.deb";
    sha256 = "sha256-OamOWJMVhmrN9ElxMhfqsrirW+ppm3/3YfpnbVrm36c=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    cups
    ghostscript
    dpkg
    a2ps
  ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    dpkg-deb -x $src $out

    # Fix perl shebangs
    substituteInPlace $out/opt/brother/Printers/HLL2440DW/lpd/lpdfilter \
      --replace "#! /usr/bin/perl" "#! ${perl}/bin/perl"
    substituteInPlace $out/opt/brother/Printers/HLL2440DW/cupswrapper/lpdwrapper \
      --replace "#! /usr/bin/perl" "#! ${perl}/bin/perl"

    # patchelf the native binaries (use x86_64)
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $out/opt/brother/Printers/HLL2440DW/lpd/x86_64/brprintconflsr3
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $out/opt/brother/Printers/HLL2440DW/lpd/x86_64/rawtobr3

    # Wrap lpdfilter with runtime deps
    wrapProgram $out/opt/brother/Printers/HLL2440DW/lpd/lpdfilter \
      --prefix PATH ":" ${
        lib.makeBinPath [
          ghostscript
          a2ps
          file
          gnused
          gnugrep
          coreutils
          which
          perl
        ]
      }

    # Wrap lpdwrapper with runtime deps
    wrapProgram $out/opt/brother/Printers/HLL2440DW/cupswrapper/lpdwrapper \
      --prefix PATH ":" ${
        lib.makeBinPath [
          ghostscript
          gnused
          gnugrep
          coreutils
          perl
        ]
      }

    # Wire up CUPS filter and PPD
    mkdir -p $out/lib/cups/filter
    ln -s $out/opt/brother/Printers/HLL2440DW/cupswrapper/lpdwrapper \
      $out/lib/cups/filter/brother_lpdwrapper_HLL2440DW

    mkdir -p $out/share/cups/model
    ln -s $out/opt/brother/Printers/HLL2440DW/cupswrapper/brother-HLL2440DW-cups-en.ppd \
      $out/share/cups/model/brother-HLL2440DW-cups-en.ppd
  '';

  meta = {
    homepage = "https://www.brother.com/";
    description = "Brother HL-L2440DW printer driver";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
