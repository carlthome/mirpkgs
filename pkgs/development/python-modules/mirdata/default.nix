{ lib
, python3
, fetchFromGitHub
, jams
, pretty-midi
, music21
, dali-dataset
}:

python3.pkgs.buildPythonPackage rec {
  pname = "mirdata";
  version = "0.3.8";
  format = "setuptools";

  # The tests require data files that are not included in the source release, so we take the source from GitHub instead.
  src = fetchFromGitHub {
    owner = "mir-dataset-loaders";
    repo = pname;
    rev = version;
    hash = "sha256-Ar0FsMb5S9lvzBLUHf13d8SXWPSSkQRxnUnSzPiu/MU=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    attrs
    black
    chardet
    deprecated
    h5py
    jams
    librosa
    numpy
    pandas
    pretty-midi
    pyyaml
    requests
    scipy
    tqdm
    dali-dataset
  ];

  passthru.optional-dependencies = with python3.pkgs; {
    cipi = [
      music21
    ];
    compmusic_carnatic_rhythm = [
      openpyxl
    ];
    compmusic_hindustani_rhythm = [
      openpyxl
    ];
    dali = [
      dali-dataset
    ];
    docs = [
      numpydoc
      recommonmark
      sphinx
      sphinx-rtd-theme
      sphinx-togglebutton
      #sphinxcontrib-napoleon
    ];
    gcs = [
      smart-open
      google-cloud-storage
    ];
    haydn_op20 = [
      music21
    ];
    http = [
      smart-open
    ];
    s3 = [
      smart-open
    ];
    tests = [
      coveralls
      decorator
      future
      pytest
      pytest-cov
      pytest-localserver
      pytest-mock
      #pytest-pep8
      smart-open
      testcontainers
      #types-chardet
      types-pyyaml
    ];
  };

  checkInputs = with python3.pkgs; [
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pytestFlagsArray = [
    "tests/"
  ];

  checkPhase = ''
    runHook preCheck
    export DEFAULT_DATA_HOME=$TEMP
    export NUMBA_CACHE_DIR=$TEMP
    ${python3.pkgs.pytest}/bin/pytest tests/
    runHook postCheck
  '';

  pythonImportsCheck = [ "mirdata" ];

  meta = with lib; {
    description = "Common loaders for MIR datasets";
    homepage = "https://pypi.org/project/mirdata/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ carlthome ];
  };
}
