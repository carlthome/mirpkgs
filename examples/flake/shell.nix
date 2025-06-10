{
  pkgs ? import <nixpkgs> { },
  ...
}:
with pkgs;
(python3.withPackages (
  ps: with ps; [
    ipython
    msaf
  ]
)).env
