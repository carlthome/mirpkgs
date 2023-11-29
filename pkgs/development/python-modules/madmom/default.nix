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
    owner = "carlthome";
    repo = "madmom";
    rev = "8bba9971075316210f1c8efd9ad005e5a6486793";
    hash = "sha256-KbdIVEzwhyRK5Xh2f2vccwOLDlJyA7lTB6dDDJMKCF0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = with python3.pkgs; [
    wheel
    cython
  ];

  propagatedBuildInputs = with python3.pkgs; [
    ffmpeg
    mido
    numpy
    scipy
    # TODO Add pyfftw for improved FFT performance.
    #pyfftw
    # TODO Add pyaudio for real-time audio I/O.
    #pyaudio
  ];

  # Remove source files so pytest only uses the built package.
  preCheck = ''
    rm -r madmom
  '';

  nativeCheckInputs = with python3.pkgs; [
    ffmpeg
    pytest-runner
    pytestCheckHook
  ];

  pythonImportsCheck = [ "madmom" ];

  meta = with lib; {
    description = "Python audio and music signal processing library";
    homepage = "https://github.com/CPJKU/madmom";
    changelog = "https://github.com/CPJKU/madmom/blob/${src.rev}/CHANGES.rst";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ carlthome ];
  };
}
