{ lib
, python3
, fetchFromGitHub
, jams
, vmo
}:

python3.pkgs.buildPythonPackage rec {
  pname = "msaf";
  version = "0.1.80-dev";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "urinieto";
    repo = "msaf";
    rev = "main";
    hash = "sha256-MmsgrYC9TthWZQWEIqtz68E0jvO6f9/a6BNatMyH3E4=";
  };

  nativeBuildInputs = with python3.pkgs;    [
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    audioread
    cvxopt
    decorator
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

  patches = [
    ./drop-enum34.patch
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
