{
  description = "Installer OSes used by Kolyma's Network";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    # Nixpkgs Unstable (for newer packages)
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Flake utils for eachSystem
    flake-utils.url = "github:numtide/flake-utils";

    # Orzklv's Nix configuration
    orzklv = {
      url = "github:orzklv/nix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    flake-utils,
    orzklv,
    ...
  } @ inputs:
  # Attributes for each system
    flake-utils.lib.eachDefaultSystem (
      system: let
        # Packages for the current <arch>
        pkgs = nixpkgs.legacyPackages.${system};
      in
        # Nixpkgs packages for the current system
        {
          # Development shells
          devShells.default = import ./shell.nix {inherit pkgs;};
        }
    )
    # and ...
    //
    # Attribute from static evaluation
    {
      # Formatter for your nix files, available through 'nix fmt'
      # Other options beside 'alejandra' include 'nixpkgs-fmt'
      inherit (orzklv) formatter;

      # NixOS configuration entrypoint
      nixosConfigurations = {
        # The installer OS
        installer = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [
            ./installer.nix
          ];
        };
      };
    };
}
