{
  description = "Nix packages for reproducible MIR research";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/a53f752568e5474fdad6b17f8648291f223853f3";

  outputs = { self, nixpkgs }@inputs:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);
      packages = forAllSystems (system: import ./default.nix (inputs // { inherit system; }));
      devShells = forAllSystems (system: { default = import ./shell.nix { pkgs = nixpkgs.legacyPackages.${system}; }; });
      overlays.default = final: prev: (import ./pkgs/development/python-modules { pkgs = final; });
      templates.default = { path = ./examples/flake; description = "A basic Python environment with mirpkgs included as a nixpkgs overlay"; };
    };
}
