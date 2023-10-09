{ lib
, python3
, fetchPypi
, jams
, vmo
}:

python3.pkgs.buildPythonPackage rec {
  pname = "msaf";
  version = "0.1.80";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-C+97yN1Al/L8N710Yr/ShFXYV4klHfnO1+mKdVeAYRU=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    audioread
    cvxopt
    decorator
    enum34
    future
    jams
    joblib
    librosa
    matplotlib
    mir_eval
    numpy
    pandas
    scikit-learn
    scipy
    seaborn
    vmo
  ];

  passthru.optional-dependencies = with python3.pkgs; {
    resample = [
      scikits-samplerate
    ];
    tests = [
      pytest
      pytest-cov
    ];
  };

  pythonImportsCheck = [ "msaf" ];

  meta = with lib; {
    description = "Python module to discover the structure of music files";
    homepage = "https://pypi.org/project/msaf/";
    license = licenses.mit;
    maintainers = with maintainers; [ carlthome ];
  };
}
