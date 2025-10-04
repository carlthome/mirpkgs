{
  description = "Example of using mirpkgs as nixpkgs overlay";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    mirpkgs = {
      url = "github:carlthome/mirpkgs/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      mirpkgs,
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgsBySystem =
        system:
        import nixpkgs {
          inherit system;
          overlays = [ mirpkgs.overlays.default ];
        };
    in
    {
      packages = forAllSystems (system: {
        default = import ./default.nix { pkgs = pkgsBySystem system; };
      });

      devShells = forAllSystems (system: {
        default = import ./shell.nix { pkgs = pkgsBySystem system; };
      });
    };
}
