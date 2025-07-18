{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "treetable";
  version = "0.2.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KclbeXqOz/S7iUy3sQPjmnjJBat4qIqaJH3jDId0Oi8=";
  };

  build-system = with python3.pkgs; [
    setuptools
    wheel
  ];

  checkPhase = ''
    echo "Running tests..."
    python test.py
    echo "Tests completed successfully."
  '';

  pythonImportsCheck = [ "treetable" ];

  meta = with lib; {
    description = "Helper to pretty print an ascii table with atree-like structure";
    homepage = "https://pypi.org/project/treetable";
    license = licenses.unlicense;
    maintainers = with maintainers; [ carlthome ];
  };
}
