[doc('Attempt to build an image. "arch" is either "x86_64-linux" or "aarch64-linux"')]
build arch:
  nix build .#nixosConfigurations.installer-{{arch}}.config.system.build.isoImage

[doc('Build an image using nixos-generators. "arch" is either "x86_64-linux" or "aarch64-linux"')]
generator arch:
  nix run nixpkgs#nixos-generators -- --format iso --flake .#installer-{{arch}} -o result
