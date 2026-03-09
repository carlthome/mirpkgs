{
  lib,
  python3,
  fetchFromGitHub,
  jams,
  pretty-midi,
  music21,
  dali-dataset,
}:

python3.pkgs.buildPythonPackage (finalAttrs: {
  pname = "mirdata";
  version = "1.0.0";
  pyproject = true;

  # The tests require data files that are not included in the source release, so we take the source from GitHub instead.
  src = fetchFromGitHub {
    owner = "mir-dataset-loaders";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    hash = "sha256-yF4mh2StTr5kLUu3wI3SZF9ASLhhHAP/+WM7x1xNnI8=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
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
    smart-open
  ];

  optional-dependencies = with python3.pkgs; {
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
      pytest
      pytest-cov
      pytest-localserver
      pytest-mock
      pytest-xdist
      smart-open
      testcontainers
      types-pyyaml
    ];
  };

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    pytest-xdist
  ];

  preCheck = ''
    export DEFAULT_DATA_HOME=$TEMP
    export NUMBA_CACHE_DIR=$TEMP
  '';

  pytestFlagsArray = [ "-n" "auto" ];

  # Tests require downloading datasets from the internet.
  disabledTestPaths = [
    "tests/test_loaders.py"
    "tests/test_soundfile_loaders.py"
  ];

  pythonImportsCheck = [ "mirdata" ];

  meta = with lib; {
    description = "Common loaders for MIR datasets";
    homepage = "https://pypi.org/project/mirdata/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ carlthome ];
  };
})
