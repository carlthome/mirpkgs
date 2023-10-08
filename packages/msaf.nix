{ pkgs
, stdenv
, lib
, fetchPypi
, fetchFromGitHub
, python3Packages
, jams
, ffmpeg
, vmo
, libsndfile
}:
pkgs.python3Packages.buildPythonPackage {
  name = "msaf";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "urinieto";
    repo = "msaf";
    rev = "1fb42a80c4b0cce981df470ff6360243c2a63cdf";
    sha256 = "sha256-JkSwcpVGkK0OzidvS8EucCrU8FwgABDb8cFwkLfGBC8=";
  };

  patches = [
    ./remove_enum34.patch
  ];

  propagatedBuildInputs = with python3Packages; [
    cvxopt
    ffmpeg
    jams
    librosa
    libsndfile
    mir_eval
    numpy
    scikit-learn
    seaborn
    vmo
  ];

  pythonImportsCheck = [
    "msaf"
  ];

  doCheck = false;

  meta = {
    description = "Python package for discovering the structure of music files";
    homepage = "https://github.com/urinieto/msaf";
    license = lib.licenses.mit;
    maintainers = [
      (import ./maintainer.nix)
    ];
  };
}
