{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "music21";
  version = "9.7.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sFbMQfuYn0kuKRiCwTwC68E+j1c0xqq5rrn+bP0sJVA=";
  };

  build-system = with python3.pkgs; [
    hatchling
  ];

  dependencies = with python3.pkgs; [
    chardet
    joblib
    jsonpickle
    matplotlib
    more-itertools
    numpy
    requests
    webcolors
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  disabledTests = [
    "music21/scale/test_intervalNetwork.py::Test::testScaleArbitrary"
    "music21/test/test_chord.py::TestExternal::testBasic"
    "music21/test/test_chord.py::TestExternal::testPostTonalChords"
    "music21/test/test_note.py::Test::testComplex"
  ];

  pythonImportsCheck = [ "music21" ];

  meta = with lib; {
    description = "A Toolkit for Computer-Aided Musical Analysis and Computational Musicology";
    homepage = "https://pypi.org/project/music21";
    license = licenses.bsd3;
    maintainers = with maintainers; [ carlthome ];
  };
}
