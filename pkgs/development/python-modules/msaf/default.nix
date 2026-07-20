{
  lib,
  python3,
  fetchFromGitHub,
  jams,
  vmo,
}:

python3.pkgs.buildPythonPackage {
  pname = "msaf";
  version = "0.1.80-dev";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "carlthome";
    repo = "msaf";
    # Pin an immutable commit (was the mutable "patch-3" branch, since deleted).
    rev = "51328e9503a8213082aa7be2ae12fb55575bbdbd";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  build-system = with python3.pkgs; [
    setuptools
    wheel
  ];

  dependencies = with python3.pkgs; [
    audioread
    cvxopt
    decorator
    jams
    joblib
    librosa
    matplotlib
    mir-eval
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
