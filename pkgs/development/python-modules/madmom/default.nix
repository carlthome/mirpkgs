{ lib
, python3
, fetchFromGitHub
, ffmpeg
}:

python3.pkgs.buildPythonPackage rec {
  pname = "madmom";
  version = "0.16.1.dev0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "CPJKU";
    repo = "madmom";
    rev = "44f6cbd1a332313110a21036c948f7dde2c769bc";
    hash = "sha256-yQbkOVc2PAdF1SGfIs0y6qWwS0/A60N/sw9J+KS0OYo=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = with python3.pkgs; [
    wheel
    cython
    pytest
    pytest-runner
  ];

  propagatedBuildInputs = with python3.pkgs; [
    ffmpeg
    mido
    numpy
    pyfftw
    scipy
  ];

  preCheck = ''
    rm -r madmom
  '';

  nativeCheckInputs = with python3.pkgs; [
    ffmpeg
    pytestCheckHook
  ];

  pytestFlags = [ "tests/" ];

  pythonImportsCheck = [ "madmom" ];

  meta = with lib; {
    description = "Python audio and music signal processing library";
    homepage = "https://github.com/CPJKU/madmom";
    changelog = "https://github.com/CPJKU/madmom/blob/${src.rev}/CHANGES.rst";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ carlthome ];
  };
}
