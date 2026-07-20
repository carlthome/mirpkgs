{
  lib,
  python3,
  fetchFromGitHub,
  jams,
  pretty-midi,
  music21,
  dali-dataset,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "mirdata";
  version = "1.0.0";
  format = "setuptools";

  # The tests require data files that are not included in the source release, so we take the source from GitHub instead.
  src = fetchFromGitHub {
    owner = "mir-dataset-loaders";
    repo = pname;
    rev = version;
    hash = "sha256-yF4mh2StTr5kLUu3wI3SZF9ASLhhHAP/+WM7x1xNnI8=";
  };

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
      pytest
      pytest-cov
      pytest-localserver
      pytest-mock
      pytest-xdist
      #pytest-pep8
      smart-open
      testcontainers
      #types-chardet
      types-pyyaml
    ];
  };

  checkInputs = lib.flatten (builtins.attrValues passthru.optional-dependencies);

  checkPhase = ''
    runHook preCheck
    export DEFAULT_DATA_HOME=$TEMP
    export NUMBA_CACHE_DIR=$TEMP
    # Deselect tests that fail on upstream incompatibilities in the pinned
    # 1.0.0 release: csv.reader rejects "\n" as a delimiter on modern Python
    # (bad delimiter value), and NumPy 2.x rejects converting non-0-d arrays
    # to Python scalars.
    ${python3.pkgs.pytest}/bin/pytest -n auto tests/ \
      --deselect tests/datasets/test_four_way_tabla.py::test_track \
      --deselect tests/datasets/test_four_way_tabla.py::test_get_onsets \
      --deselect tests/datasets/test_gtzan_genre.py::test_track \
      --deselect tests/datasets/test_gtzan_genre.py::test_load_tempo \
      --deselect tests/datasets/test_tonality_classicaldb.py::test_track \
      --deselect tests/datasets/test_tonality_classicaldb.py::test_load_key \
      --deselect tests/test_loaders.py::test_track
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
