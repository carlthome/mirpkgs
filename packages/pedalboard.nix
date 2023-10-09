{ pkgs
, stdenv
, lib
, fetchPypi
, fetchFromGitHub
, python3Packages
, gcc
}:
pkgs.python3Packages.buildPythonPackage rec {
  pname = "pedalboard";
  version = "0.7.3";
  format = "wheel";

  # TODO Add wheels for other platforms and operating systems.
  src = fetchPypi {
    inherit pname version format;
    dist = "cp310";
    python = "cp310";
    abi = "cp310";
    platform = "macosx_11_0_arm64";
    sha256 = "umWtjINA852sdiN61sTdORPPVGIGtel5dJMq4hzX+iQ=";
  };

  propagatedBuildInputs = [
    pkgs.python3Packages.numpy
  ];

  pythonImportsCheck = [
    "pedalboard"
  ];

  meta = with lib; {
    description = "A Python library for adding effects to audio.";
    homepage = "https://github.com/spotify/pedalboard";
    license = licenses.gpl3;
    maintainers = with maintainers; [ carlthome ];
  };
}
