{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonApplication rec {
  pname = "music21";
  version = "9.1.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bGFCXHr1v1ThIK/rq8/9sivjJiCw6iKw2ONqxer678g=";
  };

  nativeBuildInputs = [
    python3.pkgs.hatchling
  ];

  propagatedBuildInputs = with python3.pkgs; [
    chardet
    joblib
    jsonpickle
    matplotlib
    more-itertools
    numpy
    requests
    webcolors
  ];

  pythonImportsCheck = [ "music21" ];

  meta = with lib; {
    description = "A Toolkit for Computer-Aided Musical Analysis and Computational Musicology";
    homepage = "https://pypi.org/project/music21";
    license = licenses.bsd3;
    maintainers = with maintainers; [ carlthome ];
  };
}
