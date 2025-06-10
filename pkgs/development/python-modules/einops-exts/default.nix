{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "einops-exts";
  version = "0.0.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YW8UWzQR+Onjvl2lyWi743LlXCSd4R+qkJx6S3RYCmw=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies = with python3.pkgs; [
    einops
    torch
  ];

  pythonImportsCheck = [
    "einops_exts"
  ];

  meta = {
    description = "Einops Extensions";
    homepage = "https://pypi.org/project/einops-exts/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "einops-exts";
  };
}
