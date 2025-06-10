{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "hyper-connections";
  version = "0.1.15";
  pyproject = true;

  src = fetchPypi {
    pname = "hyper_connections";
    inherit version;
    hash = "sha256-02+eqIA+guFPIzCFZTZg6tUhF8oXhxhr0P2xlwtlzhw=";
  };

  build-system = [
    python3.pkgs.hatchling
  ];

  dependencies = with python3.pkgs; [
    einops
    torch
  ];

  pythonImportsCheck = [
    "hyper_connections"
  ];

  meta = {
    description = "Hyper-Connections";
    homepage = "https://pypi.org/project/hyper-connections/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "hyper-connections";
  };
}
