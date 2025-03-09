{
  description = "Installer OSes used by Kolyma's Network";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    # Flake utils for eachSystem
    flake-utils.url = "github:numtide/flake-utils";

    # Orzklv's Nix configuration
    orzklv = {
      url = "github:orzklv/nix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
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
      nixosConfigurations =
        flake-utils.lib.eachSystemPassThrough
        ["x86_64-linux" "aarch64-linux"]
        (system: {
          # The installer OS
          "installer-${system}" = nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit inputs;
              arch = system;
            };
            modules = [
              ./installer.nix
            ];
          };
        });
    };
}
