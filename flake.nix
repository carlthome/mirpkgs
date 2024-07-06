{
  description = "Nix packages for reproducible MIR research";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-github-actions = { url = "github:nix-community/nix-github-actions"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = { self, nixpkgs, nix-github-actions }@inputs:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);
      packages = forAllSystems (system: import ./default.nix (inputs // { inherit system; }));
      devShells = forAllSystems (system: { default = import ./shell.nix { pkgs = nixpkgs.legacyPackages.${system}; }; });
      overlays.default = final: prev: (import ./pkgs/development/python-modules { pkgs = final; });
      templates.default = { path = ./examples/flake; description = "A basic Python environment with mirpkgs included as a nixpkgs overlay"; };
      githubActions = nix-github-actions.lib.mkGithubMatrix {
        checks = nixpkgs.lib.getAttrs [ "x86_64-linux" ] self.packages;
      };
    };
}
