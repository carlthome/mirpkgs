{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "randomname";
  version = "0.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-t5uYMCukR5FksKT4eZW3vrvR2RASrtpIM0Hj5YrOUg4=";
  };

  build-system = with python3.pkgs; [
    setuptools
    wheel
  ];

  dependencies = with python3.pkgs; [
    fire
  ];

  pythonImportsCheck = [ "randomname" ];

  meta = with lib; {
    description = "Generate random adj-noun names like docker and github";
    homepage = "https://pypi.org/project/randomname/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "randomname";
  };
}
