{ pkgs
, stdenv
, lib
, fetchPypi
, fetchFromGitHub
, python3Packages
}:
pkgs.python3Packages.buildPythonPackage {
  name = "vmo";
  format = "setuptools";

  src = fetchPypi {
    pname = "vmo";
    version = "0.30.5";
    hash = "sha256-yXt+a7a3JM3aSy8usgCKzab4JK5lTQR1AiMEcFdjNdY=";
  };

  propagatedBuildInputs = with python3Packages; [
    numpy
    scipy
    librosa
  ];

  pythonImportsCheck = [
    "vmo"
  ];

  nativeCheckInputs = with python3Packages; [
    unittestCheckHook
  ];

  meta = {
    description = "Python Modules of Variable Markov Oracle";
    homepage = "https://github.com/wangsix/vmo";
    license = lib.licenses.gpl3;
    maintainers = [
      (import ./maintainer.nix)
    ];
  };
}
