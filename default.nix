{ nixpkgs, system, ... }:
let
  pkgs = nixpkgs.legacyPackages.${system};
  packages = import ./pkgs/development/python-modules { inherit pkgs; };
  allPackages = packages: pkgs.symlinkJoin { name = "all"; paths = (builtins.attrValues packages); };
in
packages // { default = allPackages packages; }
