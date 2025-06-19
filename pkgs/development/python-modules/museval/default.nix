{
  lib,
  python3,
  fetchPypi,
  musdb,
  ffmpeg,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "museval";
  version = "0.4.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JNIUDIWV/RcWdKWu1A+DfJiAoEQ9guGm26qZ8mv2CG4=";
  };

  build-system = with python3.pkgs; [
    setuptools
    wheel
    ffmpeg
  ];

  dependencies = with python3.pkgs; [
    jsonschema
    musdb
    ffmpeg
    numpy
    pandas
    scipy
    simplejson
    soundfile
  ];

  passthru.optional-dependencies = with python3.pkgs; {
    dev = [
      check-manifest
    ];
    docs = [
      numpydoc
      recommonmark
      sphinx
      sphinx-rtd-theme
    ];
    tests = [
      pytest
    ];
  };

  pythonImportsCheck = [ "museval" ];

  meta = with lib; {
    description = "Evaluation tools for the SIGSEP MUS database";
    homepage = "https://pypi.org/project/museval/";
    license = licenses.mit;
    maintainers = with maintainers; [ carlthome ];
  };
}
