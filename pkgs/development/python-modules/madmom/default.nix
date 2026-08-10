{
  lib,
  python3,
  fetchFromGitHub,
  ffmpeg,
  pytest-runner,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "madmom";
  # What the pinned commit's setup.py declares; the metadata check insists the
  # two agree.
  version = "0.17.dev0";
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
    pytest-timeout
  ];

  # Guard against the test suite hanging until GitHub kills the job at six
  # hours, as the batch tests below used to do.
  pytestFlags = [ "--timeout=300" ];

  disabledTestPaths = [
    # These drive madmom's multiprocessing batch runner in-process, and the
    # forked workers never report back, so process_batch() sits in
    # JoinableQueue.join() forever. Only reproduces under the test runner;
    # `SuperFlux batch ...` on the command line is fine.
    "tests/test_bin.py::TestDifferentFileFormats::test_batch_wav"
    "tests/test_bin.py::TestDifferentFileFormats::test_batch_flac"
    "tests/test_bin.py::TestDifferentFileFormats::test_batch_m4a"
    "tests/test_bin.py::TestBarTrackerProgram::test_batch"
    "tests/test_bin.py::TestSuperFluxProgram::test_batch"
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
