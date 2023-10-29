{ nixpkgs, system, ... }:
let
  pkgs = nixpkgs.legacyPackages.${system};
  pythonPackages = import ./pkgs/development/python-modules { inherit pkgs; };
  shell = pkgs.buildEnv {
    name = "ipython";
    paths = [ (pkgs.python3.withPackages (ps: [ ps.ipython ] ++ builtins.attrValues pythonPackages)) ];
  };
in
pythonPackages // { default = shell; }
