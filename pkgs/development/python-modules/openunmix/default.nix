{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "openunmix";
  version = "1.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7uMKO6xaSpMfD1Xf3cC1QEjr/zE9obojlHD2sI3vsHc=";
  };

  dependencies = with python3.pkgs; [
    numpy
    torch
    torchaudio
    tqdm
  ];

  passthru.optional-dependencies = with python3.pkgs; {
    asteroid = [
      asteroid-filterbanks
    ];
    evaluation = [
      musdb
      museval
    ];
    stempeg = [
      stempeg
    ];
    tests = [
      asteroid-filterbanks
      musdb
      museval
      onnx
      pytest
      tqdm
    ];
  };

  pythonImportsCheck = [ "openunmix" ];

  meta = with lib; {
    description = "PyTorch-based music source separation toolkit";
    homepage = "https://pypi.org/project/openunmix/";
    license = licenses.mit;
    maintainers = with maintainers; [ carlthome ];
  };
}
