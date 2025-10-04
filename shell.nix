{
  pkgs ? import <nixpkgs> { },
  ...
}:
pkgs.mkShell {
  buildInputs = with pkgs; [
    nixfmt
    actionlint
    nix-init
    nix-update
  ];
}
