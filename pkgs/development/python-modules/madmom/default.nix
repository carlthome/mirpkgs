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

  # Remove source files so pytest only uses the built package.
  preCheck = ''
    rm -r madmom
  '';

  nativeCheckInputs = with python3.pkgs; [
    ffmpeg
    pytestCheckHook
  ];

  pythonImportsCheck = [ "madmom" ];

  disabledTests = [
    # TODO Resolve numerical failures on aarch64-darwin.
    "TestCLPChromaClass"
    "TestResampleFunction"
    # TODO https://github.com/CPJKU/madmom/pull/531
    "TestTCNBeatTrackerProgram"
    "TestTCNTempoDetectorProgram"
    "TestTCNBeatProcessorClass"
  ];

  meta = with lib; {
    description = "Python audio and music signal processing library";
    homepage = "https://github.com/CPJKU/madmom";
    changelog = "https://github.com/CPJKU/madmom/blob/${src.rev}/CHANGES.rst";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ carlthome ];
  };
}
