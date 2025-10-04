{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "mido";
  version = "1.3.3";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GuyzC38oJATxfkN2jL90pqMb8is7eDvdEXoc6dIst0w=";
  };

  build-system = with python3.pkgs; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3.pkgs; [
    importlib-metadata
    packaging
  ];

  passthru.optional-dependencies = with python3.pkgs; {
    build-docs = [
      sphinx
      sphinx-rtd-theme
    ];
    check-manifest = [
      check-manifest
    ];
    dev = [
      mido
    ];
    lint-code = [
      flake8
    ];
    lint-reuse = [
      reuse
    ];
    ports-all = [
      mido
    ];
    ports-pygame = [
      pygame
    ];
    ports-rtmidi = [
      python-rtmidi
    ];
    ports-rtmidi-python = [
      rtmidi-python
    ];
    release = [
      twine
    ];
    test-code = [
      pytest
    ];
  };

  pythonImportsCheck = [ "mido" ];

  meta = with lib; {
    description = "MIDI Objects for Python";
    homepage = "https://pypi.org/project/mido/";
    license = licenses.mit;
    maintainers = with maintainers; [ carlthome ];
  };
}
