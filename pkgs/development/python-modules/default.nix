{ pkgs, ... }:
let
  subdirectories = builtins.attrNames (
    pkgs.lib.filterAttrs (name: type: type == "directory") (builtins.readDir ./.)
  );

  mkScope =
    self:
    builtins.listToAttrs (
      map (dir: {
        name = dir;
        value = self.callPackage (./. + "/${dir}") { };
      }) subdirectories
    );

  scope = pkgs.lib.makeScope pkgs.newScope mkScope;

  packages = builtins.listToAttrs (
    map (dir: {
      name = dir;
      value = scope.${dir};
    }) subdirectories
  );
in
packages
