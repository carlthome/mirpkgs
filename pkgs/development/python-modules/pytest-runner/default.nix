{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pytest-runner";
  version = "6.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cNRzlYWnAI83v0kzwBP9sye4h4paafy7MxbIiILw9Js=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.setuptools-scm
  ];

  optional-dependencies = with python3.pkgs; {
    docs = [
      jaraco-packaging
      jaraco-tidelift
      rst-linker
      sphinx
    ];
    testing = [
      pytest
      pytest-black
      pytest-checkdocs
      pytest-cov
      pytest-enabler
      pytest-flake8
      pytest-mypy
      pytest-virtualenv
      types-setuptools
    ];
  };

  meta = {
    description = "Invoke py.test as distutils command with dependency resolution";
    homepage = "https://pypi.org/project/pytest-runner/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "pytest-runner";
  };
}
