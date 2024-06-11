build: 
    nix build .#nixosConfigurations.installer.config.system.build.isoImage

generator:
    nix run nixpkgs#nixos-generators -- --format iso --flake .#installer -o result