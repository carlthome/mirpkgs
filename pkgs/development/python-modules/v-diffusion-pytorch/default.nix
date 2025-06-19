{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "v-diffusion-pytorch";
  version = "0.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-K5oBNHjFgex3i7UhgpvIovGBi9Rcqx+EmDRyjJtYy8k=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    ftfy
    pillow
    regex
    requests
    torch
    torchvision
    tqdm
  ];

  pythonImportsCheck = [
    "diffusion"
  ];

  meta = {
    description = "V objective diffusion inference code for PyTorch";
    homepage = "https://pypi.org/project/v-diffusion-pytorch/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "v-diffusion-pytorch";
  };
}
