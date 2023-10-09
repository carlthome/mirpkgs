{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonPackage rec {
  pname = "julius";
  version = "0.2.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PA9fUwbX1gFvzJUZaydMrm8H4slZbu0xTk52QVVPuwg=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pytorch
    resampy
  ];

  pythonImportsCheck = [ "julius" ];

  meta = with lib; {
    description = "Nice DSP sweets: resampling, FFT Convolutions. All with PyTorch, differentiable and with CUDA support";
    homepage = "https://pypi.org/project/julius/";
    license = licenses.mit;
    maintainers = with maintainers; [ carlthome ];
  };
}
