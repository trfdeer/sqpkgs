{ lib, callPackage }:

let
  versions = import ./versions.nix;

  escape = v: lib.replaceStrings [ "." ] [ "_" ] v;

  papermcPackages = lib.mapAttrs' (mcVersion: value: {
    name = "papermc_${escape mcVersion}";
    value = callPackage ./derivation.nix value;
  }) versions;

  latest = lib.last (builtins.sort lib.versionOlder (builtins.attrNames versions));
in
papermcPackages
// {
  default = papermcPackages."papermc_${escape latest}";
}
