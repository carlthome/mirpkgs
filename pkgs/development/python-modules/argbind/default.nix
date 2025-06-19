{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonApplication rec {
  pname = "argbind";
  version = "0.3.9";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GxWcBK9WhYqR1Zx6R7yeo52Wrfzh1/z6OAUNesmBV0U=";
  };

  build-system = with python3.pkgs; [
    setuptools
    wheel
  ];

  dependencies = with python3.pkgs; [
    docstring-parser
    pyyaml
  ];

  passthru.optional-dependencies = with python3.pkgs; {
    examples = [
      torch
      torchvision
    ];
    tests = [
      pytest
      pytest-cov
      torch
      torchvision
    ];
  };

  pythonImportsCheck = [ "argbind" ];

  meta = with lib; {
    description = "Simple way to bind function arguments to the command line";
    homepage = "https://pypi.org/project/argbind/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "argbind";
  };
}
