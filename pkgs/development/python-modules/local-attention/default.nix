{
  lib,
  python3,
  fetchPypi,
  hyper-connections,
  pytest-runner,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "local-attention";
  version = "1.11.1";
  pyproject = true;

  src = fetchPypi {
    pname = "local_attention";
    inherit version;
    hash = "sha256-vyRFPR6iUe0HWjpMc05bYI5J6cSJ+bhn2luVUDjSwGM=";
  };

  build-system = with python3.pkgs; [
    setuptools
    wheel
    pytest-runner
  ];

  dependencies = with python3.pkgs; [
    einops
    hyper-connections
    torch
  ];

  pythonImportsCheck = [
    "local_attention"
  ];

  meta = {
    description = "Local attention, window with lookback, for language modeling";
    homepage = "https://pypi.org/project/local-attention/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "local-attention";
  };
}
