{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonPackage rec {
  pname = "vmo";
  version = "0.30.5";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yXt+a7a3JM3aSy8usgCKzab4JK5lTQR1AiMEcFdjNdY=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = [
    python3.pkgs.numpy
    python3.pkgs.scipy
  ];

  pythonImportsCheck = [ "vmo" ];

  meta = with lib; {
    description = "Variable Markov Oracle in Python";
    homepage = "https://pypi.org/project/vmo/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ carlthome ];
  };
}
