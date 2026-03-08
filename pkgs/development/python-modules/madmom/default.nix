{
  lib,
  python3,
  fetchFromGitHub,
  ffmpeg,
  pytest-runner,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "madmom";
  version = "0.16.1.dev0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CPJKU";
    repo = "madmom";
    rev = "27f032e8947204902c675e5e341a3faf5dc86dae";
    hash = "sha256-gJb+p35rYHOrYkIbz2rCoFxr6OttSrIBQwv+3Gfxh7Y=";
    fetchSubmodules = true;
  };

  build-system = with python3.pkgs; [
    setuptools
    wheel
    cython
    pytest-runner
    oldest-supported-numpy
  ];

  dependencies = with python3.pkgs; [
    ffmpeg
    mido
    numpy
    scipy
    # TODO Add pyfftw for improved FFT performance.
    #pyfftw
    pyaudio
  ];

  # Tests require downloading model/data files which are unavailable in the Nix sandbox.
  doCheck = false;

  pythonImportsCheck = [ "madmom" ];

  meta = with lib; {
    description = "Python audio and music signal processing library";
    homepage = "https://github.com/CPJKU/madmom";
    changelog = "https://github.com/CPJKU/madmom/blob/${src.rev}/CHANGES.rst";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ carlthome ];
  };
}
