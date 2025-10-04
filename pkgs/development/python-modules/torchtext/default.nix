{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "torchtext";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dSL7tY6EfWmPbGoyU9TJSC4ZNgj6DKZHxc/JfWMFGMQ=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies = with python3.pkgs; [
    numpy
    requests
    torch
    tqdm
    sentencepiece
  ];

  pythonImportsCheck = [
    "torchtext"
  ];

  meta = {
    description = "Text utilities, models, transforms, and datasets for PyTorch";
    homepage = "https://pypi.org/project/torchtext/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "torchtext";
  };
}
