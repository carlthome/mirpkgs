{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication {
  pname = "pyloudnorm";
  version = "0.1.1-dev0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "csteinmetz1";
    repo = "pyloudnorm";
    rev = "a741692b186dbb1ca5ae69562d3e4354bc3e761f";
    hash = "sha256-l+MrDomWsXnI+pxw96bFTjMqeEuT/RLJzbEU0oGtcgg=";
  };

  # The project relies on a setup.py so we need to remove the malformed pyproject.toml
  preBuild = ''
    rm pyproject.toml
  '';

  build-system = with python3.pkgs; [
    attrs
    setuptools
    wheel
  ];

  dependencies = with python3.pkgs; [
    numpy
    scipy
  ];

  pythonImportsCheck = [
    "pyloudnorm"
  ];

  meta = {
    description = "Implementation of ITU-R BS.1770-4 loudness algorithm in Python";
    homepage = "https://pypi.org/project/pyloudnorm/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "pyloudnorm";
  };
}
