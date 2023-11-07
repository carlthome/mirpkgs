{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dali-dataset";
  version = "1.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "DALI-dataset";
    inherit version;
    hash = "sha256-1PA581EiRkkgcc5w6fWQF8atZMz5+JRGY/02qcgWe3A=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    youtube-dl
    numpy
  ];

  checkPhase = ''
    runHook preCheck
    ${python3.interpreter} -m unittest
    runHook postCheck
  '';

  pythonImportsCheck = [ "DALI" ];

  meta = with lib; {
    description = "Code for working with the DALI dataset";
    homepage = "https://pypi.org/project/dali-dataset";
    license = with licenses; [
      # TODO cc-by-nc-sa-40
    ];
    maintainers = with maintainers; [ carlthome ];
  };
}
