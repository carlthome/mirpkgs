{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "auraloss";
  version = "0.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-hus7zoGq9XnZ4t9ZsMrnq43nk5AsNEr3LyVdU8PVyVQ=";
  };

  # Rely on setup.py as the pyproject.toml is incomplete.
  configurePhase = ''
    rm pyproject.toml
  '';

  build-system = with python3.pkgs; [
    attrs
    setuptools
  ];

  dependencies = with python3.pkgs; [
    numpy
    torch
  ];

  optional-dependencies = with python3.pkgs; {
    all = [
      librosa
      matplotlib
      scipy
    ];
  };

  pythonImportsCheck = [ "auraloss" ];

  meta = with lib; {
    description = "Collection of audio-focused loss functions in PyTorch";
    homepage = "https://pypi.org/project/auraloss/";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    mainProgram = "auraloss";
  };
})
