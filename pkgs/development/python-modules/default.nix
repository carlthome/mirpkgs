{ pkgs, lib, ... }:
let
  subdirectories = builtins.attrNames (
    lib.filterAttrs (name: type: type == "directory") (builtins.readDir ./.)
  );

  mkScope =
    self:
    builtins.listToAttrs (
      map (dir: {
        name = dir;
        value = self.callPackage (./. + "/${dir}") { };
      }) subdirectories
    );

  scope = lib.makeScope pkgs.newScope mkScope;

  packages = builtins.listToAttrs (
    map (dir: {
      name = dir;
      value = scope.${dir};
    }) subdirectories
  );
in
packages
