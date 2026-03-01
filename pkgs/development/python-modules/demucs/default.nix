{
  lib,
  python3,
  fetchPypi,
  diffq,
  dora-search,
  hydra-colorlog,
  julius,
  lameenc,
  museval,
  openunmix,
  submitit,
  treetable,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "demucs";
  version = "4.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5FpaeIuueXZ8N7v25pquA4Yt3MoFVQ+3m5JjRqF31xM=";
  };

  dependencies = with python3.pkgs; [
    diffq
    dora-search
    einops
    flake8
    hydra-core
    hydra-colorlog
    julius
    lameenc
    museval
    mypy
    openunmix
    pyyaml
    soundfile
    submitit
    torch
    torchaudio
    tqdm
    treetable
  ];

  pythonImportsCheck = [ "demucs" ];

  meta = with lib; {
    description = "Music source separation in the waveform domain";
    homepage = "https://pypi.org/project/demucs/";
    license = licenses.mit;
    maintainers = with maintainers; [ carlthome ];
  };
}
