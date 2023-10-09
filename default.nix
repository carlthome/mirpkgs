{ nixpkgs, system, self, ... }@inputs:
let
  pkgs = nixpkgs.legacyPackages.${system};
  packages = import ./overlay.nix pkgs self;
  allPackages = packages: pkgs.symlinkJoin { name = "all"; paths = (builtins.attrValues packages); };
in
packages // { default = allPackages packages; }
