{
  lib,
  python3,
  fetchFromGitHub,
  argbind,
  pyloudnorm,
  pystoi,
  randomname,
  torch-stoi,

}:

python3.pkgs.buildPythonApplication rec {
  pname = "descript-audiotools";
  version = "0.7.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "descriptinc";
    repo = "audiotools";
    rev = version;
    hash = "sha256-mDReVnVgxb+qcTosUSNG3jp6QhaIWdcddyfK4xuyxCc=";
  };

  build-system = with python3.pkgs; [
    setuptools
    wheel
  ];

  dependencies = with python3.pkgs; [
    argbind
    ffmpy
    flatten-dict
    importlib-resources
    ipython
    julius
    librosa
    markdown2
    matplotlib
    numpy
    protobuf
    pyloudnorm
    pystoi
    randomname
    rich
    scipy
    soundfile
    tensorboard
    torch
    torch-stoi
    torchaudio
    tqdm
  ];

  optional-dependencies = with python3.pkgs; {
    docs = [
      myst-nb
      myst-parser
      sphinx
      sphinx-multiversion
      sphinx-rtd-theme
    ];
    tests = [
      gradio
      line-profiler
      pesq
      pytest
      pytest-cov
      transformers
    ];
    whisper = [
      transformers
    ];
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'protobuf >= 3.19.6, != 4.24.0, < 5.0.0' 'protobuf >=3.19.6' \
  '';

  pythonImportsCheck = [
    "audiotools"
  ];

  meta = {
    description = "Utilities for handling audio";
    homepage = "https://pypi.org/project/descript-audiotools/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "descript-audiotools";
  };
}
