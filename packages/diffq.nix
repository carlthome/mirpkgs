{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonApplication rec {
  pname = "diffq";
  version = "0.2.4";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BJBkhh6XTr8A0LrauLMkx3UDc3FBntoxUJhbnUd7W9I=";
  };

  nativeBuildInputs = [
    python3.pkgs.cython
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    cython
    numpy
    torch
  ];

  passthru.optional-dependencies = with python3.pkgs; {
    dev = [
      coverage
      flake8
      pdoc3
      torchvision
    ];
  };

  pythonImportsCheck = [ "diffq" ];

  meta = with lib; {
    description = "Differentiable quantization framework for PyTorch";
    homepage = "https://pypi.org/project/diffq";
    license = licenses.mit;
    maintainers = with maintainers; [ carlthome ];
  };
}
