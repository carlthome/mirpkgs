{ lib
, python3
, fetchPypi
, read-version
}:

python3.pkgs.buildPythonPackage rec {
  pname = "hydra-colorlog";
  version = "1.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1E+FAI+r0kSMfjtJbDG0TXYQVg9v/3TzZzr6qUmHCJk=";
  };

  nativeBuildInputs = with python3.pkgs; [
    read-version
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    colorlog
    hydra-core
  ];

  pythonImportsCheck = [ "hydra" ];

  meta = with lib; {
    description = "Enables colorlog for Hydra apps";
    homepage = "https://pypi.org/project/hydra-colorlog";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ carlthome ];
  };
}
