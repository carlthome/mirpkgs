{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonPackage rec {
  pname = "encodec";
  version = "0.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Nt3pjM/mxRoVV2R2yt/LOzWmNQe4uFVavWmImm+6Z3I=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    numpy
    torch
    einops
    torchaudio
    soundfile
  ];

  patches = [
    ./0001-Move-torch.distributed.ReduceOp.SUM-into-is_distribu.patch
  ];

  pythonImportsCheck = [ "encodec" ];

  meta = with lib; {
    description = "High fidelity neural audio codec";
    homepage = "https://pypi.org/project/encodec/";
    license = licenses.mit;
    maintainers = with maintainers; [ carlthome ];
  };
}
