{ lib
, python3
, fetchPypi
, jams
, pretty-midi
, music21
, dali-dataset
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mirdata";
  version = "0.3.8";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ueIX4QfyfRYv/Nhm6G8GIUf69KqCYEN7PrF3CAXMbD4=";
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
      sphinxcontrib-napoleon
    ];
    gcs = [
      smart-open
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
      pytest-pep8
      smart-open
      testcontainers
      types-chardet
      types-pyyaml
    ];
  };

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  checkInputs = with python3.pkgs; [
    openpyxl
    smart-open
    dali-dataset
    music21
  ];

  pythonImportsCheck = [ "mirdata" ];

  meta = with lib; {
    description = "Common loaders for MIR datasets";
    homepage = "https://pypi.org/project/mirdata/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ carlthome ];
  };
}
