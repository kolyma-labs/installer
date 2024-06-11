{
  description = "Installer OSes used by Kolyma's Network";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";

    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Flake utils for eachSystem
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils, ... } @ inputs: let
    inherit (self) outputs;

    # Legacy packages are needed for home-manager
    lib = nixpkgs.lib;

        # Supported systems for your flake packages, shell, etc.
    systems = [
      "aarch64-linux"
      "x86_64-linux"
    ];

    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;

    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});

    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    pkgsFor = lib.genAttrs systems (system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      }
    );

    # Define a development shell for each system
    devShellFor = system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
      pkgs.mkShell {
        NIX_CONFIG = "extra-experimental-features = nix-command flakes repl-flake";
        buildInputs = with pkgs; [
          nix
          nil
          git
          just
        ];

        # Set environment variables, if needed
        shellHook = ''
          # export SOME_VAR=some_value
          echo "Welcome to Sokhibjon's dotfiles!"
        '';
      };
  in {
    inherit lib;

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};

    # NixOS configuration entrypoint
    nixosConfigurations = {
      installer = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./installer.nix
        ];
      };
    };
  };
}
