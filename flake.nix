{
  description = "Installer OSes used by Kolyma's Network";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    # Nixpkgs Unstable (for newer packages)
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... } @ inputs: {
    # NixOS configuration entrypoint
    nixosConfigurations = {
      # The installer OS
      installer = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./installer.nix
        ];
      };
    };
  };
}
