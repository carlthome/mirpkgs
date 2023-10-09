{ pkgs ? import <nixpkgs> { }, ... }: with pkgs;
python3.buildEnv.override {
  extraLibs = [
    msaf
  ];
}
