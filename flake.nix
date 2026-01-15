{
  description = "Installer OSes used by Kolyma's Network";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # Flake-parts utilities
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    { nixpkgs, flake-parts, ... }@inputs:
    # https://flake.parts/module-arguments.html
    flake-parts.lib.mkFlake { inherit inputs; } (
      { ... }:
      {
        flake = {
          # NixOS configuration entrypoint
          nixosConfigurations =
            [
              "x86_64-linux"
              "aarch64-linux"
            ]
            |> builtins.map (system: {
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
            })
            |> nixpkgs.lib.mkMerge;
        };
        systems = [
          "x86_64-linux"
          "aarch64-linux"
          "aarch64-darwin"
        ];
        perSystem =
          { pkgs, ... }:
          {
            # Development shells
            devShells.default = import ./shell.nix { inherit pkgs; };

            # Formatter for your nix files, available through 'nix fmt'
            # Other options beside 'alejandra' include 'nixpkgs-fmt'
            formatter = pkgs.nixfmt-tree;
          };
      }
    );
}
