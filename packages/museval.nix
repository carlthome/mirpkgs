{ lib
, python3
, fetchPypi
, musdb
}:

python3.pkgs.buildPythonApplication rec {
  pname = "museval";
  version = "0.4.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JNIUDIWV/RcWdKWu1A+DfJiAoEQ9guGm26qZ8mv2CG4=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    jsonschema
    musdb
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
