{
  description = "repository for packages i need";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ self.overlays.default ];
      };
    in
    {
      overlays = {
        sq = final: prev: {
          sqpkgs = {
            papermc = final.sqpkgs.papermcPackages.default;
            papermcPackages = final.callPackage ./pkgs/games/minecraft/papermc { };
            minecraftPlugins = final.callPackage ./pkgs/games/minecraft/plugins { };
          };
        };
        terraria = import ./pkgs/games/terraria;

        default = final: prev: (self.overlays.sq final prev) // (self.overlays.terraria final prev);
      };

      packages.${system}.papermc = pkgs.sqpkgs.papermc;

      legacyPackages.${system} = {
        papermcPackages = pkgs.sqpkgs.papermcPackages;
        minecraftPlugins = pkgs.sqpkgs.minecraftPlugins;
      };

      devShells.${system}.default = pkgs.mkShellNoCC {
        packages = with pkgs; [
          nixd
          nixfmt-rfc-style
        ];
      };
    };
}
