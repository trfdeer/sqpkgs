{ lib, callPackage }:

lib.makeScope callPackage (_: {
  geysermc = callPackage ./geysermc.nix { };
  floodgate = callPackage ./floodgate.nix { };
})
