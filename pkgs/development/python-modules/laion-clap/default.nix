{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "laion-clap";
  version = "1.1.7";
  pyproject = true;

  src = fetchPypi {
    pname = "laion_clap";
    inherit version;
    hash = "sha256-mrnFI2ueCUT2fWaF7yqcFIFOvRPA2GLH/gepu1ZgQ5c=";
  };

  patches = [
    ./defer-download.patch
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'numpy >= 1.23.5, < 2.0.0' 'numpy >= 1.23.5'
  '';

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    braceexpand
    ftfy
    h5py
    librosa
    llvmlite
    numpy
    pandas
    progressbar
    regex
    scikit-learn
    scipy
    soundfile
    torch
    torchaudio
    torchlibrosa
    torchvision
    tqdm
    transformers
    wandb
    webdataset
    wget
  ];

  pythonImportsCheck = [ "laion_clap" ];

  meta = {
    description = "Contrastive Language-Audio Pretraining Model from LAION";
    homepage = "https://pypi.org/project/laion-clap/";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "laion-clap";
  };
}
