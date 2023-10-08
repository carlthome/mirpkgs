{ pkgs
, stdenv
, lib
, fetchPypi
, fetchFromGitHub
, python3Packages
}:
pkgs.python3Packages.buildPythonPackage {
  name = "jams";
  format = "setuptools";

  src = fetchPypi {
    pname = "jams";
    version = "0.3.4";
    hash = "sha256-i7IVi9GbTwV7i5AyG0Sx3RZZxmy+vg1CGYidMdf4iLk=";
  };

  propagatedBuildInputs = with python3Packages; [
    pandas
    jsonschema
    decorator
    sortedcontainers
    mir_eval
  ];

  pythonImportsCheck = [
    "jams"
  ];

  doCheck = false;

  meta = {
    description = "A JSON Annotated Music Specification for Reproducible MIR Research";
    homepage = "https://github.com/marl/jams";
    license = lib.licenses.isc;
    maintainers = [
      (import ./maintainer.nix)
    ];
  };
}
