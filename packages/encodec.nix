{ pkgs
, stdenv
, lib
, fetchPypi
, fetchFromGitHub
, python3Packages
}:
pkgs.python3Packages.buildPythonPackage {
  name = "encodec";
  format = "setuptools";

  src = fetchPypi {
    pname = "encodec";
    version = "0.1.1";
    hash = "sha256-Nt3pjM/mxRoVV2R2yt/LOzWmNQe4uFVavWmImm+6Z3I=";
  };

  patches = [
    ./0001-Move-torch.distributed.ReduceOp.SUM-into-is_distribu.patch
  ];

  propagatedBuildInputs = with python3Packages; [
    torch
    torchaudio
    einops
  ];

  pythonImportsCheck = [
    "encodec"
  ];

  doCheck = false;

  meta = {
    description = "High fidelity neural audio codec";
    homepage = "https://github.com/facebookresearch/encodec";
    license = lib.licenses.mit;
    maintainers = [
      (import ./maintainer.nix)
    ];
  };
}
