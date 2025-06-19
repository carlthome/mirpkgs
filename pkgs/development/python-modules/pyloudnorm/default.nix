{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pyloudnorm";
  version = "0.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Y81OGX3qTneVFg6gjtAtMYCRvOiD5Dam28WWMya3Hh4=";
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
    future
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
