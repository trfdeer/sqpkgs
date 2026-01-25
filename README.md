# sqpkgs

`sqpkgs` is a Nix flake that provides reproducible Minecraft server packages
(PaperMC) and common plugins.

---

## Use as a flake input

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    sqpkgs.url = "git+ssh://git@github.com:trfdeer/sqpkgs";
  };

  outputs = { nixpkgs, sqpkgs, ... }: {
    nixosConfigurations.host = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ pkgs, ... }: {
          nixpkgs.overlays = [ sqpkgs.overlays.default ];
        })
      ];
    };
  };
}
```

---

## Available packages

After applying the overlay, packages are available under `pkgs.sqpkgs`.

### PaperMC (latest)

```nix
pkgs.sqpkgs.papermc
```

Build it directly:

```sh
nix build .#papermc
```

---

### PaperMC (versioned)

```nix
pkgs.sqpkgs.papermcPackages.default
pkgs.sqpkgs.papermcPackages.papermc_1_21_11
```

---

### Minecraft plugins

```nix
pkgs.sqpkgs.minecraftPlugins.geysermc
pkgs.sqpkgs.minecraftPlugins.floodgate
```

Each plugin derivation provides a single file:

```text
$out/plugin.jar
```

---

## Access without overlays (legacyPackages)

Versioned collections are also exposed via `legacyPackages`:

```nix
sqpkgs.legacyPackages.x86_64-linux.papermcPackages
sqpkgs.legacyPackages.x86_64-linux.minecraftPlugins
```

Example:

```nix
sqpkgs.legacyPackages.x86_64-linux.minecraftPlugins.geysermc
```

---

## Example: NixOS Minecraft server

```nix
{
  services.minecraft-server = {
    enable = true;
    package = pkgs.sqpkgs.papermc;
  };
}
```

Plugins can be copied or symlinked into the server’s `plugins/` directory from
their derivation outputs.
