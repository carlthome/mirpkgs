{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonPackage rec {
  pname = "treetable";
  version = "0.2.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KclbeXqOz/S7iUy3sQPjmnjJBat4qIqaJH3jDId0Oi8=";
  };

  nativeCheckInputs = with python3.pkgs; [
    unittestCheckHook
  ];

  pythonImportsCheck = [ "treetable" ];

  meta = with lib; {
    description = "Helper to pretty print an ascii table with atree-like structure";
    homepage = "https://pypi.org/project/treetable";
    license = licenses.unlicense;
    maintainers = with maintainers; [ carlthome ];
  };
}
