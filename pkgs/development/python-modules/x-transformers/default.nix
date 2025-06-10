{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "x-transformers";
  version = "2.3.12";
  pyproject = true;

  src = fetchPypi {
    pname = "x_transformers";
    inherit version;
    hash = "sha256-BJ5Ag7nH3shVED9SExKeyBOJPqeXGiV7js/QlXU/5i4=";
  };

  build-system = [
    python3.pkgs.hatchling
  ];

  dependencies = with python3.pkgs; [
    einops
    einx
    loguru
    packaging
    torch
  ];

  optional-dependencies = with python3.pkgs; {
    examples = [
      lion-pytorch
      tqdm
    ];
    test = [
      pytest
    ];
  };

  pythonImportsCheck = [
    "x_transformers"
  ];

  meta = {
    description = "X-Transformers";
    homepage = "https://pypi.org/project/x-transformers/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "x-transformers";
  };
}
