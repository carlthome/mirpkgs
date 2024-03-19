{ nixpkgs, system, ... }:
let
  pkgs = nixpkgs.legacyPackages.${system};
  pythonPackages = import ./pkgs/development/python-modules { inherit pkgs; };
  pythonEnv = pkgs.python3.buildEnv.override {
    extraLibs = (with pkgs.python3Packages; [ ipython ]) ++ builtins.attrValues pythonPackages;
    ignoreCollisions = true;
  };
in
pythonPackages // { default = pythonEnv; }
