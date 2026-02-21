final: prev:
let
  overlays = [
    (import ./terraria-server.nix)
  ];
in
builtins.foldl' (acc: ov: acc // (ov final prev)) { } overlays
